# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""ProfilesView — Tab "Perfiles & Recetas" (Fase 3).

La receta de nutrientes es del PERFIL×FASE (no del cultivo). Layout (design.md
§2, contrato visual ``mockups/interactive-megatabs.html``):

  ┌─ QListView de perfiles (plano) ─┬─ header (perfil + "aplica a N cultivos") ─┐
  │                                 │  switch de base (1000 ml de agua / 1 L)    │
  │                                 │  accordions de fase (Veg/Rep/Mad)          │
  │                                 │    editor 3 columnas A/B/C con steppers     │
  └─────────────────────────────────┴────────────────────────────────────────────┘

El switch de base es SOLO VISTA (``aforo_factor``): reescala los gramos
mostrados; el dato guardado sigue siendo "por 1000 ml de agua". Guardar una fase
llama ``db.save_profile_recipe`` (propaga a los N cultivos del perfil, auditado).
"""

from __future__ import annotations

import os
import sys

from PySide6.QtCore import Qt, Signal
from PySide6.QtWidgets import (
    QWidget,
    QVBoxLayout,
    QHBoxLayout,
    QLabel,
    QListWidget,
    QListWidgetItem,
    QPushButton,
    QFrame,
    QScrollArea,
)

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import tokens as T  # noqa: E402
import recipe_math as rm  # noqa: E402
import reference_data as rd  # noqa: E402
from widgets.instrument_card import Stepper  # noqa: E402

# Perfiles del catálogo (profile_key -> label legible). Lista PLANA (sin grouping).
PROFILE_LABELS: list[tuple[str, str]] = [
    ("fruto_vegetativa", "Cultivos de Fruto — Vegetativa"),
    ("hoja_vegetativa", "Cultivos de Hoja — Vegetativa"),
    ("hierba_aromatica", "Hierbas Aromáticas — Vegetativa"),
    ("fruto_reproductiva", "Cultivos de Fruto — Reproductiva"),
    ("baya_fructificacion", "Frutos de Baya — Reproductiva"),
    ("raiz_engrosamiento", "Raíz / Bulbo / Tubérculo — Maduración"),
]

# Fases con su color de la hoja (Modelo Fitotécnico): Veg morado · Rep magenta ·
# Mad azul. (phase_key, etiqueta, color).
PHASES: list[tuple[str, str, str]] = [
    ("vegetativa", "Fase Vegetativa", "#6C4FA1"),
    ("reproductiva", "Fase Reproductiva", "#B03A6E"),
    ("maduracion", "Fase de Maduración", "#2F77C2"),
]

# Estructura estándar A/B/C de las soluciones (claves = como persiste la receta).
SOLUTIONS: list[tuple[str, str, list[str]]] = [
    (
        "solucion_a_nitratos",
        "Solución A — Nitratos",
        ["nitrato_de_calcio", "nitrato_de_potasio"],
    ),
    (
        "solucion_b_fosfatos_sulfatos",
        "Solución B — Fosfatos / Sulfatos",
        ["fosfato_monoamonico", "sulfato_de_magnesio"],
    ),
    (
        "solucion_c_micros",
        "Solución C — Micro-Nutrientes",
        ["manganeso", "hierro", "boro", "zinc", "cobre"],
    ),
]

SALT_LABELS = {
    "nitrato_de_calcio": "Nitrato de Calcio",
    "nitrato_de_potasio": "Nitrato de Potasio",
    "fosfato_monoamonico": "Fosfato Monoamoníaco",
    "sulfato_de_magnesio": "Sulfato de Magnesio",
    "manganeso": "Manganeso",
    "hierro": "Hierro",
    "boro": "Boro",
    "zinc": "Zinc",
    "cobre": "Cobre",
}


def _hline() -> QFrame:
    f = QFrame()
    f.setFrameShape(QFrame.HLine)
    f.setStyleSheet(f"color:{T.BORDER};")
    return f


class _Accordion(QFrame):
    """Accordion colapsable: cabecera color de fase + cuerpo plegable."""

    def __init__(self, title: str, color: str, *, subtitle: str = "", parent=None):
        super().__init__(parent)
        self.setAttribute(Qt.WA_StyledBackground, True)
        self.setStyleSheet(
            f"_Accordion {{ border:1px solid {T.BORDER}; border-radius:6px; }}"
        )
        lay = QVBoxLayout(self)
        lay.setContentsMargins(0, 0, 0, 0)
        lay.setSpacing(0)

        self._head = QPushButton(
            f"{title}    {subtitle}" if subtitle else title
        )
        self._head.setCheckable(True)
        self._head.setChecked(True)
        self._head.setCursor(Qt.PointingHandCursor)
        self._head.setStyleSheet(
            f"QPushButton {{ background:{color}; color:#FFFFFF; border:none;"
            f" border-top-left-radius:6px; border-top-right-radius:6px;"
            f" text-align:left; padding:9px 12px; font-weight:600;"
            f" font-family:'{T.FONT_FAMILY}'; }}"
        )
        lay.addWidget(self._head)

        self._body = QWidget()
        self._body_lay = QVBoxLayout(self._body)
        self._body_lay.setContentsMargins(11, 11, 11, 11)
        self._body_lay.setSpacing(9)
        lay.addWidget(self._body)
        self._head.toggled.connect(self._body.setVisible)

    def body_layout(self) -> QVBoxLayout:
        return self._body_lay

    def set_open(self, is_open: bool):
        self._head.setChecked(is_open)
        self._body.setVisible(is_open)


def _callout(text: str, *, info: bool = False, mini: bool = False) -> QLabel:
    """Callout estilo Notion (warning ámbar o info azul)."""
    if info:
        bg, border, fg = "#E0ECF7", "#2F77C2", "#1c3a5e"
    else:
        bg, border, fg = "#FFF4E0", "#FF9E1B", "#6D3800"
    lbl = QLabel(text)
    lbl.setWordWrap(True)
    size = "10.5px" if mini else "12px"
    lbl.setStyleSheet(
        f"background:{bg}; border-left:{3 if mini else 5}px solid {border};"
        f" border-radius:{4 if mini else 6}px; padding:{6 if mini else 10}px;"
        f" color:{fg}; font-size:{size}; font-family:'{T.FONT_FAMILY}';"
    )
    return lbl


class ProfilesView(QWidget):
    """Tab de edición de recetas por perfil×fase con propagación auditada."""

    recipeSaved = Signal(str, str, int)  # profile_key, phase, n_cultivos

    def __init__(self, db, parent=None):
        super().__init__(parent)
        self.db = db
        self._densities = rd.load_salt_densities()
        self._mode = "water"  # "water" | "aforo"
        self._profile_key = PROFILE_LABELS[0][0]
        self._steppers: dict[tuple[str, str, str], Stepper] = {}
        self._vol_badges: dict[tuple[str, str], QLabel] = {}
        self._build()
        self._select_profile(0)

    # --- construcción del chrome ---
    def _build(self):
        root = QHBoxLayout(self)
        root.setContentsMargins(6, 6, 6, 6)
        root.setSpacing(8)

        # Izquierda: QListView plano de perfiles.
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
        for key, label in PROFILE_LABELS:
            item = QListWidgetItem(label)
            item.setData(Qt.UserRole, key)
            self.list.addItem(item)
        self.list.currentRowChanged.connect(self._select_profile)
        root.addWidget(self.list)

        # Derecha: scroll con header + switch + accordions.
        self.scroll = QScrollArea()
        self.scroll.setWidgetResizable(True)
        self.scroll.setFrameShape(QFrame.NoFrame)
        self._right = QWidget()
        self.right_lay = QVBoxLayout(self._right)
        self.right_lay.setContentsMargins(8, 8, 8, 8)
        self.right_lay.setSpacing(8)
        self.scroll.setWidget(self._right)
        root.addWidget(self.scroll, 1)

    # --- selección / render ---
    @staticmethod
    def _clear_layout(layout):
        """Vacía un layout recursivamente, sacando widgets del árbol al instante."""
        while layout.count():
            item = layout.takeAt(0)
            w = item.widget()
            if w is not None:
                w.setParent(None)
                w.deleteLater()
            child = item.layout()
            if child is not None:
                ProfilesView._clear_layout(child)

    def _select_profile(self, row: int):
        if row < 0 or row >= len(PROFILE_LABELS):
            return
        self._profile_key = PROFILE_LABELS[row][0]
        # setCurrentRow re-dispara currentRowChanged; guardamos contra el doble
        # render comparando antes de tocar la selección.
        if self.list.currentRow() != row:
            self.list.blockSignals(True)
            self.list.setCurrentRow(row)
            self.list.blockSignals(False)
        self._render()

    def _set_mode(self, mode: str):
        self._mode = mode
        self._render()

    def _render(self):
        # Limpia el panel derecho. setParent(None) lo saca del árbol de forma
        # SÍNCRONA (deleteLater es asíncrono y dejaría fantasmas al re-render).
        self._clear_layout(self.right_lay)
        self._steppers.clear()
        self._vol_badges.clear()

        key = self._profile_key
        label = dict(PROFILE_LABELS)[key]
        n = len(self.db.crops_using_profile(key))

        # Header: nombre + switch de base.
        top = QHBoxLayout()
        pname = QLabel(label)
        pname.setStyleSheet(
            f"font-size:16px; font-weight:bold; color:{T.PRIMARY};"
            f" font-family:'{T.FONT_FAMILY}';"
        )
        top.addWidget(pname)
        top.addStretch()
        top.addWidget(self._build_base_switch())
        self.right_lay.addLayout(top)

        warn = _callout(
            f"⚠ Editar aplica a los {n} cultivos con este perfil · el dato se "
            f"GUARDA como “por 1000 ml de agua”; “aforado” es solo vista."
        )
        self.right_lay.addWidget(warn)

        for idx, (phase_key, phase_label, color) in enumerate(PHASES):
            recipe = self.db.profile_recipe(key, phase_key)
            acc = self._build_phase_accordion(phase_key, phase_label, color, recipe, n)
            # Contrato visual: solo la primera fase (Vegetativa) abierta; el resto
            # colapsado (comunica el hueco de fases aún sin receta).
            acc.set_open(idx == 0)
            self.right_lay.addWidget(acc)

        self._toast = QLabel("")
        self._toast.setStyleSheet("font-size:11px;")
        self.right_lay.addWidget(self._toast)
        self.right_lay.addStretch()

    def _build_base_switch(self) -> QWidget:
        box = QFrame()
        box.setStyleSheet(
            f"QFrame {{ border:1px solid {T.PRIMARY}; border-radius:6px; }}"
        )
        lay = QHBoxLayout(box)
        lay.setContentsMargins(0, 0, 0, 0)
        lay.setSpacing(0)
        cap = QLabel("Base:")
        cap.setStyleSheet(f"color:{T.TEXT_MUTED}; padding:5px 8px; font-size:12px;")
        lay.addWidget(cap)
        for mode, text in (("water", "Por 1000 ml de agua"), ("aforo", "Aforado a 1 L")):
            btn = QPushButton(text)
            on = self._mode == mode
            btn.setCursor(Qt.PointingHandCursor)
            btn.setStyleSheet(
                f"QPushButton {{ border:none; padding:5px 12px; font-size:12px;"
                f" font-family:'{T.FONT_FAMILY}';"
                + (
                    f" background:{T.PRIMARY}; color:{T.BTN_FG}; font-weight:600; }}"
                    if on
                    else f" background:{T.SURFACE}; color:{T.PRIMARY}; }}"
                )
            )
            btn.clicked.connect(lambda _=False, m=mode: self._set_mode(m))
            lay.addWidget(btn)
        return box

    def _build_phase_accordion(
        self, phase_key, phase_label, color, recipe, n
    ) -> _Accordion:
        has_recipe = isinstance(recipe, dict) and any(
            isinstance(recipe.get(sk), dict) for sk, _, _ in SOLUTIONS
        )
        subtitle = "" if has_recipe else "(sin receta — clic para agregar)"
        acc = _Accordion(phase_label, color, subtitle=subtitle)
        body = acc.body_layout()

        note = (
            "<b>Modo: por 1000 ml de agua.</b> Pesá la sal seca y disolvéla en "
            "1000 ml de agua; NO se afora. El volumen final (&gt;1 L) se calcula "
            "por solución."
            if self._mode == "water"
            else "<b>Modo: aforado a 1 L (solo vista).</b> Gramos reescalados a 1 L "
            "exacto, misma concentración; el guardado sigue siendo “por 1000 ml "
            "de agua”."
        )
        body.addWidget(_callout(note, info=True))

        cols = QHBoxLayout()
        cols.setSpacing(10)
        for sk, slabel, salts in SOLUTIONS:
            cols.addWidget(self._build_solution_col(phase_key, sk, slabel, salts, recipe))
        body.addLayout(cols)

        save = QPushButton(f"💾 Guardar {phase_label.replace('Fase ', '')} → {n} cultivos")
        save.setCursor(Qt.PointingHandCursor)
        save.setStyleSheet(
            f"QPushButton {{ background:{T.BTN_BG}; color:{T.BTN_FG}; border:none;"
            f" border-radius:4px; padding:6px 14px; font-size:12.5px;"
            f" font-family:'{T.FONT_FAMILY}'; }}"
            f" QPushButton:hover {{ background:{T.palette('primary', 30) or T.BTN_BG}; }}"
        )
        save.clicked.connect(lambda _=False, p=phase_key: self._on_save(p))
        save_row = QHBoxLayout()
        save_row.addWidget(save)
        save_row.addStretch()
        body.addLayout(save_row)
        return acc

    def _build_solution_col(self, phase_key, sk, slabel, salts, recipe) -> QWidget:
        col = QFrame()
        col.setStyleSheet(
            f"QFrame {{ border:1px solid {T.BORDER}; border-radius:6px; }}"
        )
        lay = QVBoxLayout(col)
        lay.setContentsMargins(9, 9, 9, 9)
        lay.setSpacing(6)

        head = QLabel(f"{slabel}  ·  g / 1000 ml de agua")
        head.setWordWrap(True)
        head.setStyleSheet(
            f"color:{T.SECONDARY}; font-size:11.5px; font-weight:600;"
            f" border-bottom:1px solid {T.TRACK}; padding-bottom:4px;"
        )
        lay.addWidget(head)

        sol_letter = sk.split("_")[1].upper()[0]
        lay.addWidget(
            _callout(
                f"⚠️ Stock {sol_letter} concentrado, aparte — no mezclar directo "
                f"con los otros.",
                mini=True,
            )
        )

        rec_salts = recipe.get(sk, {}) if isinstance(recipe, dict) else {}
        factor = self._factor_for(rec_salts)
        for salt in salts:
            grams = rec_salts.get(salt, 0) or 0
            shown = grams * factor if factor is not None else grams
            cell = QVBoxLayout()
            cell.setSpacing(2)
            cap = QLabel(SALT_LABELS.get(salt, salt))
            cap.setStyleSheet(f"font-size:13px; font-weight:600; color:{T.TEXT};")
            cell.addWidget(cap)
            stepper = Stepper(float(shown), "g", minimum=0.0, step=1.0)
            # En modo aforo el stepper es solo vista (no se persiste el reescalado).
            stepper.setEnabled(self._mode == "water")
            self._steppers[(phase_key, sk, salt)] = stepper
            cell.addWidget(stepper)
            lay.addLayout(cell)

        lay.addStretch()
        badge = QLabel("")
        badge.setStyleSheet(
            f"background:#E0ECF7; border-left:4px solid #2F77C2; border-radius:4px;"
            f" padding:7px 9px; font-size:12px; color:#1c3a5e;"
            f" font-family:'{T.FONT_FAMILY}';"
        )
        self._vol_badges[(phase_key, sk)] = badge
        lay.addWidget(badge)
        self._refresh_volume_badge(phase_key, sk)
        return col

    # --- cálculo de volumen / aforo ---
    def _current_salts(self, phase_key, sk) -> dict[str, float]:
        """Lee los steppers de una solución -> {salt: gramos mostrados}."""
        return {
            salt: (self._steppers[(phase_key, sk, salt)].value() or 0.0)
            for _sk, _l, salts in SOLUTIONS
            if _sk == sk
            for salt in salts
        }

    def _factor_for(self, salts: dict) -> float | None:
        if self._mode != "aforo":
            return 1.0
        f = rm.aforo_factor(salts, self._densities)
        return f if f is not None else 1.0

    def _refresh_volume_badge(self, phase_key, sk):
        badge = self._vol_badges.get((phase_key, sk))
        if badge is None:
            return
        salts = self._current_salts(phase_key, sk)
        if self._mode == "aforo":
            badge.setText("📐 Volumen final = 1,00 L (aforado)")
            return
        v = rm.unit_final_ml(salts, self._densities)
        if v is None:
            badge.setText("📐 Volumen final ≈ — (falta densidad)")
        else:
            badge.setText(f"📐 Volumen final ≈ {v / 1000:.2f} L".replace(".", ","))

    # --- guardado (propaga al perfil -> N cultivos, auditado) ---
    def _collect_recipe(self, phase_key) -> dict:
        recipe: dict[str, dict] = {}
        for sk, _label, salts in SOLUTIONS:
            recipe[sk] = {
                salt: (self._steppers[(phase_key, sk, salt)].value() or 0.0)
                for salt in salts
            }
        return recipe

    def _on_save(self, phase_key: str):
        if self._mode == "aforo":
            self._toast.setText(
                "Cambiá a “Por 1000 ml de agua” para editar/guardar (aforo es solo vista)."
            )
            self._toast.setStyleSheet(f"color:{T.WARNING}; font-size:11px;")
            return
        recipe = self._collect_recipe(phase_key)
        n = self.db.save_profile_recipe(
            self._profile_key, phase_key, recipe, changed_by="explorer"
        )
        self._toast.setText(f"✓ Guardado → propagado a {n} cultivos del perfil.")
        self._toast.setStyleSheet(f"color:{T.SUCCESS}; font-size:11px;")
        self.recipeSaved.emit(self._profile_key, phase_key, n)
        for sk, _l, _s in SOLUTIONS:
            self._refresh_volume_badge(phase_key, sk)
