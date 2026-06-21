# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""Tests for the crop catalog loader (VRTV-96).

The loader is the "cache JSON" consumer of the canonical
``apps/raspberry/config/crops.json`` artifact. It loads the catalog and
resolves each crop's agronomic profile into a flat setpoints dict that the
simulator/orchestrator (VRTV-95) can consume.
"""

import json

import pytest

from src.agronomy.crop_catalog import (
    Crop,
    CropCatalog,
    CropNotFoundError,
    load_catalog,
)


def test_load_catalog_returns_catalog():
    catalog = load_catalog()
    assert isinstance(catalog, CropCatalog)
    assert len(catalog.list_crops()) > 0


def test_list_crops_contains_known_crop():
    catalog = load_catalog()
    names = [c.name_es for c in catalog.list_crops()]
    assert "Albahaca" in names


def test_get_crop_returns_crop_dataclass():
    catalog = load_catalog()
    crop = catalog.get_crop("Albahaca")
    assert isinstance(crop, Crop)
    assert crop.name_es == "Albahaca"
    assert crop.name_en == "Basil"
    assert crop.profile == "leafy_vegetative"
    assert crop.aeroponic is True
    assert crop.in_kit is True


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


def test_setpoints_resolves_profile_for_albahaca():
    catalog = load_catalog()
    sp = catalog.setpoints("Albahaca")
    # pH ideal 6.6 (from the leafy_vegetative profile).
    assert sp["ph"]["ideal"] == pytest.approx(6.6)
    assert sp["ph"]["min"] == pytest.approx(6.0)
    assert sp["ph"]["max"] == pytest.approx(7.4)
    # EC 250-450 uS/cm3.
    assert sp["ec_uS_cm3"]["min"] == 250
    assert sp["ec_uS_cm3"]["max"] == 450
    # Temps / humidity / photoperiod carried over from the profile.
    assert sp["photoperiod_h"] == 18
    assert sp["ambient_temp_c"]["day"]["max"] == 33
    assert sp["relative_humidity_pct"]["night"]["min"] == 50


def test_setpoints_includes_crop_identity():
    catalog = load_catalog()
    sp = catalog.setpoints("Albahaca")
    # The resolved setpoints carry crop identity so the consumer does not need
    # a second lookup.
    assert sp["crop"]["name_es"] == "Albahaca"
    assert sp["crop"]["profile"] == "leafy_vegetative"
    # The nutrient recipe travels with the resolved profile.
    assert "nutrient_recipe_g_per_1000ml" in sp


def test_setpoints_unknown_crop_raises():
    catalog = load_catalog()
    with pytest.raises(CropNotFoundError):
        catalog.setpoints("NoExiste")


def test_list_crops_aeroponic_only_filters():
    catalog = load_catalog()
    all_crops = catalog.list_crops()
    aero = catalog.list_crops(aeroponic_only=True)
    assert len(aero) <= len(all_crops)
    assert all(c.aeroponic for c in aero)


def test_kit_crops_subset_of_catalog():
    catalog = load_catalog()
    kit = catalog.kit_crops()
    assert len(kit) > 0
    assert all(c.in_kit for c in kit)
    kit_names = {c.name_es for c in kit}
    # Kit crops per the canonical artifact.
    assert {"Albahaca", "Espinaca", "Cebollín", "Culantro"}.issubset(kit_names)


def test_load_catalog_with_explicit_path(tmp_path):
    payload = {
        "profiles": {
            "demo": {
                "ph": {"min": 5.5, "ideal": 6.0, "max": 6.5},
                "ec_uS_cm3": {"min": 100, "max": 200},
            }
        },
        "crops": [
            {
                "name_es": "Prueba",
                "name_en": "Test",
                "family": "Testaceae",
                "species": "Testus testus",
                "aeroponic": False,
                "priority": 9,
                "edible_part": "Hojas",
                "profile": "demo",
                "in_kit": False,
            }
        ],
    }
    p = tmp_path / "crops.json"
    p.write_text(json.dumps(payload), encoding="utf-8")

    catalog = load_catalog(path=p)
    sp = catalog.setpoints("Prueba")
    assert sp["ph"]["ideal"] == pytest.approx(6.0)
    assert catalog.list_crops(aeroponic_only=True) == []


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
