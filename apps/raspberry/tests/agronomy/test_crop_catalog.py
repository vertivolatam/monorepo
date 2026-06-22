# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""Tests for the crop catalog loader (VRTV-96, v2 schema).

The loader is the "cache JSON" consumer of the canonical
``apps/raspberry/config/crops.json`` artifact (107 crops, 6 agronomic
profiles, values wrapped with provenance). It loads the catalog and resolves
each crop's profile into a **clean** (provenance-free) setpoints dict that the
simulator/orchestrator (VRTV-95) can consume.
"""

import json

import pytest

from src.agronomy.crop_catalog import (
    Crop,
    CropCatalog,
    CropNotFoundError,
    NoProfileError,
    load_catalog,
)

# Provenance keys that must NEVER leak into clean setpoints.
_PROVENANCE_KEYS = {"source", "_source", "citation", "confidence", "unit"}


def _assert_no_provenance(obj):
    """Recursively assert no provenance keys appear anywhere in ``obj``."""
    if isinstance(obj, dict):
        leaked = _PROVENANCE_KEYS & set(obj)
        assert not leaked, f"provenance leaked into setpoints: {leaked} in {obj}"
        for v in obj.values():
            _assert_no_provenance(v)
    elif isinstance(obj, list):
        for v in obj:
            _assert_no_provenance(v)


# -- catalog loading -----------------------------------------------------


def test_load_catalog_returns_catalog():
    catalog = load_catalog()
    assert isinstance(catalog, CropCatalog)
    # The complete v2 catalog ships 108 crops (Zapallo/Ayote split into 2 species).
    assert len(catalog.list_crops()) == 108


def test_list_crops_contains_known_crop():
    catalog = load_catalog()
    names = [c.name_es for c in catalog.list_crops()]
    assert "Albahaca" in names
    assert "Tomate" in names
    assert "Lechuga" in names


def test_get_crop_returns_crop_dataclass():
    catalog = load_catalog()
    crop = catalog.get_crop("Albahaca")
    assert isinstance(crop, Crop)
    assert crop.name_es == "Albahaca"
    assert crop.name_en == "Basil"
    # In v2 Albahaca is an aromatic herb, not a generic leafy crop.
    assert crop.profile == "hierba_aromatica"
    assert crop.aeroponic is True


def test_get_crop_is_case_insensitive():
    catalog = load_catalog()
    assert catalog.get_crop("albahaca").name_es == "Albahaca"
    assert catalog.get_crop("  ALBAHACA  ").name_es == "Albahaca"


def test_get_crop_unknown_raises_clear_error():
    catalog = load_catalog()
    with pytest.raises(CropNotFoundError) as exc:
        catalog.get_crop("Mandrágora")
    msg = str(exc.value)
    assert "Mandrágora" in msg
    # The error should be helpful: list a few available crops.
    assert "Albahaca" in msg


# -- clean setpoints: profile resolution & provenance unwrap -------------


def test_setpoints_resolves_leafy_profile_clean():
    """Lechuga → hoja_vegetativa; values clean (numbers, not provenance)."""
    catalog = load_catalog()
    sp = catalog.setpoints("Lechuga")
    # pH ideal 6.6 from the hoja_vegetativa profile.
    assert sp["ph"]["ideal"] == pytest.approx(6.6)
    assert sp["ph"]["min"] == pytest.approx(6.0)
    assert sp["ph"]["max"] == pytest.approx(7.4)
    # EC is now dS/m (not ec_uS_cm3); researched min >= 1.0.
    assert sp["ec_dS_m"]["min"] >= 1.0
    assert "ec_uS_cm3" not in sp
    # photoperiod_h unwrapped from {value, source} to a plain int.
    assert sp["photoperiod_h"] == 18
    assert isinstance(sp["photoperiod_h"], int)
    # Day/night nested ranges carried over.
    assert sp["ambient_temp_c"]["day"]["max"] == 33
    assert sp["relative_humidity_pct"]["night"]["min"] == 50
    # ORP and PPFD present and clean.
    assert sp["orp_mv"]["min"] == 650
    assert sp["ppfd_umol_m2_s"]["max"] == 450
    # The nutrient recipe travels with the resolved profile.
    assert "nutrient_recipe_g_per_1000ml" in sp


def test_setpoints_strips_provenance_keys():
    """setpoints() must NOT carry source / citation / confidence / unit."""
    catalog = load_catalog()
    for name in ("Lechuga", "Albahaca", "Tomate", "Fresa", "Papa"):
        sp = catalog.setpoints(name)
        _assert_no_provenance(sp)
    # The anomalous spreadsheet EC placeholder is dropped entirely.
    assert "ec_sheet_raw" not in catalog.setpoints("Lechuga")


def test_setpoints_includes_crop_identity():
    catalog = load_catalog()
    sp = catalog.setpoints("Albahaca")
    assert sp["crop"]["name_es"] == "Albahaca"
    assert sp["crop"]["profile"] == "hierba_aromatica"
    assert sp["crop"]["aeroponic"] is True


def test_setpoints_herb_profile_values():
    """Albahaca resolves the researched hierba_aromatica profile (pH 5.8)."""
    catalog = load_catalog()
    sp = catalog.setpoints("Albahaca")
    assert sp["ph"]["ideal"] == pytest.approx(5.8)
    assert sp["ec_dS_m"]["min"] == pytest.approx(0.8)


# -- fruit crops: profile_phases -----------------------------------------


def test_setpoints_fruit_default_phase_is_vegetative():
    """Tomate (profile_phases) defaults to the vegetative phase."""
    catalog = load_catalog()
    crop = catalog.get_crop("Tomate")
    assert crop.profile_phases == {
        "vegetative": "fruto_vegetativa",
        "reproductive": "fruto_reproductiva",
    }
    sp = catalog.setpoints("Tomate")
    assert sp["crop"]["profile"] == "fruto_vegetativa"
    assert sp["ph"]["ideal"] == pytest.approx(6.0)


def test_setpoints_fruit_reproductive_phase():
    """Explicit reproductive phase resolves the reproductive profile."""
    catalog = load_catalog()
    sp = catalog.setpoints("Tomate", phase="reproductive")
    assert sp["crop"]["profile"] == "fruto_reproductiva"
    assert sp["ph"]["ideal"] == pytest.approx(5.8)
    _assert_no_provenance(sp)


def test_setpoints_unknown_phase_raises():
    catalog = load_catalog()
    with pytest.raises(KeyError):
        catalog.setpoints("Tomate", phase="maduracion")


# -- non-aeroponic / profile-less crops ----------------------------------


def test_setpoints_aeroponic_only_crop_without_profile_raises():
    """Aceituna is not aeroponic and has profile=null → NoProfileError."""
    catalog = load_catalog()
    crop = catalog.get_crop("Aceituna")
    assert crop.aeroponic is False
    assert crop.profile is None
    with pytest.raises(NoProfileError):
        catalog.setpoints("Aceituna")


def test_setpoints_unknown_crop_raises():
    catalog = load_catalog()
    with pytest.raises(CropNotFoundError):
        catalog.setpoints("NoExiste")


# -- raw provenance access ----------------------------------------------


def test_raw_profile_preserves_provenance():
    """raw_profile keeps the citations / source the clean view strips."""
    catalog = load_catalog()
    raw = catalog.raw_profile("Lechuga")
    assert raw["ph"]["source"] == "sheet"
    assert "citation" in raw["ec_dS_m"]
    # And the clean view of the same crop does not.
    _assert_no_provenance(catalog.setpoints("Lechuga"))


# -- list / filter helpers -----------------------------------------------


def test_list_crops_aeroponic_only_filters():
    catalog = load_catalog()
    all_crops = catalog.list_crops()
    aero = catalog.list_crops(aeroponic_only=True)
    assert len(aero) < len(all_crops)
    assert all(c.aeroponic for c in aero)
    # v2: 64 of 107 crops are aeroponic-capable.
    assert len(aero) == 64


def test_kit_crops_handles_absent_in_kit_field():
    """v2 has no in_kit field yet → kit_crops() is a (possibly empty) list."""
    catalog = load_catalog()
    kit = catalog.kit_crops()
    assert isinstance(kit, list)
    assert all(c.in_kit for c in kit)


# -- explicit-path payloads (schema contract, incl. in_kit) --------------


def test_load_catalog_with_explicit_path_unwraps_provenance(tmp_path):
    payload = {
        "profiles": {
            "demo": {
                "label_es": "Demo",
                "ph": {"min": 5.5, "ideal": 6.0, "max": 6.5, "source": "sheet"},
                "ec_dS_m": {
                    "min": 1.2,
                    "max": 2.0,
                    "unit": "dS/m",
                    "source": "researched",
                    "citation": "demo",
                    "confidence": "low",
                },
                "ec_sheet_raw": {"min": 10.0, "max": 12.0, "source": "sheet"},
                "photoperiod_h": {"value": 16, "source": "sheet"},
            }
        },
        "crops": [
            {
                "name_es": "Prueba",
                "name_en": "Test",
                "family": "Testaceae",
                "species": "Testus testus",
                "aeroponic": True,
                "priority": 9,
                "edible_part": "Hojas",
                "profile": "demo",
                "in_kit": True,
            }
        ],
    }
    p = tmp_path / "crops.json"
    p.write_text(json.dumps(payload), encoding="utf-8")

    catalog = load_catalog(path=p)
    crop = catalog.get_crop("Prueba")
    assert crop.in_kit is True
    assert catalog.kit_crops() == [crop]

    sp = catalog.setpoints("Prueba")
    assert sp["ph"]["ideal"] == pytest.approx(6.0)
    assert sp["ec_dS_m"]["min"] == pytest.approx(1.2)
    assert sp["photoperiod_h"] == 16
    assert "ec_sheet_raw" not in sp
    assert "label_es" not in sp
    _assert_no_provenance(sp)


def test_setpoints_missing_profile_raises(tmp_path):
    payload = {
        "profiles": {},
        "crops": [
            {"name_es": "Huérfano", "profile": "inexistente"},
        ],
    }
    p = tmp_path / "crops.json"
    p.write_text(json.dumps(payload), encoding="utf-8")
    catalog = load_catalog(path=p)
    with pytest.raises(KeyError):
        catalog.setpoints("Huérfano")
