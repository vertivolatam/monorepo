# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# All Rights Reserved.
#
# Phase 3 — control command validation (mirrors the dispatcher contract).

import os
import sys

import pytest

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..")))

from sim_control.control_schema import ValidationError, validate_command  # noqa: E402


class TestSetTarget:
    def test_valid(self):
        out = validate_command({"sensor": "ph", "action": "set_target", "value": 6.6})
        assert out == {"sensor": "ph", "action": "set_target", "value": 6.6}

    def test_missing_value(self):
        with pytest.raises(ValidationError):
            validate_command({"sensor": "ph", "action": "set_target"})

    def test_non_numeric_value(self):
        with pytest.raises(ValidationError):
            validate_command({"sensor": "ph", "action": "set_target", "value": "high"})


class TestInjectAnomaly:
    def test_valid(self):
        out = validate_command({"sensor": "orp", "action": "inject_anomaly", "magnitude": 120.0})
        assert out["magnitude"] == 120.0


class TestEnable:
    def test_valid_off(self):
        out = validate_command({"sensor": "co2", "action": "enable", "on": False})
        assert out == {"sensor": "co2", "action": "enable", "on": False}

    def test_default_on(self):
        out = validate_command({"sensor": "co2", "action": "enable"})
        assert out["on"] is True

    def test_non_bool(self):
        with pytest.raises(ValidationError):
            validate_command({"sensor": "co2", "action": "enable", "on": "yes"})


class TestCalibrate:
    def test_ec_simple(self):
        out = validate_command({"sensor": "ec", "action": "calibrate"})
        assert out == {"sensor": "ec", "action": "calibrate"}

    def test_ph_mid(self):
        out = validate_command({"sensor": "ph", "action": "calibrate", "point": "mid", "value": 7.0})
        assert out == {"sensor": "ph", "action": "calibrate", "point": "mid", "value": 7.0}

    def test_ph_invalid_point(self):
        with pytest.raises(ValidationError):
            validate_command({"sensor": "ph", "action": "calibrate", "point": "extreme"})

    def test_point_on_non_ph_rejected(self):
        with pytest.raises(ValidationError):
            validate_command({"sensor": "ec", "action": "calibrate", "point": "mid"})


class TestGlobal:
    def test_kill_all(self):
        assert validate_command({"action": "kill_all"}) == {"action": "kill_all"}

    def test_set_interval(self):
        assert validate_command({"action": "set_interval", "seconds": 5}) == {
            "action": "set_interval",
            "seconds": 5,
        }

    def test_set_interval_invalid(self):
        with pytest.raises(ValidationError):
            validate_command({"action": "set_interval", "seconds": 0})


class TestRobustness:
    def test_missing_action(self):
        with pytest.raises(ValidationError):
            validate_command({"sensor": "ph"})

    def test_unknown_action(self):
        with pytest.raises(ValidationError):
            validate_command({"sensor": "ph", "action": "teleport"})

    def test_unknown_sensor(self):
        with pytest.raises(ValidationError):
            validate_command({"sensor": "banana", "action": "set_target", "value": 1.0})

    def test_non_dict(self):
        with pytest.raises(ValidationError):
            validate_command("not a dict")

    def test_bool_is_not_number(self):
        # bool is a subclass of int in Python — must be rejected as a value.
        with pytest.raises(ValidationError):
            validate_command({"sensor": "ph", "action": "set_target", "value": True})
