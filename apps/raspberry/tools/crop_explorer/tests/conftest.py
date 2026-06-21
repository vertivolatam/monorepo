# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""Pytest fixtures for the crop_explorer tool tests.

Adds the tool directory to ``sys.path`` so ``build_db``, ``db`` and ``widgets``
import as top-level modules (mirrors how crop_explorer.py runs them), and forces
the Qt offscreen platform so widget smoke tests run headless in CI.
"""

import os
import sys
from pathlib import Path

import pytest

TOOL_DIR = Path(__file__).resolve().parent.parent
if str(TOOL_DIR) not in sys.path:
    sys.path.insert(0, str(TOOL_DIR))

# Headless Qt for widget smoke tests.
os.environ.setdefault("QT_QPA_PLATFORM", "offscreen")

CONFIG_DIR = TOOL_DIR.parent.parent / "config"


@pytest.fixture(scope="session")
def crops_json() -> Path:
    return CONFIG_DIR / "crops.json"


@pytest.fixture(scope="session")
def source_xlsx() -> Path:
    return CONFIG_DIR / "modelo-fitotecnico.xlsx"


@pytest.fixture
def temp_db(tmp_path, crops_json, source_xlsx) -> Path:
    """A freshly seeded crops.db in a temp dir (never touches the real one)."""
    import build_db

    db_path = tmp_path / "crops.db"
    build_db.build(crops_json, source_xlsx, db_path, reseed=True)
    return db_path
