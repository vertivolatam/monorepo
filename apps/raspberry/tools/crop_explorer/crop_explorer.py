#!/usr/bin/env python3
"""crop_explorer.py — Explorador visual Qt/PySide6 del catálogo de cultivos.

Inspecciona crops.db (SQLite, fuente de verdad local construida por build_db.py):
  - Tabla de cultivos con filtros (búsqueda + multi-select por aeroponic /
    sheet_harvest_type / assigned_profile).
  - Resalta DISCREPANCIAS: cuando sheet_harvest_type no concuerda con el tipo
    presupuesto por assigned_profile (validación clave del catálogo).
  - Panel de detalle: setpoints operativos con su provenance (🟦 sheet /
    🟨 researched + cita + confianza), leídos de setpoint_audit (is_active=1).
  - Export CSV.
  - Rollback por campo: reactiva un registro source='sheet' previo en
    setpoint_audit y actualiza setpoints (demuestra el flujo de auditoría).

Estilo replicado de gherkin/scripts/preview-suite.py (chrome oscuro + contenido
claro, CheckableComboBox, MultiColumnFilterProxy, QSplitter).

Requiere: Python >= 3.10, PySide6 (auto-instalado si falta).
Uso: python crop_explorer.py [ruta/a/crops.db]
"""

import csv
import io
import json
import sqlite3
import subprocess
import sys
from pathlib import Path

# --- Auto-ensure PySide6 (estilo preview-suite.py) --------------------------
try:
    from PySide6.QtCore import Qt  # noqa: F401
except ImportError:
    print("[crop_explorer] PySide6 no encontrado — instalando con pip…")
    subprocess.run([sys.executable, "-m", "pip", "install", "PySide6"], check=False)

from PySide6.QtCore import Qt, QSortFilterProxyModel, QModelIndex
from PySide6.QtGui import QColor, QStandardItemModel, QStandardItem, QFont, QPalette
from PySide6.QtWidgets import (
    QApplication,
    QMainWindow,
    QSplitter,
    QTableView,
    QTextEdit,
    QVBoxLayout,
    QHBoxLayout,
    QWidget,
    QComboBox,
    QPushButton,
    QLineEdit,
    QStatusBar,
    QHeaderView,
    QFileDialog,
    QMessageBox,
    QAbstractItemView,
)

# Reutilizamos la lógica de clasificación de build_db (single source of truth).
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
try:
    from build_db import PROFILE_TO_SHEET_TYPE
except Exception:  # pragma: no cover — fallback si el import falla
    PROFILE_TO_SHEET_TYPE = {
        "leafy_vegetative": "Cultivos de Hoja",
        "herb_aromatic": "Cultivos de Hoja",
        "fruiting_vegetative": "Cultivos de Fruto",
        "fruiting_reproductive": "Cultivos de Fruto",
        "berry_fruiting": "Cultivos de Fruto",
        "root_bulking": "Cultivos de Raíz",
    }

DEFAULT_DB = HERE.parent.parent / "config" / "crops.db"

# (nombre, ancho). El índice == columna del modelo.
COLUMNS = [
    ("ID", 50),
    ("Nombre (ES)", 170),
    ("Familia", 150),
    ("Parte Comestible", 180),
    ("Sheet Harvest Type", 150),
    ("Perfil Asignado", 150),
    ("Aeropónico", 90),
    ("Prioridad", 75),
]
COL_ID = 0
COL_SHEET_TYPE = 4
COL_PROFILE = 5
# Columnas con filtro multi-select (checkable): sheet type, perfil, aeropónico.
MULTISELECT_COLS = {COL_SHEET_TYPE, COL_PROFILE, 6}

DISCREPANCY_BG = QColor("#fee2e2")  # rojo claro — fila con discrepancia
DISCREPANCY_CELL = QColor("#fca5a5")  # rojo más fuerte — celda culpable
NORMAL_BG = QColor("#ffffff")

SOURCE_BADGE = {
    "sheet": "🟦 sheet",
    "researched": "🟨 researched",
    "experiment": "🟩 experiment",
    "agronomist": "🟪 agronomist",
}


def is_discrepant(profile: str | None, sheet_type: str | None) -> bool:
    if not profile or not sheet_type:
        return False
    expected = PROFILE_TO_SHEET_TYPE.get(profile)
    return bool(expected) and expected != sheet_type


