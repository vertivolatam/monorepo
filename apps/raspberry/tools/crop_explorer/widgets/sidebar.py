# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""Sidebar — búsqueda por nombre común + filtros reales + lista con estado.

Resuelve la crítica de la v1: filtros como combos multi-select consistentes
(Aeropónico / Tipo de cosecha / Perfil) + chip-toggle "⚠ solo discrepancias"
(no botón suelto) + lista con punto de estado (🟢 aeropónico · ⚪ no-aero ·
🟠 discrepancia) y un contador "N de TOTAL · M ⚠". Emite ``cropSelected(int)``.
"""

from __future__ import annotations

from PySide6.QtCore import Qt, Signal
from PySide6.QtWidgets import (
    QWidget,
    QVBoxLayout,
    QLabel,
    QLineEdit,
    QComboBox,
    QPushButton,
    QListWidget,
    QListWidgetItem,
)

from db import is_discrepant

DOT_AERO = "🟢"
DOT_NON_AERO = "⚪"
DOT_DISCREPANT = "🟠"

ANY = "(todos)"


class _MultiCombo(QComboBox):
    """ComboBox checkable simple para filtro multi-select."""

    changed = Signal()

    def __init__(self, placeholder: str, values: list[str], parent=None):
        super().__init__(parent)
        self._placeholder = placeholder
        self._checked: set[str] = set()
        self.setEditable(True)
        self.lineEdit().setReadOnly(True)
        self.lineEdit().setText(placeholder)
        from PySide6.QtGui import QStandardItem, QStandardItemModel

        self._model = QStandardItemModel(self)
        self.setModel(self._model)
        for v in values:
            item = QStandardItem(v)
            item.setCheckable(True)
            item.setCheckState(Qt.Unchecked)
            item.setEditable(False)
            self._model.appendRow(item)
        self.view().pressed.connect(self._toggle)

    def _toggle(self, index):
        item = self._model.itemFromIndex(index)
        if not item:
            return
        if item.checkState() == Qt.Checked:
            item.setCheckState(Qt.Unchecked)
            self._checked.discard(item.text())
        else:
            item.setCheckState(Qt.Checked)
            self._checked.add(item.text())
        self.lineEdit().setText(
            ", ".join(sorted(self._checked)) if self._checked else self._placeholder
        )
        self.changed.emit()

    def checked(self) -> set[str]:
        return set(self._checked)

    def hidePopup(self):  # mantener abierto al clickear
        pass


class Sidebar(QWidget):
    """Panel izquierdo: búsqueda + filtros + lista de cultivos."""

    cropSelected = Signal(int)

    def __init__(self, db, parent=None):
        super().__init__(parent)
        self.db = db
        self.crops = list(db.crops())
        self._discrepant_only = False
        self._build()
        self.refresh()

    # --- construcción ---
    def _build(self):
        lay = QVBoxLayout(self)
        lay.setContentsMargins(8, 8, 8, 8)
        lay.setSpacing(6)

        self.search = QLineEdit()
        self.search.setPlaceholderText("🔍 Buscar (nombre, familia, especie)…")
        self.search.textChanged.connect(self._apply)
        lay.addWidget(self.search)

        types = sorted({c["sheet_harvest_type"] for c in self.crops if c["sheet_harvest_type"]})
        profiles = sorted({c["assigned_profile"] for c in self.crops if c["assigned_profile"]})

        self.combo_aero = _MultiCombo("Aeropónico", ["SI", "NO"], self)
        self.combo_type = _MultiCombo("Tipo (cosecha)", types, self)
        self.combo_profile = _MultiCombo("Perfil", profiles, self)
        for cb in (self.combo_aero, self.combo_type, self.combo_profile):
            cb.changed.connect(self._apply)
            lay.addWidget(cb)

        self.chip_disc = QPushButton("⚠  solo discrepancias")
        self.chip_disc.setCheckable(True)
        self.chip_disc.setStyleSheet(
            "QPushButton { text-align:left; padding:4px 8px; border:1px solid #fca5a5;"
            "  border-radius:12px; background:#fff; color:#991b1b; }"
            "QPushButton:checked { background:#fee2e2; font-weight:bold; }"
        )
        self.chip_disc.toggled.connect(self._on_chip)
        lay.addWidget(self.chip_disc)

        self.counter = QLabel("")
        self.counter.setStyleSheet("color:#64748b; font-size:11px; padding:2px;")
        lay.addWidget(self.counter)

        self.list = QListWidget()
        self.list.currentItemChanged.connect(self._on_select)
        lay.addWidget(self.list, 1)

    # --- filtrado ---
    def _matches(self, crop) -> bool:
        term = self.search.text().strip().lower()
        if term:
            hay = " ".join(
                str(crop[k] or "") for k in ("name_es", "name_en", "family", "species")
            ).lower()
            if term not in hay:
                return False
        aero = self.combo_aero.checked()
        if aero:
            label = "SI" if crop["aeroponic"] else "NO"
            if label not in aero:
                return False
        types = self.combo_type.checked()
        if types and (crop["sheet_harvest_type"] or "") not in types:
            return False
        profiles = self.combo_profile.checked()
        if profiles and (crop["assigned_profile"] or "") not in profiles:
            return False
        if self._discrepant_only and not is_discrepant(
            crop["assigned_profile"], crop["sheet_harvest_type"]
        ):
            return False
        return True

    def _dot(self, crop) -> str:
        if is_discrepant(crop["assigned_profile"], crop["sheet_harvest_type"]):
            return DOT_DISCREPANT
        return DOT_AERO if crop["aeroponic"] else DOT_NON_AERO

    def refresh(self):
        """Re-lee crops desde la DB (tras un Guardar que cambió clasificación)."""
        self.crops = list(self.db.crops())
        self._apply()

    def _apply(self):
        prev_id = self.current_crop_id()
        self.list.blockSignals(True)
        self.list.clear()
        shown = 0
        n_disc = 0
        restore_row = None
        for crop in self.crops:
            if not self._matches(crop):
                continue
            disc = is_discrepant(crop["assigned_profile"], crop["sheet_harvest_type"])
            if disc:
                n_disc += 1
            type_txt = crop["sheet_harvest_type"] or "—"
            item = QListWidgetItem(f"{self._dot(crop)}  {crop['name_es']}   · {type_txt}")
            item.setData(Qt.UserRole, crop["id"])
            self.list.addItem(item)
            if crop["id"] == prev_id:
                restore_row = self.list.count() - 1
            shown += 1
        self.list.blockSignals(False)
        total = len(self.crops)
        self.counter.setText(f"{shown} de {total}  ·  {n_disc} ⚠")
        if restore_row is not None:
            self.list.setCurrentRow(restore_row)

    # --- handlers ---
    def _on_chip(self, on: bool):
        self._discrepant_only = on
        self._apply()

    def _on_select(self, current, _prev):
        if current is None:
            return
        crop_id = current.data(Qt.UserRole)
        if crop_id is not None:
            self.cropSelected.emit(int(crop_id))

    def current_crop_id(self) -> int | None:
        item = self.list.currentItem()
        if item is None:
            return None
        return item.data(Qt.UserRole)

    # --- helpers para tests ---
    def visible_count(self) -> int:
        return self.list.count()
