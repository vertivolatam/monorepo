# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""Crop catalog loader and setpoint resolution (VRTV-96, v2 schema).

Loads the canonical ``config/crops.json`` artifact (107 crops, 6 agronomic
profiles) and exposes a clean API:

    >>> catalog = load_catalog()
    >>> catalog.get_crop("Albahaca").name_en
    'Basil'
    >>> catalog.setpoints("Lechuga")["ph"]["ideal"]
    6.6

In the **v2 schema** every numeric setpoint is wrapped with provenance, e.g.
``ph = {"min", "ideal", "max", "source"}`` and ``ec_dS_m = {"min", "max",
"unit", "source", "citation", "confidence"}``. ``setpoints(name_es)`` resolves
the crop's referenced ``profile`` and returns **clean** values (the provenance
wrapper unwrapped to plain numbers) so the simulator/orchestrator (VRTV-95)
receives numbers, not provenance dicts.

Crops of fruit (``profile_phases``: vegetative + reproductive) expose an
optional ``phase`` argument; ``setpoints()`` defaults to the vegetative phase.
The raw, provenance-carrying profile is still reachable via
:meth:`CropCatalog.raw_profile` / :meth:`CropCatalog.raw_setpoints`.
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

# Provenance / documentation keys attached to wrapped values in the v2 schema.
# These are stripped when producing clean setpoints.
_PROVENANCE_KEYS = frozenset(
    {
        "source",
        "_source",
        "citation",
        "confidence",
        "unit",
        "note",
        "research_note",
        "sheet_value",
    }
)

# Profile-level documentation keys (not agronomic setpoints).
_PROFILE_DOC_KEYS = frozenset({"label_es", "label_en", "applies_to_es"})


class CropCatalogError(Exception):
    """Base error for crop catalog problems."""


class CropNotFoundError(CropCatalogError, KeyError):
    """Raised when a crop cannot be found by its Spanish name.

    Subclasses :class:`KeyError` so existing ``except KeyError`` paths keep
    working, while remaining catchable as a catalog-specific error.
    """


class NoProfileError(CropCatalogError):
    """Raised when a crop has no agronomic profile (e.g. non-aeroponic crops).

    The v2 catalog ships 43 crops with ``profile: null`` — these are listed for
    completeness but carry no setpoints, so :meth:`CropCatalog.setpoints` on
    them is a programming error rather than a missing-data condition.
    """


@dataclass(frozen=True)
class Crop:
    """A single crop entry from the catalog.

    ``extra`` carries any catalog fields not promoted to first-class
    attributes (e.g. ``origin``, ``source_row``, ``sheet_setpoints``), so the
    loader does not silently drop data when the artifact evolves.
    """

    name_es: str
    name_en: Optional[str]
    family: Optional[str]
    species: Optional[str]
    aeroponic: bool
    priority: Optional[float]
    edible_part: Optional[str]
    profile: Optional[str]
    profiles: Optional[List[str]]
    profile_phases: Optional[Dict[str, str]]
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
            "profiles",
            "profile_phases",
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
            profiles=data.get("profiles"),
            profile_phases=data.get("profile_phases"),
            in_kit=bool(data.get("in_kit", False)),
            extra=extra,
        )


def _clean_value(value: Any) -> Any:
    """Recursively strip provenance from a v2 wrapped value.

    Rules:
      * ``{"value": x, "source": ...}`` → ``x`` (single-value wrapper).
      * any other dict → same dict with provenance keys removed and remaining
        values cleaned recursively (covers ``{min, ideal, max}``,
        ``{min, max}``, ``{day, night}`` and the nested nutrient recipe).
      * non-dicts → returned unchanged.
    """
    if not isinstance(value, dict):
        return value

    # Single-value wrapper: ``{"value": ..., "source": ...}``.
    if "value" in value:
        return _clean_value(value["value"])

    return {
        k: _clean_value(v)
        for k, v in value.items()
        if k not in _PROVENANCE_KEYS
    }


