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
import ssl
from typing import Dict, Any, Callable, Optional, List, Union
import threading

# Paho MQTT Client
import paho.mqtt.client as mqtt

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class PahoMQTTClient:
    """
    Client for connecting to AWS IoT Core using Paho MQTT protocol.
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
        keepalive: int = 60
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
        
        # Initialize MQTT client
        self.client = mqtt.Client(client_id=self.client_id)
        self.client.on_connect = self._on_connect
        self.client.on_disconnect = self._on_disconnect
        self.client.on_message = self._on_message
        self.client.on_publish = self._on_publish
        
        # Configure TLS/SSL
        self.client.tls_set(
            ca_certs=self.root_ca_path,
            certfile=self.cert_path,
            keyfile=self.key_path,
            cert_reqs=ssl.CERT_REQUIRED,
            tls_version=ssl.PROTOCOL_TLSv1_2
        )
        
        # Topic callbacks dictionary
        self.topic_callbacks: Dict[str, List[Callable]] = {}
        
        # Connection status
        self.connected = False
        self.reconnect_thread = None
        self.should_reconnect = False

    def _verify_cert_files(self) -> None:
        """Verify that all certificate files exist."""
        for file_path in [self.cert_path, self.key_path, self.root_ca_path]:
            if not os.path.isfile(file_path):
                raise FileNotFoundError(f"Certificate file not found: {file_path}")

    def _on_connect(self, client, userdata, flags, rc):
        """Callback for when the client connects to the broker."""
        connection_codes = {
            0: "Connection successful",
            1: "Connection refused - incorrect protocol version",
            2: "Connection refused - invalid client identifier",
            3: "Connection refused - server unavailable",
            4: "Connection refused - bad username or password",
            5: "Connection refused - not authorized"
        }
        
        if rc == 0:
            self.connected = True
            logger.info(f"Connected to AWS IoT Core: {connection_codes.get(rc, f'Unknown result code {rc}')}")
            
            # Resubscribe to topics if any
            for topic in self.topic_callbacks.keys():
                self.client.subscribe(topic)
                logger.info(f"Resubscribed to topic: {topic}")
        else:
            logger.error(f"Connection failed: {connection_codes.get(rc, f'Unknown result code {rc}')}")

    def _on_disconnect(self, client, userdata, rc):
        """Callback for when the client disconnects from the broker."""
        self.connected = False
        if rc != 0:
            logger.warning(f"Unexpected disconnection from AWS IoT Core. RC: {rc}")
            if self.should_reconnect and not self.reconnect_thread:
                self._start_reconnect_thread()
        else:
            logger.info("Disconnected from AWS IoT Core")

    def _on_message(self, client, userdata, msg):
        """Callback for when a message is received from the broker."""
        topic = msg.topic
        payload = msg.payload.decode('utf-8')
        logger.debug(f"Received message on topic '{topic}': {payload}")
        
        # Call topic-specific callbacks if registered
        if topic in self.topic_callbacks:
            for callback in self.topic_callbacks[topic]:
                try:
                    callback(topic, payload)
                except Exception as e:
                    logger.error(f"Error in message callback: {e}")

    def _on_publish(self, client, userdata, mid):
        """Callback for when a message is published."""
        logger.debug(f"Message {mid} published successfully")

    def _start_reconnect_thread(self):
        """Start a thread to handle reconnection attempts."""
        if self.reconnect_thread and self.reconnect_thread.is_alive():
            return
            
        self.reconnect_thread = threading.Thread(target=self._reconnect_task)
        self.reconnect_thread.daemon = True
        self.reconnect_thread.start()

    def _reconnect_task(self):
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

    def connect(self) -> bool:
        """
        Connect to AWS IoT Core.
        
        Returns:
            bool: True if connection successful, False otherwise
        """
        try:
            self.client.connect(self.endpoint, self.port, self.keepalive)
            self.client.loop_start()
            self.should_reconnect = True
            return True
        except Exception as e:
            logger.error(f"Failed to connect to AWS IoT Core: {e}")
            return False

    def disconnect(self) -> None:
        """Disconnect from AWS IoT Core."""
        self.should_reconnect = False
        try:
            self.client.loop_stop()
            self.client.disconnect()
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
                
            result = self.client.publish(topic, payload, qos=qos)
            if result.rc == mqtt.MQTT_ERR_SUCCESS:
                logger.debug(f"Message published to topic '{topic}'")
                return True
            else:
                logger.error(f"Failed to publish message. Error code: {result.rc}")
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
            
            # Subscribe to the topic
            result = self.client.subscribe(topic, qos)
            if result[0] == mqtt.MQTT_ERR_SUCCESS:
                logger.info(f"Subscribed to topic '{topic}' with QoS {qos}")
                return True
            else:
                logger.error(f"Failed to subscribe to topic '{topic}'. Error code: {result[0]}")
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
            if result[0] == mqtt.MQTT_ERR_SUCCESS:
                logger.info(f"Unsubscribed from topic '{topic}'")
                # Remove callbacks for this topic
                if topic in self.topic_callbacks:
                    del self.topic_callbacks[topic]
                return True
            else:
                logger.error(f"Failed to unsubscribe from topic '{topic}'. Error code: {result[0]}")
                return False
        except Exception as e:
            logger.error(f"Error unsubscribing from topic: {e}")
            return False