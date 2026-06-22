# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""Tests de la receta por PERFIL + propagación auditada (Fase 2).

La receta vive en el perfil×fase: editarla escribe ``profile_recipes`` y
re-resuelve ``nutrient_recipe_json`` en TODOS los cultivos con ese perfil,
dejando ``setpoint_audit`` por cultivo (rollback)."""

import json

import pytest

from db import CropDB

PROFILE = "fruto_vegetativa"
PHASE = "vegetativa"

RECIPE = {
    "solucion_a_nitratos": {"nitrato_de_calcio": 520, "nitrato_de_potasio": 274},
    "solucion_b_fosfatos_sulfatos": {
        "fosfato_monoamonico": 85, "sulfato_de_magnesio": 122.8,
    },
    "solucion_c_micros": {
        "manganeso": 62, "hierro": 12.58, "boro": 1.5, "zinc": 0.3, "cobre": 0.2,
    },
}


def test_crops_using_profile(temp_db):
    db = CropDB(temp_db)
    ids = db.crops_using_profile(PROFILE)
    assert isinstance(ids, list)
    assert len(ids) == 9  # fruto_vegetativa en el seed
    db.close()


def test_save_profile_recipe_persists_and_propagates(temp_db):
    db = CropDB(temp_db)
    ids = db.crops_using_profile(PROFILE)
    n = db.save_profile_recipe(PROFILE, PHASE, RECIPE, changed_by="agronomist")
    assert n == len(ids)

    # 1) Persistida en profile_recipes (la receta del PERFIL).
    stored = db.profile_recipe(PROFILE, PHASE)
    assert stored is not None
    assert stored["solucion_a_nitratos"]["nitrato_de_calcio"] == 520

    # 2) Propagada: cada cultivo tiene nutrient_recipe_json = la receta del perfil.
    for crop_id in ids:
        sps = {s["field"]: s for s in db.active_setpoints(crop_id)}
        assert "nutrient_recipe_json" in sps
        body = json.loads(sps["nutrient_recipe_json"]["value_text"])
        assert body["solucion_a_nitratos"]["nitrato_de_calcio"] == 520
        # 3) Auditada: la entrada activa es source=experiment, changed_by propagado.
        assert sps["nutrient_recipe_json"]["source"] == "experiment"
        assert sps["nutrient_recipe_json"]["changed_by"] == "agronomist"
    db.close()


def test_save_profile_recipe_rollback_chain(temp_db):
    db = CropDB(temp_db)
    crop_id = db.crops_using_profile(PROFILE)[0]
    db.save_profile_recipe(PROFILE, PHASE, RECIPE, changed_by="agronomist")

    other = dict(RECIPE)
    other["solucion_a_nitratos"] = {"nitrato_de_calcio": 999, "nitrato_de_potasio": 100}
    db.save_profile_recipe(PROFILE, PHASE, other, changed_by="agronomist")

    # Solo una entrada activa por campo; el historial encadena supersedes.
    rows = db.conn.execute(
        "SELECT is_active, supersedes_id FROM setpoint_audit "
        "WHERE crop_id = ? AND field = 'nutrient_recipe_json' ORDER BY id",
        (crop_id,),
    ).fetchall()
    active = [r for r in rows if r["is_active"]]
    assert len(active) == 1
    # La última entrada supersedeó a una previa.
    assert active[0]["supersedes_id"] is not None
    db.close()


def test_save_profile_recipe_no_crops_ok(temp_db):
    db = CropDB(temp_db)
    # Perfil sin cultivos asignados (N=0): permitido, sin propagación, no rompe.
    n = db.save_profile_recipe("perfil_fantasma", PHASE, RECIPE, changed_by="x")
    assert n == 0
    assert db.profile_recipe("perfil_fantasma", PHASE) is not None
    db.close()


def test_profile_recipe_absent_returns_none(temp_db):
    db = CropDB(temp_db)
    assert db.profile_recipe("no_existe", "vegetativa") is None
    db.close()


# --- contrato / alineación (regresión CodeRabbit) ---
def test_profile_recipe_nonobject_json_returns_none(temp_db):
    db = CropDB(temp_db)
    # JSON válido pero NO-objeto (lista/string) viola el contrato dict -> None.
    db.conn.execute(
        "INSERT INTO profile_recipes (profile_key, phase, recipe_json, "
        "changed_at, changed_by) VALUES (?,?,?,?,?)",
        ("raro_lista", PHASE, json.dumps([1, 2, 3]), "now", "t"),
    )
    db.conn.execute(
        "INSERT INTO profile_recipes (profile_key, phase, recipe_json, "
        "changed_at, changed_by) VALUES (?,?,?,?,?)",
        ("raro_str", PHASE, json.dumps("no soy receta"), "now", "t"),
    )
    db.conn.commit()
    assert db.profile_recipe("raro_lista", PHASE) is None
    assert db.profile_recipe("raro_str", PHASE) is None
    db.close()


def test_save_profile_recipe_setpoint_matches_active_audit(temp_db):
    # El VALOR del setpoint debe coincidir con el audit activo (escritura del
    # setpoint ANTES del audit: quedan alineados, sin audit sin valor).
    db = CropDB(temp_db)
    for crop_id in db.crops_using_profile(PROFILE):
        db.save_profile_recipe(PROFILE, PHASE, RECIPE, changed_by="t")
        sp = db.conn.execute(
            "SELECT value_text FROM setpoints "
            "WHERE crop_id = ? AND field = 'nutrient_recipe_json'",
            (crop_id,),
        ).fetchone()
        au = db.conn.execute(
            "SELECT value_text FROM setpoint_audit "
            "WHERE crop_id = ? AND field = 'nutrient_recipe_json' AND is_active = 1",
            (crop_id,),
        ).fetchone()
        assert sp is not None and au is not None
        assert sp["value_text"] == au["value_text"]
        break
    db.close()


if __name__ == "__main__":
    raise SystemExit(pytest.main([__file__, "-q"]))
