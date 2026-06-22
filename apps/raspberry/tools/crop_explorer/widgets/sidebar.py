# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""Sidebar — búsqueda + filtros + árbol PIVOT (agrupación multinivel reordenable).

Filtros multi-select en español (Aeropónico / Tipo de cosecha / Perfil, con
opción "Sin perfil") + chip "⚠ solo discrepancias". La lista es un ``QTreeWidget``
estilo tabla dinámica de Excel: el usuario activa uno o varios NIVELES de
agrupación (Prioridad / Tipo de cultivo / Perfil) y los **reordena arrastrando**;
el árbol se reconstruye anidado y cada grupo es colapsable/expandible (preserva
el estado al refiltrar). Emite ``cropSelected(int)``.
"""

from __future__ import annotations

import os
import sys

from PySide6.QtCore import Qt, Signal
from PySide6.QtGui import QColor, QFont
from PySide6.QtWidgets import (
    QWidget,
    QVBoxLayout,
    QHBoxLayout,
    QLabel,
    QLineEdit,
    QComboBox,
    QPushButton,
    QListWidget,
    QListWidgetItem,
    QTreeWidget,
    QTreeWidgetItem,
    QTreeWidgetItemIterator,
    QAbstractItemView,
)

from db import is_discrepant

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import tokens as T  # noqa: E402

DOT_AERO = "🟢"
DOT_NON_AERO = "⚪"
DOT_DISCREPANT = "🟠"

NO_PROFILE_VALUE = ""  # valor centinela del filtro "Sin perfil"

# Roles de datos en los items del árbol.
ROLE_CROP_ID = Qt.UserRole       # leaf -> crop_id; grupo -> None
ROLE_GROUP_PATH = Qt.UserRole + 1  # grupo -> tupla-path (para preservar colapso)

# Dimensiones de agrupación disponibles (label, key).
GROUP_DIMENSIONS = [
    ("Prioridad", "priority"),
    ("Tipo de cultivo", "type"),
    ("Perfil", "profile"),
]


class _MultiCombo(QComboBox):
    """ComboBox multi-select. Muestra ``label`` pero filtra por ``value``.

    El estado seleccionado se marca con un prefijo "✓" en el texto del item (no
    con el indicator de checkbox del estilo), porque ese indicator es casi
    invisible en dark mode con Fusion. Así el check se ve en cualquier tema.
    """

    changed = Signal()
    _CHECK = "✓ "
    _BLANK = "    "

    def __init__(self, placeholder: str, items: list[tuple[str, str]], parent=None):
        super().__init__(parent)
        self._placeholder = placeholder
        self._checked: set[str] = set()  # guarda VALUES, no labels
        self._label_of: dict[str, str] = {}
        self.setEditable(True)
        self.lineEdit().setReadOnly(True)
        self.lineEdit().setText(placeholder)
        from PySide6.QtGui import QStandardItem, QStandardItemModel

        self._model = QStandardItemModel(self)
        self.setModel(self._model)
        for label, value in items:
            item = QStandardItem(self._BLANK + label)
            item.setEditable(False)
            item.setData(value, Qt.UserRole)
            item.setData(label, Qt.UserRole + 1)  # label base (sin prefijo)
            self._model.appendRow(item)
            self._label_of[value] = label
        self.view().pressed.connect(self._toggle)

    def _toggle(self, index):
        item = self._model.itemFromIndex(index)
        if not item:
            return
        value = item.data(Qt.UserRole)
        base = item.data(Qt.UserRole + 1)
        if value in self._checked:
            self._checked.discard(value)
            item.setText(self._BLANK + base)
        else:
            self._checked.add(value)
            item.setText(self._CHECK + base)
        labels = [self._label_of.get(v, v) for v in self._checked]
        self.lineEdit().setText(
            ", ".join(sorted(labels)) if labels else self._placeholder
        )
        self.changed.emit()

    def checked(self) -> set[str]:
        return set(self._checked)

    def hidePopup(self):  # mantener abierto al clickear
        pass


class Sidebar(QWidget):
    """Panel izquierdo: búsqueda + filtros + árbol pivot de cultivos."""

    cropSelected = Signal(int)

    def __init__(self, db, parent=None):
        super().__init__(parent)
        self.db = db
        self.crops = list(db.crops())
        self._discrepant_only = False
        self._collapsed: set[tuple] = set()  # paths de grupo colapsados
        self._profile_label = {
            slug: (p.get("label_es") or slug)
            for slug, p in db._profiles().items()
            if isinstance(p, dict)
        }
        self._build()
        self.refresh()

    # --- construcción ---
    def _build(self):
        lay = QVBoxLayout(self)
        lay.setContentsMargins(8, 8, 8, 8)
        lay.setSpacing(6)
        self.setStyleSheet(f"Sidebar {{ font-family:'{T.FONT_FAMILY}'; }}")

        self.search = QLineEdit()
        self.search.setPlaceholderText("🔍 Buscar (nombre, familia, especie)…")
        self.search.textChanged.connect(self._apply)
        lay.addWidget(self.search)

        types = sorted({c["sheet_harvest_type"] for c in self.crops if c["sheet_harvest_type"]})
        profiles = sorted({c["assigned_profile"] for c in self.crops if c["assigned_profile"]})

        self.combo_aero = _MultiCombo("Todos", [("Sí", "SI"), ("No", "NO")], self)
        self.combo_type = _MultiCombo("Todos", [(t, t) for t in types], self)
        profile_items = [("— Sin perfil —", NO_PROFILE_VALUE)] + [
            (self._profile_label.get(s, s), s) for s in profiles
        ]
        self.combo_profile = _MultiCombo("Todos", profile_items, self)

        def _filter_row(caption: str, combo: _MultiCombo):
            row = QHBoxLayout()
            row.setSpacing(6)
            cap = QLabel(caption)
            cap.setFixedWidth(86)
            cap.setWordWrap(True)
            cap.setStyleSheet(
                f"color:{T.TEXT_MUTED}; font-size:10px; font-weight:bold;"
                " text-transform:uppercase;"
            )
            row.addWidget(cap)
            combo.changed.connect(self._apply)
            row.addWidget(combo, 1)
            lay.addLayout(row)

        _filter_row("Aeropónico", self.combo_aero)
        _filter_row("Tipo de cosecha", self.combo_type)
        _filter_row("Perfil asignado", self.combo_profile)

        # --- pivot: niveles de agrupación checkables + reordenables (drag) ---
        glabel = QLabel("Niveles de agrupación (✓ activa · arrastra para reordenar):")
        glabel.setWordWrap(True)
        glabel.setStyleSheet(f"color:{T.TEXT_MUTED}; font-size:11px;")
        lay.addWidget(glabel)

        self.group_levels = QListWidget()
        self.group_levels.setDragDropMode(QAbstractItemView.InternalMove)
        self.group_levels.setSelectionMode(QAbstractItemView.SingleSelection)
        self.group_levels.setMaximumHeight(92)
        self.group_levels.setStyleSheet(
            f"QListWidget {{ border:1px solid {T.BORDER}; border-radius:6px;"
            f" background:{T.SURFACE}; font-size:12px; }}"
        )
        for label, key in GROUP_DIMENSIONS:
            it = QListWidgetItem(label)
            it.setData(Qt.UserRole, key)
            it.setFlags(it.flags() | Qt.ItemIsUserCheckable)
            it.setCheckState(Qt.Unchecked)
            self.group_levels.addItem(it)
        self.group_levels.itemChanged.connect(self._apply)
        self.group_levels.model().rowsMoved.connect(lambda *a: self._apply())
        lay.addWidget(self.group_levels)

        self.chip_disc = QPushButton("⚠  solo discrepancias")
        self.chip_disc.setCheckable(True)
        warn_border = T.palette("warning", 60) or "#CC7A07"
        warn_bg = T.palette("warning", 90) or "#FFDCAA"
        warn_fg = T.palette("warning", 20) or "#4D2600"
        self.chip_disc.setStyleSheet(
            f"QPushButton {{ text-align:left; padding:4px 8px; border:1px solid {warn_border};"
            f"  border-radius:12px; background:{T.SURFACE}; color:{warn_fg}; }}"
            f"QPushButton:checked {{ background:{warn_bg}; font-weight:bold; }}"
        )
        self.chip_disc.toggled.connect(self._on_chip)
        lay.addWidget(self.chip_disc)

        # --- expandir/colapsar todo ---
        exp_row = QVBoxLayout()
        exp_btns = QWidget()
        h = QHBoxLayout(exp_btns)
        h.setContentsMargins(0, 0, 0, 0)
        h.setSpacing(4)
        self.btn_expand = QPushButton("⊞ Expandir todo")
        self.btn_collapse = QPushButton("⊟ Colapsar todo")
        for b in (self.btn_expand, self.btn_collapse):
            b.setStyleSheet(
                f"QPushButton {{ font-size:10px; padding:2px 6px; border:1px solid {T.BORDER};"
                f" border-radius:4px; background:{T.SURFACE}; color:{T.TEXT_MUTED}; }}"
            )
            h.addWidget(b)
        self.btn_expand.clicked.connect(self._expand_all)
        self.btn_collapse.clicked.connect(self._collapse_all)
        exp_row.addWidget(exp_btns)
        lay.addLayout(exp_row)

        self.counter = QLabel("")
        self.counter.setStyleSheet(f"color:{T.TEXT_MUTED}; font-size:11px; padding:2px;")
        lay.addWidget(self.counter)

        self.tree = QTreeWidget()
        self.tree.setHeaderHidden(True)
        self.tree.setStyleSheet(
            f"QTreeWidget {{ border:1px solid {T.BORDER}; border-radius:6px;"
            f" font-family:'{T.FONT_FAMILY}'; }}"
        )
        self.tree.currentItemChanged.connect(self._on_select)
        self.tree.itemExpanded.connect(self._on_expand)
        self.tree.itemCollapsed.connect(self._on_collapse)
        lay.addWidget(self.tree, 1)

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
        if profiles and (crop["assigned_profile"] or NO_PROFILE_VALUE) not in profiles:
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

    def _group_key(self, crop, mode: str) -> str:
        if mode == "priority":
            p = crop["priority"]
            return "Sin prioridad" if p is None else f"Prioridad {p:g}"
        if mode == "type":
            return crop["sheet_harvest_type"] or "Sin tipo"
        if mode == "profile":
            slug = crop["assigned_profile"]
            return self._profile_label.get(slug, slug) if slug else "Sin perfil"
        return ""

    def _active_levels(self) -> list[str]:
        """Keys de las dimensiones activas, EN EL ORDEN actual de la lista."""
        out = []
        for i in range(self.group_levels.count()):
            it = self.group_levels.item(i)
            if it.checkState() == Qt.Checked:
                out.append(it.data(Qt.UserRole))
        return out

    # --- construcción del árbol ---
    def _add_leaf(self, parent, crop):
        # El tipo NUNCA se repite en la fila: o lo cubre el grouping, o es ruido.
        leaf = QTreeWidgetItem(parent, [f"{self._dot(crop)}  {crop['name_es']}"])
        leaf.setData(0, ROLE_CROP_ID, crop["id"])

    def _style_group(self, node, depth: int, count: int):
        font = QFont(T.FONT_FAMILY)
        font.setBold(True)
        node.setFont(0, font)
        palette = [T.PRIMARY, T.ACCENT, T.palette("secondary", 40) or "#5F6A00"]
        node.setForeground(0, QColor(palette[min(depth, 2)]))
        node.setBackground(0, QColor(T.SURFACE_SUNKEN))

    def _build_group(self, parent, crops, keys, path):
        mode = keys[0]
        groups: dict[str, list] = {}
        for c in crops:
            groups.setdefault(self._group_key(c, mode), []).append(c)
        for key in sorted(groups, key=lambda x: str(x).lower()):
            sub = groups[key]
            node = QTreeWidgetItem(parent, [f"{key}   ({len(sub)})"])
            node.setData(0, ROLE_CROP_ID, None)
            npath = path + (key,)
            node.setData(0, ROLE_GROUP_PATH, npath)
            self._style_group(node, depth=len(path), count=len(sub))
            if len(keys) > 1:
                self._build_group(node, sub, keys[1:], npath)
            else:
                for c in sorted(sub, key=lambda c: (c["name_es"] or "").lower()):
                    self._add_leaf(node, c)
            node.setExpanded(npath not in self._collapsed)

    def refresh(self):
        """Re-lee crops desde la DB (tras un Guardar que cambió clasificación)."""
        self.crops = list(self.db.crops())
        self._apply()

    def _apply(self):
        prev_id = self.current_crop_id()
        self.tree.blockSignals(True)
        self.tree.clear()

        visible = [c for c in self.crops if self._matches(c)]
        n_disc = sum(
            1
            for c in visible
            if is_discrepant(c["assigned_profile"], c["sheet_harvest_type"])
        )
        levels = self._active_levels()
        if not levels:
            for c in sorted(visible, key=lambda c: (c["name_es"] or "").lower()):
                self._add_leaf(self.tree, c)
        else:
            self._build_group(self.tree, visible, levels, ())

        self.tree.blockSignals(False)
        self.counter.setText(f"{len(visible)} de {len(self.crops)}  ·  {n_disc} ⚠")
        if prev_id is not None:
            self._select_crop(prev_id)

    # --- handlers ---
    def _on_chip(self, on: bool):
        self._discrepant_only = on
        self._apply()

    def _on_select(self, current, _prev):
        if current is None:
            return
        crop_id = current.data(0, ROLE_CROP_ID)
        if crop_id is not None:
            self.cropSelected.emit(int(crop_id))

    def _on_expand(self, item):
        path = item.data(0, ROLE_GROUP_PATH)
        if path is not None:
            self._collapsed.discard(path)

    def _on_collapse(self, item):
        path = item.data(0, ROLE_GROUP_PATH)
        if path is not None:
            self._collapsed.add(path)

    def _expand_all(self):
        self._collapsed.clear()
        self.tree.expandAll()

    def _collapse_all(self):
        it = QTreeWidgetItemIterator(self.tree)
        while it.value():
            node = it.value()
            path = node.data(0, ROLE_GROUP_PATH)
            if path is not None:
                self._collapsed.add(path)
            it += 1
        self.tree.collapseAll()

    def _select_crop(self, crop_id: int):
        it = QTreeWidgetItemIterator(self.tree)
        while it.value():
            node = it.value()
            if node.data(0, ROLE_CROP_ID) == crop_id:
                self.tree.setCurrentItem(node)
                return
            it += 1

    def current_crop_id(self) -> int | None:
        item = self.tree.currentItem()
        if item is None:
            return None
        return item.data(0, ROLE_CROP_ID)

    # --- helpers para tests ---
    def first_crop_item(self) -> QTreeWidgetItem | None:
        it = QTreeWidgetItemIterator(self.tree)
        while it.value():
            node = it.value()
            if node.data(0, ROLE_CROP_ID) is not None:
                return node
            it += 1
        return None

    def visible_count(self) -> int:
        """Cuenta de cultivos visibles (leaves; excluye nodos de grupo)."""
        n = 0
        it = QTreeWidgetItemIterator(self.tree)
        while it.value():
            if it.value().data(0, ROLE_CROP_ID) is not None:
                n += 1
            it += 1
        return n
