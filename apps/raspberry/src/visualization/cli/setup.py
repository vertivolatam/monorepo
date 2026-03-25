# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

from setuptools import setup, find_packages

setup(
    name="vertivo-monitoring",
    version="0.1.0",
    packages=find_packages(),
    entry_points={
        'console_scripts': [
            'generate-dashboards=src.visualization.cli.generate_dashboards:main',
        ],
    },
    install_requires=[
        'grafanalib',
    ],
)