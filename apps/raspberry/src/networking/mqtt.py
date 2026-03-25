# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

import os
import json
import time
import uuid
import socket
import logging
import threading
from typing import Dict, Any, Callable, Optional, List, Union

# Import the MQTT client factory
from src.cloud_sdk_libs.mqtt_client_factory import get_mqtt_client, load_config

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class MQTTManager:
    """
    Manager class for MQTT communication.
    Handles connection to MQTT broker, message publishing and subscription.
    """
    
    def __init__(self):
        """Initialize the MQTT Manager."""
        self.config = load_config()
        self.mqtt_config = self.config.get("mqtt_connection", {})
        self.mqtt_topics = self.config.get("mqtt_topics", {})
        
        # Generate a unique device ID if not provided
        self.device_id = self.config.get("device_id", self._generate_device_id())
        
        # MQTT client
        self.client = None
        self.connected = False
        
        # Topic callbacks
        self.topic_callbacks = {}
        
        # Background thread for automatic reconnection
        self.reconnect_thread = None
        self.should_reconnect = False
        
        # Background thread for periodic publishing
        self.publish_thread = None
        self.should_publish = False
        self.publish_interval = self.config.get("mqtt_publish_interval", 60)  # Default: 60 seconds
        
        # Monitors data cache
        self.monitors_data = {
            "environmental": {},
            "nutrient_solution": {}
        }

    def _generate_device_id(self) -> str:
        """Generate a unique device ID based on MAC address and random UUID."""
        try:
            # Get MAC address
            mac = uuid.getnode()
            # Get hostname
            hostname = socket.gethostname()
            # Generate a unique ID
            return f"{hostname}-{mac:012x}"
        except:
            # Fallback to random UUID
            return str(uuid.uuid4())

    def _get_cert_paths(self) -> Dict[str, str]:
        """Get the paths to the certificate files."""
        cert_dir = self.mqtt_config.get("cert_dir", "certs")
        
        # Make cert_dir absolute if it's relative
        if not os.path.isabs(cert_dir):
            cert_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), cert_dir)
        
        # Ensure cert directory exists
        os.makedirs(cert_dir, exist_ok=True)
        
        # Get certificate filenames
        cert_filename = self.mqtt_config.get("cert_filename", "device.pem.crt")
        key_filename = self.mqtt_config.get("key_filename", "private.pem.key")
        root_ca_filename = self.mqtt_config.get("root_ca_filename", "AmazonRootCA1.pem")
        
        # Return paths
        return {
            "cert_path": os.path.join(cert_dir, cert_filename),
            "key_path": os.path.join(cert_dir, key_filename),
            "root_ca_path": os.path.join(cert_dir, root_ca_filename)
        }

    def _format_topic(self, topic_key: str, category: Optional[str] = None, subcategory: Optional[str] = None) -> str:
        """
        Format a topic string with device ID and optional category/subcategory.
        
        Args:
            topic_key: Key of the topic
            category: Optional category (e.g., 'environmental', 'nutrient_solution')
            subcategory: Optional subcategory (e.g., 'temperature', 'humidity')
            
        Returns:
            str: Formatted topic string
        """
        if category and subcategory and category in self.mqtt_topics and subcategory in self.mqtt_topics[category]:
            topic_template = self.mqtt_topics[category][subcategory]
        elif category and category in self.mqtt_topics:
            topic_template = self.mqtt_topics[category].get(topic_key, f"device/{self.device_id}/{category}/{topic_key}")
        else:
            topic_template = self.mqtt_topics.get(topic_key, f"device/{self.device_id}/{topic_key}")
        
        return topic_template.format(device_id=self.device_id)

    def _on_message_callback(self, topic: str, payload: str) -> None:
        """Callback for when a message is received."""
        logger.debug(f"Message received on topic '{topic}': {payload}")
        
        # Call registered callbacks for this topic
        if topic in self.topic_callbacks:
            for callback in self.topic_callbacks[topic]:
                try:
                    callback(topic, payload)
                except Exception as e:
                    logger.error(f"Error in message callback: {e}")

    def _start_reconnect_thread(self) -> None:
        """Start a thread to handle reconnection attempts."""
        if self.reconnect_thread and self.reconnect_thread.is_alive():
            return
            
        self.reconnect_thread = threading.Thread(target=self._reconnect_task)
        self.reconnect_thread.daemon = True
        self.reconnect_thread.start()

    def _reconnect_task(self) -> None:
        """Task to handle reconnection attempts with exponential backoff."""
        max_delay = 120  # Maximum delay between reconnect attempts (seconds)
        delay = 1  # Initial delay
        
        while self.should_reconnect and not self.connected:
            try:
                logger.info(f"Attempting to reconnect in {delay} seconds...")
                time.sleep(delay)
                self.connect()
                
                # If connection successful, break the loop
                if self.connected:
                    break
                    
                # Exponential backoff with maximum delay
                delay = min(delay * 2, max_delay)
            except Exception as e:
                logger.error(f"Reconnection attempt failed: {e}")
        
        self.reconnect_thread = None

    def _start_publish_thread(self) -> None:
        """Start a thread to handle periodic publishing."""
        if self.publish_thread and self.publish_thread.is_alive():
            return
            
        self.publish_thread = threading.Thread(target=self._publish_task)
        self.publish_thread.daemon = True
        self.publish_thread.start()

    def _publish_task(self) -> None:
        """Task to handle periodic publishing of monitor data."""
        while self.should_publish and self.connected:
            try:
                # Publish all monitor data
                self.publish_all_monitor_data()
                
                # Sleep for the publish interval
                time.sleep(self.publish_interval)
            except Exception as e:
                logger.error(f"Error in publish task: {e}")
        
        self.publish_thread = None

    def connect(self) -> bool:
        """
        Connect to the MQTT broker.
        
        Returns:
            bool: True if connection successful, False otherwise
        """
        try:
            # Get connection parameters
            endpoint = self.mqtt_config.get("endpoint")
            port = self.mqtt_config.get("port", 8883)
            keepalive = self.mqtt_config.get("keepalive", 60)
            
            # Check if endpoint is configured
            if not endpoint:
                logger.error("MQTT endpoint not configured")
                return False
            
            # Get certificate paths
            cert_paths = self._get_cert_paths()
            
            # Generate client ID
            client_id_prefix = self.mqtt_config.get("client_id_prefix", "vertivo-device")
            client_id = f"{client_id_prefix}-{self.device_id}"
            
            # Create MQTT client using factory
            self.client = get_mqtt_client(
                endpoint=endpoint,
                client_id=client_id,
                cert_path=cert_paths["cert_path"],
                key_path=cert_paths["key_path"],
                root_ca_path=cert_paths["root_ca_path"],
                port=port,
                keepalive=keepalive
            )
            
            # Connect to broker
            self.connected = self.client.connect()
            
            if self.connected:
                logger.info(f"Connected to MQTT broker at {endpoint}")
                self.should_reconnect = True
                
                # Resubscribe to topics
                for topic in self.topic_callbacks.keys():
                    self.subscribe(topic, self._on_message_callback)
                
                # Start publish thread if enabled
                if self.should_publish:
                    self._start_publish_thread()
            else:
                logger.error(f"Failed to connect to MQTT broker at {endpoint}")
                
                # Start reconnect thread
                if self.should_reconnect:
                    self._start_reconnect_thread()
            
            return self.connected
        except Exception as e:
            logger.error(f"Error connecting to MQTT broker: {e}")
            return False

    def disconnect(self) -> None:
        """Disconnect from the MQTT broker."""
        if self.client:
            self.should_reconnect = False
            self.should_publish = False
            self.client.disconnect()
            self.connected = False
            logger.info("Disconnected from MQTT broker")

    def publish(self, topic_key: str, payload: Union[Dict[str, Any], str], qos: int = 0, 
                category: Optional[str] = None, subcategory: Optional[str] = None) -> bool:
        """
        Publish a message to a topic.
        
        Args:
            topic_key: Key of the topic to publish to (from config)
            payload: Message payload (dictionary will be converted to JSON)
            qos: Quality of Service level (0, 1, or 2)
            category: Optional category (e.g., 'environmental', 'nutrient_solution')
            subcategory: Optional subcategory (e.g., 'temperature', 'humidity')
            
        Returns:
            bool: True if publish was successful, False otherwise
        """
        if not self.client or not self.connected:
            logger.error("Not connected to MQTT broker")
            return False
        
        try:
            # Format topic
            topic = self._format_topic(topic_key, category, subcategory)
            
            # Publish message
            return self.client.publish(topic, payload, qos)
        except Exception as e:
            logger.error(f"Error publishing message: {e}")
            return False

    def subscribe(self, topic_key: str, callback: Callable[[str, str], None], qos: int = 0,
                  category: Optional[str] = None, subcategory: Optional[str] = None) -> bool:
        """
        Subscribe to a topic.
        
        Args:
            topic_key: Key of the topic to subscribe to (from config)
            callback: Function to call when a message is received on this topic
            qos: Quality of Service level (0, 1, or 2)
            category: Optional category (e.g., 'environmental', 'nutrient_solution')
            subcategory: Optional subcategory (e.g., 'temperature', 'humidity')
            
        Returns:
            bool: True if subscription was successful, False otherwise
        """
        if not self.client or not self.connected:
            logger.error("Not connected to MQTT broker")
            return False
        
        try:
            # Format topic
            topic = self._format_topic(topic_key, category, subcategory)
            
            # Register callback
            if topic not in self.topic_callbacks:
                self.topic_callbacks[topic] = []
            self.topic_callbacks[topic].append(callback)
            
            # Subscribe to topic
            return self.client.subscribe(topic, callback, qos)
        except Exception as e:
            logger.error(f"Error subscribing to topic: {e}")
            return False

    def unsubscribe(self, topic_key: str, category: Optional[str] = None, subcategory: Optional[str] = None) -> bool:
        """
        Unsubscribe from a topic.
        
        Args:
            topic_key: Key of the topic to unsubscribe from (from config)
            category: Optional category (e.g., 'environmental', 'nutrient_solution')
            subcategory: Optional subcategory (e.g., 'temperature', 'humidity')
            
        Returns:
            bool: True if unsubscription was successful, False otherwise
        """
        if not self.client or not self.connected:
            logger.error("Not connected to MQTT broker")
            return False
        
        try:
            # Format topic
            topic = self._format_topic(topic_key, category, subcategory)
            
            # Unsubscribe from topic
            result = self.client.unsubscribe(topic)
            
            # Remove callbacks
            if result and topic in self.topic_callbacks:
                del self.topic_callbacks[topic]
            
            return result
        except Exception as e:
            logger.error(f"Error unsubscribing from topic: {e}")
            return False

    def publish_telemetry(self, data: Dict[str, Any], qos: int = 0) -> bool:
        """
        Publish telemetry data.
        
        Args:
            data: Telemetry data to publish
            qos: Quality of Service level (0, 1, or 2)
            
        Returns:
            bool: True if publish was successful, False otherwise
        """
        # Add timestamp if not present
        if "timestamp" not in data:
            data["timestamp"] = time.time()
        
        return self.publish("telemetry", data, qos)

    def publish_status(self, status: str, details: Optional[Dict[str, Any]] = None, qos: int = 0) -> bool:
        """
        Publish device status.
        
        Args:
            status: Status string (e.g., "online", "offline", "error")
            details: Additional status details
            qos: Quality of Service level (0, 1, or 2)
            
        Returns:
            bool: True if publish was successful, False otherwise
        """
        payload = {
            "status": status,
            "timestamp": time.time(),
            "device_id": self.device_id
        }
        
        if details:
            payload.update(details)
        
        return self.publish("status", payload, qos)

    def subscribe_to_commands(self, callback: Callable[[str, str], None], qos: int = 0) -> bool:
        """
        Subscribe to device commands.
        
        Args:
            callback: Function to call when a command is received
            qos: Quality of Service level (0, 1, or 2)
            
        Returns:
            bool: True if subscription was successful, False otherwise
        """
        return self.subscribe("commands", callback, qos)

    # Environmental monitor methods
    def update_environmental_temperature(self, temperature: float) -> None:
        """Update environmental temperature data."""
        self.monitors_data["environmental"]["temperature"] = {
            "value": temperature,
            "timestamp": time.time()
        }

    def update_environmental_humidity(self, humidity: float) -> None:
        """Update environmental humidity data."""
        self.monitors_data["environmental"]["humidity"] = {
            "value": humidity,
            "timestamp": time.time()
        }

    def update_environmental_co2(self, co2: float) -> None:
        """Update environmental CO2 data."""
        self.monitors_data["environmental"]["co2"] = {
            "value": co2,
            "timestamp": time.time()
        }

    def update_environmental_air_quality(self, air_quality_data: Dict[str, Any]) -> None:
        """Update environmental air quality data."""
        air_quality_data["timestamp"] = time.time()
        self.monitors_data["environmental"]["air_quality"] = air_quality_data

    def update_environmental_gases(self, gases_data: Dict[str, Any]) -> None:
        """Update environmental gases data."""
        gases_data["timestamp"] = time.time()
        self.monitors_data["environmental"]["gases"] = gases_data

    def update_environmental_particulate_matter(self, pm_data: Dict[str, Any]) -> None:
        """Update environmental particulate matter data."""
        pm_data["timestamp"] = time.time()
        self.monitors_data["environmental"]["particulate_matter"] = pm_data

    # Nutrient solution monitor methods
    def update_nutrient_solution_temperature(self, temperature: float) -> None:
        """Update nutrient solution temperature data."""
        self.monitors_data["nutrient_solution"]["temperature"] = {
            "value": temperature,
            "timestamp": time.time()
        }

    def update_nutrient_solution_ph(self, ph: float) -> None:
        """Update nutrient solution pH data."""
        self.monitors_data["nutrient_solution"]["ph"] = {
            "value": ph,
            "timestamp": time.time()
        }

    def update_nutrient_solution_ec(self, ec: float) -> None:
        """Update nutrient solution EC data."""
        self.monitors_data["nutrient_solution"]["ec"] = {
            "value": ec,
            "timestamp": time.time()
        }

    def update_nutrient_solution_tds(self, tds: float) -> None:
        """Update nutrient solution TDS data."""
        self.monitors_data["nutrient_solution"]["tds"] = {
            "value": tds,
            "timestamp": time.time()
        }

    def update_nutrient_solution_do(self, do: float) -> None:
        """Update nutrient solution DO data."""
        self.monitors_data["nutrient_solution"]["do"] = {
            "value": do,
            "timestamp": time.time()
        }

    def update_nutrient_solution_orp(self, orp: float) -> None:
        """Update nutrient solution ORP data."""
        self.monitors_data["nutrient_solution"]["orp"] = {
            "value": orp,
            "timestamp": time.time()
        }

    def publish_environmental_data(self, qos: int = 0) -> bool:
        """
        Publish all environmental data.
        
        Args:
            qos: Quality of Service level (0, 1, or 2)
            
        Returns:
            bool: True if all publishes were successful, False otherwise
        """
        success = True
        
        # Publish each environmental metric
        for metric, data in self.monitors_data["environmental"].items():
            if not self.publish(metric, data, qos, category="environmental"):
                success = False
        
        return success

    def publish_nutrient_solution_data(self, qos: int = 0) -> bool:
        """
        Publish all nutrient solution data.
        
        Args:
            qos: Quality of Service level (0, 1, or 2)
            
        Returns:
            bool: True if all publishes were successful, False otherwise
        """
        success = True
        
        # Publish each nutrient solution metric
        for metric, data in self.monitors_data["nutrient_solution"].items():
            if not self.publish(metric, data, qos, category="nutrient_solution"):
                success = False
        
        return success

    def publish_all_monitor_data(self, qos: int = 0) -> bool:
        """
        Publish all monitor data.
        
        Args:
            qos: Quality of Service level (0, 1, or 2)
            
        Returns:
            bool: True if all publishes were successful, False otherwise
        """
        # Publish environmental data
        env_success = self.publish_environmental_data(qos)
        
        # Publish nutrient solution data
        ns_success = self.publish_nutrient_solution_data(qos)
        
        # Also publish a combined telemetry message with all data
        combined_data = {
            "environmental": self.monitors_data["environmental"],
            "nutrient_solution": self.monitors_data["nutrient_solution"],
            "timestamp": time.time()
        }
        telemetry_success = self.publish_telemetry(combined_data, qos)
        
        return env_success and ns_success and telemetry_success

    def start_periodic_publishing(self, interval: Optional[int] = None) -> None:
        """
        Start periodic publishing of monitor data.
        
        Args:
            interval: Publishing interval in seconds (default: from config)
        """
        if interval is not None:
            self.publish_interval = interval
        
        self.should_publish = True
        
        if self.connected and not self.publish_thread:
            self._start_publish_thread()

    def stop_periodic_publishing(self) -> None:
        """Stop periodic publishing of monitor data."""
        self.should_publish = False


