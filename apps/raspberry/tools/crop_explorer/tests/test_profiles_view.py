# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""Smoke del Tab "Perfiles & Recetas" (Fase 3): monta, el switch re-renderiza,
guardar propaga al perfil. Corre headless (QT_QPA_PLATFORM=offscreen)."""

import pytest

from db import CropDB

pytest.importorskip("PySide6")
from PySide6.QtWidgets import QApplication  # noqa: E402
from widgets.profiles_view import ProfilesView, PROFILE_LABELS  # noqa: E402


@pytest.fixture(scope="module")
def app():
    return QApplication.instance() or QApplication([])


def test_profiles_view_mounts(app, temp_db):
    db = CropDB(temp_db)
    view = ProfilesView(db)
    assert view.list.count() == len(PROFILE_LABELS)
    # Hay steppers montados para la solución A del perfil seleccionado.
    assert any(k[1] == "solucion_a_nitratos" for k in view._steppers)
    db.close()


def test_base_switch_rerenders(app, temp_db):
    db = CropDB(temp_db)
    view = ProfilesView(db)
    view._set_mode("aforo")
    # En aforo los steppers son solo-vista (deshabilitados) y el badge dice 1 L.
    any_stepper = next(iter(view._steppers.values()))
    assert not any_stepper.isEnabled()
    badge = next(iter(view._vol_badges.values()))
    assert "1,00 L" in badge.text()
    view._set_mode("water")
    any_stepper = next(iter(view._steppers.values()))
    assert any_stepper.isEnabled()
    db.close()


def test_save_propagates(app, temp_db):
    db = CropDB(temp_db)
    view = ProfilesView(db)
    # fruto_vegetativa es el primer perfil (índice 0), con 9 cultivos.
    view._select_profile(0)
    emitted = []
    view.recipeSaved.connect(lambda *a: emitted.append(a))
    # Mete un valor en la solución A y guarda la fase vegetativa.
    st = view._steppers[("vegetativa", "solucion_a_nitratos", "nitrato_de_calcio")]
    st._spin.setValue(520.0)
    view._on_save("vegetativa")
    assert emitted and emitted[0][2] == 9
    stored = db.profile_recipe("fruto_vegetativa", "vegetativa")
    assert stored["solucion_a_nitratos"]["nitrato_de_calcio"] == 520.0
    db.close()


def test_aforo_with_missing_density_does_not_fake_one_liter(app, temp_db):
    # Regresión CodeRabbit: en aforo, si falta densidad el factor NO es
    # computable -> _factor_for None y el badge NO afirma "1,00 L (aforado)".
    db = CropDB(temp_db)
    recipe = {
        "solucion_a_nitratos": {"nitrato_de_calcio": 520, "nitrato_de_potasio": 274},
        "solucion_b_fosfatos_sulfatos": {},
        "solucion_c_micros": {},
    }
    db.save_profile_recipe("fruto_vegetativa", "vegetativa", recipe, changed_by="t")
    view = ProfilesView(db)
    view._select_profile(0)
    # Simula densidad faltante para una sal con valor en la solución A.
    view._densities = {
        k: v for k, v in view._densities.items() if k != "nitrato_de_calcio"
    }
    view._set_mode("aforo")
    salts = view._current_salts("vegetativa", "solucion_a_nitratos")
    assert view._factor_for(salts) is None  # no se finge factor 1.0
    badge = view._vol_badges[("vegetativa", "solucion_a_nitratos")]
    assert "falta densidad" in badge.text()
    db.close()
