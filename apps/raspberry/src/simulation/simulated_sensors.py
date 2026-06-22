# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# All Rights Reserved.
#
# Simulated sensors that implement the exact same read_*() interfaces as
# real Atlas Scientific EZO sensors, but generate synthetic data using
# random-walk with mean reversion (Ornstein-Uhlenbeck process).
# These are drop-in replacements: inject them into monitors via
# the input_EZO_*Sensor constructor parameter.

import math
import time
import random
import logging

logger = logging.getLogger(__name__)


class _SimulatedSensorBase:
    """Base class for all simulated sensors.

    Uses an Ornstein-Uhlenbeck process to generate realistic time-series
    data that fluctuates around a configurable mean with natural drift,
    bounded within physical limits.

    Parameters:
        mean: Target value the sensor hovers around.
        std: Standard deviation of the noise.
        min_val: Physical minimum (clamps output).
        max_val: Physical maximum (clamps output).
        reversion_rate: How quickly the value reverts to the mean (0-1).
            Higher = tighter around mean, lower = more drift.
        anomaly_probability: Chance per read of injecting an anomaly spike.
        anomaly_magnitude: Multiplier for anomaly deviation.
        failure_probability: Chance per read of simulating a sensor failure
            (returns NaN).
        diurnal_amplitude: Amplitude of a 24h sinusoidal cycle (0 to disable).
        diurnal_phase_hours: Hour of peak in the diurnal cycle.
    """

    def __init__(
        self,
        mean: float,
        std: float,
        min_val: float,
        max_val: float,
        reversion_rate: float = 0.1,
        anomaly_probability: float = 0.0,
        anomaly_magnitude: float = 3.0,
        failure_probability: float = 0.0,
        diurnal_amplitude: float = 0.0,
        diurnal_phase_hours: float = 14.0,
    ):
        self.mean = mean
        self.std = std
        self.min_val = min_val
        self.max_val = max_val
        self.reversion_rate = reversion_rate
        self.anomaly_probability = anomaly_probability
        self.anomaly_magnitude = anomaly_magnitude
        self.failure_probability = failure_probability
        self.diurnal_amplitude = diurnal_amplitude
        self.diurnal_phase_hours = diurnal_phase_hours

        # State
        self._value = mean
        self._start_time = time.time()

        # Live-control state (Phase 0)
        self._enabled = True
        # Pending one-shot anomaly offset (sensor units). 0.0 = none.
        self._pending_anomaly = 0.0

        # Calibration model (Phase 1). Factory sensors leave
        # requires_calibration False and therefore never bias. Sensors that
        # model a real probe (pH/EC/DO/ORP) set requires_calibration True in
        # their subclass; their read() is biased until calibrate() flips
        # `calibrated`. `bias` is an additive offset; `slope` is a
        # multiplicative gain error (1.0 = perfect).
        self.requires_calibration = False
        self.calibrated = False
        self.bias = 0.0
        self.slope = 1.0

    def _is_biasing(self) -> bool:
        """Whether the uncalibrated bias/slope should currently distort read()."""
        return self.requires_calibration and not self.calibrated

    def _apply_bias(self, value: float) -> float:
        """Apply uncalibrated bias+slope to a raw value (Phase 1)."""
        if not self._is_biasing():
            return value
        return value * self.slope + self.bias

    # ------------------------------------------------------------------
    # Live setters (Phase 0) — mutate the running sensor from control UI
    # ------------------------------------------------------------------
    def set_target(self, mean: float) -> None:
        """Move the target mean the sensor reverts toward (live)."""
        self.mean = mean

    def inject_anomaly(self, magnitude: float) -> None:
        """Queue a one-shot anomaly spike for the next read().

        magnitude is an absolute offset in the sensor's own units (e.g.
        +2.0 pH, -150 mV ORP), added to the next _next_value() result. This
        is the intuitive contract for a control UI (the UI sends "+50 mV"),
        and is independent of std. A spike is still clamped to the sensor's
        physical bounds.
        """
        self._pending_anomaly = magnitude

    def enable(self, on: bool) -> None:
        """Enable/disable this sensor. Disabled sensors are skipped by the
        Simulator publish loop (their monitor value is not updated)."""
        self._enabled = bool(on)

    def calibrate(self, *args, **kwargs) -> None:
        """Calibrate this sensor.

        Base behaviour (EC/DO/ORP and any single-action probe): a single
        calibrate() with no arguments flips the probe to calibrated and zeroes
        the bias/slope error. pH overrides this with a multi-point procedure.
        """
        self.calibrated = True
        self.bias = 0.0
        self.slope = 1.0

    def _diurnal_offset(self) -> float:
        """Sinusoidal offset based on time of day."""
        if self.diurnal_amplitude == 0.0:
            return 0.0
        now = time.localtime()
        hour_frac = now.tm_hour + now.tm_min / 60.0
        phase = (hour_frac - self.diurnal_phase_hours) / 24.0 * 2.0 * math.pi
        return self.diurnal_amplitude * math.sin(phase)

    def _next_value(self) -> float:
        """Generate next value using Ornstein-Uhlenbeck + optional effects."""
        # Sensor failure
        if self.failure_probability > 0 and random.random() < self.failure_probability:
            logger.debug(f"{self.__class__.__name__}: simulated sensor failure (NaN)")
            return float("nan")

        # Mean reversion (Ornstein-Uhlenbeck discrete step)
        target = self.mean + self._diurnal_offset()
        noise = random.gauss(0, self.std)
        self._value += self.reversion_rate * (target - self._value) + noise

        # One-shot injected anomaly (Phase 0, from control UI). magnitude is
        # an absolute offset in the sensor's own units.
        if self._pending_anomaly:
            self._value += self._pending_anomaly
            logger.debug(
                f"{self.__class__.__name__}: injected anomaly {self._pending_anomaly:+.2f}"
            )
            self._pending_anomaly = 0.0

        # Anomaly injection
        if self.anomaly_probability > 0 and random.random() < self.anomaly_probability:
            direction = random.choice([-1, 1])
            spike = direction * self.anomaly_magnitude * self.std
            self._value += spike
            logger.debug(f"{self.__class__.__name__}: anomaly spike {spike:+.2f}")

        # Clamp the underlying (true) state to physical bounds
        self._value = max(self.min_val, min(self.max_val, self._value))

        # Apply uncalibrated bias on the way out (does not corrupt the
        # internal mean-reversion state). No-op for calibrated/factory sensors.
        out = self._apply_bias(self._value)
        out = max(self.min_val, min(self.max_val, out))
        return round(out, 2)


