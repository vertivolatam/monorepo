# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

import unittest
from src.monitors.environmental.water_quality import WaterQualityMonitor

class TestWaterQualityMonitor(unittest.TestCase):
    def setUp(self):
        self.monitor = WaterQualityMonitor()

    def test_initial_values(self):
        self.assertEqual(self.monitor.current_water_quality, 0.0)

    def test_read_water_quality(self):
        self.monitor.read_water_quality()
        self.monitor.debug_print()
        self.assertIsInstance(self.monitor.current_water_quality, float)

if __name__ == '__main__':
    unittest.main()