# Singleton instance
_mqtt_manager = None

def get_mqtt_manager() -> MQTTManager:
    """
    Get the singleton instance of the MQTT Manager.
    
    Returns:
        MQTTManager: The MQTT Manager instance
    """
    global _mqtt_manager
    if _mqtt_manager is None:
        _mqtt_manager = MQTTManager()
    return _mqtt_manager


# Example usage with monitors
def example_usage_with_monitors():
    """Example of how to use the MQTT Manager with monitors."""
    # Get MQTT manager
    mqtt = get_mqtt_manager()
    
    # Connect to broker
    if mqtt.connect():
        # Define a callback for received commands
        def on_command_received(topic, payload):
            print(f"Command received: {payload}")
            try:
                command = json.loads(payload)
                print(f"Parsed command: {command}")
                # Process command...
            except json.JSONDecodeError:
                print("Command payload is not valid JSON")
        
        # Subscribe to commands
        mqtt.subscribe_to_commands(on_command_received)
        
        # Publish online status
        mqtt.publish_status("online", {
            "version": "1.0.0",
            "uptime": 0
        })
        
        try:
            # Start periodic publishing (every 60 seconds)
            mqtt.start_periodic_publishing()
            
            start_time = time.time()
            while True:
                # Update monitor data (this would normally come from actual sensors)
                mqtt.update_environmental_temperature(25.5)
                mqtt.update_environmental_humidity(60.2)
                mqtt.update_environmental_co2(450)
                
                mqtt.update_nutrient_solution_temperature(22.3)
                mqtt.update_nutrient_solution_ph(6.5)
                mqtt.update_nutrient_solution_ec(1.8)
                mqtt.update_nutrient_solution_tds(900)
                mqtt.update_nutrient_solution_do(8.2)
                mqtt.update_nutrient_solution_orp(350)
                
                # Sleep for a while (shorter than the publish interval)
                time.sleep(10)
        except KeyboardInterrupt:
            print("Exiting...")
        finally:
            # Stop periodic publishing
            mqtt.stop_periodic_publishing()
            
            # Publish offline status and disconnect
            mqtt.publish_status("offline")
            mqtt.disconnect()


if __name__ == "__main__":
    example_usage_with_monitors()