# --- Acceso a datos ---------------------------------------------------------
class CropRepo:
    def __init__(self, db_path: Path):
        self.db_path = db_path
        self.conn = sqlite3.connect(str(db_path))
        self.conn.row_factory = sqlite3.Row

    def crops(self) -> list[sqlite3.Row]:
        return self.conn.execute(
            "SELECT id, name_es, name_en, family, species, edible_part, "
            "sheet_harvest_type, aeroponic, priority, assigned_profile "
            "FROM crops ORDER BY id"
        ).fetchall()

    def active_setpoints(self, crop_id: int) -> list[sqlite3.Row]:
        """Setpoints operativos + su provenance activa (audit is_active=1)."""
        return self.conn.execute(
            """
            SELECT s.field, s.value_num, s.value_text,
                   a.source, a.confidence, a.citation, a.note,
                   a.changed_at, a.changed_by
            FROM setpoints s
            LEFT JOIN setpoint_audit a
              ON a.crop_id = s.crop_id AND a.field = s.field AND a.is_active = 1
            WHERE s.crop_id = ?
            ORDER BY s.field
            """,
            (crop_id,),
        ).fetchall()

    def prior_sheet_audit(self, crop_id: int, field: str) -> sqlite3.Row | None:
        """Registro source='sheet' previo (inactivo) para rollback de un campo."""
        return self.conn.execute(
            "SELECT * FROM setpoint_audit "
            "WHERE crop_id = ? AND field = ? AND source = 'sheet' "
            "ORDER BY id DESC LIMIT 1",
            (crop_id, field),
        ).fetchone()

    def active_audit_id(self, crop_id: int, field: str) -> int | None:
        row = self.conn.execute(
            "SELECT id FROM setpoint_audit "
            "WHERE crop_id = ? AND field = ? AND is_active = 1 LIMIT 1",
            (crop_id, field),
        ).fetchone()
        return row["id"] if row else None

    def rollback_to_sheet(self, crop_id: int, field: str) -> bool:
        """Reactiva el valor source='sheet' previo: desactiva el activo, inserta
        un nuevo registro de audit (source='experiment' que reaplica el sheet)
        con supersedes_id, y sincroniza la tabla setpoints. Devuelve True si hizo
        rollback."""
        from datetime import datetime, timezone

        prior = self.prior_sheet_audit(crop_id, field)
        if prior is None:
            return False
        active_id = self.active_audit_id(crop_id, field)
        if active_id == prior["id"]:
            return False  # ya está en el valor de la hoja

        ts = datetime.now(timezone.utc).isoformat()
        cur = self.conn.cursor()
        # Desactiva el registro activo actual.
        if active_id is not None:
            cur.execute(
                "UPDATE setpoint_audit SET is_active = 0 WHERE id = ?", (active_id,)
            )
        # Nuevo registro que reaplica el valor de la hoja (historia preservada).
        cur.execute(
            "INSERT INTO setpoint_audit (crop_id, field, value_num, value_text, "
            "source, confidence, citation, note, is_active, supersedes_id, "
            "changed_at, changed_by) VALUES (?,?,?,?,?,?,?,?,1,?,?,?)",
            (
                crop_id,
                field,
                prior["value_num"],
                prior["value_text"],
                "experiment",
                prior["confidence"],
                prior["citation"],
                f"rollback a valor source=sheet (audit #{prior['id']})",
                active_id,
                ts,
                "crop_explorer",
            ),
        )
        # Sincroniza el setpoint operativo.
        cur.execute(
            "UPDATE setpoints SET value_num = ?, value_text = ? "
            "WHERE crop_id = ? AND field = ?",
            (prior["value_num"], prior["value_text"], crop_id, field),
        )
        self.conn.commit()
        return True


# --- CheckableComboBox (de preview-suite.py) --------------------------------
class CheckableComboBox(QComboBox):
    def __init__(self, placeholder: str = "", parent=None):
        super().__init__(parent)
        self._placeholder = placeholder
        self._checked: set[str] = set()
        self._model = QStandardItemModel(self)
        self.setModel(self._model)
        self.view().pressed.connect(self._on_item_pressed)
        self.setEditable(True)
        self.lineEdit().setReadOnly(True)
        self.lineEdit().setText(placeholder)

    def add_items(self, values: list[str]):
        for val in values:
            item = QStandardItem(val)
            item.setCheckable(True)
            item.setCheckState(Qt.Unchecked)
            item.setEditable(False)
            self._model.appendRow(item)

    def _on_item_pressed(self, index: QModelIndex):
        item = self._model.itemFromIndex(index)
        if not item:
            return
        if item.checkState() == Qt.Checked:
            item.setCheckState(Qt.Unchecked)
            self._checked.discard(item.text())
        else:
            item.setCheckState(Qt.Checked)
            self._checked.add(item.text())
        self._update_text()

    def _update_text(self):
        if not self._checked:
            self.lineEdit().setText(self._placeholder)
        else:
            self.lineEdit().setText(", ".join(sorted(self._checked)))

    def checked_values(self) -> set[str]:
        return set(self._checked)

    def reset(self):
        for r in range(self._model.rowCount()):
            self._model.item(r).setCheckState(Qt.Unchecked)
        self._checked.clear()
        self._update_text()

    def hidePopup(self):  # mantener abierto al clickear
        pass


