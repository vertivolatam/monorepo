# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""Phase 5 — ExplorerWindow composition smoke test (headless Qt).

Verifies the refactored main window wires Sidebar | DetailView and that
selecting a crop in the sidebar drives the detail panel.
"""

import pytest

import crop_explorer
from db import CropDB


@pytest.fixture(scope="module")
def qapp():
    from PySide6.QtWidgets import QApplication

    app = QApplication.instance() or QApplication([])
    yield app


def test_window_composes_sidebar_and_detail(qapp, temp_db):
    db = CropDB(temp_db)
    win = crop_explorer.ExplorerWindow(db)
    assert win.sidebar is not None
    assert win.detail is not None
    # selecting a crop in the sidebar should drive the detail view
    win.sidebar.tree.setCurrentItem(win.sidebar.first_crop_item())
    assert win.detail._crop_id is not None
    db.close()


def test_saved_signal_refreshes_sidebar(qapp, temp_db):
    db = CropDB(temp_db)
    win = crop_explorer.ExplorerWindow(db)
    # emit a saved signal and ensure no crash on refresh
    cid = db.conn.execute("SELECT id FROM crops LIMIT 1").fetchone()["id"]
    win._on_saved(cid)
    assert win.sidebar.visible_count() == 108
    db.close()
