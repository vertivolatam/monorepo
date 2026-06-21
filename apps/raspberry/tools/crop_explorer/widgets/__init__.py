# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""Reusable PySide6 widgets for the crop explorer (and, later, the simulator).

``InstrumentCard`` and its pure ``range_status`` helper are the SHARED visual
language between this explorer and the simulator (VRTV-95): a value coloured by
range status, a min/ideal/max gauge, and a provenance badge.
"""

from .instrument_card import InstrumentCard, range_status

__all__ = ["InstrumentCard", "range_status"]