# --- Proxy de filtrado (texto + multi-select por columna) -------------------
class MultiColumnFilterProxy(QSortFilterProxyModel):
    def __init__(self, parent=None):
        super().__init__(parent)
        self._filters: dict[int, set[str]] = {}
        self._text = ""
        self._discrepant_only = False

    def set_column_filter(self, col: int, values: set[str]):
        if not values:
            self._filters.pop(col, None)
        else:
            self._filters[col] = values
        self.invalidateRowsFilter()

    def set_text(self, text: str):
        self._text = text.strip().lower()
        self.invalidateRowsFilter()

    def set_discrepant_only(self, on: bool):
        self._discrepant_only = on
        self.invalidateRowsFilter()

    def clear_filters(self):
        self._filters.clear()
        self._text = ""
        self._discrepant_only = False
        self.invalidateRowsFilter()

    def filterAcceptsRow(self, source_row: int, source_parent: QModelIndex) -> bool:
        model = self.sourceModel()
        for col, allowed in self._filters.items():
            idx = model.index(source_row, col, source_parent)
            cell = model.data(idx, Qt.DisplayRole) or ""
            if cell not in allowed:
                return False
        if self._text:
            joined = " ".join(
                (model.data(model.index(source_row, c, source_parent), Qt.DisplayRole) or "")
                for c in range(model.columnCount())
            ).lower()
            if self._text not in joined:
                return False
        if self._discrepant_only:
            prof = model.data(model.index(source_row, COL_PROFILE, source_parent), Qt.DisplayRole)
            sht = model.data(model.index(source_row, COL_SHEET_TYPE, source_parent), Qt.DisplayRole)
            if not is_discrepant(prof or None, sht or None):
                return False
        return True


