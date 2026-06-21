# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""Crop catalog loader and setpoint resolution (VRTV-96).

Loads the canonical ``config/crops.json`` artifact and exposes a clean API:

    >>> catalog = load_catalog()
    >>> catalog.get_crop("Albahaca").name_en
    'Basil'
    >>> catalog.setpoints("Albahaca")["ph"]["ideal"]
    6.6

``crops.json`` keeps the agronomic setpoints (pH / EC / temps / humidity /
nutrient recipe) in *profiles* and references them from each crop via the
``profile`` key. ``setpoints(name_es)`` resolves that indirection into a single
flat dict so downstream consumers (the simulator / orchestrator, VRTV-95) do
not need to know about the profile layer.
"""

from __future__ import annotations

import copy
import json
import os
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Dict, List, Optional, Union

# Default location of the canonical artifact: apps/raspberry/config/crops.json,
# resolved relative to this file (src/agronomy/crop_catalog.py).
_DEFAULT_CONFIG_PATH = (
    Path(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
    / "config"
    / "crops.json"
)


class CropCatalogError(Exception):
    """Base error for crop catalog problems."""


class CropNotFoundError(CropCatalogError, KeyError):
    """Raised when a crop cannot be found by its Spanish name.

    Subclasses :class:`KeyError` so existing ``except KeyError`` paths keep
    working, while remaining catchable as a catalog-specific error.
    """


@dataclass(frozen=True)
class Crop:
    """A single crop entry from the catalog.

    ``extra`` carries any catalog fields not promoted to first-class
    attributes (e.g. ``species_inferred``), so the loader does not silently
    drop data when the artifact evolves.
    """

    name_es: str
    name_en: Optional[str]
    family: Optional[str]
    species: Optional[str]
    aeroponic: bool
    priority: Optional[int]
    edible_part: Optional[str]
    profile: Optional[str]
    in_kit: bool
    extra: Dict[str, Any]

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> "Crop":
        known = {
            "name_es",
            "name_en",
            "family",
            "species",
            "aeroponic",
            "priority",
            "edible_part",
            "profile",
            "in_kit",
        }
        extra = {k: v for k, v in data.items() if k not in known}
        return cls(
            name_es=data["name_es"],
            name_en=data.get("name_en"),
            family=data.get("family"),
            species=data.get("species"),
            aeroponic=bool(data.get("aeroponic", False)),
            priority=data.get("priority"),
            edible_part=data.get("edible_part"),
            profile=data.get("profile"),
            in_kit=bool(data.get("in_kit", False)),
            extra=extra,
        )


class CropCatalog:
    """In-memory view of the crop catalog with setpoint resolution."""

    def __init__(
        self,
        crops: List[Crop],
        profiles: Dict[str, Dict[str, Any]],
        meta: Optional[Dict[str, Any]] = None,
    ) -> None:
        self._crops = list(crops)
        self._profiles = profiles
        self.meta = meta or {}
        # Case-insensitive index by Spanish name.
        self._by_name = {c.name_es.strip().casefold(): c for c in self._crops}

    # -- queries ---------------------------------------------------------

    def list_crops(self, aeroponic_only: bool = False) -> List[Crop]:
        """Return all crops, optionally filtered to aeroponic-capable ones."""
        if aeroponic_only:
            return [c for c in self._crops if c.aeroponic]
        return list(self._crops)

    def kit_crops(self) -> List[Crop]:
        """Return the crops shipped in the starter kit (``in_kit``)."""
        return [c for c in self._crops if c.in_kit]

    def get_crop(self, name_es: str) -> Crop:
        """Look up a crop by its Spanish name (case/space-insensitive)."""
        key = (name_es or "").strip().casefold()
        crop = self._by_name.get(key)
        if crop is None:
            available = ", ".join(sorted(c.name_es for c in self._crops))
            raise CropNotFoundError(
                f"Cultivo '{name_es}' no encontrado en el catálogo. "
                f"Cultivos disponibles: {available}"
            )
        return crop

    def get_profile(self, profile_name: str) -> Dict[str, Any]:
        """Return a deep copy of a named agronomic profile."""
        if profile_name not in self._profiles:
            available = ", ".join(sorted(self._profiles)) or "(ninguno)"
            raise KeyError(
                f"Perfil '{profile_name}' no encontrado. "
                f"Perfiles disponibles: {available}"
            )
        return copy.deepcopy(self._profiles[profile_name])

    def setpoints(self, name_es: str) -> Dict[str, Any]:
        """Resolve the full agronomic setpoints for a crop.

        Merges the crop's referenced ``profile`` (pH / EC / temps / humidity /
        photoperiod / nutrient recipe) into a single flat dict, and stamps the
        crop identity under the ``crop`` key. This is the payload the simulator
        / orchestrator (VRTV-95) consumes to drive its control loops.

        Raises:
            CropNotFoundError: if the crop is unknown.
            KeyError: if the crop references a profile that does not exist.
        """
        crop = self.get_crop(name_es)
        resolved = self.get_profile(crop.profile)
        resolved["crop"] = {
            "name_es": crop.name_es,
            "name_en": crop.name_en,
            "family": crop.family,
            "species": crop.species,
            "aeroponic": crop.aeroponic,
            "priority": crop.priority,
            "edible_part": crop.edible_part,
            "profile": crop.profile,
            "in_kit": crop.in_kit,
        }
        return resolved


def load_catalog(path: Optional[Union[str, os.PathLike]] = None) -> CropCatalog:
    """Load the crop catalog from ``crops.json``.

    Args:
        path: Optional explicit path to a ``crops.json``-shaped file. Defaults
            to the canonical ``apps/raspberry/config/crops.json``.

    Returns:
        A :class:`CropCatalog`.

    Raises:
        FileNotFoundError: if the file does not exist.
        CropCatalogError: if the file is not valid JSON or is malformed.
    """
    config_path = Path(path) if path is not None else _DEFAULT_CONFIG_PATH

    try:
        with open(config_path, "r", encoding="utf-8") as f:
            data = json.load(f)
    except FileNotFoundError as exc:
        raise FileNotFoundError(
            f"Catálogo de cultivos no encontrado: {config_path}"
        ) from exc
    except json.JSONDecodeError as exc:
        raise CropCatalogError(
            f"JSON inválido en el catálogo de cultivos '{config_path}': {exc}"
        ) from exc

    if not isinstance(data, dict):
        raise CropCatalogError(
            f"El catálogo de cultivos debe ser un objeto JSON: {config_path}"
        )

    profiles = data.get("profiles", {})
    raw_crops = data.get("crops", [])
    if not isinstance(raw_crops, list):
        raise CropCatalogError(
            f"El campo 'crops' debe ser una lista en {config_path}"
        )

    crops = [Crop.from_dict(c) for c in raw_crops]
    return CropCatalog(crops=crops, profiles=profiles, meta=data.get("meta"))
