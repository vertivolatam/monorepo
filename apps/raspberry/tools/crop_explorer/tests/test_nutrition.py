# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""Phase 0 — nutrition extraction (build_db.py).

The XLSX green group ("Nutritional value per 100 g") is currently EMPTY, so the
sheet extractor yields 0 rows; researched ``nutrition_per_100g`` blocks in
crops.json supply the flagship crops. These tests pin both behaviours and the
``nutrition`` table population.
"""

import sqlite3

import build_db


def test_nutrition_columns_cover_groups():
    keys = {k for k, _c, _u in build_db.NUTRITION_COLUMNS}
    # Macros + water present.
    for k in ("energy", "protein", "fat", "water", "carbohydrates_sugars", "dietary_fiber"):
        assert k in keys
    # Vitamin and mineral families present.
    assert any(k.startswith("vit_") for k in keys)
    assert any(k.startswith("min_") for k in keys)
    # 26 columns (106-131), 1-indexed, no dupes.
    cols = [c for _k, c, _u in build_db.NUTRITION_COLUMNS]
    assert cols == list(range(106, 132))
    assert len(keys) == len(build_db.NUTRITION_COLUMNS) == 26


def test_resolve_nutrition_from_json_block():
    crop = {
        "name_es": "Demo",
        "source_row": 99999,  # not in the (empty) sheet
        "nutrition_per_100g": {
            "source": "researched",
            "protein": {"value": 3.15, "unit": "g"},
            "vit_c": 18,  # bare scalar -> unit from NUTRITION_UNITS
            "energy": None,  # skipped
        },
    }
    rows = build_db.resolve_nutrition(crop, sheet_nutrition={})
    by_n = {r["nutrient"]: r for r in rows}
    assert by_n["protein"]["value_num"] == 3.15
    assert by_n["protein"]["unit"] == "g"
    assert by_n["protein"]["source"] == "researched"
    assert by_n["vit_c"]["unit"] == "mg"  # filled from NUTRITION_UNITS
    assert "energy" not in by_n  # None value skipped


def test_sheet_nutrition_takes_priority_over_json():
    crop = {
        "source_row": 7,
        "nutrition_per_100g": {"protein": 99.0},  # would lose to the sheet
    }
    sheet = {7: [{"nutrient": "protein", "value_num": 2.86, "unit": "g", "source": "sheet"}]}
    rows = build_db.resolve_nutrition(crop, sheet)
    assert rows == sheet[7]
    assert rows[0]["source"] == "sheet"


def test_sheet_green_group_is_currently_empty(source_xlsx):
    """Documents the data gap: the XLSX nutrition columns hold no values today."""
    sheet = build_db.read_sheet_nutrition(source_xlsx)
    assert sheet == {}, (
        "Sheet nutrition is expected EMPTY (data gap). If this fails the sheet "
        "was populated — great; update this test to assert real rows."
    )


def test_build_populates_nutrition_table(temp_db):
    conn = sqlite3.connect(temp_db)
    conn.row_factory = sqlite3.Row
    total = conn.execute("SELECT COUNT(*) FROM nutrition").fetchone()[0]
    assert total > 0, "nutrition table must have rows after build"

    # Espinaca (a known flagship) has nutrition rows with researched provenance.
    crop = conn.execute(
        "SELECT id FROM crops WHERE name_es = 'Espinaca'"
    ).fetchone()
    assert crop is not None
    rows = conn.execute(
        "SELECT nutrient, value_num, unit, source FROM nutrition WHERE crop_id = ?",
        (crop["id"],),
    ).fetchall()
    assert len(rows) > 0
    by_n = {r["nutrient"]: r for r in rows}
    assert "protein" in by_n
    assert by_n["protein"]["value_num"] > 0
    assert by_n["protein"]["unit"] == "g"
    assert by_n["protein"]["source"] == "researched"
    conn.close()
