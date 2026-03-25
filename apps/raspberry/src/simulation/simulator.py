# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# All Rights Reserved.
#
# Simulator: injects simulated sensors into the real monitor → orchestrator
# → MQTT pipeline. Uses the existing dependency-injection pattern
# (input_EZO_*Sensor constructor params) so the entire pipeline runs
# identically to production, only the I2C layer is replaced.

import logging
import signal
import sys
import time

from src.simulation.simulated_sensors import (
    SimulatedCO2Sensor,
    SimulatedHumiditySensor,
    SimulatedPHSensor,
    SimulatedECSensor,
    SimulatedDOSensor,
    SimulatedORPSensor,
    SimulatedTDSSensor,
    SimulatedRTDSensor,
)
from src.simulation.scenarios import get_scenario, list_scenarios

# Import monitors
from src.monitors.atlas_scientific.co2_monitor import CO2Monitor
from src.monitors.atlas_scientific.humidity_monitor import HumidityMonitor
from src.monitors.atlas_scientific.nutrient_solution_do_monitor import NutrientSolutionDOMonitor
from src.monitors.atlas_scientific.nutrient_solution_ec_monitor import NutrientSolutionECMonitor
from src.monitors.atlas_scientific.nutrient_solution_orp_monitor import NutrientSolutionORPMonitor
from src.monitors.atlas_scientific.nutrient_solution_pH_monitor import NutrientSolutionPhMonitor
from src.monitors.atlas_scientific.nutrient_solution_tds_monitor import NutrientSolutionTDSMonitor
from src.monitors.atlas_scientific.nutrient_solution_temp_monitor import NutrientSolutionTempMonitor

# Import MQTT integration
from src.networking.monitor_mqtt_integration import MonitorMQTTIntegration

logger = logging.getLogger(__name__)


