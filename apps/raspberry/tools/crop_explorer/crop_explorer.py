#!/usr/bin/env python3
# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""crop_explorer.py — Explorador visual Qt/PySide6 del catálogo de cultivos.

Rediseño (VRTV-96): ventana de dos paneles — **Sidebar** (búsqueda + filtros
reales + chip de discrepancias + lista con estado) | **DetailView** (Datos
Botánicos sticky · Soluciones del Negocio editable con Guardar→audit + Constantes
de Monitoreo · 4 tabs de fase con InstrumentCard + árbol de receta).

``crops.db`` (SQLite) es la FUENTE DE VERDAD local construida por build_db.py
(seed-if-empty). Editar perfil/prioridad escribe en setpoint_audit (rollback).

Requiere: Python >= 3.10, PySide6 (auto-instalado si falta).
Uso: python crop_explorer.py [ruta/a/crops.db]
"""

import subprocess
import sys
from pathlib import Path

# --- Auto-ensure PySide6 -----------------------------------------------------
try:
    from PySide6.QtCore import Qt  # noqa: F401
except ImportError:
    print("[crop_explorer] PySide6 no encontrado — instalando con pip…")
    subprocess.run([sys.executable, "-m", "pip", "install", "PySide6"], check=False)

from PySide6.QtCore import Qt
from PySide6.QtGui import QColor, QFont, QPalette
from PySide6.QtWidgets import (
    QApplication,
    QMainWindow,
    QSplitter,
    QStatusBar,
    QWidget,
    QVBoxLayout,
)

# Importar como módulos top-level (el script vive en tools/crop_explorer/).
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))

from db import CropDB, is_discrepant  # noqa: E402
from widgets.sidebar import Sidebar  # noqa: E402
from widgets.detail_view import DetailView  # noqa: E402

DEFAULT_DB = HERE.parent.parent / "config" / "crops.db"


def _ensure_db(db_path: Path) -> bool:
    """Asegura crops.db: si falta, intenta construirla (seed-if-empty)."""
    if db_path.exists():
        return True
    try:
        import build_db

        print(f"[crop_explorer] {db_path.name} no existe — construyendo (seed-if-empty)…")
        build_db.build(build_db.DEFAULT_CROPS, build_db.DEFAULT_XLSX, db_path)
        return db_path.exists()
    except Exception as exc:  # pragma: no cover
        print(f"[crop_explorer] no se pudo construir la DB: {exc}")
        return False


class ExplorerWindow(QMainWindow):
    def __init__(self, db: CropDB):
        super().__init__()
        self.db = db
        self.setWindowTitle(f"Crop Catalog Explorer — {db.db_path.name}")
        self.resize(1500, 880)

        central = QWidget()
        self.setCentralWidget(central)
        layout = QVBoxLayout(central)
        layout.setContentsMargins(4, 4, 4, 4)

        splitter = QSplitter(Qt.Horizontal)
        self.sidebar = Sidebar(db)
        self.detail = DetailView(db)
        splitter.addWidget(self.sidebar)
        splitter.addWidget(self.detail)
        splitter.setSizes([360, 1140])
        layout.addWidget(splitter)

        # Conexiones: selección -> detalle; guardado -> refrescar sidebar.
        self.sidebar.cropSelected.connect(self.detail.setCrop)
        self.detail.classificationSaved.connect(self._on_saved)

        self.status = QStatusBar()
        self.setStatusBar(self.status)
        self._update_status()

    def _on_saved(self, _crop_id: int):
        self.sidebar.refresh()
        self._update_status()

    def _update_status(self):
        crops = self.db.crops()
        n_disc = sum(
            1 for c in crops if is_discrepant(c["assigned_profile"], c["sheet_harvest_type"])
        )
        self.status.showMessage(
            f"{len(crops)} cultivos  ·  {n_disc} discrepancias sheet/profile"
        )


def main() -> int:
    db_path = Path(sys.argv[1]) if len(sys.argv) > 1 else DEFAULT_DB
    if not _ensure_db(db_path):
        print(f"Error: no existe {db_path}. Corre build_db.py primero.")
        return 1

    db = CropDB(db_path)

    app = QApplication(sys.argv)
    app.setStyle("Fusion")
    app.setFont(QFont("Ubuntu", 10))

    palette = QPalette()
    palette.setColor(QPalette.Window, QColor("#f1f5f9"))
    palette.setColor(QPalette.WindowText, QColor("#1e293b"))
    palette.setColor(QPalette.Base, QColor("#ffffff"))
    palette.setColor(QPalette.AlternateBase, QColor("#f1f5f9"))
    palette.setColor(QPalette.Text, QColor("#1e293b"))
    palette.setColor(QPalette.Button, QColor("#e2e8f0"))
    palette.setColor(QPalette.ButtonText, QColor("#1e293b"))
    palette.setColor(QPalette.Highlight, QColor("#3b82f6"))
    palette.setColor(QPalette.HighlightedText, QColor("#ffffff"))
    app.setPalette(palette)

    window = ExplorerWindow(db)
    window.show()
    return app.exec()


if __name__ == "__main__":
    sys.exit(main())