class SimulatedCO2Sensor(_SimulatedSensorBase):
    """Drop-in replacement for EZO_CO2Sensor. Returns ppm."""

    def __init__(self, bus_number: int = 1, **kwargs):
        defaults = dict(mean=600.0, std=15.0, min_val=0.0, max_val=5000.0,
                        diurnal_amplitude=100.0, diurnal_phase_hours=14.0)
        defaults.update(kwargs)
        super().__init__(**defaults)

    def read_co2(self) -> float:
        return self._next_value()


class SimulatedHumiditySensor(_SimulatedSensorBase):
    """Drop-in replacement for EZO_HumiditySensor. Returns %."""

    def __init__(self, bus_number: int = 1, **kwargs):
        defaults = dict(mean=60.0, std=2.0, min_val=0.0, max_val=100.0,
                        diurnal_amplitude=8.0, diurnal_phase_hours=6.0)
        defaults.update(kwargs)
        super().__init__(**defaults)

    def read_humidity(self) -> float:
        return self._next_value()


# Ideal Nernstian slope of a pH electrode at 25 °C: 59.16 mV per pH unit.
_PH_IDEAL_SLOPE_MV = 59.16
# Standard pH buffer values for the three calibration points.
_PH_BUFFERS = {"low": 4.0, "mid": 7.0, "high": 10.0}


class SimulatedPHSensor(_SimulatedSensorBase):
    """Drop-in replacement for EZO_PHSensor.

    Models a faithful multi-point pH calibration:
      * calibrate("mid", value)  -> fixes the offset (single-point cal).
      * calibrate("low"/"high", value) together -> derives the slope % of the
        electrode (ideal 59.16 mV/pH @25°C == 100%).
      * mtc(temp) applies a manual temperature compensation to the reading.
    """

    def __init__(self, bus_number: int = 1, **kwargs):
        defaults = dict(mean=6.0, std=0.05, min_val=0.0, max_val=14.0)
        defaults.update(kwargs)
        super().__init__(**defaults)
        self.requires_calibration = True

        # Recorded calibration points: point name -> true buffer value.
        self._cal_points = {}
        # Slope as a percentage of the ideal Nernstian response (None until a
        # low/high pair is captured). 100% == perfect electrode.
        self.slope_pct = None

    def calibrate(self, point: str = None, value: float = None) -> None:
        """Faithful pH calibration.

        point ∈ {"low", "mid", "high"} maps to buffers 4.0 / 7.0 / 10.0.
        `value` is the true pH of the buffer being measured (defaults to the
        nominal buffer value). One point ("mid") sets the offset; capturing
        low+high additionally derives the slope and range.
        """
        if point is None:
            # Fall back to the simple single-action calibration.
            super().calibrate()
            return

        if point not in _PH_BUFFERS:
            logger.warning(f"pH calibrate: unknown point '{point}' (ignored)")
            return

        true_value = _PH_BUFFERS[point] if value is None else value
        self._cal_points[point] = true_value

        # Single-point ("mid") fixes the additive offset so read() == buffer.
        if point == "mid":
            self.bias = true_value - self.mean

        # Two-point (low+high) derives the slope % of the ideal electrode.
        if "low" in self._cal_points and "high" in self._cal_points:
            span = self._cal_points["high"] - self._cal_points["low"]
            ideal_span = _PH_BUFFERS["high"] - _PH_BUFFERS["low"]  # 6.0 pH
            if ideal_span:
                self.slope_pct = (span / ideal_span) * 100.0

        # The probe is considered calibrated once any point is captured.
        self.calibrated = True

    def mtc(self, temp: float) -> float:
        """Manual Temperature Compensation.

        Returns the current reading compensated for `temp` (°C). The
        electrode's mV/pH slope scales with absolute temperature (Nernst), so
        readings away from 25 °C are corrected back to the 25 °C reference.
        """
        reading = self.read_ph()
        ref_k = 273.15 + 25.0
        temp_k = 273.15 + temp
        if temp_k <= 0:
            return reading
        # Deviation from the neutral midpoint scales with T/T_ref.
        midpoint = _PH_BUFFERS["mid"]
        return round(midpoint + (reading - midpoint) * (ref_k / temp_k), 2)

    def read_ph(self) -> float:
        return self._next_value()


