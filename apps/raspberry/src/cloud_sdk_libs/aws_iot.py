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
import logging
from typing import Dict, Any, Callable, Optional, List, Union

# AWS IoT SDK
from AWSIoTPythonSDK.MQTTLib import AWSIoTMQTTClient

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class AWSIoTClient:
    """
    Client for connecting to AWS IoT Core using AWS IoT Python SDK.
    Handles device authentication, connection, message publishing and subscription.
    """
    
    def __init__(
        self,
        endpoint: str,
        client_id: str,
        cert_path: str,
        key_path: str,
        root_ca_path: str,
        port: int = 8883,
        keepalive: int = 600
    ):
        """
        Initialize AWS IoT client with required certificates and connection parameters.
        
        Args:
            endpoint: AWS IoT endpoint (e.g., 'xxxxxxx-ats.iot.region.amazonaws.com')
            client_id: Unique client identifier
            cert_path: Path to device certificate file
            key_path: Path to private key file
            root_ca_path: Path to root CA certificate file
            port: MQTT port (default: 8883 for secure connection)
            keepalive: Connection keepalive interval in seconds
        """
        self.endpoint = endpoint
        self.client_id = client_id
        self.cert_path = cert_path
        self.key_path = key_path
        self.root_ca_path = root_ca_path
        self.port = port
        self.keepalive = keepalive
        
        # Verify certificate files exist
        self._verify_cert_files()
        
        # Initialize AWS IoT MQTT client
        self.client = AWSIoTMQTTClient(self.client_id)
        self.client.configureEndpoint(self.endpoint, self.port)
        self.client.configureCredentials(
            self.root_ca_path,
            self.key_path,
            self.cert_path
        )
        
        # Configure connection parameters
        self.client.configureAutoReconnectBackoffTime(1, 32, 20)
        self.client.configureOfflinePublishQueueing(-1)  # Infinite offline queue
        self.client.configureDrainingFrequency(2)  # Draining: 2 Hz
        self.client.configureConnectDisconnectTimeout(10)  # 10 seconds
        self.client.configureMQTTOperationTimeout(5)  # 5 seconds
        
        # Topic callbacks dictionary
        self.topic_callbacks: Dict[str, List[Callable]] = {}
        
        # Connection status
        self.connected = False

    def _verify_cert_files(self) -> None:
        """Verify that all certificate files exist."""
        for file_path in [self.cert_path, self.key_path, self.root_ca_path]:
            if not os.path.isfile(file_path):
                raise FileNotFoundError(f"Certificate file not found: {file_path}")

    def _on_message(self, topic: str, payload: str) -> None:
        """Callback for when a message is received from the broker."""
        logger.debug(f"Received message on topic '{topic}': {payload}")
        
        # Call topic-specific callbacks if registered
        if topic in self.topic_callbacks:
            for callback in self.topic_callbacks[topic]:
                try:
                    callback(topic, payload)
                except Exception as e:
                    logger.error(f"Error in message callback: {e}")

    def connect(self) -> bool:
        """
        Connect to AWS IoT Core.
        
        Returns:
            bool: True if connection successful, False otherwise
        """
        try:
            self.connected = self.client.connect(self.keepalive)
            if self.connected:
                logger.info("Connected to AWS IoT Core successfully")
                
                # Resubscribe to topics if any
                for topic, callbacks in self.topic_callbacks.items():
                    for callback in callbacks:
                        self.client.subscribe(topic, 0, lambda client, userdata, message: 
                                             self._on_message(message.topic, message.payload.decode('utf-8')))
                        logger.info(f"Resubscribed to topic: {topic}")
            else:
                logger.error("Failed to connect to AWS IoT Core")
            
            return self.connected
        except Exception as e:
            logger.error(f"Failed to connect to AWS IoT Core: {e}")
            return False

    def disconnect(self) -> None:
        """Disconnect from AWS IoT Core."""
        try:
            self.client.disconnect()
            self.connected = False
            logger.info("Disconnected from AWS IoT Core")
        except Exception as e:
            logger.error(f"Error during disconnect: {e}")

    def publish(self, topic: str, payload: Union[Dict[str, Any], str], qos: int = 0) -> bool:
        """
        Publish a message to a topic.
        
        Args:
            topic: The topic to publish to
            payload: Message payload (dictionary will be converted to JSON)
            qos: Quality of Service level (0, 1, or 2)
            
        Returns:
            bool: True if publish was successful, False otherwise
        """
        try:
            # Convert dict to JSON string if needed
            if isinstance(payload, dict):
                payload = json.dumps(payload)
                
            result = self.client.publish(topic, payload, qos)
            if result:
                logger.debug(f"Message published to topic '{topic}'")
                return True
            else:
                logger.error("Failed to publish message")
                return False
        except Exception as e:
            logger.error(f"Error publishing message: {e}")
            return False

    def subscribe(self, topic: str, callback: Callable[[str, str], None], qos: int = 0) -> bool:
        """
        Subscribe to a topic.
        
        Args:
            topic: The topic to subscribe to
            callback: Function to call when a message is received on this topic
            qos: Quality of Service level (0, 1, or 2)
            
        Returns:
            bool: True if subscription was successful, False otherwise
        """
        try:
            # Register the callback
            if topic not in self.topic_callbacks:
                self.topic_callbacks[topic] = []
            self.topic_callbacks[topic].append(callback)
            
            # Create a callback that will call our internal callback
            def message_callback(client, userdata, message):
                self._on_message(message.topic, message.payload.decode('utf-8'))
            
            # Subscribe to the topic
            result = self.client.subscribe(topic, qos, message_callback)
            if result:
                logger.info(f"Subscribed to topic '{topic}' with QoS {qos}")
                return True
            else:
                logger.error(f"Failed to subscribe to topic '{topic}'")
                return False
        except Exception as e:
            logger.error(f"Error subscribing to topic: {e}")
            return False

    def unsubscribe(self, topic: str) -> bool:
        """
        Unsubscribe from a topic.
        
        Args:
            topic: The topic to unsubscribe from
            
        Returns:
            bool: True if unsubscription was successful, False otherwise
        """
        try:
            result = self.client.unsubscribe(topic)
            if result:
                logger.info(f"Unsubscribed from topic '{topic}'")
                # Remove callbacks for this topic
                if topic in self.topic_callbacks:
                    del self.topic_callbacks[topic]
                return True
            else:
                logger.error(f"Failed to unsubscribe from topic '{topic}'")
                return False
        except Exception as e:
            logger.error(f"Error unsubscribing from topic: {e}")
            return False


