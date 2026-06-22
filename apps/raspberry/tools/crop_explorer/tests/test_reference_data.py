# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""Tests de los datos de referencia (Fase 0): densidades de sal + catálogo de
envases. Verifican que ambos cargan desde config/ y que una densidad faltante
devuelve None sin romper."""

import reference_data as rd


def test_salt_densities_load():
    dens = rd.load_salt_densities()
    assert isinstance(dens, dict)
    # 9 sales conocidas del design.md §5
    assert dens["nitrato_de_calcio"] == 1.82
    assert dens["nitrato_de_potasio"] == 2.11
    assert dens["sulfato_de_magnesio"] == 1.68
    assert len(dens) == 9


def test_salt_density_missing_returns_none():
    dens = rd.load_salt_densities()
    assert rd.salt_density("sal_inexistente", dens) is None
    assert rd.salt_density("nitrato_de_calcio", dens) == 1.82


def test_container_catalog_load():
    cats = rd.load_container_catalog()
    assert isinstance(cats, list)
    models = {c["model"]: c for c in cats}
    assert "Pichinga 18 L" in models
    assert models["Pichinga 18 L"]["capacity_L"] == 18
    assert any(c["capacity_L"] == 27000 for c in cats)


def test_loaders_missing_file_does_not_crash(tmp_path):
    # Apuntar a un archivo inexistente -> dict/list vacíos, sin excepción.
    assert rd.load_salt_densities(tmp_path / "nope.json") == {}
    assert rd.load_container_catalog(tmp_path / "nope.json") == []
