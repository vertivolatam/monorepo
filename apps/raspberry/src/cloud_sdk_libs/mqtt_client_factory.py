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
import logging
from typing import Dict, Any, Union

# Import client implementations (AWS SDK is optional)
try:
    from src.cloud_sdk_libs.aws_iot import AWSIoTClient
except ImportError:
    AWSIoTClient = None
from src.cloud_sdk_libs.paho_mqtt_client import PahoMQTTClient

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Client types
CLIENT_TYPE_AWS_SDK = "aws_sdk"
CLIENT_TYPE_PAHO = "paho"

def load_config() -> Dict[str, Any]:
    """
    Load configuration from environmental.json files.
    Prioritizes config/current over config/defaults.
    
    Returns:
        Dict containing the merged configuration
    """
    config = {}
    
    # Default config path
    default_config_path = os.path.join("config", "defaults", "environmental.json")
    
    # Current config path (overrides defaults)
    current_config_path = os.path.join("config", "current", "environmental.json")
    
    # Load default config if exists
    if os.path.exists(default_config_path):
        try:
            with open(default_config_path, 'r') as f:
                config.update(json.load(f))
        except Exception as e:
            logger.error(f"Error loading default config: {e}")
    
    # Load current config if exists (overrides defaults)
    if os.path.exists(current_config_path):
        try:
            with open(current_config_path, 'r') as f:
                config.update(json.load(f))
        except Exception as e:
            logger.error(f"Error loading current config: {e}")

    # Load MQTT-specific config if exists (mqtt_dev.json)
    mqtt_config_path = os.path.join("config", "current", "mqtt_dev.json")
    if os.path.exists(mqtt_config_path):
        try:
            with open(mqtt_config_path, 'r') as f:
                config.update(json.load(f))
        except Exception as e:
            logger.error(f"Error loading MQTT config: {e}")

    return config

def get_mqtt_client(
    endpoint: str,
    client_id: str,
    cert_path: str,
    key_path: str,
    root_ca_path: str,
    port: int = 8883,
    keepalive: int = 60
) -> Union[AWSIoTClient, PahoMQTTClient]:
    """
    Factory function to create the appropriate MQTT client based on configuration.
    
    Args:
        endpoint: AWS IoT endpoint
        client_id: Unique client identifier
        cert_path: Path to device certificate file
        key_path: Path to private key file
        root_ca_path: Path to root CA certificate file
        port: MQTT port (default: 8883)
        keepalive: Connection keepalive interval in seconds
        
    Returns:
        An instance of either AWSIoTClient or PahoMQTTClient
    """
    # Load configuration
    config = load_config()
    
    # Get client type from config, default to AWS SDK if not specified
    client_type = config.get("mqtt_client_type", CLIENT_TYPE_AWS_SDK)
    
    if client_type == CLIENT_TYPE_PAHO:
        logger.info("Using Paho MQTT client")
        return PahoMQTTClient(
            endpoint=endpoint,
            client_id=client_id,
            cert_path=cert_path,
            key_path=key_path,
            root_ca_path=root_ca_path,
            port=port,
            keepalive=keepalive
        )
    else:
        if AWSIoTClient is None:
            raise ImportError(
                "AWSIoTPythonSDK is not installed. Install it or set mqtt_client_type to 'paho' in config."
            )
        logger.info("Using AWS IoT SDK client")
        return AWSIoTClient(
            endpoint=endpoint,
            client_id=client_id,
            cert_path=cert_path,
            key_path=key_path,
            root_ca_path=root_ca_path,
            port=port,
            keepalive=keepalive
        )