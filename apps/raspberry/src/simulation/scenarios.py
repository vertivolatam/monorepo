# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# All Rights Reserved.
#
# Pre-defined simulation scenarios. Each scenario is a dict mapping
# sensor class kwargs that override the defaults in SimulatedSensorBase.
# Use get_scenario("name") to get a scenario dict, then pass the
# per-sensor sub-dicts as **kwargs when constructing simulated sensors.

SCENARIOS = {
    # Normal day: all sensors within healthy operating ranges
    "normal": {
        "description": "Normal operating conditions with mild natural fluctuations",
        "co2":         {"mean": 600.0,  "std": 12.0,  "diurnal_amplitude": 80.0},
        "humidity":    {"mean": 60.0,   "std": 1.5,   "diurnal_amplitude": 6.0},
        "ph":          {"mean": 6.0,    "std": 0.03},
        "ec":          {"mean": 1500.0, "std": 20.0},
        "do":          {"mean": 6.5,    "std": 0.15},
        "orp":         {"mean": 400.0,  "std": 8.0},
        "tds":         {"mean": 1000.0, "std": 15.0},
        "temperature": {"mean": 21.0,   "std": 0.2,   "diurnal_amplitude": 1.0},
    },

    # Heat wave: temperature spikes, humidity drops, DO drops
    "heat_wave": {
        "description": "Simulated heat wave — high temp, low humidity, oxygen stress",
        "co2":         {"mean": 550.0,  "std": 20.0,  "diurnal_amplitude": 120.0},
        "humidity":    {"mean": 35.0,   "std": 3.0,   "diurnal_amplitude": 5.0},
        "ph":          {"mean": 6.2,    "std": 0.08},
        "ec":          {"mean": 1800.0, "std": 40.0},
        "do":          {"mean": 4.5,    "std": 0.3},
        "orp":         {"mean": 380.0,  "std": 15.0},
        "tds":         {"mean": 1200.0, "std": 30.0},
        "temperature": {"mean": 30.0,   "std": 0.5,   "diurnal_amplitude": 3.0},
    },

    # Nutrient imbalance: pH/EC drift out of range
    "nutrient_imbalance": {
        "description": "Nutrient solution degradation — pH and EC drifting out of range",
        "co2":         {"mean": 620.0,  "std": 10.0},
        "humidity":    {"mean": 58.0,   "std": 1.5},
        "ph":          {"mean": 7.2,    "std": 0.1,   "reversion_rate": 0.03},
        "ec":          {"mean": 2500.0, "std": 60.0,  "reversion_rate": 0.03},
        "do":          {"mean": 5.5,    "std": 0.2},
        "orp":         {"mean": 350.0,  "std": 12.0},
        "tds":         {"mean": 1600.0, "std": 40.0},
        "temperature": {"mean": 22.0,   "std": 0.3},
    },

    # Sensor failures: random NaN outputs simulating hardware issues
    "sensor_failure": {
        "description": "Random sensor failures — some readings return NaN",
        "co2":         {"mean": 600.0,  "std": 12.0,  "failure_probability": 0.1},
        "humidity":    {"mean": 60.0,   "std": 1.5,   "failure_probability": 0.05},
        "ph":          {"mean": 6.0,    "std": 0.03,  "failure_probability": 0.08},
        "ec":          {"mean": 1500.0, "std": 20.0,  "failure_probability": 0.08},
        "do":          {"mean": 6.5,    "std": 0.15},
        "orp":         {"mean": 400.0,  "std": 8.0},
        "tds":         {"mean": 1000.0, "std": 15.0},
        "temperature": {"mean": 21.0,   "std": 0.2,   "failure_probability": 0.05},
    },

    # Anomaly spikes: occasional extreme readings
    "anomaly_spikes": {
        "description": "Occasional extreme spikes in multiple sensors",
        "co2":         {"mean": 600.0,  "std": 12.0,  "anomaly_probability": 0.05, "anomaly_magnitude": 5.0},
        "humidity":    {"mean": 60.0,   "std": 1.5,   "anomaly_probability": 0.05, "anomaly_magnitude": 4.0},
        "ph":          {"mean": 6.0,    "std": 0.03,  "anomaly_probability": 0.03, "anomaly_magnitude": 6.0},
        "ec":          {"mean": 1500.0, "std": 20.0,  "anomaly_probability": 0.05, "anomaly_magnitude": 5.0},
        "do":          {"mean": 6.5,    "std": 0.15,  "anomaly_probability": 0.03, "anomaly_magnitude": 4.0},
        "orp":         {"mean": 400.0,  "std": 8.0,   "anomaly_probability": 0.03, "anomaly_magnitude": 4.0},
        "tds":         {"mean": 1000.0, "std": 15.0,  "anomaly_probability": 0.05, "anomaly_magnitude": 5.0},
        "temperature": {"mean": 21.0,   "std": 0.2,   "anomaly_probability": 0.05, "anomaly_magnitude": 5.0},
    },

    # Night cycle: lights off, CO2 rises, humidity rises, temp drops
    "night_cycle": {
        "description": "Night-time conditions — elevated CO2, higher humidity, lower temp",
        "co2":         {"mean": 900.0,  "std": 20.0,  "diurnal_amplitude": 0.0},
        "humidity":    {"mean": 75.0,   "std": 2.0,   "diurnal_amplitude": 0.0},
        "ph":          {"mean": 6.0,    "std": 0.03},
        "ec":          {"mean": 1500.0, "std": 20.0},
        "do":          {"mean": 6.0,    "std": 0.2},
        "orp":         {"mean": 390.0,  "std": 8.0},
        "tds":         {"mean": 1000.0, "std": 15.0},
        "temperature": {"mean": 18.0,   "std": 0.2,   "diurnal_amplitude": 0.0},
    },

    # Stress test: everything at the edge of bounds simultaneously
    "stress": {
        "description": "Stress test — all parameters near their boundary limits",
        "co2":         {"mean": 950.0,  "std": 25.0},
        "humidity":    {"mean": 78.0,   "std": 3.0},
        "ph":          {"mean": 5.6,    "std": 0.08},
        "ec":          {"mean": 1950.0, "std": 50.0},
        "do":          {"mean": 5.2,    "std": 0.25},
        "orp":         {"mean": 310.0,  "std": 12.0},
        "tds":         {"mean": 1450.0, "std": 35.0},
        "temperature": {"mean": 23.5,   "std": 0.4},
    },
}


def get_scenario(name: str) -> dict:
    """Get a scenario by name. Raises KeyError if not found."""
    if name not in SCENARIOS:
        available = ", ".join(SCENARIOS.keys())
        raise KeyError(f"Unknown scenario '{name}'. Available: {available}")
    return SCENARIOS[name]


def list_scenarios() -> list:
    """Return list of (name, description) tuples for all scenarios."""
    return [(name, s["description"]) for name, s in SCENARIOS.items()]
