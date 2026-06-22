# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

"""Phase 1 — InstrumentCard + range_status.

``range_status`` is a pure function (same in/warn/alert semantics as the pH
status slice). The card is smoke-tested headless (offscreen Qt, no exec()).
"""

import pytest

from widgets.instrument_card import InstrumentCard, range_status


# --- range_status (pure) ----------------------------------------------------
class TestRangeStatus:
    def test_in_range_is_ok(self):
        assert range_status(6.5, lo=6.0, hi=7.0) == "ok"

    def test_outside_low_is_alert(self):
        assert range_status(5.0, lo=6.0, hi=7.0) == "alert"

    def test_outside_high_is_alert(self):
        assert range_status(8.0, lo=6.0, hi=7.0) == "alert"

    def test_near_low_border_is_warn(self):
        # 6.05 sits inside the warn band just above the low bound.
        assert range_status(6.05, lo=6.0, hi=7.0, warn_band=0.1) == "warn"

    def test_near_high_border_is_warn(self):
        assert range_status(6.95, lo=6.0, hi=7.0, warn_band=0.1) == "warn"

    def test_exact_bound_is_warn(self):
        assert range_status(6.0, lo=6.0, hi=7.0) == "warn"
        assert range_status(7.0, lo=6.0, hi=7.0) == "warn"

    def test_center_is_ok_even_with_warn_band(self):
        assert range_status(6.5, lo=6.0, hi=7.0, warn_band=0.1) == "ok"

    def test_no_range_is_na(self):
        assert range_status(6.5, lo=None, hi=None) == "n/a"
        assert range_status(6.5, lo=6.0, hi=None) == "n/a"

    def test_no_value_is_na(self):
        assert range_status(None, lo=6.0, hi=7.0) == "n/a"

    def test_single_point_range_uses_ideal_tolerance(self):
        # lo == hi: only the exact value is ok; nearby is warn, far is alert.
        assert range_status(7.0, lo=7.0, hi=7.0) == "ok"

    def test_ideal_does_not_break_ok(self):
        assert range_status(6.4, lo=6.0, hi=7.0, ideal=6.5) == "ok"


# --- InstrumentCard (smoke, headless) ---------------------------------------
@pytest.fixture(scope="module")
def qapp():
    from PySide6.QtWidgets import QApplication

    app = QApplication.instance() or QApplication([])
    yield app


def test_card_builds_in_range(qapp):
    card = InstrumentCard(
        label="pH", value=6.5, unit="", lo=6.0, hi=7.0, ideal=6.5,
        source="sheet", confidence="high", citation="Purdue HO-309-W",
    )
    assert card.status == "ok"
    assert "6.5" in card.value_text()
    assert card.badge_text().startswith("🟦")


def test_card_builds_out_of_range(qapp):
    card = InstrumentCard(label="EC", value=20.0, unit="dS/m", lo=1.0, hi=2.0)
    assert card.status == "alert"


def test_card_no_range_is_na(qapp):
    card = InstrumentCard(label="Espectro", value=None, unit="", lo=None, hi=None)
    assert card.status == "n/a"


def test_card_researched_badge(qapp):
    card = InstrumentCard(
        label="ORP", value=350, unit="mV", lo=300, hi=400, source="researched",
    )
    assert card.badge_text().startswith("🟨")
