# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

import unittest
from src.monitors.atlas_scientific.co2_monitor import CO2Monitor  # Ajusta la ruta según tu estructura real

class TestCO2Monitor(unittest.TestCase):
    def setUp(self):
        self.monitor = CO2Monitor(lower_bound=400, upper_bound=2000)

    def test_initial_values(self):
        self.assertEqual(self.monitor.current_co2, 0.0)

    def test_read_co2(self):
        self.monitor.read_co2()
        self.monitor.debug_print()
        self.assertIsInstance(self.monitor.current_co2, float)

if __name__ == '__main__':
    unittest.main()
