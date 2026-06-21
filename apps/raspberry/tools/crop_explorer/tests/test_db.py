# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""Phase 2 — audited writes (db.py).

``save_classification`` updates crops.assigned_profile / priority, re-resolves
setpoints when the profile changes, and writes a ``setpoint_audit`` row
(source='experiment', supersedes_id, is_active toggling) for rollback.
"""

import pytest

from db import CropDB


@pytest.fixture
def cropdb(temp_db):
    db = CropDB(temp_db)
    yield db
    db.close()


def _crop_id(db: CropDB, name: str) -> int:
    row = db.conn.execute("SELECT id FROM crops WHERE name_es = ?", (name,)).fetchone()
    assert row is not None, name
    return row["id"]


def test_change_profile_writes_audit_and_resyncs_setpoints(cropdb, temp_db):
    cid = _crop_id(cropdb, "Espinaca")  # leafy_vegetative
    before = cropdb.conn.execute(
        "SELECT assigned_profile FROM crops WHERE id = ?", (cid,)
    ).fetchone()["assigned_profile"]
    assert before == "leafy_vegetative"

    n_sp_before = cropdb.conn.execute(
        "SELECT COUNT(*) FROM setpoints WHERE crop_id = ?", (cid,)
    ).fetchone()[0]

    cropdb.save_classification(cid, profile="herb_aromatic", changed_by="pytest")

    # crops updated
    after = cropdb.conn.execute(
        "SELECT assigned_profile FROM crops WHERE id = ?", (cid,)
    ).fetchone()["assigned_profile"]
    assert after == "herb_aromatic"

    # audit row created for assigned_profile, source='experiment', is_active=1
    audit = cropdb.conn.execute(
        "SELECT * FROM setpoint_audit WHERE crop_id = ? AND field = 'assigned_profile' "
        "AND is_active = 1",
        (cid,),
    ).fetchone()
    assert audit is not None
    assert audit["source"] == "experiment"
    assert audit["value_text"] == "herb_aromatic"
    assert audit["changed_by"] == "pytest"

    # setpoints were re-resolved (still present; profile change keeps rows)
    n_sp_after = cropdb.conn.execute(
        "SELECT COUNT(*) FROM setpoints WHERE crop_id = ?", (cid,)
    ).fetchone()[0]
    assert n_sp_after > 0
    assert n_sp_before > 0


def test_second_profile_change_supersedes_prior_audit(cropdb):
    cid = _crop_id(cropdb, "Espinaca")
    cropdb.save_classification(cid, profile="herb_aromatic", changed_by="pytest")
    first = cropdb.conn.execute(
        "SELECT id FROM setpoint_audit WHERE crop_id = ? AND field = 'assigned_profile' "
        "AND is_active = 1",
        (cid,),
    ).fetchone()["id"]

    cropdb.save_classification(cid, profile="leafy_vegetative", changed_by="pytest")

    # prior is now inactive
    prior = cropdb.conn.execute(
        "SELECT is_active FROM setpoint_audit WHERE id = ?", (first,)
    ).fetchone()
    assert prior["is_active"] == 0

    # new active audit supersedes the first
    new = cropdb.conn.execute(
        "SELECT * FROM setpoint_audit WHERE crop_id = ? AND field = 'assigned_profile' "
        "AND is_active = 1",
        (cid,),
    ).fetchone()
    assert new["supersedes_id"] == first
    assert new["value_text"] == "leafy_vegetative"


def test_change_priority_only_leaves_setpoints_intact(cropdb):
    cid = _crop_id(cropdb, "Espinaca")
    sp_before = cropdb.conn.execute(
        "SELECT field, value_num, value_text FROM setpoints WHERE crop_id = ? ORDER BY field",
        (cid,),
    ).fetchall()
    profile_before = cropdb.conn.execute(
        "SELECT assigned_profile FROM crops WHERE id = ?", (cid,)
    ).fetchone()["assigned_profile"]

    cropdb.save_classification(cid, priority=3.0, changed_by="pytest")

    # priority audit exists; no assigned_profile audit
    pri_audit = cropdb.conn.execute(
        "SELECT * FROM setpoint_audit WHERE crop_id = ? AND field = 'priority' "
        "AND is_active = 1",
        (cid,),
    ).fetchone()
    assert pri_audit is not None
    assert pri_audit["value_num"] == 3.0
    assert pri_audit["source"] == "experiment"

    # crops.priority updated, profile unchanged
    row = cropdb.conn.execute(
        "SELECT priority, assigned_profile FROM crops WHERE id = ?", (cid,)
    ).fetchone()
    assert row["priority"] == 3.0
    assert row["assigned_profile"] == profile_before

    # setpoints untouched
    sp_after = cropdb.conn.execute(
        "SELECT field, value_num, value_text FROM setpoints WHERE crop_id = ? ORDER BY field",
        (cid,),
    ).fetchall()
    assert [tuple(r) for r in sp_after] == [tuple(r) for r in sp_before]

    assert cropdb.conn.execute(
        "SELECT COUNT(*) FROM setpoint_audit WHERE crop_id = ? AND field = 'assigned_profile'",
        (cid,),
    ).fetchone()[0] == 0


def test_noop_save_does_not_write_audit(cropdb):
    cid = _crop_id(cropdb, "Espinaca")
    before = cropdb.conn.execute(
        "SELECT COUNT(*) FROM setpoint_audit WHERE crop_id = ?", (cid,)
    ).fetchone()[0]
    # Same profile, no priority change -> no-op.
    cropdb.save_classification(cid, profile="leafy_vegetative", changed_by="pytest")
    after = cropdb.conn.execute(
        "SELECT COUNT(*) FROM setpoint_audit WHERE crop_id = ?", (cid,)
    ).fetchone()[0]
    assert after == before


def test_active_setpoints_reads_provenance(cropdb):
    cid = _crop_id(cropdb, "Espinaca")
    sps = cropdb.active_setpoints(cid)
    assert len(sps) > 0
    # each row exposes field/value + provenance columns
    keys = sps[0].keys()
    for k in ("field", "value_num", "value_text", "source"):
        assert k in keys