class SimulatedECSensor(_SimulatedSensorBase):
    """Drop-in replacement for EZO_ECSensor. Returns µS/cm."""

    def __init__(self, bus_number: int = 1, **kwargs):
        defaults = dict(mean=1500.0, std=30.0, min_val=0.0, max_val=20000.0)
        defaults.update(kwargs)
        super().__init__(**defaults)
        self.requires_calibration = True

    def read_conductivity(self) -> float:
        return self._next_value()

    # Monitor calls read_ec(), not read_conductivity()
    def read_ec(self) -> float:
        return self.read_conductivity()


class SimulatedDOSensor(_SimulatedSensorBase):
    """Drop-in replacement for EZO_DOSensor. Returns mg/L."""

    def __init__(self, bus_number: int = 1, **kwargs):
        defaults = dict(mean=6.5, std=0.2, min_val=0.0, max_val=20.0)
        defaults.update(kwargs)
        super().__init__(**defaults)
        self.requires_calibration = True

    def read_dissolved_oxygen(self) -> float:
        return self._next_value()

    # Monitor calls read_do(), not read_dissolved_oxygen()
    def read_do(self) -> float:
        return self.read_dissolved_oxygen()


class SimulatedORPSensor(_SimulatedSensorBase):
    """Drop-in replacement for EZO_ORPSensor. Returns mV."""

    def __init__(self, bus_number: int = 1, **kwargs):
        defaults = dict(mean=400.0, std=10.0, min_val=-2000.0, max_val=2000.0)
        defaults.update(kwargs)
        super().__init__(**defaults)
        self.requires_calibration = True

    def read_orp(self) -> float:
        return self._next_value()


class SimulatedTDSSensor(_SimulatedSensorBase):
    """Drop-in replacement for EZO_TDSSensor. Returns mg/L.

    TDS is derived from EC on real Atlas Scientific kits, so it has no
    calibration state of its own: it tracks the linked EC sensor's
    `calibrated` flag. Pass the EC instance as `ec_sensor` to link them; if
    none is provided the sensor behaves as factory-calibrated (never biases).
    """

    def __init__(self, bus_number: int = 1, ec_sensor=None, **kwargs):
        defaults = dict(mean=1000.0, std=20.0, min_val=0.0, max_val=10000.0)
        defaults.update(kwargs)
        super().__init__(**defaults)
        self._ec_sensor = ec_sensor
        # TDS requires calibration only when it is linked to an EC probe.
        self.requires_calibration = ec_sensor is not None

    @property
    def calibrated(self) -> bool:
        # Follow the EC sensor's calibration when linked; otherwise factory.
        if self._ec_sensor is not None:
            return self._ec_sensor.calibrated
        return self._calibrated

    @calibrated.setter
    def calibrated(self, value: bool) -> None:
        # The base __init__ sets calibrated=False; store a local fallback used
        # only when no EC sensor is linked.
        self._calibrated = value

    def calibrate(self, *args, **kwargs) -> None:
        # Delegate to the linked EC probe so TDS stays in lock-step with it.
        if self._ec_sensor is not None:
            self._ec_sensor.calibrate()
        else:
            super().calibrate()

    def read_tds(self) -> float:
        return self._next_value()


class SimulatedRTDSensor(_SimulatedSensorBase):
    """Drop-in replacement for EZO_RTD_Sensor. Returns °C."""

    def __init__(self, bus_number: int = 1, **kwargs):
        defaults = dict(mean=21.0, std=0.3, min_val=-10.0, max_val=60.0,
                        diurnal_amplitude=1.5, diurnal_phase_hours=15.0)
        defaults.update(kwargs)
        super().__init__(**defaults)

    def read_temperature(self) -> float:
        return self._next_value()
