# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""Tests de la lógica pura de recetas (Fase 1, TDD).

Casos de referencia tomados del mockup aprobado (interactive-megatabs.html) para
la receta fruto-vegetativa. Convención canónica: g de sal SECA por 1000 ml de
AGUA (no aforado). V_final = 1000 + Σ(masa_g / densidad_g_ml)."""

import math

import recipe_math as rm

# Densidades de referencia (del mockup / design.md §5).
DENS = {
    "nitrato_de_calcio": 1.82,
    "nitrato_de_potasio": 2.11,
    "fosfato_monoamonico": 1.80,
    "sulfato_de_magnesio": 1.68,
    "manganeso": 2.95,
    "hierro": 2.0,
    "boro": 1.73,
    "zinc": 3.5,
    "cobre": 3.6,
}

# Receta fruto-vegetativa A/B/C (g / 1000 ml de agua), del mockup.
SALTS_A = {"nitrato_de_calcio": 520, "nitrato_de_potasio": 274}
SALTS_B = {"fosfato_monoamonico": 85, "sulfato_de_magnesio": 122.8}
SALTS_C = {
    "manganeso": 62, "hierro": 12.58, "boro": 1.5, "zinc": 0.3, "cobre": 0.2,
}


def test_unit_final_ml_solution_a():
    # 1000 + 520/1.82 + 274/2.11 = 1415.572…
    v = rm.unit_final_ml(SALTS_A, DENS)
    assert math.isclose(v, 1000 + 520 / 1.82 + 274 / 2.11, rel_tol=1e-9)
    assert math.isclose(v, 1415.5722, abs_tol=1e-3)


def test_unit_final_ml_solution_b():
    v = rm.unit_final_ml(SALTS_B, DENS)
    assert math.isclose(v, 1000 + 85 / 1.80 + 122.8 / 1.68, rel_tol=1e-9)
    assert math.isclose(v, 1120.3174, abs_tol=1e-3)


def test_unit_final_ml_solution_c():
    v = rm.unit_final_ml(SALTS_C, DENS)
    expected = 1000 + 62 / 2.95 + 12.58 / 2.0 + 1.5 / 1.73 + 0.3 / 3.5 + 0.2 / 3.6
    assert math.isclose(v, expected, rel_tol=1e-9)
    assert math.isclose(v, 1028.3151, abs_tol=1e-3)


def test_unit_final_ml_missing_density_returns_none():
    # Una sal sin densidad -> V_final no calculable (design.md §8).
    v = rm.unit_final_ml({"sal_rara": 100}, DENS)
    assert v is None


def test_aforo_factor_formula():
    # factor_aforo = 1000 / V_final (transformación de DISPLAY: los gramos se
    # reescalan para reportarse "por 1 L de solución"; el volumen mostrado es
    # 1,00 L por convención, NO se recalcula el desplazamiento — design.md §3).
    f = rm.aforo_factor(SALTS_A, DENS)
    v = rm.unit_final_ml(SALTS_A, DENS)
    assert math.isclose(f, 1000 / v, rel_tol=1e-12)
    # El factor < 1 porque V_final > 1000 ml (la sal desplaza volumen).
    assert 0 < f < 1


def test_aforo_factor_missing_density_none():
    assert rm.aforo_factor({"sal_rara": 100}, DENS) is None


def test_scale_to_volume_pichinga_18L_solution_a():
    # Pichinga 18 L = 18000 ml. units = 18000 / V_final_A.
    out = rm.scale_to_volume(SALTS_A, 18000.0, DENS)
    uf = rm.unit_final_ml(SALTS_A, DENS)
    units = 18000.0 / uf
    assert math.isclose(out["agua_L"], units, rel_tol=1e-9)
    assert math.isclose(out["agua_L"], 12.7160, abs_tol=1e-3)
    assert math.isclose(out["masas_g"]["nitrato_de_calcio"], units * 520, rel_tol=1e-9)
    assert math.isclose(out["masas_g"]["nitrato_de_calcio"], 6612.17, abs_tol=1e-1)
    # 18 L final con botella de 1 L -> 18 botellas.
    assert out["botellas"] == 18


def test_scale_to_volume_bottle_size():
    # Botella de 0.5 L sobre 18 L -> 36 botellas.
    out = rm.scale_to_volume(SALTS_A, 18000.0, DENS, bottle_L=0.5)
    assert out["botellas"] == 36


def test_scale_to_volume_missing_density_none_volumen():
    out = rm.scale_to_volume({"sal_rara": 100}, 18000.0, DENS)
    # No calculable: agua/masas None, pero no rompe.
    assert out["agua_L"] is None
    assert out["masas_g"] is None


# --- branches defensivos (regresión CodeRabbit) ---
def test_unit_final_ml_negative_mass_returns_none():
    # Una masa negativa no tiene sentido físico -> receta no-determinable.
    assert rm.unit_final_ml({"nitrato_de_calcio": -10}, DENS) is None


def test_unit_final_ml_nonpositive_density_returns_none():
    # Densidad cero o negativa -> volumen no calculable (no dividir por <= 0).
    assert rm.unit_final_ml({"x": 100}, {"x": 0}) is None
    assert rm.unit_final_ml({"x": 100}, {"x": -1.5}) is None


def test_scale_to_volume_nonpositive_bottle_returns_zero_bottles():
    # bottle_L <= 0 -> 0 botellas, sin ZeroDivisionError; el cálculo sigue.
    out = rm.scale_to_volume(SALTS_A, 18000.0, DENS, bottle_L=0.0)
    assert out["botellas"] == 0
    assert out["agua_L"] is not None  # el resto del solver no se rompe
    out_neg = rm.scale_to_volume(SALTS_A, 18000.0, DENS, bottle_L=-1.0)
    assert out_neg["botellas"] == 0
