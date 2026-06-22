# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""recipe_math.py — lógica PURA del cálculo de recetas (Fase 1, sin Qt).

Convención canónica (confirmada con agrónomos, design.md §3): la receta se
guarda SIEMPRE como gramos de sal SECA por **1000 ml de AGUA** (no aforado). La
sal desplaza volumen, por lo que el volumen final de cada stock es > 1 L.

    V_final_unidad(ml) = 1000 + Σ_sal ( masa_g / densidad_g_por_ml )

- ``unit_final_ml``  → volumen final de una unidad de stock (1000 ml de agua).
- ``aforo_factor``   → factor de display "aforado a 1 L" (no altera el dato).
- ``scale_to_volume``→ solver inverso de lote para un volumen FINAL de envase.

Una sal sin densidad hace el cálculo no-determinable → se devuelve ``None``
(la UI muestra "—" + warning), nunca se rompe (design.md §8).

``salts`` es un mapeo {clave_sal: gramos}; ``densities`` {clave_sal: g/ml}.
"""

from __future__ import annotations

import math

DEFAULT_BOTTLE_L = 1.0


def unit_final_ml(salts: dict[str, float], densities: dict[str, float]) -> float | None:
    """Volumen final (ml) de una unidad de stock = 1000 ml de agua + desplazamiento.

    Devuelve None si alguna sal con masa > 0 no tiene densidad registrada."""
    total = 1000.0
    for salt, grams in salts.items():
        if not grams:
            continue
        # Una masa negativa no tiene sentido físico (la sal no "resta" volumen);
        # tratamos la receta como no-determinable -> None.
        if grams < 0:
            return None
        rho = densities.get(salt)
        # Densidad ausente, cero o negativa -> volumen no calculable (design.md §8).
        if rho is None or rho <= 0:
            return None
        total += grams / rho
    return total


def aforo_factor(salts: dict[str, float], densities: dict[str, float]) -> float | None:
    """Factor de reescalado para llevar el volumen final a 1 L exacto (solo vista).

    ``factor_aforo = 1000 / V_final_unidad``. Al multiplicar los gramos por este
    factor, el volumen final mostrado es 1,00 L con la misma concentración.
    None si el volumen final no es calculable."""
    v = unit_final_ml(salts, densities)
    if v is None or v <= 0:
        return None
    return 1000.0 / v


def scale_to_volume(
    salts: dict[str, float],
    v_final_ml: float,
    densities: dict[str, float],
    *,
    bottle_L: float = DEFAULT_BOTTLE_L,
) -> dict:
    """Solver inverso de lote (design.md §4).

    Dado el volumen FINAL del envase (ml), la receta de una solución y las
    densidades, calcula hacia atrás:

        unidades   = V_final / V_final_unidad
        agua_L     = unidades * 1.0        (1 L de agua por unidad)
        masa_g(sal)= unidades * g_por_1000ml(sal)
        botellas   = floor(V_final_L / volumen_botella_L)

    Devuelve ``{agua_L, masas_g, unidades, v_final_unidad_ml, botellas}``.
    Si el volumen unidad no es calculable (densidad faltante), ``agua_L``,
    ``masas_g`` y ``unidades`` son None (las botellas igual se calculan del
    volumen del envase)."""
    bottles = (
        int(math.floor((v_final_ml / 1000.0) / bottle_L))
        if bottle_L and bottle_L > 0
        else 0
    )
    uf = unit_final_ml(salts, densities)
    if uf is None or uf <= 0:
        return {
            "agua_L": None,
            "masas_g": None,
            "unidades": None,
            "v_final_unidad_ml": uf,
            "botellas": bottles,
        }
    units = v_final_ml / uf
    return {
        "agua_L": units,
        "masas_g": {salt: units * grams for salt, grams in salts.items()},
        "unidades": units,
        "v_final_unidad_ml": uf,
        "botellas": bottles,
    }
