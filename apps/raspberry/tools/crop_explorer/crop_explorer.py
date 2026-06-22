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

Requiere: Python >= 3.10, PySide6 (ver requirements.txt).
Uso: python crop_explorer.py [ruta/a/crops.db]
"""

import sys
from pathlib import Path

# --- Dependencia: PySide6 (no se auto-instala; ver requirements.txt) ----------
try:
    from PySide6.QtCore import Qt
except ImportError as exc:
    raise ImportError(
        "PySide6 no está instalado. Corré: "
        "pip install -r apps/raspberry/tools/crop_explorer/requirements.txt"
    ) from exc
from PySide6.QtGui import QAction, QColor, QFont, QPalette
from PySide6.QtWidgets import (
    QApplication,
    QMainWindow,
    QSplitter,
    QStatusBar,
    QToolBar,
    QWidget,
    QVBoxLayout,
)

# Importar como módulos top-level (el script vive en tools/crop_explorer/).
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))

from db import CropDB, is_discrepant  # noqa: E402
from widgets.sidebar import Sidebar  # noqa: E402
from widgets.detail_view import DetailView  # noqa: E402
import tokens as T  # noqa: E402

DEFAULT_DB = HERE.parent.parent / "config" / "crops.db"


def build_palette(dark: bool) -> QPalette:
    """QPalette derivada de los tokens, para el chrome (ventana, menús, scrollbars)."""
    T.set_mode("dark" if dark else "light")
    pal = QPalette()
    pal.setColor(QPalette.Window, QColor(T.SURFACE_ALT))
    pal.setColor(QPalette.WindowText, QColor(T.TEXT))
    pal.setColor(QPalette.Base, QColor(T.SURFACE))
    pal.setColor(QPalette.AlternateBase, QColor(T.SURFACE_SUNKEN))
    pal.setColor(QPalette.Text, QColor(T.TEXT))
    pal.setColor(QPalette.Button, QColor(T.SURFACE_SUNKEN))
    pal.setColor(QPalette.ButtonText, QColor(T.TEXT))
    pal.setColor(QPalette.ToolTipBase, QColor(T.SURFACE))
    pal.setColor(QPalette.ToolTipText, QColor(T.TEXT))
    pal.setColor(QPalette.PlaceholderText, QColor(T.TEXT_MUTED))
    pal.setColor(QPalette.Highlight, QColor(T.PRIMARY))
    pal.setColor(QPalette.HighlightedText, QColor(T.SURFACE if dark else "#FFFFFF"))
    return pal


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

        # Toolbar con toggle de tema (☀/🌙).
        toolbar = QToolBar("Tema")
        toolbar.setMovable(False)
        self.addToolBar(toolbar)
        self.act_dark = QAction("🌙  Modo oscuro", self)
        self.act_dark.setCheckable(True)
        self.act_dark.toggled.connect(self._toggle_theme)
        toolbar.addAction(self.act_dark)

        central = QWidget()
        self.setCentralWidget(central)
        layout = QVBoxLayout(central)
        layout.setContentsMargins(4, 4, 4, 4)

        self.splitter = QSplitter(Qt.Horizontal)
        self.sidebar = Sidebar(db)
        self.detail = DetailView(db)
        self.splitter.addWidget(self.sidebar)
        self.splitter.addWidget(self.detail)
        self.splitter.setSizes([360, 1140])
        layout.addWidget(self.splitter)
        self._wire_panels()

        self.status = QStatusBar()
        self.setStatusBar(self.status)
        self._update_status()

    def _wire_panels(self):
        """Conexiones: selección -> detalle; guardado -> refrescar sidebar."""
        self.sidebar.cropSelected.connect(self.detail.setCrop)
        self.detail.classificationSaved.connect(self._on_saved)

    def _toggle_theme(self, dark: bool):
        """Cambia tema: re-aplica paleta + reconstruye paneles (recogen tokens nuevos)."""
        self.act_dark.setText("☀  Modo claro" if dark else "🌙  Modo oscuro")
        app = QApplication.instance()
        if app is not None:
            app.setPalette(build_palette(dark))
        else:
            T.set_mode("dark" if dark else "light")
        current = self.sidebar.current_crop_id()
        new_sidebar = Sidebar(self.db)
        new_detail = DetailView(self.db)
        self.splitter.replaceWidget(0, new_sidebar)
        self.splitter.replaceWidget(1, new_detail)
        self.sidebar.deleteLater()
        self.detail.deleteLater()
        self.sidebar, self.detail = new_sidebar, new_detail
        self.splitter.setSizes([360, 1140])
        self._wire_panels()
        if current is not None:
            self.detail.setCrop(current)

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
    app.setFont(QFont(T.FONT_FAMILY, 10))
    app.setPalette(build_palette(dark=False))  # arranca en claro (token-based)

    window = ExplorerWindow(db)
    window.show()
    return app.exec()


if __name__ == "__main__":
    sys.exit(main())
