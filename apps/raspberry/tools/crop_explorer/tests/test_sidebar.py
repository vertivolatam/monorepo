# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""Phase 3 — Sidebar smoke tests (headless Qt).

Builds the sidebar against a real seeded DB and verifies live search narrows the
list and the discrepancy chip leaves exactly the 5 known discrepancies.
"""

import pytest

from db import CropDB
from widgets.sidebar import Sidebar


@pytest.fixture(scope="module")
def qapp():
    from PySide6.QtWidgets import QApplication

    app = QApplication.instance() or QApplication([])
    yield app


@pytest.fixture
def sidebar(qapp, temp_db):
    db = CropDB(temp_db)
    sb = Sidebar(db)
    yield sb
    db.close()


def test_lists_all_crops(sidebar):
    assert sidebar.visible_count() == 107


def test_search_narrows(sidebar):
    sidebar.search.setText("Espinaca")
    n = sidebar.visible_count()
    assert 0 < n < 107


def test_search_matches_family(sidebar):
    # family-based search should still find rows
    sidebar.search.setText("Lamiaceae")
    assert sidebar.visible_count() > 0


def test_discrepancy_chip_leaves_five(sidebar):
    sidebar.chip_disc.setChecked(True)
    assert sidebar.visible_count() == 5


def test_crop_selected_signal(sidebar):
    received = []
    sidebar.cropSelected.connect(received.append)
    sidebar.list.setCurrentRow(0)
    assert received and isinstance(received[0], int)
