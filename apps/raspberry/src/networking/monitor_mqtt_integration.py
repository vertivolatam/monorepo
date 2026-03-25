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
import threading
import time
from typing import Dict, Any, Optional, List

# Import MQTT manager
from src.networking.mqtt import get_mqtt_manager

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class MonitorMQTTIntegration:
    """
    Integration class that connects monitors to MQTT.
    Automatically collects data from monitors and publishes to MQTT.
    """
    
    def __init__(self, publish_interval: int = 60):
        """
        Initialize the Monitor-MQTT Integration.
        
        Args:
            publish_interval: Interval in seconds for publishing monitor data
        """
        self.mqtt = get_mqtt_manager()
        self.publish_interval = publish_interval
        
        # Monitors
        self.environmental_monitors = {}
        self.nutrient_solution_monitors = {}
        
        # Data collection thread
        self.collection_thread = None
        self.should_collect = False

    def connect(self) -> bool:
        """
        Connect to the MQTT broker.
        
        Returns:
            bool: True if connection successful, False otherwise
        """
        return self.mqtt.connect()

    def disconnect(self) -> None:
        """Disconnect from the MQTT broker."""
        self.stop_data_collection()
        self.mqtt.disconnect()

    def register_environmental_temperature_monitor(self, monitor) -> None:
        """Register an environmental temperature monitor."""
        self.environmental_monitors["temperature"] = monitor
        logger.info("Registered environmental temperature monitor")

    def register_environmental_humidity_monitor(self, monitor) -> None:
        """Register an environmental humidity monitor."""
        self.environmental_monitors["humidity"] = monitor
        logger.info("Registered environmental humidity monitor")

    def register_environmental_co2_monitor(self, monitor) -> None:
        """Register an environmental CO2 monitor."""
        self.environmental_monitors["co2"] = monitor
        logger.info("Registered environmental CO2 monitor")

    def register_nutrient_solution_temperature_monitor(self, monitor) -> None:
        """Register a nutrient solution temperature monitor."""
        self.nutrient_solution_monitors["temperature"] = monitor
        logger.info("Registered nutrient solution temperature monitor")

    def register_nutrient_solution_ph_monitor(self, monitor) -> None:
        """Register a nutrient solution pH monitor."""
        self.nutrient_solution_monitors["ph"] = monitor
        logger.info("Registered nutrient solution pH monitor")

    def register_nutrient_solution_ec_monitor(self, monitor) -> None:
        """Register a nutrient solution EC monitor."""
        self.nutrient_solution_monitors["ec"] = monitor
        logger.info("Registered nutrient solution EC monitor")

    def register_nutrient_solution_tds_monitor(self, monitor) -> None:
        """Register a nutrient solution TDS monitor."""
        self.nutrient_solution_monitors["tds"] = monitor
        logger.info("Registered nutrient solution TDS monitor")

    def register_nutrient_solution_do_monitor(self, monitor) -> None:
        """Register a nutrient solution DO monitor."""
        self.nutrient_solution_monitors["do"] = monitor
        logger.info("Registered nutrient solution DO monitor")

    def register_nutrient_solution_orp_monitor(self, monitor) -> None:
        """Register a nutrient solution ORP monitor."""
        self.nutrient_solution_monitors["orp"] = monitor
        logger.info("Registered nutrient solution ORP monitor")

    def collect_environmental_data(self) -> None:
        """Collect data from environmental monitors and update MQTT manager."""
        try:
            # Temperature
            if "temperature" in self.environmental_monitors:
                monitor = self.environmental_monitors["temperature"]
                temperature = monitor.read_temperature()
                self.mqtt.update_environmental_temperature(temperature)
                logger.debug(f"Collected environmental temperature: {temperature}")
            
            # Humidity
            if "humidity" in self.environmental_monitors:
                monitor = self.environmental_monitors["humidity"]
                humidity = monitor.read_humidity()
                self.mqtt.update_environmental_humidity(humidity)
                logger.debug(f"Collected environmental humidity: {humidity}")
            
            # CO2
            if "co2" in self.environmental_monitors:
                monitor = self.environmental_monitors["co2"]
                co2 = monitor.read_co2()
                self.mqtt.update_environmental_co2(co2)
                logger.debug(f"Collected environmental CO2: {co2}")
        except Exception as e:
            logger.error(f"Error collecting environmental data: {e}")

    def collect_nutrient_solution_data(self) -> None:
        """Collect data from nutrient solution monitors and update MQTT manager."""
        try:
            # Temperature
            if "temperature" in self.nutrient_solution_monitors:
                monitor = self.nutrient_solution_monitors["temperature"]
                temperature = monitor.read_temperature()
                self.mqtt.update_nutrient_solution_temperature(temperature)
                logger.debug(f"Collected nutrient solution temperature: {temperature}")
            
            # pH
            if "ph" in self.nutrient_solution_monitors:
                monitor = self.nutrient_solution_monitors["ph"]
                ph = monitor.read_ph()
                self.mqtt.update_nutrient_solution_ph(ph)
                logger.debug(f"Collected nutrient solution pH: {ph}")
            
            # EC
            if "ec" in self.nutrient_solution_monitors:
                monitor = self.nutrient_solution_monitors["ec"]
                ec = monitor.read_ec()
                self.mqtt.update_nutrient_solution_ec(ec)
                logger.debug(f"Collected nutrient solution EC: {ec}")
            
            # TDS
            if "tds" in self.nutrient_solution_monitors:
                monitor = self.nutrient_solution_monitors["tds"]
                tds = monitor.read_tds()
                self.mqtt.update_nutrient_solution_tds(tds)
                logger.debug(f"Collected nutrient solution TDS: {tds}")
            
            # DO
            if "do" in self.nutrient_solution_monitors:
                monitor = self.nutrient_solution_monitors["do"]
                do = monitor.read_do()
                self.mqtt.update_nutrient_solution_do(do)
                logger.debug(f"Collected nutrient solution DO: {do}")
            
            # ORP
            if "orp" in self.nutrient_solution_monitors:
                monitor = self.nutrient_solution_monitors["orp"]
                orp = monitor.read_orp()
                self.mqtt.update_nutrient_solution_orp(orp)
                logger.debug(f"Collected nutrient solution ORP: {orp}")
        except Exception as e:
            logger.error(f"Error collecting nutrient solution data: {e}")

    def _collection_task(self) -> None:
        """Task to handle periodic data collection and publishing."""
        while self.should_collect:
            try:
                # Collect data from monitors
                self.collect_environmental_data()
                self.collect_nutrient_solution_data()
                
                # Publish all data
                self.mqtt.publish_all_monitor_data()
                
                # Sleep for the publish interval
                time.sleep(self.publish_interval)
            except Exception as e:
                logger.error(f"Error in data collection task: {e}")
        
        self.collection_thread = None

    def start_data_collection(self, interval: Optional[int] = None) -> None:
        """
        Start periodic data collection and publishing.
        
        Args:
            interval: Collection and publishing interval in seconds
        """
        if interval is not None:
            self.publish_interval = interval
        
        self.should_collect = True
        
        if not self.collection_thread:
            self.collection_thread = threading.Thread(target=self._collection_task)
            self.collection_thread.daemon = True
            self.collection_thread.start()
            logger.info(f"Started data collection with interval {self.publish_interval} seconds")

    def stop_data_collection(self) -> None:
        """Stop periodic data collection and publishing."""
        self.should_collect = False
        logger.info("Stopped data collection")

    def publish_status(self, status: str, details: Optional[Dict[str, Any]] = None) -> bool:
        """
        Publish device status.
        
        Args:
            status: Status string (e.g., "online", "offline", "error")
            details: Additional status details
            
        Returns:
            bool: True if publish was successful, False otherwise
        """
        return self.mqtt.publish_status(status, details)