# Example usage
def example_usage():
    """Example of how to use the AWSIoTClient class."""
    # Certificate paths
    cert_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "certs")
    cert_path = os.path.join(cert_dir, "device.pem.crt")
    key_path = os.path.join(cert_dir, "private.pem.key")
    root_ca_path = os.path.join(cert_dir, "AmazonRootCA1.pem")
    
    # AWS IoT Core endpoint and client ID
    endpoint = "xxxxxxx-ats.iot.region.amazonaws.com"  # Replace with your endpoint
    client_id = "device-001"  # Replace with your client ID
    
    # Create AWS IoT client
    aws_iot = AWSIoTClient(
        endpoint=endpoint,
        client_id=client_id,
        cert_path=cert_path,
        key_path=key_path,
        root_ca_path=root_ca_path
    )
    
    # Connect to AWS IoT Core
    if aws_iot.connect():
        # Define a callback for received messages
        def on_message_received(topic, payload):
            print(f"Message received on {topic}: {payload}")
            try:
                data = json.loads(payload)
                print(f"Parsed data: {data}")
            except json.JSONDecodeError:
                print("Payload is not valid JSON")
        
        # Subscribe to a topic
        aws_iot.subscribe("device/data", on_message_received)
        
        # Publish a message
        aws_iot.publish("device/status", {"status": "online", "timestamp": time.time()})
        
        # Keep the connection alive for a while
        try:
            while True:
                # Publish sensor data every 5 seconds
                aws_iot.publish("device/data", {
                    "temperature": 25.5,
                    "humidity": 60.2,
                    "timestamp": time.time()
                })
                time.sleep(5)
        except KeyboardInterrupt:
            print("Exiting...")
        finally:
            # Disconnect when done
            aws_iot.disconnect()


if __name__ == "__main__":
    example_usage()