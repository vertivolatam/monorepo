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

        # Anomaly injection
        if self.anomaly_probability > 0 and random.random() < self.anomaly_probability:
            direction = random.choice([-1, 1])
            spike = direction * self.anomaly_magnitude * self.std
            self._value += spike
            logger.debug(f"{self.__class__.__name__}: anomaly spike {spike:+.2f}")

        # Clamp to physical bounds
        self._value = max(self.min_val, min(self.max_val, self._value))
        return round(self._value, 2)


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


class SimulatedPHSensor(_SimulatedSensorBase):
    """Drop-in replacement for EZO_PHSensor."""

    def __init__(self, bus_number: int = 1, **kwargs):
        defaults = dict(mean=6.0, std=0.05, min_val=0.0, max_val=14.0)
        defaults.update(kwargs)
        super().__init__(**defaults)

    def read_ph(self) -> float:
        return self._next_value()


class SimulatedECSensor(_SimulatedSensorBase):
    """Drop-in replacement for EZO_ECSensor. Returns µS/cm."""

    def __init__(self, bus_number: int = 1, **kwargs):
        defaults = dict(mean=1500.0, std=30.0, min_val=0.0, max_val=20000.0)
        defaults.update(kwargs)
        super().__init__(**defaults)

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

    def read_orp(self) -> float:
        return self._next_value()


class SimulatedTDSSensor(_SimulatedSensorBase):
    """Drop-in replacement for EZO_TDSSensor. Returns mg/L."""

    def __init__(self, bus_number: int = 1, **kwargs):
        defaults = dict(mean=1000.0, std=20.0, min_val=0.0, max_val=10000.0)
        defaults.update(kwargs)
        super().__init__(**defaults)

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
