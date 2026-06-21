# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# All Rights Reserved.
#
# Phase 1 — calibration model for the isolated EZO sensors (pH, EC, DO, ORP).
# Factory sensors (HUM, CO2, RTD) never bias. TDS follows EC's calibration.

import sys
import os

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..")))

from src.simulation.simulated_sensors import (
    SimulatedPHSensor,
    SimulatedECSensor,
    SimulatedDOSensor,
    SimulatedORPSensor,
    SimulatedTDSSensor,
    SimulatedCO2Sensor,
    SimulatedHumiditySensor,
    SimulatedRTDSensor,
)


def _avg(read_fn, n=300):
    return sum(read_fn() for _ in range(n)) / n


class TestRequiresCalibrationFlags:
    def test_ezo_sensors_require_calibration(self):
        for cls in (SimulatedPHSensor, SimulatedECSensor,
                    SimulatedDOSensor, SimulatedORPSensor):
            s = cls()
            assert s.requires_calibration is True, cls.__name__
            assert s.calibrated is False, cls.__name__

    def test_factory_sensors_never_require_calibration(self):
        for cls in (SimulatedCO2Sensor, SimulatedHumiditySensor, SimulatedRTDSensor):
            s = cls()
            assert s.requires_calibration is False, cls.__name__


class TestFactorySensorsNeverBias:
    def test_factory_sensor_unbiased_even_with_bias_set(self):
        s = SimulatedHumiditySensor(mean=60.0, std=0.01, diurnal_amplitude=0.0)
        # even if someone forces a bias, a factory sensor must ignore it
        s.bias = 100.0
        val = _avg(s.read_humidity)
        assert abs(val - 60.0) < 1.0


class TestEZOBiasUntilCalibrated:
    def test_ec_biased_before_calibration(self):
        s = SimulatedECSensor(mean=1500.0, std=1.0)
        s.bias = 200.0  # uncalibrated drift
        biased = _avg(s.read_ec)
        assert biased > 1600.0  # bias is applied

    def test_ec_calibrate_removes_bias(self):
        s = SimulatedECSensor(mean=1500.0, std=1.0)
        s.bias = 200.0
        s.calibrate()
        assert s.calibrated is True
        assert s.bias == 0.0
        after = _avg(s.read_ec)
        assert abs(after - 1500.0) < 5.0

    def test_do_calibrate_no_args(self):
        s = SimulatedDOSensor(mean=6.5, std=0.01)
        s.bias = 2.0
        s.calibrate()
        assert s.calibrated is True
        assert abs(_avg(s.read_do) - 6.5) < 0.2

    def test_orp_calibrate_no_args(self):
        s = SimulatedORPSensor(mean=400.0, std=1.0)
        s.bias = 50.0
        s.calibrate()
        assert s.calibrated is True
        assert abs(_avg(s.read_orp) - 400.0) < 5.0


class TestPHCalibration:
    def test_ph_mid_sets_offset(self):
        s = SimulatedPHSensor(mean=7.0, std=0.001)
        s.bias = 1.0  # raw reads ~8.0
        # calibrate the mid point: tell it the true value is 7.0
        s.calibrate("mid", 7.0)
        assert abs(_avg(s.read_ph) - 7.0) < 0.1

    def test_ph_low_high_sets_slope(self):
        s = SimulatedPHSensor()
        s.calibrate("mid", 7.0)
        s.calibrate("low", 4.0)
        s.calibrate("high", 10.0)
        # a full 3-point calibration marks the probe calibrated with a slope %
        assert s.calibrated is True
        assert s.slope_pct is not None
        # slope should be a sane percentage (around 100% for an ideal probe)
        assert 0.0 < s.slope_pct <= 200.0

    def test_ph_single_point_offset_only(self):
        s = SimulatedPHSensor()
        s.calibrate("mid", 7.0)
        # one point gives an offset but not yet a full slope
        assert s.calibrated is True

    def test_ph_mtc_adjusts_reading(self):
        # mean offset from the 7.0 neutral midpoint so MTC has something to act on
        s = SimulatedPHSensor(mean=5.0, std=0.0)
        s.calibrate("mid", 5.0)  # offset cal, reading hovers near 5.0
        base = s.mtc(25.0)
        hot = s.mtc(35.0)
        # temperature compensation should change the compensated reading
        assert base != hot


class TestTDSFollowsEC:
    def test_tds_follows_ec_calibration(self):
        ec = SimulatedECSensor(mean=1500.0, std=1.0)
        tds = SimulatedTDSSensor(mean=1000.0, std=1.0, ec_sensor=ec)
        # before EC is calibrated, TDS is considered uncalibrated too
        assert tds.calibrated is False
        ec.calibrate()
        assert tds.calibrated is True

    def test_tds_biases_with_ec_uncalibrated(self):
        ec = SimulatedECSensor(mean=1500.0, std=1.0)
        tds = SimulatedTDSSensor(mean=1000.0, std=1.0, ec_sensor=ec)
        tds.bias = 100.0
        biased = _avg(tds.read_tds)
        assert biased > 1050.0
        ec.calibrate()
        # once EC is calibrated, TDS no longer biases
        tds.bias = 100.0
        assert abs(_avg(tds.read_tds) - 1000.0) < 5.0
