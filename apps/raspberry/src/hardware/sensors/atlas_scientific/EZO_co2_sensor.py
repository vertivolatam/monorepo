# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

from src.hardware.sensors.atlas_scientific.AtlasScientificSensor import AtlasScientificSensor

class EZO_CO2Sensor(AtlasScientificSensor):
    """
    CO2 Sensor class for reading carbon dioxide levels.
    """

    def __init__(self, bus_number=1):
        super().__init__("CO2", bus_number)

    def read_co2(self):
        data = self.read_data()
        # Process the raw data for CO2
        return data