class Simulator:
    """Runs the full sensor → monitor → MQTT pipeline with simulated sensors.

    Usage:
        sim = Simulator(scenario="normal", mqtt_publish_interval=30)
        sim.start()   # blocks until Ctrl+C
    """

    def __init__(
        self,
        scenario: str = "normal",
        mode_config: dict = None,
        mqtt_publish_interval: int = 30,
        debug: bool = False,
    ):
        self.debug = debug
        self.scenario_name = scenario
        self.mqtt_publish_interval = mqtt_publish_interval

        # Load scenario overrides
        scenario_data = get_scenario(scenario)
        logger.info(f"Simulation scenario: {scenario} — {scenario_data['description']}")

        # Load mode config for bounds (fallback to indoor defaults)
        if mode_config is None:
            from src.config import load_mode_config
            mode_config = load_mode_config("indoor")

        # Create simulated sensors with scenario parameters
        sim_co2 = SimulatedCO2Sensor(**scenario_data.get("co2", {}))
        sim_humidity = SimulatedHumiditySensor(**scenario_data.get("humidity", {}))
        sim_ph = SimulatedPHSensor(**scenario_data.get("ph", {}))
        sim_ec = SimulatedECSensor(**scenario_data.get("ec", {}))
        sim_do = SimulatedDOSensor(**scenario_data.get("do", {}))
        sim_orp = SimulatedORPSensor(**scenario_data.get("orp", {}))
        sim_tds = SimulatedTDSSensor(**scenario_data.get("tds", {}))
        sim_temp = SimulatedRTDSensor(**scenario_data.get("temperature", {}))

        # Create monitors with simulated sensors injected
        self.co2_monitor = CO2Monitor(
            mode_config.get("co2_input_lower_bound", 400),
            mode_config.get("co2_input_upper_bound", 1000),
            input_EZO_CO2Sensor=sim_co2,
        )
        self.humidity_monitor = HumidityMonitor(
            mode_config.get("humidity_input_lower_bound", 40),
            mode_config.get("humidity_input_upper_bound", 80),
            input_EZO_HumiditySensor=sim_humidity,
        )
        self.do_monitor = NutrientSolutionDOMonitor(
            mode_config.get("nutrient_solution_do_input_lower_bound", 5),
            mode_config.get("nutrient_solution_do_input_upper_bound", 8),
            input_EZO_DOSensor=sim_do,
        )
        self.ec_monitor = NutrientSolutionECMonitor(
            mode_config.get("nutrient_solution_ec_input_lower_bound", 1000),
            mode_config.get("nutrient_solution_ec_input_upper_bound", 2000),
            input_EZO_ECSensor=sim_ec,
        )
        self.orp_monitor = NutrientSolutionORPMonitor(
            mode_config.get("nutrient_solution_orp_input_lower_bound", 300),
            mode_config.get("nutrient_solution_orp_input_upper_bound", 500),
            input_EZO_ORPSensor=sim_orp,
        )
        self.ph_monitor = NutrientSolutionPhMonitor(
            mode_config.get("nutrient_solution_ph_input_lower_bound", 5.5),
            mode_config.get("nutrient_solution_ph_input_upper_bound", 6.5),
            input_EZO_PHSensor=sim_ph,
        )
        self.tds_monitor = NutrientSolutionTDSMonitor(
            mode_config.get("nutrient_solution_tds_input_lower_bound", 500),
            mode_config.get("nutrient_solution_tds_input_upper_bound", 1500),
            input_EZO_TDSSensor=sim_tds,
        )
        self.temp_monitor = NutrientSolutionTempMonitor(
            mode_config.get("nutrient_solution_temperature_input_lower_bound", 18),
            mode_config.get("nutrient_solution_temperature_input_upper_bound", 24),
            input_EZO_RTD_Sensor=sim_temp,
        )

        # MQTT integration
        self.mqtt_integration = MonitorMQTTIntegration(
            publish_interval=mqtt_publish_interval
        )
        self._register_monitors()

        # State
        self._running = False

    def _register_monitors(self):
        """Register all monitors with MQTT integration."""
        self.mqtt_integration.register_environmental_co2_monitor(self.co2_monitor)
        self.mqtt_integration.register_environmental_humidity_monitor(self.humidity_monitor)
        self.mqtt_integration.register_nutrient_solution_temperature_monitor(self.temp_monitor)
        self.mqtt_integration.register_nutrient_solution_ph_monitor(self.ph_monitor)
        self.mqtt_integration.register_nutrient_solution_ec_monitor(self.ec_monitor)
        self.mqtt_integration.register_nutrient_solution_tds_monitor(self.tds_monitor)
        self.mqtt_integration.register_nutrient_solution_do_monitor(self.do_monitor)
        self.mqtt_integration.register_nutrient_solution_orp_monitor(self.orp_monitor)

    def read_all_sensors(self):
        """Read from all simulated sensors (via monitors)."""
        self.co2_monitor.read_co2()
        self.humidity_monitor.read_humidity()
        self.do_monitor.read_do()
        self.ec_monitor.read_ec()
        self.orp_monitor.read_orp()
        self.ph_monitor.read_ph()
        self.tds_monitor.read_tds()
        self.temp_monitor.read_temperature()

    def print_status(self):
        """Print current simulated values."""
        print(f"\n{'='*70}")
        print(f"  SIMULATION [{self.scenario_name}]  —  {time.strftime('%H:%M:%S')}")
        print(f"{'='*70}")
        print(f"  {'CO2:':<35} {self.co2_monitor.current_co2:>8.2f} ppm")
        print(f"  {'Humedad:':<35} {self.humidity_monitor.current_humidity:>8.2f} %")
        print(f"  {'Temperatura (solución):':<35} {self.temp_monitor.current_temperature:>8.2f} °C")
        print(f"  {'pH:':<35} {self.ph_monitor.current_ph:>8.2f}")
        print(f"  {'EC:':<35} {self.ec_monitor.current_ec:>8.2f} µS/cm")
        print(f"  {'TDS:':<35} {self.tds_monitor.current_tds:>8.2f} mg/L")
        print(f"  {'DO:':<35} {self.do_monitor.current_do:>8.2f} mg/L")
        print(f"  {'ORP:':<35} {self.orp_monitor.current_orp:>8.2f} mV")

        # Bounds alerts
        alerts = []
        if self.co2_monitor.is_above_upper_bound():
            alerts.append(f"  !! CO2 above upper bound ({self.co2_monitor.upper_bound})")
        if self.co2_monitor.is_below_lower_bound():
            alerts.append(f"  !! CO2 below lower bound ({self.co2_monitor.lower_bound})")
        if self.humidity_monitor.is_above_upper_bound():
            alerts.append(f"  !! Humidity above upper bound ({self.humidity_monitor.upper_bound})")
        if self.humidity_monitor.is_below_lower_bound():
            alerts.append(f"  !! Humidity below lower bound ({self.humidity_monitor.lower_bound})")
        if self.ph_monitor.is_above_upper_bound():
            alerts.append(f"  !! pH above upper bound ({self.ph_monitor.upper_bound})")
        if self.ph_monitor.is_below_lower_bound():
            alerts.append(f"  !! pH below lower bound ({self.ph_monitor.lower_bound})")

        if alerts:
            print(f"\n  ALERTS:")
            for a in alerts:
                print(a)

        print(f"{'='*70}\n")

    def start(self):
        """Start simulation loop. Connects to MQTT and publishes continuously."""
        self._running = True

        # Handle Ctrl+C gracefully
        def signal_handler(sig, frame):
            print("\nStopping simulation...")
            self._running = False

        signal.signal(signal.SIGINT, signal_handler)
        signal.signal(signal.SIGTERM, signal_handler)

        # Connect to MQTT
        mqtt_connected = self.mqtt_integration.connect()
        if mqtt_connected:
            logger.info("Connected to MQTT broker — publishing simulated data")
            self.mqtt_integration.publish_status("online", {
                "mode": "simulation",
                "scenario": self.scenario_name,
            })
            self.mqtt_integration.start_data_collection()
        else:
            logger.warning("MQTT connection failed — running in local-only mode (no publishing)")

        print(f"\nSimulation started: scenario={self.scenario_name}, "
              f"interval={self.mqtt_publish_interval}s, mqtt={'connected' if mqtt_connected else 'offline'}")
        print("Press Ctrl+C to stop.\n")

        try:
            while self._running:
                self.read_all_sensors()

                if self.debug:
                    self.print_status()

                time.sleep(1)
        finally:
            if mqtt_connected:
                self.mqtt_integration.publish_status("offline", {
                    "mode": "simulation",
                    "scenario": self.scenario_name,
                })
                self.mqtt_integration.disconnect()

            logger.info("Simulation stopped")

    def run_once(self):
        """Single read + print, useful for testing without MQTT."""
        self.read_all_sensors()
        self.print_status()
