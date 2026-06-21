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
  - Izquierda sticky: Datos Botánicos (familia, especie, parte comestible,
    origen, uso).
  - Der-arriba sticky (3 cols): Soluciones del Negocio (Apto + Perfil/Prioridad
    editables + Guardar→audit) · Constantes de Monitoreo (espectro, fotoperiodo).
  - Der-abajo: 4 tabs (Vegetativa/Reproductiva/Maduración/Valor Nutricional).
    Cada tab de fase = grid de InstrumentCard (de los setpoints activos) +
    árbol de receta de nutrientes. Tab Nutricional = tabla desde `nutrition`.
    Fase sin datos → "No aplica".

Emite ``classificationSaved(crop_id)`` tras un Guardar exitoso, para que el
sidebar re-evalúe discrepancias.
"""

from __future__ import annotations

import json

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
    QFrame,
    QSizePolicy,
)

from db import is_discrepant
from widgets.instrument_card import InstrumentCard

# --- Definición de tarjetas-instrumento (vegetativa/monitoreo) ---------------
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

# Perfiles y prioridades disponibles para los drop-downs editables.
PROFILE_CHOICES = [
    "leafy_vegetative",
    "herb_aromatic",
    "fruiting_vegetative",
    "fruiting_reproductive",
    "berry_fruiting",
    "root_bulking",
]
PRIORITY_CHOICES = ["1.0", "2.0", "3.0", "4.0", "5.0"]

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
    lbl.setStyleSheet("color:#94a3b8; font-style:italic; padding:24px;")
    return lbl


class DetailView(QWidget):
    """Panel de detalle de un cultivo."""

    classificationSaved = Signal(int)

    def __init__(self, db, parent=None):
        super().__init__(parent)
        self.db = db
        self._crop_id: int | None = None
        self._build()

    def _build(self):
        outer = QVBoxLayout(self)
        outer.setContentsMargins(8, 8, 8, 8)
        outer.setSpacing(8)

        self.title = QLabel("Selecciona un cultivo")
        self.title.setStyleSheet("font-size:18px; font-weight:bold; color:#1e293b;")
        outer.addWidget(self.title)

        self.disc_banner = QLabel("")
        self.disc_banner.setWordWrap(True)
        self.disc_banner.setStyleSheet(
            "background:#fee2e2; color:#991b1b; padding:6px; border-radius:4px;"
        )
        self.disc_banner.hide()
        outer.addWidget(self.disc_banner)

        # --- fila superior sticky: Botánicos | Negocio | Monitoreo ---
        top = QHBoxLayout()
        top.setSpacing(8)

        self.botanic_box = QGroupBox("Datos Botánicos")
        self.botanic_box.setStyleSheet(
            "QGroupBox { border:1px solid #fdba74; border-radius:6px; margin-top:8px;"
            " font-weight:bold; } QGroupBox::title { left:8px; padding:0 4px; }"
        )
        self.botanic_form = QVBoxLayout(self.botanic_box)
        top.addWidget(self.botanic_box, 1)

        self.business_box = QGroupBox("Soluciones del Negocio")
        self.business_box.setStyleSheet(
            "QGroupBox { border:1px solid #93c5fd; border-radius:6px; margin-top:8px;"
            " font-weight:bold; } QGroupBox::title { left:8px; padding:0 4px; }"
        )
        biz = QVBoxLayout(self.business_box)
        self.apt_label = QLabel("")
        biz.addWidget(self.apt_label)
        row1 = QHBoxLayout()
        row1.addWidget(QLabel("Perfil:"))
        self.profile_combo = QComboBox()
        self.profile_combo.addItems([""] + PROFILE_CHOICES)
        row1.addWidget(self.profile_combo, 1)
        biz.addLayout(row1)
        row2 = QHBoxLayout()
        row2.addWidget(QLabel("Prioridad:"))
        self.priority_combo = QComboBox()
        self.priority_combo.addItems([""] + PRIORITY_CHOICES)
        row2.addWidget(self.priority_combo, 1)
        biz.addLayout(row2)
        self.save_btn = QPushButton("💾 Guardar")
        self.save_btn.clicked.connect(self._on_save)
        biz.addWidget(self.save_btn)
        self.toast = QLabel("")
        self.toast.setStyleSheet("font-size:11px;")
        biz.addWidget(self.toast)
        top.addWidget(self.business_box, 1)

        self.monitor_box = QGroupBox("Constantes de Monitoreo")
        self.monitor_box.setStyleSheet(
            "QGroupBox { border:1px solid #c4b5fd; border-radius:6px; margin-top:8px;"
            " font-weight:bold; } QGroupBox::title { left:8px; padding:0 4px; }"
        )
        self.monitor_form = QVBoxLayout(self.monitor_box)
        top.addWidget(self.monitor_box, 1)

        outer.addLayout(top)

        # --- tabs de fase ---
        self.tabs = QTabWidget()
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
                f"'{crop['assigned_profile']}' presupone '{expected}'."
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
            row = QLabel(f"<b>{label}:</b> {val if val else '—'}")
            row.setWordWrap(True)
            self.botanic_form.addWidget(row)
        self.botanic_form.addStretch()

    def _fill_business(self, crop):
        apt = "✅ Apto para aeroponía" if crop["aeroponic"] else "❌ No apto (no-aeropónico)"
        self.apt_label.setText(apt)
        # set combos sin disparar guardado
        self.profile_combo.setCurrentText(crop["assigned_profile"] or "")
        pri = crop["priority"]
        self.priority_combo.setCurrentText("" if pri is None else f"{pri:g}.0" if float(pri).is_integer() else f"{pri:g}")
        self.toast.setText("")

    def _fill_monitor(self, crop_id):
        self._clear(self.monitor_form)
        sps = {s["field"]: s for s in self.db.active_setpoints(crop_id)}
        spectrum = sps.get("light_spectrum")
        photo = sps.get("photoperiod_h")
        spec_txt = spectrum["value_text"] if spectrum and spectrum["value_text"] else "—"
        photo_txt = f"{photo['value_num']:g} h" if photo and photo["value_num"] is not None else "—"
        self.monitor_form.addWidget(QLabel(f"<b>Espectro de luz:</b> {spec_txt}"))
        self.monitor_form.addWidget(QLabel(f"<b>Fotoperiodo:</b> {photo_txt}"))
        self.monitor_form.addStretch()

    def _build_phase_widget(self, crop_id, has_data: bool) -> QWidget:
        """Grid de InstrumentCard + árbol de receta para una fase con datos."""
        if not has_data:
            holder = QWidget()
            lay = QVBoxLayout(holder)
            lay.addWidget(_na_label())
            return holder

        sps = {s["field"]: s for s in self.db.active_setpoints(crop_id)}
        holder = QWidget()
        lay = QVBoxLayout(holder)
        lay.setSpacing(10)

        grid = QGridLayout()
        grid.setSpacing(8)
        col = 0
        rowi = 0
        ncols = 3
        for label, unit, fmin, fmax, fideal in CARD_DEFS:
            lo = sps[fmin]["value_num"] if fmin in sps else None
            hi = sps[fmax]["value_num"] if fmax in sps else None
            ideal = sps[fideal]["value_num"] if fideal and fideal in sps else None
            if lo is None and hi is None and ideal is None:
                continue
            # valor representado = ideal si existe, si no el punto medio del rango
            if ideal is not None:
                value = ideal
            elif lo is not None and hi is not None:
                value = (lo + hi) / 2
            else:
                value = lo if lo is not None else hi
            src_row = sps.get(fmin) or sps.get(fmax) or sps.get(fideal)
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
            )
            card.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
            grid.addWidget(card, rowi, col)
            col += 1
            if col >= ncols:
                col = 0
                rowi += 1
        lay.addLayout(grid)

        # árbol de receta
        recipe = sps.get("nutrient_recipe_json")
        if recipe and recipe["value_text"]:
            sep = QFrame()
            sep.setFrameShape(QFrame.HLine)
            sep.setStyleSheet("color:#e2e8f0;")
            lay.addWidget(sep)
            lay.addWidget(QLabel("<b>Receta de nutrientes (g / 1000 ml)</b>"))
            lay.addWidget(self._recipe_tree(recipe["value_text"]))
        lay.addStretch()
        return holder

    @staticmethod
    def _recipe_tree(recipe_json: str) -> QTreeWidget:
        tree = QTreeWidget()
        tree.setHeaderLabels(["Grupo / Sal", "g/1000ml"])
        tree.setColumnWidth(0, 240)
        try:
            recipe = json.loads(recipe_json)
        except Exception:
            recipe = {}

        def add(parent, key, val):
            if isinstance(val, dict):
                node = QTreeWidgetItem(parent, [str(key), ""])
                for k, v in val.items():
                    add(node, k, v)
                node.setExpanded(True)
            else:
                QTreeWidgetItem(parent, [str(key).replace("_", " "), f"{val:g}" if isinstance(val, (int, float)) else str(val)])

        for k, v in recipe.items():
            add(tree, k.replace("_", " "), v)
        tree.expandAll()
        return tree

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
        # Agrupar vitaminas/minerales en nodos.
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
        # Vegetativa: con datos si el cultivo tiene perfil (setpoints resueltos).
        self.tab_veg.setWidget(self._build_phase_widget(crop_id, has_profile))
        # Reproductiva / Maduración: la hoja está VACÍA -> No aplica.
        self.tab_repro.setWidget(self._build_phase_widget(crop_id, False))
        self.tab_madur.setWidget(self._build_phase_widget(crop_id, False))
        # Nutricional.
        self.tab_nutri.setWidget(self._nutrition_widget(crop_id))

    # --- guardar (auditado) ---
    def _on_save(self):
        if self._crop_id is None:
            return
        profile = self.profile_combo.currentText().strip() or None
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
            self.toast.setStyleSheet("color:#dc2626; font-size:11px;")
            self.toast.setText(f"✗ error: {exc}")
            return
        if changed:
            # refrescar detalle (re-lee combos/cards) y LUEGO mostrar el toast,
            # porque setCrop() limpia el toast al rellenar el panel de negocio.
            self.setCrop(self._crop_id)
            self.toast.setStyleSheet("color:#16a34a; font-size:11px;")
            self.toast.setText("✓ guardado — auditoría registrada")
            # avisar al sidebar para re-evaluar discrepancias
            self.classificationSaved.emit(self._crop_id)
        else:
            self.toast.setStyleSheet("color:#64748b; font-size:11px;")
            self.toast.setText("sin cambios")
