# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# All Rights Reserved.
#
# Simulator: injects simulated sensors into the real monitor → orchestrator
# → MQTT pipeline. Uses the existing dependency-injection pattern
# (input_EZO_*Sensor constructor params) so the entire pipeline runs
# identically to production, only the I2C layer is replaced.

import json
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
        # TDS derives from EC on real kits — link it so it follows EC's
        # calibration state (no calibration state of its own).
        sim_tds = SimulatedTDSSensor(ec_sensor=sim_ec, **scenario_data.get("tds", {}))
        sim_temp = SimulatedRTDSensor(**scenario_data.get("temperature", {}))

        # Keep references to the simulated sensors so live control commands
        # (set_target / inject_anomaly / enable / calibrate) can reach them.
        self.sensors = {
            "co2": sim_co2,
            "humidity": sim_humidity,
            "ph": sim_ph,
            "ec": sim_ec,
            "do": sim_do,
            "orp": sim_orp,
            "tds": sim_tds,
            "temperature": sim_temp,
        }

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
        # Global kill switch (Phase 2): when True the loop publishes nothing.
        self._kill_all = False

        # Control config (greenhouse_id for the control topic). Best-effort:
        # fall back to "1" if config can't be loaded.
        try:
            from src.cloud_sdk_libs.mqtt_client_factory import load_config
            self._config = load_config()
        except Exception as exc:  # pragma: no cover - defensive
            logger.warning(f"Could not load MQTT config for control topic: {exc}")
            self._config = {}

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
        """Read from all simulated sensors (via monitors).

        Sensors whose underlying simulated sensor is disabled (`_enabled`
        is False) are skipped — their monitor value is not refreshed and so
        nothing new is published for them. When the global kill switch
        (`_kill_all`) is active, no sensor is read at all.
        """
        if self._kill_all:
            return

        def _enabled(key):
            return self.sensors[key]._enabled

        if _enabled("co2"):
            self.co2_monitor.read_co2()
        if _enabled("humidity"):
            self.humidity_monitor.read_humidity()
        if _enabled("do"):
            self.do_monitor.read_do()
        if _enabled("ec"):
            self.ec_monitor.read_ec()
        if _enabled("orp"):
            self.orp_monitor.read_orp()
        if _enabled("ph"):
            self.ph_monitor.read_ph()
        if _enabled("tds"):
            self.tds_monitor.read_tds()
        if _enabled("temperature"):
            self.temp_monitor.read_temperature()

    # ------------------------------------------------------------------
    # Control plane (Phase 2): dispatcher + MQTT control subscription
    # ------------------------------------------------------------------
    def _control_topic(self) -> str:
        """Build the control topic the simulator listens on.

        Schema: vertivo/sim/greenhouse/{greenhouse_id}/control
        """
        gh = self._config.get("greenhouse_id", "1")
        return f"vertivo/sim/greenhouse/{gh}/control"

    def _dispatch(self, command) -> None:
        """Pure command dispatcher: map a control command dict to an effect.

        Expected shape: {"sensor": <name>, "action": <action>, ...}. Global
        actions (kill_all, set_interval) ignore "sensor". Unknown sensors or
        actions, or malformed commands, are logged and ignored (never raise).

        Supported actions:
          set_target     {sensor, value}
          inject_anomaly {sensor, magnitude}
          enable         {sensor, on}
          calibrate      {sensor, point?, value?}
          kill_all       {}
          set_interval   {seconds}
        """
        if not isinstance(command, dict):
            logger.warning(f"Control command is not a dict, ignored: {command!r}")
            return

        action = command.get("action")
        if not action:
            logger.warning(f"Control command missing 'action', ignored: {command!r}")
            return

        # Global actions (no sensor required).
        if action == "kill_all":
            self._kill_all = True
            logger.info("Control: kill_all — publishing halted")
            return
        if action == "set_interval":
            seconds = command.get("seconds")
            if isinstance(seconds, (int, float)) and seconds > 0:
                self.mqtt_publish_interval = seconds
                # Propagate to the live MQTT integration if it supports it.
                integration = getattr(self, "mqtt_integration", None)
                if integration is not None:
                    try:
                        integration.publish_interval = seconds
                    except Exception:  # pragma: no cover - defensive
                        pass
                logger.info(f"Control: set_interval — {seconds}s")
            else:
                logger.warning(f"Control: set_interval invalid seconds: {seconds!r}")
            return

        # Per-sensor actions.
        sensor_name = command.get("sensor")
        sensor = self.sensors.get(sensor_name)
        if sensor is None:
            logger.warning(f"Control: unknown sensor '{sensor_name}', ignored")
            return

        try:
            if action == "set_target":
                sensor.set_target(float(command["value"]))
            elif action == "inject_anomaly":
                sensor.inject_anomaly(float(command["magnitude"]))
            elif action == "enable":
                sensor.enable(bool(command.get("on", True)))
            elif action == "calibrate":
                point = command.get("point")
                value = command.get("value")
                if point is not None:
                    sensor.calibrate(point, value)
                else:
                    sensor.calibrate()
            else:
                logger.warning(f"Control: unknown action '{action}', ignored")
        except (KeyError, TypeError, ValueError) as exc:
            logger.warning(f"Control: malformed '{action}' command {command!r}: {exc}")

    def _handle_control_message(self, topic: str, payload) -> None:
        """MQTT callback: parse a JSON control payload and dispatch it.

        Invalid JSON is logged and ignored (never raises).
        """
        try:
            command = json.loads(payload)
        except (ValueError, TypeError) as exc:
            logger.warning(f"Control: invalid JSON on {topic}: {exc}")
            return
        self._dispatch(command)

    def _subscribe_to_control(self) -> None:
        """Subscribe to the control topic and route messages to the dispatcher.

        Best-effort: logs and continues if the MQTT layer can't subscribe.
        """
        topic = self._control_topic()
        try:
            self.mqtt_integration.mqtt.subscribe(topic, self._handle_control_message)
            logger.info(f"Control: subscribed to {topic}")
        except Exception as exc:  # pragma: no cover - defensive
            logger.warning(f"Control: failed to subscribe to {topic}: {exc}")

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
            self._subscribe_to_control()
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
