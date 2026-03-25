# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

from grafanalib.core import Dashboard, Row, SECONDS_FORMAT, Templating, Template
import os
import glob
import logging
from src.visualization.monitoring_plots.graphs import create_monitor_graph

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger("visualization.dashboards")

def create_monitors_dashboard(device_name=None):
    """
    Create a dashboard containing graphs for all monitors.
    
    Args:
        device_name (str, optional): Name of the device for dashboard title
        
    Returns:
        Dashboard: A Grafana dashboard object with monitor graphs
    """
    # Find all monitor files
    monitor_files = glob.glob('monitors/*.py')
    if not monitor_files:
        logger.warning("No monitor files found in 'monitors/' directory")
        # Use a fallback for development/testing
        monitor_files = ["monitors/air_quality.py", "monitors/water_quality.py"]
        logger.info(f"Using fallback monitor files: {monitor_files}")
    
    # Set dashboard title based on device name if provided
    title = "Monitors Dashboard"
    if device_name:
        title = f"{device_name} - {title}"
    
    # Create dashboard with templating for Prometheus data source
    dashboard = Dashboard(
        title=title,
        description="Dashboard for monitoring metrics from the monitors folder",
        rows=[],
        templating=Templating(
            list=[
                Template(
                    name="datasource",
                    label="Data Source",
                    type="datasource",
                    query="prometheus",
                    current="Prometheus",
                )
            ]
        ),
        refresh="10s",  # Auto-refresh every 10 seconds
        time_options=["5m", "15m", "1h", "6h", "12h", "24h", "2d", "7d"],
        timezone="browser",
    )
    
    # Add a row for each monitor
    y_pos = 0
    for monitor_file in monitor_files:
        monitor_name = os.path.basename(monitor_file).replace('.py', '')
        
        # Create a graph for this monitor using the function from graphs module
        graph = create_monitor_graph(monitor_name, y_pos)
        
        # Add the graph to a new row
        dashboard.rows.append(Row(panels=[graph]))
        y_pos += 8
    
    logger.info(f"Created dashboard with {len(monitor_files)} monitor graphs")
    return dashboard

def create_system_dashboard(device_name=None):
    """
    Create a system monitoring dashboard for Raspberry Pi.
    
    Args:
        device_name (str, optional): Name of the device for dashboard title
        
    Returns:
        Dashboard: A Grafana dashboard object with system metrics
    """
    # Set dashboard title based on device name if provided
    title = "System Monitoring"
    if device_name:
        title = f"{device_name} - {title}"
    
    # Create dashboard with system metrics
    dashboard = Dashboard(
        title=title,
        description="System metrics for Raspberry Pi monitoring",
        rows=[],
        refresh="10s",
    )
    
    # TODO: Add system monitoring panels (CPU, memory, disk, network)
    # This would be implemented in a separate module
    
    logger.info("Created system monitoring dashboard")
    return dashboard

# Example usage
if __name__ == "__main__":
    # Get device name from environment if available
    device_name = os.environ.get('BALENA_DEVICE_NAME_AT_INIT', 'Development')
    
    # Create and print dashboard
    dashboard = create_monitors_dashboard(device_name)
    print(dashboard.to_json_data())