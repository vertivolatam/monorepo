# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# All Rights Reserved.
#
# Phase 2 — control command dispatcher on the Simulator.

import sys
import os
from unittest.mock import patch, MagicMock

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..")))


def _make_sim():
    with patch("src.simulation.simulator.MonitorMQTTIntegration"):
        from src.simulation.simulator import Simulator

        return Simulator(scenario="normal", mqtt_publish_interval=30)


class TestDispatchSetTarget:
    def test_set_target(self):
        sim = _make_sim()
        sim._dispatch({"sensor": "ph", "action": "set_target", "value": 8.5})
        assert sim.sensors["ph"].mean == 8.5


class TestDispatchInjectAnomaly:
    def test_inject_anomaly(self):
        sim = _make_sim()
        sim._dispatch({"sensor": "orp", "action": "inject_anomaly", "magnitude": 120.0})
        assert sim.sensors["orp"]._pending_anomaly == 120.0


class TestDispatchEnable:
    def test_enable_off(self):
        sim = _make_sim()
        sim._dispatch({"sensor": "co2", "action": "enable", "on": False})
        assert sim.sensors["co2"]._enabled is False

    def test_enable_on(self):
        sim = _make_sim()
        sim.sensors["co2"].enable(False)
        sim._dispatch({"sensor": "co2", "action": "enable", "on": True})
        assert sim.sensors["co2"]._enabled is True


class TestDispatchKillAll:
    def test_kill_all_sets_flag(self):
        sim = _make_sim()
        sim._dispatch({"action": "kill_all"})
        assert sim._kill_all is True

    def test_kill_all_stops_publishing(self):
        sim = _make_sim()
        sim._dispatch({"action": "kill_all"})
        before = sim.ph_monitor.current_ph
        sim.read_all_sensors()
        # nothing should be read/updated while killed
        assert sim.ph_monitor.current_ph == before


class TestDispatchSetInterval:
    def test_set_interval(self):
        sim = _make_sim()
        sim._dispatch({"action": "set_interval", "seconds": 5})
        assert sim.mqtt_publish_interval == 5


class TestDispatchCalibrate:
    def test_calibrate_ec(self):
        sim = _make_sim()
        sim.sensors["ec"].bias = 200.0
        sim._dispatch({"sensor": "ec", "action": "calibrate"})
        assert sim.sensors["ec"].calibrated is True

    def test_calibrate_ph_mid(self):
        sim = _make_sim()
        sim._dispatch({"sensor": "ph", "action": "calibrate", "point": "mid", "value": 7.0})
        assert sim.sensors["ph"].calibrated is True


class TestDispatchRobustness:
    def test_unknown_sensor_noop(self):
        sim = _make_sim()
        # should not raise
        sim._dispatch({"sensor": "banana", "action": "set_target", "value": 1.0})

    def test_unknown_action_noop(self):
        sim = _make_sim()
        sim._dispatch({"sensor": "ph", "action": "teleport"})

    def test_missing_action_noop(self):
        sim = _make_sim()
        sim._dispatch({"sensor": "ph"})

    def test_non_dict_noop(self):
        sim = _make_sim()
        sim._dispatch("not a dict")
        sim._dispatch(None)
        sim._dispatch(42)


class TestControlMessageRouting:
    def test_handle_control_message_parses_json(self):
        sim = _make_sim()
        sim._handle_control_message(
            "vertivo/sim/greenhouse/1/control",
            '{"sensor": "ph", "action": "set_target", "value": 9.0}',
        )
        assert sim.sensors["ph"].mean == 9.0

    def test_handle_control_message_invalid_json_noop(self):
        sim = _make_sim()
        # malformed JSON must not raise
        sim._handle_control_message("vertivo/sim/greenhouse/1/control", "{not json")

    def test_control_topic_built_from_config(self):
        sim = _make_sim()
        topic = sim._control_topic()
        assert topic == "vertivo/sim/greenhouse/1/control"

    def test_subscribe_to_control_uses_topic_and_handler(self):
        sim = _make_sim()
        sim.mqtt_integration.mqtt = MagicMock()
        sim._subscribe_to_control()
        sim.mqtt_integration.mqtt.subscribe.assert_called_once()
        args, _ = sim.mqtt_integration.mqtt.subscribe.call_args
        assert args[0] == "vertivo/sim/greenhouse/1/control"
        assert args[1] == sim._handle_control_message
