# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

import unittest
from src.monitors.atlas_scientific.nutrient_solution_tds_monitor import NutrientSolutionTDSMonitor

class TestNutrientSolutionTDSMonitor(unittest.TestCase):
    def setUp(self):
        self.monitor = NutrientSolutionTDSMonitor(lower_bound=0.0, upper_bound=2000.0)

    def test_initial_values(self):
        self.assertEqual(self.monitor.current_tds, 0.0)

    def test_read_tds(self):
        self.monitor.read_tds()
        self.monitor.debug_print()
        self.assertIsInstance(self.monitor.current_tds, float)

if __name__ == '__main__':
    unittest.main()
