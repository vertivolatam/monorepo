# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

import logging
from grafanalib.core import (
    Graph, Target, GridPos, YAxes, YAxis, 
    MILLISECONDS_FORMAT, SHORT_FORMAT, PERCENT_FORMAT,
    Tooltip, Legend, Templating, Template
)

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger("visualization.monitoring_plots.graphs")

def create_monitor_graph(monitor_name, y_position=0):
    """
    Create a Grafana graph for a specific monitor.
    
    Args:
        monitor_name (str): Name of the monitor
        y_position (int): Y position in the dashboard grid
        
    Returns:
        Graph: A Grafana graph object configured for the monitor
    """
    # Determine appropriate format based on monitor type
    format_type = MILLISECONDS_FORMAT
    if monitor_name in ['cpu', 'memory', 'disk']:
        format_type = PERCENT_FORMAT
    elif monitor_name in ['temperature', 'humidity']:
        format_type = SHORT_FORMAT
    
    # Create appropriate targets based on monitor name
    targets = []
    
    if monitor_name == 'air_quality':
        metrics = ['pm25', 'pm10', 'co2', 'voc']
        for metric in metrics:
            targets.append(
                Target(
                    expr=f'monitor_{monitor_name}_{metric}',
                    legendFormat=f"{metric}",
                    refId=metric.upper(),
                )
            )
    elif monitor_name == 'water_quality':
        metrics = ['ph', 'dissolved_oxygen', 'conductivity']
        for metric in metrics:
            targets.append(
                Target(
                    expr=f'monitor_{monitor_name}_{metric}',
                    legendFormat=f"{metric}",
                    refId=metric.upper(),
                )
            )
    else:
        # Default target for other monitor types
        targets.append(
            Target(
                expr=f'monitor_{monitor_name}_metric',
                legendFormat="{{instance}}",
                refId='A',
            )
        )
    
    logger.debug(f"Created graph for monitor: {monitor_name} with {len(targets)} targets")
    
    return Graph(
        title=f"{monitor_name.replace('_', ' ').title()} Metrics",
        dataSource="${datasource}",  # Use template variable for data source
        targets=targets,
        gridPos=GridPos(h=8, w=24, x=0, y=y_position),
        yAxes=YAxes(
            left=YAxis(format=format_type),
            right=YAxis(format=SHORT_FORMAT),
        ),
        tooltip=Tooltip(
            shared=True,
            value_type="individual"
        ),
        legend=Legend(
            show=True,
            values=True,
            min=True,
            max=True,
            current=True,
            alignAsTable=True
        ),
        transparent=False,
        editable=True,
    )

def create_system_graph(metric_type, y_position=0):
    """
    Create a Grafana graph for system metrics.
    
    Args:
        metric_type (str): Type of system metric (cpu, memory, disk, network)
        y_position (int): Y position in the dashboard grid
        
    Returns:
        Graph: A Grafana graph object configured for the system metric
    """
    # Configure based on metric type
    if metric_type == 'cpu':
        title = "CPU Usage"
        expr = 'node_cpu_seconds_total{mode="user"} / node_cpu_seconds_total * 100'
        format_type = PERCENT_FORMAT
    elif metric_type == 'memory':
        title = "Memory Usage"
        expr = '(node_memory_MemTotal_bytes - node_memory_MemFree_bytes) / node_memory_MemTotal_bytes * 100'
        format_type = PERCENT_FORMAT
    elif metric_type == 'disk':
        title = "Disk Usage"
        expr = 'node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"} * 100'
        format_type = PERCENT_FORMAT
    elif metric_type == 'network':
        title = "Network Traffic"
        expr = 'rate(node_network_receive_bytes_total[5m])'
        format_type = SHORT_FORMAT
    else:
        title = f"{metric_type.replace('_', ' ').title()} Metric"
        expr = f'node_{metric_type}'
        format_type = SHORT_FORMAT
    
    return Graph(
        title=title,
        dataSource="${datasource}",  # Use template variable for data source
        targets=[
            Target(
                expr=expr,
                legendFormat="{{instance}}",
                refId='A',
            ),
        ],
        gridPos=GridPos(h=8, w=24, x=0, y=y_position),
        yAxes=YAxes(
            left=YAxis(format=format_type),
            right=YAxis(format=SHORT_FORMAT),
        ),
        tooltip=Tooltip(
            shared=True,
            value_type="individual"
        ),
        legend=Legend(
            show=True,
            values=True,
            min=True,
            max=True,
            current=True
        ),
    )