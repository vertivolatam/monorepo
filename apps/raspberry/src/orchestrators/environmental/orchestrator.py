# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

import json
import logging
import time
import threading
from typing import Dict, Any, Optional

# Import monitors
from src.monitors.atlas_scientific.co2_monitor import CO2Monitor
from src.monitors.atlas_scientific.humidity_monitor import HumidityMonitor

# Import MQTT integration
from src.networking.monitor_mqtt_integration import MonitorMQTTIntegration

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class EnvironmentalOrchestrator:
    """
    Orchestrator for environmental monitoring systems.
    Manages environmental monitors and integrates with MQTT for cloud connectivity.
    """
    
    def __init__(self,
                co2_input_lower_bound: float,
                co2_input_upper_bound: float,
                humidity_input_lower_bound: float,
                humidity_input_upper_bound: float,
                mqtt_publish_interval: int = 60):
        """
        Initialize the orchestrator with bounds for each monitor and MQTT integration.

        Args:
            co2_input_lower_bound: Lower bound for CO2 monitor
            co2_input_upper_bound: Upper bound for CO2 monitor
            humidity_input_lower_bound: Lower bound for humidity monitor
            humidity_input_upper_bound: Upper bound for humidity monitor
            mqtt_publish_interval: Interval in seconds for publishing data to MQTT
        """
        # Initialize monitors
        self.co2_monitor = CO2Monitor(co2_input_lower_bound, co2_input_upper_bound)
        self.humidity_monitor = HumidityMonitor(humidity_input_lower_bound, humidity_input_upper_bound)
        
        # Initialize MQTT integration
        self.mqtt_integration = MonitorMQTTIntegration(publish_interval=mqtt_publish_interval)
        
        # Register monitors with MQTT integration
        self._register_monitors()
        
        # Start time for uptime calculation
        self.start_time = time.time()
        
        # Status
        self.is_running = False
        self.monitoring_thread = None

    def _register_monitors(self):
        """Register all monitors with the MQTT integration."""
        # Environmental monitors
        self.mqtt_integration.register_environmental_co2_monitor(self.co2_monitor)
        self.mqtt_integration.register_environmental_humidity_monitor(self.humidity_monitor)

    def connect_mqtt(self) -> bool:
        """
        Connect to MQTT broker.
        
        Returns:
            bool: True if connection successful, False otherwise
        """
        return self.mqtt_integration.connect()

    def disconnect_mqtt(self):
        """Disconnect from MQTT broker."""
        self.mqtt_integration.disconnect()

    def read_sensors(self):
        """Read data from all monitors."""
        # Read environmental monitors
        self.co2_monitor.read_co2()
        self.humidity_monitor.read_humidity()

    def _monitoring_task(self):
        """Background task for continuous monitoring."""
        while self.is_running:
            try:
                # Read all sensors
                self.read_sensors()
                
                # Sleep for a short interval (to avoid CPU overuse)
                time.sleep(1)
            except Exception as e:
                logger.error(f"Error in monitoring task: {e}")

    def start_monitoring(self):
        """Start continuous monitoring and MQTT publishing."""
        if not self.is_running:
            # Connect to MQTT broker
            if self.connect_mqtt():
                # Publish online status
                self.mqtt_integration.publish_status("online", {
                    "version": "1.0.0",
                    "uptime": 0,
                    "type": "environmental_monitoring"
                })
                
                # Start MQTT data collection and publishing
                self.mqtt_integration.start_data_collection()
                
                # Start monitoring thread
                self.is_running = True
                self.monitoring_thread = threading.Thread(target=self._monitoring_task)
                self.monitoring_thread.daemon = True
                self.monitoring_thread.start()
                
                logger.info("Started environmental monitoring and MQTT publishing")
                return True
            else:
                logger.error("Failed to connect to MQTT broker")
                return False
        else:
            logger.warning("Monitoring is already running")
            return True

    def stop_monitoring(self):
        """Stop continuous monitoring and MQTT publishing."""
        if self.is_running:
            # Stop monitoring thread
            self.is_running = False
            if self.monitoring_thread:
                self.monitoring_thread.join(timeout=5)
            
            # Publish offline status
            self.mqtt_integration.publish_status("offline")
            
            # Disconnect from MQTT broker
            self.disconnect_mqtt()
            
            logger.info("Stopped environmental monitoring and MQTT publishing")
        else:
            logger.warning("Monitoring is not running")

    def debug_print(self):
        """Print current monitor values for debugging."""
        print("############################################################################# \n")
        print("Valores actuales de los respectivos sensores del Orquestador de Monitoreo Ambiental:")
        print("############################################################################# \n")
        
        print("MONITORES DEL AMBIENTE:")
        print("===================")
        print(f"{'CO2:':<40} {self.co2_monitor.current_co2:.2f} ppm")
        print(f"{'Humedad:':<40} {self.humidity_monitor.current_humidity:.2f} %")

    def json_serialize_status(self):
        """
        Get the status of all monitors in JSON format.
        
        Returns:
            str: JSON string with monitor status
        """
        status = {
            'environmental': {
                'co2': self.co2_monitor.json_serialize_status(),
                'humidity': self.humidity_monitor.json_serialize_status(),
            },
            'timestamp': time.time(),
            'uptime': time.time() - self.start_time
        }

        return json.dumps(status)


# Example usage
def main():
    """Example of how to use the EnvironmentalOrchestrator."""
    # Load configuration
    import os
    import json
    
    config_path = os.path.join("config", "current", "environmental.json")
    if not os.path.exists(config_path):
        config_path = os.path.join("config", "defaults", "environmental.json")
    
    with open(config_path, 'r') as f:
        config = json.load(f)
    
    # Create orchestrator with configuration
    orchestrator = EnvironmentalOrchestrator(
        co2_input_lower_bound=config.get("co2_input_lower_bound", 400),
        co2_input_upper_bound=config.get("co2_input_upper_bound", 800),
        humidity_input_lower_bound=config.get("humidity_input_lower_bound", 40),
        humidity_input_upper_bound=config.get("humidity_input_upper_bound", 60),
        mqtt_publish_interval=config.get("mqtt_publish_interval", 60)
    )
    
    # Start monitoring
    orchestrator.start_monitoring()
    
    try:
        # Keep the application running
        while True:
            # Print debug information every 30 seconds
            orchestrator.debug_print()
            time.sleep(30)
    except KeyboardInterrupt:
        print("Exiting...")
    finally:
        # Stop monitoring
        orchestrator.stop_monitoring()


if __name__ == "__main__":
    main()