# --- Ventana principal ------------------------------------------------------
class ExplorerWindow(QMainWindow):
    def __init__(self, repo: CropRepo):
        super().__init__()
        self.repo = repo
        self.rows = repo.crops()
        self.row_by_id = {r["id"]: r for r in self.rows}
        self.n_discrepant = sum(
            1 for r in self.rows if is_discrepant(r["assigned_profile"], r["sheet_harvest_type"])
        )
        self.setWindowTitle(
            f"Crop Catalog Explorer — {repo.db_path.name} "
            f"({len(self.rows)} cultivos, {self.n_discrepant} discrepancias)"
        )
        self.resize(1500, 850)
        self._build_model()
        self._build_ui()
        self._update_status()

    def _build_model(self):
        self.model = QStandardItemModel()
        self.model.setHorizontalHeaderLabels([c[0] for c in COLUMNS])
        for r in self.rows:
            disc = is_discrepant(r["assigned_profile"], r["sheet_harvest_type"])
            vals = [
                str(r["id"]),
                r["name_es"] or "",
                r["family"] or "",
                r["edible_part"] or "",
                r["sheet_harvest_type"] or "",
                r["assigned_profile"] or "",
                "SI" if r["aeroponic"] else "NO",
                "" if r["priority"] is None else str(r["priority"]),
            ]
            items = []
            for ci, val in enumerate(vals):
                item = QStandardItem(val)
                item.setEditable(False)
                item.setForeground(QColor("#1e293b"))
                if disc:
                    if ci in (COL_SHEET_TYPE, COL_PROFILE):
                        item.setBackground(DISCREPANCY_CELL)
                    else:
                        item.setBackground(DISCREPANCY_BG)
                else:
                    item.setBackground(NORMAL_BG)
                items.append(item)
            self.model.appendRow(items)

        self.proxy = MultiColumnFilterProxy(self)
        self.proxy.setSourceModel(self.model)

    def _build_ui(self):
        central = QWidget()
        self.setCentralWidget(central)
        layout = QVBoxLayout(central)
        layout.setContentsMargins(6, 6, 6, 2)
        layout.setSpacing(4)

        # --- Barra de filtros ---
        filter_bar = QHBoxLayout()
        filter_bar.setSpacing(6)

        combo_style = (
            "QComboBox { background-color:#313244; color:#cdd6f4;"
            "  border:1px solid #45475a; border-radius:3px; padding:3px 6px; }"
            "QComboBox::drop-down { border:none; }"
            "QComboBox QAbstractItemView { background-color:#ffffff; color:#0f172a;"
            "  selection-background-color:#e0e7ff; selection-color:#0f172a;"
            "  border:1px solid #94a3b8; }"
        )

        self.search = QLineEdit()
        self.search.setPlaceholderText("Buscar (nombre, familia, especie)…")
        self.search.setMinimumWidth(240)
        self.search.setStyleSheet(
            "QLineEdit { background-color:#313244; color:#cdd6f4;"
            " border:1px solid #45475a; border-radius:3px; padding:3px 6px; }"
        )
        self.search.textChanged.connect(self.proxy.set_text)
        filter_bar.addWidget(self.search)

        self.filter_combos: dict[int, CheckableComboBox] = {}
        for col in sorted(MULTISELECT_COLS):
            name = COLUMNS[col][0]
            combo = CheckableComboBox(placeholder=f"({name})", parent=self)
            combo.setMinimumWidth(140)
            combo.setStyleSheet(combo_style)
            unique = sorted({
                self.model.item(r, col).text()
                for r in range(self.model.rowCount())
                if self.model.item(r, col).text()
            })
            combo.add_items(unique)
            combo.view().pressed.connect(
                lambda _idx, c=col, cb=combo: self._on_check_filter(c, cb)
            )
            filter_bar.addWidget(combo)
            self.filter_combos[col] = combo

        self.disc_btn = QPushButton("Solo discrepancias")
        self.disc_btn.setCheckable(True)
        self.disc_btn.toggled.connect(self._on_discrepant_toggle)
        filter_bar.addWidget(self.disc_btn)

        filter_bar.addStretch()

        reset_btn = QPushButton("Reset")
        reset_btn.setFixedWidth(60)
        reset_btn.clicked.connect(self._reset_filters)
        filter_bar.addWidget(reset_btn)

        export_btn = QPushButton("CSV")
        export_btn.setFixedWidth(50)
        export_btn.clicked.connect(self._export_csv)
        filter_bar.addWidget(export_btn)

        layout.addLayout(filter_bar)

        # --- Splitter: tabla + detalle ---
        splitter = QSplitter(Qt.Horizontal)

        self.table = QTableView()
        self.table.setModel(self.proxy)
        self.table.setSortingEnabled(True)
        self.table.setSelectionBehavior(QAbstractItemView.SelectionBehavior.SelectRows)
        self.table.setSelectionMode(QAbstractItemView.SelectionMode.SingleSelection)
        self.table.setAlternatingRowColors(True)
        self.table.verticalHeader().setVisible(False)
        self.table.verticalHeader().setDefaultSectionSize(26)
        self.table.setStyleSheet(
            "QTableView { gridline-color:#e2e8f0; background-color:#ffffff; color:#1e293b; }"
            "QTableView::item:selected { background-color:#3b82f6; color:white; }"
            "QHeaderView::section { background-color:#f8fafc; color:#1e293b;"
            "  font-weight:bold; border:1px solid #e2e8f0; padding:4px; }"
        )
        header = self.table.horizontalHeader()
        for ci, (_, w) in enumerate(COLUMNS):
            header.resizeSection(ci, w)
        header.setStretchLastSection(True)
        self.table.selectionModel().currentRowChanged.connect(self._on_row_selected)

        self.detail = QTextEdit()
        self.detail.setReadOnly(True)
        self.detail.setStyleSheet(
            "QTextEdit { padding:8px; background-color:#ffffff; color:#1e293b; }"
        )

        # Panel inferior de rollback (acción por campo)
        right = QWidget()
        right_layout = QVBoxLayout(right)
        right_layout.setContentsMargins(0, 0, 0, 0)
        right_layout.addWidget(self.detail)
        rollback_bar = QHBoxLayout()
        self.field_combo = QComboBox()
        self.field_combo.setStyleSheet(combo_style)
        rollback_bar.addWidget(self.field_combo, 1)
        self.rollback_btn = QPushButton("Rollback a 'sheet'")
        self.rollback_btn.clicked.connect(self._on_rollback)
        rollback_bar.addWidget(self.rollback_btn)
        right_layout.addLayout(rollback_bar)

        splitter.addWidget(self.table)
        splitter.addWidget(right)
        splitter.setSizes([900, 600])
        layout.addWidget(splitter)

        self.status = QStatusBar()
        self.setStatusBar(self.status)

    # --- Handlers de filtro ---
    def _on_check_filter(self, col: int, combo: CheckableComboBox):
        self.proxy.set_column_filter(col, combo.checked_values())
        self._update_status()

    def _on_discrepant_toggle(self, on: bool):
        self.proxy.set_discrepant_only(on)
        self._update_status()

    def _reset_filters(self):
        for combo in self.filter_combos.values():
            combo.reset()
        self.search.clear()
        self.disc_btn.setChecked(False)
        self.proxy.clear_filters()
        self._update_status()

    def _selected_crop_id(self) -> int | None:
        idx = self.table.selectionModel().currentIndex()
        if not idx.isValid():
            return None
        src = self.proxy.mapToSource(idx)
        return int(self.model.item(src.row(), COL_ID).text())

    def _on_row_selected(self, current: QModelIndex, _prev):
        if not current.isValid():
            return
        src = self.proxy.mapToSource(current)
        crop_id = int(self.model.item(src.row(), COL_ID).text())
        self._show_detail(crop_id)

    @staticmethod
    def _escape(text: str) -> str:
        return (
            str(text)
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\n", "<br>")
        )

    def _fmt_value(self, row: sqlite3.Row) -> str:
        if row["value_num"] is not None:
            v = row["value_num"]
            return f"{v:g}"
        if row["value_text"]:
            t = row["value_text"]
            if row["field"] == "nutrient_recipe_json":
                try:
                    parsed = json.loads(t)
                    return f"<i>receta JSON ({len(parsed)} grupos)</i>"
                except Exception:
                    pass
            return self._escape(t)
        return "—"

    def _show_detail(self, crop_id: int):
        crop = self.row_by_id[crop_id]
        sps = self.repo.active_setpoints(crop_id)
        disc = is_discrepant(crop["assigned_profile"], crop["sheet_harvest_type"])

        h = [f"<h3 style='color:#1e293b;'>{self._escape(crop['name_es'])} "
             f"<span style='color:#64748b;font-weight:normal;'>"
             f"({self._escape(crop['name_en'] or '')})</span></h3>"]
        h.append("<table style='font-size:13px;'>")
        for label, val in [
            ("Familia", crop["family"]),
            ("Especie", crop["species"]),
            ("Parte comestible", crop["edible_part"]),
            ("Sheet harvest type", crop["sheet_harvest_type"]),
            ("Perfil asignado", crop["assigned_profile"]),
            ("Aeropónico", "SI" if crop["aeroponic"] else "NO"),
            ("Prioridad", crop["priority"]),
        ]:
            h.append(
                f"<tr><td><b>{label}:</b></td>"
                f"<td style='padding-left:8px;'>{self._escape(val if val is not None else '—')}</td></tr>"
            )
        h.append("</table>")

        if disc:
            expected = PROFILE_TO_SHEET_TYPE.get(crop["assigned_profile"])
            h.append(
                "<p style='background:#fee2e2;color:#991b1b;padding:6px;"
                "border-radius:4px;'>⚠ DISCREPANCIA: la hoja clasifica este cultivo "
                f"como <b>{self._escape(crop['sheet_harvest_type'])}</b> pero el perfil "
                f"<b>{self._escape(crop['assigned_profile'])}</b> presupone "
                f"<b>{self._escape(expected)}</b>.</p>"
            )

        h.append("<h4 style='color:#475569;'>Setpoints operativos (provenance activa)</h4>")
        if not sps:
            h.append("<p style='color:#64748b;'><i>Sin setpoints (cultivo sin perfil asignado).</i></p>")
        else:
            h.append("<table style='font-size:12px;border-collapse:collapse;'>")
            h.append(
                "<tr style='background:#f1f5f9;'>"
                "<th style='text-align:left;padding:3px 8px;'>Campo</th>"
                "<th style='text-align:left;padding:3px 8px;'>Valor</th>"
                "<th style='text-align:left;padding:3px 8px;'>Provenance</th></tr>"
            )
            for sp in sps:
                badge = SOURCE_BADGE.get(sp["source"], sp["source"] or "—")
                prov = badge
                if sp["confidence"]:
                    prov += f" · conf={self._escape(sp['confidence'])}"
                cite = ""
                if sp["citation"]:
                    cite = (
                        f"<div style='color:#64748b;font-size:11px;'>"
                        f"{self._escape(sp['citation'])}</div>"
                    )
                h.append(
                    "<tr>"
                    f"<td style='padding:3px 8px;'><code>{self._escape(sp['field'])}</code></td>"
                    f"<td style='padding:3px 8px;'>{self._fmt_value(sp)}</td>"
                    f"<td style='padding:3px 8px;'>{prov}{cite}</td>"
                    "</tr>"
                )
            h.append("</table>")
        self.detail.setHtml("\n".join(h))

        # Poblar combo de campos con rollback disponible (existe sheet previo).
        self.field_combo.clear()
        for sp in sps:
            prior = self.repo.prior_sheet_audit(crop_id, sp["field"])
            if prior is not None:
                self.field_combo.addItem(sp["field"])

    def _on_rollback(self):
        crop_id = self._selected_crop_id()
        if crop_id is None:
            QMessageBox.information(self, "Rollback", "Selecciona un cultivo primero.")
            return
        field = self.field_combo.currentText()
        if not field:
            QMessageBox.information(
                self, "Rollback", "No hay campo con valor 'sheet' previo para revertir."
            )
            return
        did = self.repo.rollback_to_sheet(crop_id, field)
        if did:
            QMessageBox.information(
                self,
                "Rollback",
                f"Campo '{field}' revertido al valor source='sheet'. "
                "Se registró un nuevo audit (source='experiment', is_active=1) "
                "y se desactivó el anterior.",
            )
            self._show_detail(crop_id)
        else:
            QMessageBox.information(
                self, "Rollback", f"Campo '{field}' ya está en el valor 'sheet' (sin cambios)."
            )

    def _update_status(self):
        visible = self.proxy.rowCount()
        total = self.model.rowCount()
        self.status.showMessage(
            f"Mostrando {visible}/{total}   |   "
            f"discrepancias sheet/profile: {self.n_discrepant}"
        )

    def _export_csv(self):
        path, _ = QFileDialog.getSaveFileName(self, "Exportar CSV", "", "CSV files (*.csv)")
        if not path:
            return
        buf = io.StringIO()
        writer = csv.writer(buf)
        headers = [c[0] for c in COLUMNS] + ["Discrepancia"]
        writer.writerow(headers)
        for r in range(self.proxy.rowCount()):
            row = []
            for c in range(len(COLUMNS)):
                src = self.proxy.mapToSource(self.proxy.index(r, c))
                row.append(self.model.data(src, Qt.DisplayRole) or "")
            prof = row[COL_PROFILE]
            sht = row[COL_SHEET_TYPE]
            row.append("SI" if is_discrepant(prof or None, sht or None) else "")
            writer.writerow(row)
        Path(path).write_text(buf.getvalue(), encoding="utf-8")
        QMessageBox.information(
            self, "Export", f"Exportadas {self.proxy.rowCount()} filas a {path}"
        )


def main() -> int:
    db_path = Path(sys.argv[1]) if len(sys.argv) > 1 else DEFAULT_DB
    if not db_path.exists():
        print(f"Error: no existe {db_path}. Corre build_db.py primero.")
        return 1

    repo = CropRepo(db_path)

    app = QApplication(sys.argv)
    app.setStyle("Fusion")
    app.setFont(QFont("Ubuntu", 10))

    palette = QPalette()
    palette.setColor(QPalette.Window, QColor("#1e1e2e"))
    palette.setColor(QPalette.WindowText, QColor("#cdd6f4"))
    palette.setColor(QPalette.Button, QColor("#313244"))
    palette.setColor(QPalette.ButtonText, QColor("#cdd6f4"))
    palette.setColor(QPalette.Base, QColor("#ffffff"))
    palette.setColor(QPalette.AlternateBase, QColor("#f1f5f9"))
    palette.setColor(QPalette.Text, QColor("#1e293b"))
    palette.setColor(QPalette.Highlight, QColor("#3b82f6"))
    palette.setColor(QPalette.HighlightedText, QColor("#ffffff"))
    app.setPalette(palette)

    window = ExplorerWindow(repo)
    window.show()
    return app.exec()


if __name__ == "__main__":
    sys.exit(main())
