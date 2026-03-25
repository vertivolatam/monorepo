# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

import unittest
from src.monitors.atlas_scientific.nutrient_solution_pH_monitor import NutrientSolutionPHMonitor

class TestNutrientSolutionPHMonitor(unittest.TestCase):
    def setUp(self):
        self.monitor = NutrientSolutionPHMonitor(lower_bound=5.5, upper_bound=7.5)
        # self.monitor.set_current_ph(4.0)

    def test_initial_values(self):
        self.assertEqual(self.monitor.current_ph, 0.0)

    def test_read_ph(self):
        self.monitor.read_ph()
        self.monitor.debug_print()
        self.assertIsInstance(self.monitor.current_ph, float)

if __name__ == '__main__':
    unittest.main()
