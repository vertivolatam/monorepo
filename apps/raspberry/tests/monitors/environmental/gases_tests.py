# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

import unittest
from src.monitors.environmental.gases import GasesMonitor

class TestGasesMonitor(unittest.TestCase):
    def setUp(self):
        self.monitor = GasesMonitor()

    def test_initial_values(self):
        self.assertEqual(self.monitor.current_gas_level, 0.0)

    def test_read_gas_levels(self):
        self.monitor.read_gas_levels()
        self.monitor.debug_print()
        self.assertIsInstance(self.monitor.current_gas_level, float)

if __name__ == '__main__':
    unittest.main()
