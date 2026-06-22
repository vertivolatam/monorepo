# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""reference_data.py — datos de referencia de primera clase (Fase 0).

Carga, desde ``config/``, la tabla de **densidad por sal** (g/ml) y el
**catálogo de envases** (modelo, capacidad_L). Estos datos alimentan
``recipe_math`` (V_final, aforo, solver de lote) y el ``QListView`` de la
calculadora — viven como JSON versionado, no hardcode (design.md §5).

Diseño robusto: si un archivo no existe o no parsea, se devuelve un contenedor
vacío (no se rompe el arranque), y una densidad faltante devuelve None.
"""

from __future__ import annotations

import json
from pathlib import Path

_HERE = Path(__file__).resolve().parent
CONFIG_DIR = _HERE.parent.parent / "config"
DEFAULT_SALT_DENSITIES = CONFIG_DIR / "salt_densities.json"
DEFAULT_CONTAINER_CATALOG = CONFIG_DIR / "container_catalog.json"


def _read_json(path: Path) -> dict | list | None:
    try:
        return json.loads(Path(path).read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return None


def load_salt_densities(path: Path | None = None) -> dict[str, float]:
    """Devuelve {clave_sal: densidad_g_ml}. Vacío si el archivo falta/inválido."""
    data = _read_json(path or DEFAULT_SALT_DENSITIES)
    if not isinstance(data, dict):
        return {}
    densities = data.get("densities", data)
    if not isinstance(densities, dict):
        return {}
    out: dict[str, float] = {}
    for salt, value in densities.items():
        if salt.startswith("_"):
            continue
        # Solo densidades numéricas ESTRICTAMENTE positivas: una densidad <= 0
        # daría volúmenes sin sentido (y rompería la división en recipe_math).
        if (
            isinstance(value, (int, float))
            and not isinstance(value, bool)
            and value > 0
        ):
            out[salt] = float(value)
    return out


def salt_density(salt: str, densities: dict[str, float]) -> float | None:
    """Densidad de una sal, o None si no está registrada (design.md §8)."""
    return densities.get(salt)


def _valid_capacity(value) -> bool:
    """``capacity_L`` debe ser numérico ESTRICTAMENTE positivo (no bool)."""
    return (
        isinstance(value, (int, float))
        and not isinstance(value, bool)
        and value > 0
    )


def load_container_catalog(path: Path | None = None) -> list[dict]:
    """Devuelve [{model, capacity_L, gal}, …]. Vacío si el archivo falta/inválido.

    Descarta entradas sin ``capacity_L`` numérico positivo (un envase de volumen
    cero/negativo/no-numérico no es seleccionable en la calculadora)."""
    data = _read_json(path or DEFAULT_CONTAINER_CATALOG)
    if isinstance(data, dict):
        data = data.get("containers", [])
    if not isinstance(data, list):
        return []
    return [
        c
        for c in data
        if isinstance(c, dict) and _valid_capacity(c.get("capacity_L"))
    ]