# Example usage
def example_usage():
    """Example of how to use the Monitor-MQTT Integration."""
    # Import monitor classes
    from atlas_scientific.co2_monitor import CO2Monitor
    from atlas_scientific.humidity_monitor import HumidityMonitor
    from atlas_scientific.nutrient_solution_temp_monitor import NutrientSolutionTempMonitor
    from atlas_scientific.nutrient_solution_pH_monitor import NutrientSolutionPhMonitor
    from atlas_scientific.nutrient_solution_ec_monitor import NutrientSolutionECMonitor
    
    # Create integration
    integration = MonitorMQTTIntegration(publish_interval=30)
    
    # Create monitors
    co2_monitor = CO2Monitor(400, 800)
    humidity_monitor = HumidityMonitor(40, 60)
    ns_temp_monitor = NutrientSolutionTempMonitor(18, 25)
    ns_ph_monitor = NutrientSolutionPhMonitor(5.5, 6.5)
    ns_ec_monitor = NutrientSolutionECMonitor(1.5, 2.5)
    
    # Register monitors
    integration.register_environmental_co2_monitor(co2_monitor)
    integration.register_environmental_humidity_monitor(humidity_monitor)
    integration.register_nutrient_solution_temperature_monitor(ns_temp_monitor)
    integration.register_nutrient_solution_ph_monitor(ns_ph_monitor)
    integration.register_nutrient_solution_ec_monitor(ns_ec_monitor)
    
    # Connect to MQTT broker
    if integration.connect():
        # Publish online status
        integration.publish_status("online", {
            "version": "1.0.0",
            "uptime": 0
        })
        
        # Start data collection
        integration.start_data_collection()
        
        try:
            # Keep the application running
            while True:
                time.sleep(1)
        except KeyboardInterrupt:
            print("Exiting...")
        finally:
            # Publish offline status and disconnect
            integration.publish_status("offline")
            integration.disconnect()


if __name__ == "__main__":
    example_usage()