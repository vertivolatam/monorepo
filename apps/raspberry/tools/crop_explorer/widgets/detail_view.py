# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""DetailView — el panel de detalle que mapea los grupos de la hoja.

Layout:
  - Izquierda sticky: Datos Botánicos.
  - Der-arriba sticky (3 cols): Soluciones del Negocio (Perfil/Prioridad
    editables + Guardar→audit) · Constantes de Monitoreo.
  - Der-abajo: 4 tabs (Vegetativa/Reproductiva/Maduración/Valor Nutricional).
    Cada tab de fase = grid de InstrumentCard EDITABLES (de los setpoints
    activos) a la izquierda + la receta de nutrientes (agrupada en Solución
    A/B/C) como sidebar a la DERECHA. Tab Nutricional = tabla desde `nutrition`.

Colores/tipografía vienen de ``tokens.py`` (design system de Vertivo). Editar
un rango o el perfil escribe en ``setpoint_audit`` (rollback posible).
"""

from __future__ import annotations

import json
import os
import sys

from PySide6.QtCore import Qt, Signal
from PySide6.QtWidgets import (
    QWidget,
    QVBoxLayout,
    QHBoxLayout,
    QGridLayout,
    QLabel,
    QComboBox,
    QPushButton,
    QGroupBox,
    QTabWidget,
    QTreeWidget,
    QTreeWidgetItem,
    QScrollArea,
    QSizePolicy,
)

from db import is_discrepant
from widgets.instrument_card import InstrumentCard

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import tokens as T  # noqa: E402

# --- Definición de tarjetas-instrumento -------------------------------------
# (label, unidad, field_min, field_max, field_ideal). El gauge usa lo/hi/ideal.
CARD_DEFS = [
    ("pH", "", "ph_min", "ph_max", "ph_ideal"),
    ("EC", "dS/m", "ec_min_dsm", "ec_max_dsm", None),
    ("PPFD", "µmol/m²·s", "ppfd_min", "ppfd_max", None),
    ("Temp. día", "°C", "temp_day_min", "temp_day_max", None),
    ("Temp. noche", "°C", "temp_night_min", "temp_night_max", None),
    ("Humedad", "%", "humidity_min", "humidity_max", None),
    ("ORP", "mV", "orp_min", "orp_max", None),
]

PRIORITY_CHOICES = ["1.0", "2.0", "3.0", "4.0", "5.0"]

# Etiquetas en español para los grupos de la receta (A/B/C).
RECIPE_GROUP_LABELS = {
    "solucion_a_nitratos": "Solución A — Nitratos",
    "solucion_b_fosfatos_sulfatos": "Solución B — Fosfatos / Sulfatos",
    "solucion_c_micros": "Solución C — Micronutrientes",
}
# Keys que NO son sales (provenance) y no deben renderizarse como ingredientes.
_RECIPE_META_KEYS = {"citation", "confidence", "source", "note", "_provenance"}

NUTRIENT_LABELS = {
    "energy": "Energía",
    "carbohydrates_sugars": "Carbohidratos (azúcares)",
    "dietary_fiber": "Fibra alimentaria",
    "fat": "Grasas",
    "protein": "Proteínas",
    "water": "Agua",
    "vit_a_retinol": "Vit. A (retinol)",
    "vit_beta_carotene": "β-caroteno",
    "vit_b1_thiamine": "Vit. B1 (tiamina)",
    "vit_b2_riboflavin": "Vit. B2 (riboflavina)",
    "vit_b3_niacin": "Vit. B3 (niacina)",
    "vit_b5_pantothenic": "Vit. B5 (ác. pantoténico)",
    "vit_b6": "Vit. B6",
    "vit_b9_folate": "Vit. B9 (folato)",
    "vit_choline": "Colina",
    "vit_c": "Vit. C",
    "vit_e": "Vit. E",
    "vit_k": "Vit. K",
    "min_calcium": "Calcio",
    "min_iron": "Hierro",
    "min_magnesium": "Magnesio",
    "min_manganese": "Manganeso",
    "min_phosphorus": "Fósforo",
    "min_potassium": "Potasio",
    "min_sodium": "Sodio",
    "min_zinc": "Zinc",
}


def _na_label(text: str = "No aplica") -> QLabel:
    lbl = QLabel(text)
    lbl.setAlignment(Qt.AlignCenter)
    lbl.setStyleSheet(
        f"color:{T.TEXT_MUTED}; font-style:italic; padding:24px;"
        f" font-family:'{T.FONT_FAMILY}';"
    )
    return lbl


class DetailView(QWidget):
    """Panel de detalle de un cultivo."""

    classificationSaved = Signal(int)

    def __init__(self, db, parent=None):
        super().__init__(parent)
        self.db = db
        self._crop_id: int | None = None
        self._build()

    # --- helpers de perfil (valor mostrado = label_es de crops.json) ---
    def _profile_items(self) -> list[tuple[str, str]]:
        profs = self.db._profiles()
        out: list[tuple[str, str]] = []
        for slug, p in profs.items():
            label = (p.get("label_es") or slug) if isinstance(p, dict) else slug
            out.append((slug, label))
        return out

    def _profile_label(self, slug: str | None) -> str:
        if not slug:
            return "—"
        for s, label in self._profile_items():
            if s == slug:
                return label
        return slug

    def _build(self):
        self.setStyleSheet(f"DetailView {{ font-family:'{T.FONT_FAMILY}'; }}")
        outer = QVBoxLayout(self)
        outer.setContentsMargins(8, 8, 8, 8)
        outer.setSpacing(8)

        self.title = QLabel("Selecciona un cultivo")
        self.title.setStyleSheet(
            f"font-size:18px; font-weight:bold; color:{T.PRIMARY};"
            f" font-family:'{T.FONT_FAMILY}';"
        )
        outer.addWidget(self.title)

        self.disc_banner = QLabel("")
        self.disc_banner.setWordWrap(True)
        self.disc_banner.setStyleSheet(
            f"background:{T.palette('warning', 90) or '#FFDCAA'};"
            f" color:{T.palette('warning', 20) or '#4D2600'};"
            " padding:8px; border-radius:6px;"
        )
        self.disc_banner.hide()
        outer.addWidget(self.disc_banner)

        # --- fila superior sticky: Botánicos | Negocio | Monitoreo ---
        top = QHBoxLayout()
        top.setSpacing(8)

        self.botanic_box = QGroupBox("Datos Botánicos")
        self.botanic_box.setStyleSheet(T.groupbox_qss("botanic"))
        self.botanic_form = QVBoxLayout(self.botanic_box)
        self.botanic_form.setContentsMargins(12, 16, 12, 12)
        self.botanic_form.setSpacing(7)
        top.addWidget(self.botanic_box, 1)

        self.business_box = QGroupBox("Soluciones del Negocio")
        self.business_box.setStyleSheet(T.groupbox_qss("business"))
        biz = QVBoxLayout(self.business_box)
        biz.setContentsMargins(12, 16, 12, 12)
        biz.setSpacing(7)
        self.apt_label = QLabel("")
        biz.addWidget(self.apt_label)
        row1 = QHBoxLayout()
        row1.addWidget(QLabel("Perfil:"))
        self.profile_combo = QComboBox()
        self.profile_combo.addItem("— sin perfil —", "")
        for slug, label in self._profile_items():
            self.profile_combo.addItem(label, slug)
        row1.addWidget(self.profile_combo, 1)
        biz.addLayout(row1)
        row2 = QHBoxLayout()
        row2.addWidget(QLabel("Prioridad:"))
        self.priority_combo = QComboBox()
        self.priority_combo.addItems([""] + PRIORITY_CHOICES)
        row2.addWidget(self.priority_combo, 1)
        biz.addLayout(row2)
        self.save_btn = QPushButton("💾 Guardar")
        self.save_btn.setStyleSheet(
            f"QPushButton {{ background:{T.BTN_BG}; color:{T.BTN_FG}; border:none;"
            f" border-radius:6px; padding:5px 10px; font-weight:600; }}"
            f" QPushButton:hover {{ background:{T.palette('primary', 30) or T.BTN_BG}; }}"
        )
        self.save_btn.clicked.connect(self._on_save)
        biz.addWidget(self.save_btn)
        self.toast = QLabel("")
        self.toast.setStyleSheet("font-size:11px;")
        biz.addWidget(self.toast)
        top.addWidget(self.business_box, 1)

        self.monitor_box = QGroupBox("Constantes de Monitoreo")
        self.monitor_box.setStyleSheet(T.groupbox_qss("monitor"))
        self.monitor_form = QVBoxLayout(self.monitor_box)
        self.monitor_form.setContentsMargins(12, 16, 12, 12)
        self.monitor_form.setSpacing(7)
        top.addWidget(self.monitor_box, 1)

        outer.addLayout(top)

        # --- tabs de fase ---
        self.tabs = QTabWidget()
        self.tabs.setStyleSheet(
            f"QTabBar::tab {{ padding:6px 12px; font-family:'{T.FONT_FAMILY}'; }}"
            f" QTabBar::tab:selected {{ color:{T.PRIMARY}; font-weight:600;"
            f" border-bottom:2px solid {T.PRIMARY}; }}"
        )
        self.tab_veg = QScrollArea()
        self.tab_repro = QScrollArea()
        self.tab_madur = QScrollArea()
        self.tab_nutri = QScrollArea()
        for area in (self.tab_veg, self.tab_repro, self.tab_madur, self.tab_nutri):
            area.setWidgetResizable(True)
        self.tabs.addTab(self.tab_veg, "🟣 Vegetativa")
        self.tabs.addTab(self.tab_repro, "🟥 Reproductiva")
        self.tabs.addTab(self.tab_madur, "🔵 Maduración")
        self.tabs.addTab(self.tab_nutri, "🟢 Valor Nutricional")
        outer.addWidget(self.tabs, 1)

    # --- API pública ---
    def setCrop(self, crop_id: int):
        crop = self.db.crop(crop_id)
        if crop is None:
            return
        self._crop_id = crop_id
        self._fill_header(crop)
        self._fill_botanic(crop)
        self._fill_business(crop)
        self._fill_monitor(crop_id)
        self._fill_tabs(crop_id, crop)

    # --- secciones ---
    def _fill_header(self, crop):
        en = crop["name_en"] or ""
        self.title.setText(f"{crop['name_es']}  ({en})")
        if is_discrepant(crop["assigned_profile"], crop["sheet_harvest_type"]):
            from build_db import PROFILE_TO_SHEET_TYPE

            expected = PROFILE_TO_SHEET_TYPE.get(crop["assigned_profile"])
            self.disc_banner.setText(
                f"⚠ DISCREPANCIA: la hoja clasifica como "
                f"'{crop['sheet_harvest_type']}' pero el perfil "
                f"'{self._profile_label(crop['assigned_profile'])}' presupone "
                f"'{expected}'."
            )
            self.disc_banner.show()
        else:
            self.disc_banner.hide()

    @staticmethod
    def _clear(layout):
        while layout.count():
            item = layout.takeAt(0)
            w = item.widget()
            if w is not None:
                w.setParent(None)  # desacopla YA (deleteLater difiere la destrucción)
                w.deleteLater()

    def _fill_botanic(self, crop):
        self._clear(self.botanic_form)
        for label, key in [
            ("Familia", "family"),
            ("Especie", "species"),
            ("Parte comestible", "edible_part"),
            ("Origen", "origin"),
            ("Uso general", "general_use"),
            ("Uso común", "common_use"),
        ]:
            val = crop[key] if key in crop.keys() else None
            row = QLabel(
                f"<span style='color:{T.TEXT_MUTED}'>{label}:</span>"
                f" <b style='color:{T.TEXT}'>{val if val else '—'}</b>"
            )
            row.setWordWrap(True)
            self.botanic_form.addWidget(row)
        self.botanic_form.addStretch()

    def _fill_business(self, crop):
        apt = "✅ Apto para aeroponía" if crop["aeroponic"] else "❌ No apto (no-aeropónico)"
        self.apt_label.setText(apt)
        # seleccionar por KEY (userData); el combo muestra el label_es en español.
        idx = self.profile_combo.findData(crop["assigned_profile"] or "")
        self.profile_combo.setCurrentIndex(idx if idx >= 0 else 0)
        pri = crop["priority"]
        self.priority_combo.setCurrentText(
            "" if pri is None
            else f"{pri:g}.0" if float(pri).is_integer() else f"{pri:g}"
        )
        self.toast.setText("")

    def _fill_monitor(self, crop_id):
        self._clear(self.monitor_form)
        sps = {s["field"]: s for s in self.db.active_setpoints(crop_id)}
        spectrum = sps.get("light_spectrum")
        photo = sps.get("photoperiod_h")
        spec_txt = spectrum["value_text"] if spectrum and spectrum["value_text"] else "—"
        photo_txt = f"{photo['value_num']:g} h" if photo and photo["value_num"] is not None else "—"
        for label, val in [("Espectro de luz", spec_txt), ("Fotoperiodo", photo_txt)]:
            self.monitor_form.addWidget(
                QLabel(
                    f"<span style='color:{T.TEXT_MUTED}'>{label}:</span>"
                    f" <b style='color:{T.TEXT}'>{val}</b>"
                )
            )
        self.monitor_form.addStretch()

    def _build_phase_widget(self, crop_id, has_data: bool) -> QWidget:
        """Cards editables (izq) + receta agrupada A/B/C como sidebar (der)."""
        if not has_data:
            holder = QWidget()
            lay = QVBoxLayout(holder)
            lay.addWidget(_na_label())
            return holder

        sps = {s["field"]: s for s in self.db.active_setpoints(crop_id)}
        holder = QWidget()
        outer = QVBoxLayout(holder)
        outer.setContentsMargins(4, 4, 4, 4)

        body = QHBoxLayout()
        body.setSpacing(12)

        # --- izquierda: grid de cards editables ---
        cards_host = QWidget()
        grid = QGridLayout(cards_host)
        grid.setContentsMargins(0, 0, 0, 0)
        grid.setSpacing(10)
        col = 0
        rowi = 0
        ncols = 3
        for label, unit, fmin, fmax, fideal in CARD_DEFS:
            lo = sps[fmin]["value_num"] if fmin in sps else None
            hi = sps[fmax]["value_num"] if fmax in sps else None
            ideal = sps[fideal]["value_num"] if fideal and fideal in sps else None
            if lo is None and hi is None and ideal is None:
                continue
            if ideal is not None:
                value = ideal
            elif lo is not None and hi is not None:
                value = (lo + hi) / 2
            else:
                value = lo if lo is not None else hi
            src_row = sps.get(fmin) or sps.get(fmax) or (sps.get(fideal) if fideal else None)
            card = InstrumentCard(
                label=label,
                value=value,
                unit=unit,
                lo=lo,
                hi=hi,
                ideal=ideal,
                source=src_row["source"] if src_row else None,
                confidence=src_row["confidence"] if src_row else None,
                citation=src_row["citation"] if src_row else None,
                editable=True,
                min_field=fmin,
                ideal_field=fideal,
                max_field=fmax,
            )
            card.rangeEdited.connect(self._on_setpoint_save)
            card.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
            grid.addWidget(card, rowi, col)
            col += 1
            if col >= ncols:
                col = 0
                rowi += 1
        grid.setRowStretch(rowi + 1, 1)
        body.addWidget(cards_host, 1)

        # --- derecha: receta de nutrientes como sidebar ---
        recipe = sps.get("nutrient_recipe_json")
        recipe_w = self._recipe_sidebar(recipe["value_text"] if recipe else None)
        recipe_w.setFixedWidth(320)
        body.addWidget(recipe_w, 0)

        outer.addLayout(body)
        return holder

    def _recipe_sidebar(self, recipe_json: str | None) -> QWidget:
        """Sidebar de la receta: árbol agrupado A/B/C (sin keys de provenance)."""
        box = QGroupBox("Receta de nutrientes  ·  g / 1000 ml")
        box.setStyleSheet(T.groupbox_qss("business"))
        lay = QVBoxLayout(box)
        lay.setContentsMargins(10, 16, 10, 10)
        lay.setSpacing(6)

        try:
            recipe = json.loads(recipe_json) if recipe_json else {}
        except Exception:
            recipe = {}

        groups = {k: v for k, v in recipe.items()
                  if k not in _RECIPE_META_KEYS and isinstance(v, dict)}

        if not groups:
            # Receta-stub: sólo provenance. Mostramos el hueco + la cita.
            lay.addWidget(_na_label("Sin receta detallada"))
            cite = recipe.get("citation")
            if cite:
                note = QLabel(f"<i>Referencia:</i> {cite}")
                note.setWordWrap(True)
                note.setStyleSheet(f"color:{T.TEXT_MUTED}; font-size:10px;")
                lay.addWidget(note)
            lay.addStretch()
            return box

        tree = QTreeWidget()
        tree.setHeaderLabels(["Grupo / Sal", "g/1000ml"])
        tree.setColumnWidth(0, 200)
        tree.setStyleSheet(
            f"QTreeWidget {{ border:1px solid {T.BORDER}; border-radius:6px;"
            f" background:{T.SURFACE}; font-family:'{T.FONT_FAMILY}'; }}"
        )
        for gkey, salts in groups.items():
            glabel = RECIPE_GROUP_LABELS.get(gkey, gkey.replace("_", " ").title())
            gnode = QTreeWidgetItem(tree, [glabel, ""])
            gnode.setFirstColumnSpanned(False)
            for salt, grams in salts.items():
                sname = salt.replace("_", " ")
                gval = f"{grams:g}" if isinstance(grams, (int, float)) else str(grams)
                QTreeWidgetItem(gnode, [sname, gval])
            gnode.setExpanded(True)
        tree.expandAll()
        lay.addWidget(tree)
        return box

    def _nutrition_widget(self, crop_id) -> QWidget:
        rows = self.db.nutrition(crop_id)
        holder = QWidget()
        lay = QVBoxLayout(holder)
        if not rows:
            lay.addWidget(_na_label("Sin datos nutricionales"))
            return holder
        src = rows[0]["source"]
        badge = "🟦 sheet" if src == "sheet" else "🟨 researched"
        lay.addWidget(QLabel(f"<b>Valor nutricional por 100 g</b>  ·  {badge}"))
        tree = QTreeWidget()
        tree.setHeaderLabels(["Nutriente", "Valor", "Unidad"])
        tree.setColumnWidth(0, 220)
        tree.setStyleSheet(
            f"QTreeWidget {{ border:1px solid {T.BORDER}; border-radius:6px;"
            f" background:{T.SURFACE}; font-family:'{T.FONT_FAMILY}'; }}"
        )
        vit_node = QTreeWidgetItem(tree, ["Vitaminas", "", ""])
        min_node = QTreeWidgetItem(tree, ["Minerales", "", ""])
        for r in rows:
            n = r["nutrient"]
            label = NUTRIENT_LABELS.get(n, n)
            val = "—" if r["value_num"] is None else f"{r['value_num']:g}"
            unit = r["unit"] or ""
            if n.startswith("vit_"):
                QTreeWidgetItem(vit_node, [label, val, unit])
            elif n.startswith("min_"):
                QTreeWidgetItem(min_node, [label, val, unit])
            else:
                QTreeWidgetItem(tree, [label, val, unit])
        vit_node.setExpanded(True)
        min_node.setExpanded(True)
        lay.addWidget(tree)
        return holder

    def _fill_tabs(self, crop_id, crop):
        has_profile = bool(crop["assigned_profile"])
        self.tab_veg.setWidget(self._build_phase_widget(crop_id, has_profile))
        # Reproductiva / Maduración: la hoja está VACÍA -> No aplica.
        self.tab_repro.setWidget(self._build_phase_widget(crop_id, False))
        self.tab_madur.setWidget(self._build_phase_widget(crop_id, False))
        self.tab_nutri.setWidget(self._nutrition_widget(crop_id))

    # --- toast helper ---
    def _set_toast(self, text: str, *, error: bool = False):
        color = T.ERROR if error else T.SUCCESS
        self.toast.setStyleSheet(f"color:{color}; font-size:11px;")
        self.toast.setText(text)

    # --- guardar clasificación (perfil/prioridad) ---
    def _on_save(self):
        if self._crop_id is None:
            return
        profile = self.profile_combo.currentData() or None
        pri_txt = self.priority_combo.currentText().strip()
        priority = float(pri_txt) if pri_txt else None
        try:
            changed = self.db.save_classification(
                self._crop_id,
                profile=profile,
                priority=priority,
                changed_by="explorer",
            )
        except Exception as exc:  # pragma: no cover - error path
            self._set_toast(f"✗ error: {exc}", error=True)
            return
        if changed:
            self.setCrop(self._crop_id)
            self._set_toast("✓ guardado — auditoría registrada")
            self.classificationSaved.emit(self._crop_id)
        else:
            self._set_toast("sin cambios")

    # --- guardar edición de rango numérico (auditada) ---
    def _on_setpoint_save(self, payload: dict):
        if self._crop_id is None:
            return
        values: dict[str, float | None] = {}
        if payload.get("min_field"):
            values[payload["min_field"]] = payload.get("lo")
        if payload.get("ideal_field"):
            values[payload["ideal_field"]] = payload.get("ideal")
        if payload.get("max_field"):
            values[payload["max_field"]] = payload.get("hi")
        try:
            changed = self.db.save_setpoint_range(
                self._crop_id, values=values, changed_by="explorer"
            )
        except Exception as exc:  # pragma: no cover - error path
            self._set_toast(f"✗ error: {exc}", error=True)
            return
        if changed:
            self.setCrop(self._crop_id)
            self._set_toast("✓ rango guardado — auditoría registrada")
            self.classificationSaved.emit(self._crop_id)
        else:
            self._set_toast("sin cambios")