def _clean_profile(profile: Dict[str, Any]) -> Dict[str, Any]:
    """Produce a clean (provenance-free) copy of an agronomic profile.

    Drops profile-level documentation keys and the ``ec_sheet_raw`` placeholder
    (the anomalous literal from the spreadsheet), and unwraps every remaining
    field via :func:`_clean_value`.
    """
    cleaned: Dict[str, Any] = {}
    for key, value in profile.items():
        if key in _PROFILE_DOC_KEYS or key == "ec_sheet_raw":
            continue
        cleaned[key] = _clean_value(value)
    return cleaned


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

    # -- profile resolution ---------------------------------------------

    def _resolve_profile_name(
        self, crop: Crop, phase: Optional[str] = None
    ) -> str:
        """Resolve the profile name for ``crop`` (honouring ``phase``).

        For crops with ``profile_phases`` (fruit: vegetative + reproductive),
        ``phase`` selects the phase; it defaults to the vegetative phase (the
        crop's primary ``profile``). For all other crops ``phase`` must be
        ``None``.

        Raises:
            NoProfileError: if the crop has no profile at all.
            KeyError: if ``phase`` is given but the crop has no such phase.
        """
        if phase is not None:
            phases = crop.profile_phases or {}
            if phase not in phases:
                available = ", ".join(sorted(phases)) or "(ninguna)"
                raise KeyError(
                    f"Cultivo '{crop.name_es}' no tiene la fase '{phase}'. "
                    f"Fases disponibles: {available}"
                )
            return phases[phase]

        if not crop.profile:
            raise NoProfileError(
                f"Cultivo '{crop.name_es}' no tiene perfil agronómico "
                f"(profile=null); no expone setpoints."
            )
        return crop.profile

    def get_profile(self, profile_name: str) -> Dict[str, Any]:
        """Return a deep copy of a named **raw** agronomic profile."""
        if profile_name not in self._profiles:
            available = ", ".join(sorted(self._profiles)) or "(ninguno)"
            raise KeyError(
                f"Perfil '{profile_name}' no encontrado. "
                f"Perfiles disponibles: {available}"
            )
        return copy.deepcopy(self._profiles[profile_name])

    def raw_profile(
        self, name_es: str, phase: Optional[str] = None
    ) -> Dict[str, Any]:
        """Return the crop's **raw** profile, provenance preserved.

        Use this when you need the citations / confidence / sheet-vs-researched
        provenance. :meth:`setpoints` returns the clean (number-only) view.
        """
        crop = self.get_crop(name_es)
        profile_name = self._resolve_profile_name(crop, phase)
        return self.get_profile(profile_name)

    # -- clean setpoints -------------------------------------------------

    def _crop_identity(self, crop: Crop, profile_name: str) -> Dict[str, Any]:
        return {
            "name_es": crop.name_es,
            "name_en": crop.name_en,
            "family": crop.family,
            "species": crop.species,
            "aeroponic": crop.aeroponic,
            "priority": crop.priority,
            "edible_part": crop.edible_part,
            "profile": profile_name,
            "in_kit": crop.in_kit,
        }

    def setpoints(
        self, name_es: str, phase: Optional[str] = None
    ) -> Dict[str, Any]:
        """Resolve the **clean** agronomic setpoints for a crop.

        Resolves the crop's referenced ``profile`` and unwraps the v2
        provenance wrappers so every field is a plain number / nested
        number-dict — the payload the simulator/orchestrator (VRTV-95)
        consumes. The returned dict carries no provenance keys (``source``,
        ``citation``, ``confidence``, ``unit``, ...).

        Resolved shape (per profile availability)::

            {
              "ph": {"min": float, "ideal": float, "max": float},
              "ec_dS_m": {"min": float, "max": float},
              "photoperiod_h": int,
              "ppfd_umol_m2_s": {"min": float, "max": float},
              "ambient_temp_c": {"day": {"min", "max"}, "night": {...}},
              "relative_humidity_pct": {"day": {...}, "night": {...}},
              "orp_mv": {"min": float, "max": float},
              "nutrient_recipe_g_per_1000ml": {...},
              ...,
              "crop": { name_es, name_en, family, species, aeroponic,
                        priority, edible_part, profile, in_kit },
            }

        Args:
            name_es: Spanish crop name (case/space-insensitive).
            phase: For fruit crops with ``profile_phases``, the phase to
                resolve (``"vegetative"`` / ``"reproductive"``). Defaults to the
                crop's primary (vegetative) profile.

        Raises:
            CropNotFoundError: if the crop is unknown.
            NoProfileError: if the crop has no agronomic profile.
            KeyError: if ``phase`` is given but unknown, or the resolved
                profile name does not exist.
        """
        crop = self.get_crop(name_es)
        profile_name = self._resolve_profile_name(crop, phase)
        resolved = _clean_profile(self.get_profile(profile_name))
        resolved["crop"] = self._crop_identity(crop, profile_name)
        return resolved

    def raw_setpoints(
        self, name_es: str, phase: Optional[str] = None
    ) -> Dict[str, Any]:
        """Like :meth:`setpoints` but with the **raw** provenance preserved."""
        crop = self.get_crop(name_es)
        profile_name = self._resolve_profile_name(crop, phase)
        resolved = self.get_profile(profile_name)
        resolved["crop"] = self._crop_identity(crop, profile_name)
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
