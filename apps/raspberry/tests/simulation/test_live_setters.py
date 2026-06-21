# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# All Rights Reserved.
#
# Phase 0 — live setters on simulated sensors:
# set_target(), inject_anomaly(), enable() + _enabled, and the Simulator
# publish loop skipping disabled sensors.

import sys
import os

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..")))

from src.simulation.simulated_sensors import SimulatedPHSensor


def _avg_read(sensor, n=200):
    vals = [sensor.read_ph() for _ in range(n)]
    return sum(vals) / len(vals)


class TestSetTarget:
    def test_set_target_moves_mean(self):
        sensor = SimulatedPHSensor(mean=6.0, std=0.01)
        baseline = _avg_read(sensor)
        assert abs(baseline - 6.0) < 0.2

        sensor.set_target(8.0)
        # let it settle toward the new target
        for _ in range(200):
            sensor.read_ph()
        after = _avg_read(sensor)
        assert abs(after - 8.0) < 0.3
        assert sensor.mean == 8.0


class TestInjectAnomaly:
    def test_inject_anomaly_produces_spike(self):
        sensor = SimulatedPHSensor(mean=6.0, std=0.01)
        # warm up
        for _ in range(20):
            sensor.read_ph()
        sensor.inject_anomaly(3.0)  # +3.0 pH absolute offset
        spiked = sensor.read_ph()
        # spike should push the reading far from the mean (and clamp at 14 max)
        assert abs(spiked - 6.0) > 1.0
        # the spike is one-shot: the following read reverts back toward mean
        recovered = sensor.read_ph()
        assert abs(recovered - 6.0) < abs(spiked - 6.0)

    def test_no_anomaly_without_injection(self):
        sensor = SimulatedPHSensor(mean=6.0, std=0.01)
        for _ in range(50):
            val = sensor.read_ph()
            assert abs(val - 6.0) < 1.0


class TestEnable:
    def test_enabled_default_true(self):
        sensor = SimulatedPHSensor()
        assert sensor._enabled is True

    def test_enable_toggles_flag(self):
        sensor = SimulatedPHSensor()
        sensor.enable(False)
        assert sensor._enabled is False
        sensor.enable(True)
        assert sensor._enabled is True


class TestSimulatorSkipsDisabled:
    def _make_sim(self):
        from unittest.mock import patch

        with patch("src.simulation.simulator.MonitorMQTTIntegration"):
            from src.simulation.simulator import Simulator

            return Simulator(scenario="normal")

    def test_disabled_sensor_not_read(self):
        sim = self._make_sim()
        # disable the pH sensor
        sim.sensors["ph"].enable(False)

        before = sim.ph_monitor.current_ph
        sim.read_all_sensors()
        # ph monitor value must be unchanged because the sensor was skipped
        assert sim.ph_monitor.current_ph == before

    def test_enabled_sensor_is_read(self):
        sim = self._make_sim()
        sim.read_all_sensors()
        # an enabled sensor updates its monitor away from the 0.0 default
        assert sim.ph_monitor.current_ph != 0.0
