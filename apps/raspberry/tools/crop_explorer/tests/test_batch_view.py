# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""Smoke del Tab "Calculadora de lote" (Fase 4): monta, cambiar de envase
recalcula, la receta del perfil alimenta el solver. Headless (offscreen)."""

import pytest

from db import CropDB

pytest.importorskip("PySide6")
from PySide6.QtWidgets import QApplication  # noqa: E402
from widgets.batch_view import BatchView  # noqa: E402

RECIPE = {
    "solucion_a_nitratos": {"nitrato_de_calcio": 520, "nitrato_de_potasio": 274},
    "solucion_b_fosfatos_sulfatos": {
        "fosfato_monoamonico": 85, "sulfato_de_magnesio": 122.8,
    },
    "solucion_c_micros": {
        "manganeso": 62, "hierro": 12.58, "boro": 1.5, "zinc": 0.3, "cobre": 0.2,
    },
}


@pytest.fixture(scope="module")
def app():
    return QApplication.instance() or QApplication([])


@pytest.fixture
def db_with_recipe(temp_db):
    db = CropDB(temp_db)
    db.save_profile_recipe("fruto_vegetativa", "vegetativa", RECIPE, changed_by="t")
    yield db
    db.close()


def test_batch_view_mounts(app, db_with_recipe):
    view = BatchView(db_with_recipe)
    # Catálogo de envases + "Personalizado".
    assert view.list.count() >= 9
    assert view._v_final_L == 18  # primer envase (Pichinga 18 L)


def test_change_container_recalculates(app, db_with_recipe):
    view = BatchView(db_with_recipe)
    view.list.setCurrentRow(0)  # Pichinga 18 L
    assert view._v_final_L == 18
    # Cambiar a Tanque 5000 L (índice 2 en el catálogo).
    view.list.setCurrentRow(2)
    assert view._v_final_L == 5000


def test_custom_volume_validation(app, db_with_recipe):
    view = BatchView(db_with_recipe)
    custom_row = view.list.count() - 1
    view.list.setCurrentRow(custom_row)
    # Sin volumen (0) -> inválido, no rompe.
    view.custom_spin.setValue(0.0)
    view._on_pick(custom_row)
    # Con volumen > 0 -> válido.
    view.custom_spin.setValue(42.0)
    view._on_pick(custom_row)
    assert view._v_final_L == 42.0


def test_bottle_selector_changes_count(app, db_with_recipe):
    view = BatchView(db_with_recipe)
    view.list.setCurrentRow(0)  # 18 L
    assert view._bottle_L == 1.0
    # 0,5 L está en índice 1 de BOTTLE_SIZES.
    view.bottle_combo.setCurrentIndex(1)
    assert view._bottle_L == 0.5


def test_phase_selector_uses_phase_recipe(app, temp_db):
    # Decisión de diseño: la calculadora soporta las 3 fases. Guardamos receta
    # solo en Reproductiva y verificamos que al seleccionarla se usa.
    db = CropDB(temp_db)
    db.save_profile_recipe("fruto_vegetativa", "reproductiva", RECIPE, changed_by="t")
    view = BatchView(db)
    view.list.setCurrentRow(0)
    assert {view.phase_combo.itemData(i) for i in range(view.phase_combo.count())} == {
        "vegetativa", "reproductiva", "maduracion",
    }
    # Seleccionar Reproductiva (índice 1).
    view.phase_combo.setCurrentIndex(1)
    assert view._phase == "reproductiva"
    db.close()


def test_bottle_change_with_invalid_custom_does_not_render_stale(app, db_with_recipe):
    # Fix CodeRabbit: cambiar de botella con un envase custom inválido (<=0) no
    # debe renderizar un cálculo con volumen stale; queda en estado inválido.
    view = BatchView(db_with_recipe)
    custom_row = view.list.count() - 1
    view.custom_spin.setValue(0.0)
    view.list.setCurrentRow(custom_row)
    assert view._valid is False
    view.bottle_combo.setCurrentIndex(1)  # cambiar botella no debe romper
    assert view._valid is False
