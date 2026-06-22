# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""BatchView — Tab "Calculadora de lote" (Fase 4).

Solver INVERSO de producción (design.md §4): se elige un envase del catálogo
(volumen FINAL) y la app calcula hacia atrás, por solución A/B/C, el agua inicial
+ los gramos de cada sal para completar ese volumen con el desplazamiento, y
cuántas botellas salen.

  ┌─ QListView de envases (vol. final) ─┬─ accordions de receta (perfil×fase) ──┐
  │   Pichinga 18/56 L · Tanque … ·     │   abierto → 3 cards de solución:        │
  │   Personalizado (input > 0)         │     agua inicial · sales · vol · botellas │
  └─────────────────────────────────────┴────────────────────────────────────────┘

Reusa ``recipe_math.scale_to_volume`` (mismo cálculo que la calculadora del
mockup) y el catálogo de ``reference_data``.
"""

from __future__ import annotations

import os
import sys

from PySide6.QtCore import Qt
from PySide6.QtWidgets import (
    QWidget,
    QVBoxLayout,
    QHBoxLayout,
    QLabel,
    QListWidget,
    QListWidgetItem,
    QFrame,
    QScrollArea,
    QComboBox,
    QDoubleSpinBox,
)

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import tokens as T  # noqa: E402
import recipe_math as rm  # noqa: E402
import reference_data as rd  # noqa: E402
from widgets.profiles_view import (  # noqa: E402
    PROFILE_LABELS,
    PHASES,
    SOLUTIONS,
    SALT_LABELS,
    _Accordion,
    _callout,
)

# Colores de la cabecera de cada card de solución (como el mockup).
SOLUTION_CARD_COLORS = {
    "solucion_a_nitratos": "#5F6A00",
    "solucion_b_fosfatos_sulfatos": "#8E4B00",
    "solucion_c_micros": "#2F77C2",
}

# Tamaños de botella ofrecidos (L). 1 L es el default de envasado.
BOTTLE_SIZES = [("1 L", 1.0), ("0,5 L", 0.5), ("2 L", 2.0), ("5 L", 5.0)]

CUSTOM_MODEL = "Personalizado"


def _fmt_L(value: float) -> str:
    """Formatea litros estilo es-CR (coma decimal); enteros para >= 100."""
    if value >= 100:
        return f"{value:,.0f}".replace(",", ".")
    return f"{value:.1f}".replace(".", ",")


def _fmt_g(value: float) -> str:
    """Gramos estilo es-CR: 2 decimales para valores chicos, miles con punto."""
    if value < 10:
        return f"{value:.2f}".replace(".", ",")
    return f"{value:,.0f}".replace(",", ".")


class BatchView(QWidget):
    """Tab de cálculo de lote: envase del catálogo -> solver inverso por solución."""

    def __init__(self, db, parent=None):
        super().__init__(parent)
        self.db = db
        self._densities = rd.load_salt_densities()
        self._catalog = rd.load_container_catalog()
        self._bottle_L = 1.0
        self._v_final_L = (
            self._catalog[0]["capacity_L"] if self._catalog else 18.0
        )
        self._model_name = (
            self._catalog[0]["model"] if self._catalog else "Pichinga 18 L"
        )
        self._phase = PHASES[0][0]  # fase activa de la calculadora
        self._valid = True  # envase seleccionado tiene volumen válido
        self._build()
        if self.list.count():
            self.list.setCurrentRow(0)

    def _build(self):
        root = QHBoxLayout(self)
        root.setContentsMargins(6, 6, 6, 6)
        root.setSpacing(8)

        # Izquierda: QListView de envases + "Personalizado".
        left = QVBoxLayout()
        left.setSpacing(6)
        self.list = QListWidget()
        self.list.setFixedWidth(260)
        self.list.setStyleSheet(
            f"QListWidget {{ border:1px solid {T.BORDER}; border-radius:6px;"
            f" background:{T.SURFACE}; font-family:'{T.FONT_FAMILY}'; }}"
            f" QListWidget::item {{ padding:9px 10px;"
            f" border-bottom:1px solid {T.TRACK}; color:{T.TEXT}; }}"
            f" QListWidget::item:selected {{ background:{T.PRIMARY};"
            f" color:{T.BTN_FG}; }}"
        )
        for c in self._catalog:
            item = QListWidgetItem(f"{c['model']}")
            gal = c.get("gal")
            if gal:
                item.setText(f"{c['model']}    ·  {gal} gal")
            item.setData(Qt.UserRole, float(c["capacity_L"]))
            item.setData(Qt.UserRole + 1, c["model"])
            self.list.addItem(item)
        custom = QListWidgetItem(f"{CUSTOM_MODEL}…")
        custom.setData(Qt.UserRole, None)
        custom.setData(Qt.UserRole + 1, CUSTOM_MODEL)
        self.list.addItem(custom)
        self.list.currentRowChanged.connect(self._on_pick)
        left.addWidget(self.list, 1)

        # Input de envase personalizado (validado > 0).
        custom_row = QHBoxLayout()
        custom_row.addWidget(QLabel("Vol. personalizado:"))
        self.custom_spin = QDoubleSpinBox()
        self.custom_spin.setRange(0.0, 1_000_000.0)
        self.custom_spin.setDecimals(1)
        self.custom_spin.setValue(0.0)
        self.custom_spin.setSuffix(" L")
        self.custom_spin.setSpecialValueText("—")
        self.custom_spin.valueChanged.connect(self._on_custom_changed)
        custom_row.addWidget(self.custom_spin, 1)
        left.addLayout(custom_row)

        # Selector de fase (Vegetativa / Reproductiva / Maduración): la
        # calculadora usa la receta del perfil×FASE seleccionada.
        phase_row = QHBoxLayout()
        phase_row.addWidget(QLabel("Fase:"))
        self.phase_combo = QComboBox()
        for phase_key, phase_label, _color in PHASES:
            # "Fase Vegetativa" -> "Vegetativa"; "Fase de Maduración" -> "Maduración".
            self.phase_combo.addItem(
                phase_label.replace("Fase de ", "").replace("Fase ", ""), phase_key
            )
        self.phase_combo.currentIndexChanged.connect(self._on_phase_changed)
        phase_row.addWidget(self.phase_combo, 1)
        left.addLayout(phase_row)

        # Selector de botella (default 1 L).
        bottle_row = QHBoxLayout()
        bottle_row.addWidget(QLabel("Botella:"))
        self.bottle_combo = QComboBox()
        for label, vol in BOTTLE_SIZES:
            self.bottle_combo.addItem(label, vol)
        self.bottle_combo.currentIndexChanged.connect(self._on_bottle_changed)
        bottle_row.addWidget(self.bottle_combo, 1)
        left.addLayout(bottle_row)
        root.addLayout(left)

        # Derecha: scroll con header + accordions de receta.
        self.scroll = QScrollArea()
        self.scroll.setWidgetResizable(True)
        self.scroll.setFrameShape(QFrame.NoFrame)
        self._right = QWidget()
        self.right_lay = QVBoxLayout(self._right)
        self.right_lay.setContentsMargins(8, 8, 8, 8)
        self.right_lay.setSpacing(8)
        self.scroll.setWidget(self._right)
        root.addWidget(self.scroll, 1)

    # --- eventos de selección ---
    def _on_pick(self, row: int):
        if row < 0 or row >= self.list.count():
            return
        item = self.list.item(row)
        vol = item.data(Qt.UserRole)
        self._model_name = item.data(Qt.UserRole + 1)
        if vol is None:  # Personalizado: usar el spin si es > 0.
            self.custom_spin.setEnabled(True)
            v = self.custom_spin.value()
            if v <= 0:
                self._valid = False
                self._render()
                return
            self._v_final_L = v
        else:
            self.custom_spin.setEnabled(False)
            self._v_final_L = float(vol)
        self._valid = True
        self._render()

    def _on_custom_changed(self, _value: float):
        if self._model_name == CUSTOM_MODEL:
            self._on_pick(self.list.currentRow())

    def _on_bottle_changed(self, _idx: int):
        self._bottle_L = self.bottle_combo.currentData() or 1.0
        # Re-render respetando el estado de validez del envase (un custom <= 0 no
        # debe renderizar un cálculo con volumen stale al cambiar de botella).
        self._render()

    def _on_phase_changed(self, _idx: int):
        self._phase = self.phase_combo.currentData() or PHASES[0][0]
        self._render()

    # --- render ---
    @staticmethod
    def _clear_layout(layout):
        while layout.count():
            item = layout.takeAt(0)
            w = item.widget()
            if w is not None:
                w.setParent(None)
                w.deleteLater()
            child = item.layout()
            if child is not None:
                BatchView._clear_layout(child)

    def _render(self):
        self._clear_layout(self.right_lay)

        head = QLabel(
            f"{self._model_name} → {_fmt_L(self._v_final_L)} L final"
            if self._valid
            else f"{self._model_name}: ingresá un volumen > 0 a la izquierda."
        )
        head.setStyleSheet(
            f"font-size:16px; font-weight:bold; color:{T.PRIMARY};"
            f" font-family:'{T.FONT_FAMILY}';"
        )
        self.right_lay.addWidget(head)

        if not self._valid:
            self.right_lay.addStretch()
            return

        self.right_lay.addWidget(
            _callout(
                "📐 Para el envase seleccionado, calcula hacia atrás el agua "
                "inicial + la sal de cada solución para completar el volumen "
                "final con el desplazamiento (sin aforar). Cambiá el envase y "
                "mirá recalcular.",
                info=True,
            )
        )

        # Color de la fase seleccionada (cabecera de los accordions).
        phase_color = next(
            (c for k, _l, c in PHASES if k == self._phase), PHASES[0][2]
        )
        for idx, (profile_key, profile_label) in enumerate(PROFILE_LABELS):
            recipe = self.db.profile_recipe(profile_key, self._phase)
            has = isinstance(recipe, dict) and any(
                isinstance(recipe.get(sk), dict) for sk, _, _ in SOLUTIONS
            )
            color = phase_color
            subtitle = f"para {self._model_name}" if has else "(sin receta)"
            acc = _Accordion(profile_label, color, subtitle=subtitle)
            if has:
                self._fill_calc(acc.body_layout(), recipe)
            else:
                acc.body_layout().addWidget(
                    _callout(
                        "➕ No hay receta para este perfil. Definíla en el tab "
                        "“Perfiles & Recetas”.",
                        info=True,
                    )
                )
            acc.set_open(idx == 0)
            self.right_lay.addWidget(acc)
        self.right_lay.addStretch()

    def _fill_calc(self, body, recipe):
        cards = QHBoxLayout()
        cards.setSpacing(10)
        v_final_ml = self._v_final_L * 1000.0
        for sk, slabel, salts in SOLUTIONS:
            rec_salts = {
                s: (recipe.get(sk, {}) or {}).get(s, 0) or 0 for s in salts
            }
            out = rm.scale_to_volume(
                rec_salts, v_final_ml, self._densities, bottle_L=self._bottle_L
            )
            cards.addWidget(self._solution_card(sk, slabel, salts, out))
        body.addLayout(cards)

    def _solution_card(self, sk, slabel, salts, out) -> QWidget:
        card = QFrame()
        card.setStyleSheet(
            f"QFrame {{ border:1px solid {T.BORDER}; border-radius:7px;"
            f" background:{T.SURFACE}; }}"
        )
        lay = QVBoxLayout(card)
        lay.setContentsMargins(0, 0, 0, 0)
        lay.setSpacing(0)

        color = SOLUTION_CARD_COLORS.get(sk, T.PRIMARY)
        hd = QLabel(slabel.replace("Solución ", ""))
        hd.setStyleSheet(
            f"background:{color}; color:#FFFFFF; padding:6px 9px; font-weight:600;"
            f" font-size:12px; border-top-left-radius:7px;"
            f" border-top-right-radius:7px; font-family:'{T.FONT_FAMILY}';"
        )
        lay.addWidget(hd)

        bd = QVBoxLayout()
        bd.setContentsMargins(9, 9, 9, 9)
        bd.setSpacing(2)

        agua = out["agua_L"]
        bd.addWidget(self._step_label("1 · Agua inicial"))
        if agua is None:
            bd.addWidget(self._kv("Agregar", "— (falta densidad)"))
        else:
            bd.addWidget(self._kv("Agregar", f"{_fmt_L(agua)} L"))

        bd.addWidget(self._step_label("2 · Disolver sales"))
        masas = out["masas_g"]
        for salt in salts:
            name = SALT_LABELS.get(salt, salt)
            if masas is None:
                bd.addWidget(self._kv(name, "—"))
            else:
                bd.addWidget(self._kv(name, f"{_fmt_g(masas[salt])} g"))

        total = QLabel(
            f"→ {_fmt_L(self._v_final_L)} L  ·  🍾 {out['botellas']}×"
            f"{('%g' % self._bottle_L).replace('.', ',')} L"
        )
        total.setStyleSheet(
            f"background:{T.SURFACE_SUNKEN}; border-radius:5px; padding:6px 8px;"
            f" margin-top:7px; font-size:12px; font-weight:700; color:{T.PRIMARY};"
            f" font-family:'{T.FONT_FAMILY}';"
        )
        bd.addWidget(total)
        lay.addLayout(bd)
        return card

    @staticmethod
    def _step_label(text: str) -> QLabel:
        lbl = QLabel(text)
        lbl.setStyleSheet(
            f"font-size:10px; color:{T.TEXT_MUTED}; font-weight:bold;"
            f" text-transform:uppercase; margin-top:6px;"
        )
        return lbl

    @staticmethod
    def _kv(key: str, value: str) -> QWidget:
        row = QWidget()
        lay = QHBoxLayout(row)
        lay.setContentsMargins(0, 0, 0, 0)
        k = QLabel(key)
        k.setStyleSheet(f"font-size:12px; color:{T.TEXT_MUTED};")
        v = QLabel(value)
        v.setStyleSheet(f"font-size:12px; font-weight:600; color:{T.TEXT};")
        v.setAlignment(Qt.AlignRight | Qt.AlignVCenter)
        lay.addWidget(k)
        lay.addWidget(v, 1)
        return row
