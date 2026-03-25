# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

import argparse
import json
import os
import logging
from src.visualization.dashboards import create_monitors_dashboard

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger("visualization.cli.generate_dashboards")

def get_balena_device_info():
    """
    Get balenaCloud device information from environment variables.
    
    Returns:
        dict: Device information including UUID and device URL
    """
    device_uuid = os.environ.get('BALENA_DEVICE_UUID')
    device_name = os.environ.get('BALENA_DEVICE_NAME_AT_INIT', 'unknown-device')
    
    if device_uuid:
        device_url = f"https://{device_uuid}.vertivolatam.balena-devices.com"
        logger.info(f"Detected balenaCloud device: {device_name} ({device_uuid})")
        return {
            "uuid": device_uuid,
            "name": device_name,
            "url": device_url,
            "grafana_url": f"https://grafana.{device_uuid}.vertivolatam.balena-devices.com"
        }
    else:
        logger.warning("Not running in balenaCloud environment, using local configuration")
        return {
            "uuid": None,
            "name": "local-development",
            "url": "http://localhost",
            "grafana_url": "http://localhost:3000"
        }

def main():
    """
    CLI tool to generate Grafana dashboards and save them to JSON files.
    """
    parser = argparse.ArgumentParser(description='Generate Grafana dashboards')
    parser.add_argument('--output', '-o', default='dashboards',
                        help='Output directory for dashboard JSON files')
    parser.add_argument('--balena-url', action='store_true',
                        help='Include balenaCloud device URL in dashboard configuration')
    args = parser.parse_args()
    
    # Create output directory if it doesn't exist
    os.makedirs(args.output, exist_ok=True)
    
    # Get balenaCloud device information if available
    device_info = get_balena_device_info()
    
    # Generate monitors dashboard
    monitors_dashboard = create_monitors_dashboard()
    dashboard_json = monitors_dashboard.to_json_data()
    
    # Add balenaCloud device URL to dashboard if requested
    if args.balena_url and device_info["uuid"]:
        # Add metadata about the device to the dashboard
        if "meta" not in dashboard_json:
            dashboard_json["meta"] = {}
        
        dashboard_json["meta"]["balenaDeviceUUID"] = device_info["uuid"]
        dashboard_json["meta"]["balenaDeviceName"] = device_info["name"]
        dashboard_json["meta"]["balenaDeviceURL"] = device_info["url"]
        dashboard_json["meta"]["grafanaURL"] = device_info["grafana_url"]
        
        logger.info(f"Added balenaCloud device information to dashboard")
        logger.info(f"Grafana URL: {device_info['grafana_url']}")
    
    # Save to file
    output_file = os.path.join(args.output, 'monitors_dashboard.json')
    with open(output_file, 'w') as f:
        json.dump(dashboard_json, f, indent=2)
    
    logger.info(f"Dashboard saved to {output_file}")
    
    # Generate Grafana configuration file if in balenaCloud environment
    if device_info["uuid"]:
        grafana_config = {
            "server": {
                "protocol": "https",
                "domain": "vertivolatam.balena-devices.com",
                "root_url": device_info["grafana_url"],
                "serve_from_sub_path": False
            },
            "security": {
                "admin_user": "${GRAFANA_ADMIN_USER}",
                "admin_password": "${GRAFANA_ADMIN_PASSWORD}"
            }
        }
        
        config_file = os.path.join(args.output, 'grafana.ini.json')
        with open(config_file, 'w') as f:
            json.dump(grafana_config, f, indent=2)
        
        logger.info(f"Grafana configuration saved to {config_file}")

if __name__ == "__main__":
    main()