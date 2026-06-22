# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""Agronomy package: crop catalog loader and setpoint resolution.

This package is the Raspberry-side ("cache JSON") consumer of the canonical
``config/crops.json`` artifact (VRTV-96). It exposes a clean API for the
simulator/orchestrator (VRTV-95) to resolve a crop's agronomic setpoints.
"""

from src.agronomy.crop_catalog import (
    Crop,
    CropCatalog,
    CropCatalogError,
    CropNotFoundError,
    load_catalog,
)

__all__ = [
    "Crop",
    "CropCatalog",
    "CropCatalogError",
    "CropNotFoundError",
    "load_catalog",
]
