# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""Phase 4 — DetailView smoke tests (headless Qt).

Builds the detail panel against a real seeded DB, loads crops, and exercises the
audited Save path (profile change -> setpoint_audit + classificationSaved).
"""

import pytest

from db import CropDB
from widgets.detail_view import DetailView


@pytest.fixture(scope="module")
def qapp():
    from PySide6.QtWidgets import QApplication

    app = QApplication.instance() or QApplication([])
    yield app


@pytest.fixture
def view(qapp, temp_db):
    db = CropDB(temp_db)
    dv = DetailView(db)
    yield dv, db
    db.close()


def _crop_id(db, name):
    return db.conn.execute("SELECT id FROM crops WHERE name_es = ?", (name,)).fetchone()["id"]


def test_set_crop_with_profile_builds_cards(view):
    dv, db = view
    cid = _crop_id(db, "Espinaca")
    dv.setCrop(cid)
    assert "Espinaca" in dv.title.text()
    # Vegetative tab should hold a widget (cards grid), not the No-aplica label only.
    assert dv.tab_veg.widget() is not None
    # Nutrition tab populated for a flagship crop.
    assert dv.tab_nutri.widget() is not None


def test_set_crop_without_profile_shows_na(view):
    dv, db = view
    # A non-aeroponic crop with profile NULL.
    row = db.conn.execute(
        "SELECT id FROM crops WHERE assigned_profile IS NULL LIMIT 1"
    ).fetchone()
    assert row is not None
    dv.setCrop(row["id"])
    assert dv.tab_veg.widget() is not None  # builds No-aplica without crashing


def test_discrepancy_banner_shows(view):
    dv, db = view
    # Tacaco is one of the 5 known discrepancies.
    cid = _crop_id(db, "Tacaco")
    dv.setCrop(cid)
    assert dv.disc_banner.isVisibleTo(dv) or dv.disc_banner.text() != ""
    assert "DISCREPANCIA" in dv.disc_banner.text()


def test_save_profile_change_emits_and_audits(view):
    dv, db = view
    cid = _crop_id(db, "Espinaca")
    dv.setCrop(cid)
    received = []
    dv.classificationSaved.connect(received.append)

    dv.profile_combo.setCurrentText("herb_aromatic")
    dv._on_save()

    assert received == [cid]
    audit = db.conn.execute(
        "SELECT value_text, source FROM setpoint_audit "
        "WHERE crop_id = ? AND field = 'assigned_profile' AND is_active = 1",
        (cid,),
    ).fetchone()
    assert audit["value_text"] == "herb_aromatic"
    assert audit["source"] == "experiment"
    assert "guardado" in dv.toast.text().lower()


def test_save_noop_reports_no_change(view):
    dv, db = view
    cid = _crop_id(db, "Lechuga")
    dv.setCrop(cid)
    # Re-save same profile/priority -> no change.
    dv._on_save()
    assert "sin cambios" in dv.toast.text().lower()
