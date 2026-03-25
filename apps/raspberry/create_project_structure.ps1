# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

$directories = @(
    "src",
    "src\communication",
    "src\monitoring_algorithms",
    "src\monitoring_algorithms\agronomic",
    "src\monitoring_algorithms\agronomic\indoor_urban_vertical_farming",
    "src\monitoring_algorithms\agronomic\outdoor_agricultural_farming",
    "src\monitoring_algorithms\agronomic\soil",
    "src\monitoring_algorithms\environmental",
    "src\monitoring_algorithms\environmental\air_quality",
    "src\monitoring_algorithms\environmental\gases",
    "src\monitoring_algorithms\environmental\oxidation_reduction_potential",
    "src\monitoring_algorithms\environmental\particulate_matter",
    "src\monitoring_algorithms\environmental\water_quality",
    "src\monitoring_hardware",
    "src\monitoring_hardware\sensors",
    "src\monitoring_hardware\sensors\atlas_scientific",
    "src\monitoring_hardware\sensors\environmental",
    "src\utils",
    "src\visualization"
)

foreach ($dir in $directories) {
    New-Item -ItemType Directory -Path $dir -Force
}

$files = @(
    "src\config.py",
    "src\main.py",
    "src\__init__.py",
    "src\communication\aws_iot.py",
    "src\communication\local_network.py",
    "src\communication\__init__.py",
    "src\monitoring_algorithms\__init__.py",
    "src\monitoring_algorithms\agronomic\__init__.py",
    "src\monitoring_algorithms\agronomic\indoor_urban_vertical_farming\monitoring_algorithm.py",
    "src\monitoring_algorithms\agronomic\indoor_urban_vertical_farming\__init__.py",
    "src\monitoring_algorithms\agronomic\outdoor_agricultural_farming\monitoring_algorithm.py",
    "src\monitoring_algorithms\agronomic\outdoor_agricultural_farming\__init__.py",
    "src\monitoring_algorithms\agronomic\soil\monitoring_algorithm.py",
    "src\monitoring_algorithms\agronomic\soil\__init__.py",
    "src\monitoring_algorithms\environmental\__init__.py",
    "src\monitoring_algorithms\environmental\air_quality\monitoring_algorithm.py",
    "src\monitoring_algorithms\environmental\air_quality\__init__.py",
    "src\monitoring_algorithms\environmental\gases\monitoring_algorithm.py",
    "src\monitoring_algorithms\environmental\gases\__init__.py",
    "src\monitoring_algorithms\environmental\oxidation_reduction_potential\monitoring_algorithm.py",
    "src\monitoring_algorithms\environmental\oxidation_reduction_potential\__init__.py",
    "src\monitoring_algorithms\environmental\particulate_matter\monitoring_algorithm.py",
    "src\monitoring_algorithms\environmental\particulate_matter\__init__.py",
    "src\monitoring_algorithms\environmental\water_quality\monitoring_algorithm.py",
    "src\monitoring_algorithms\environmental\water_quality\__init__.py",
    "src\monitoring_hardware\__init__.py",
    "src\monitoring_hardware\sensors\base_I2C_sensor.py",
    "src\monitoring_hardware\sensors\dag_base_I2C_sensor.py",
    "src\monitoring_hardware\sensors\dag_I2C_multiplexor.py",
    "src\monitoring_hardware\sensors\use_cases.csv",
    "src\monitoring_hardware\sensors\use_cases.xlsx",
    "src\monitoring_hardware\sensors\__init__.py",
    "src\monitoring_hardware\sensors\atlas_scientific\AtlasScientificSensor.py",
    "src\monitoring_hardware\sensors\atlas_scientific\co2_sensor.py",
    "src\monitoring_hardware\sensors\atlas_scientific\do_sensor.py",
    "src\monitoring_hardware\sensors\atlas_scientific\ec_sensor.py",
    "src\monitoring_hardware\sensors\atlas_scientific\humidity_sensor.py",
    "src\monitoring_hardware\sensors\atlas_scientific\i2c_addresses.csv",
    "src\monitoring_hardware\sensors\atlas_scientific\orp_sensor.py",
    "src\monitoring_hardware\sensors\atlas_scientific\ph_sensor.py",
    "src\monitoring_hardware\sensors\atlas_scientific\rtd_temperature_sensor.py",
    "src\monitoring_hardware\sensors\atlas_scientific\tds_sensor.py",
    "src\monitoring_hardware\sensors\atlas_scientific\__init__.py",
    "src\monitoring_hardware\sensors\environmental\Adafruit_ADS1115.py",
    "src\monitoring_hardware\sensors\environmental\Adafruit_MQ135.py",
    "src\monitoring_hardware\sensors\environmental\AeroqualSeries200.py",
    "src\monitoring_hardware\sensors\environmental\AMS_IAQ2000.py",
    "src\monitoring_hardware\sensors\environmental\Bosch_BME680.py",
    "src\monitoring_hardware\sensors\environmental\DFRobot_Gravity_TDS.py",
    "src\monitoring_hardware\sensors\environmental\DFRobot_Gravity_Turbidity.py",
    "src\monitoring_hardware\sensors\environmental\Figaro_TGS2600.py",
    "src\monitoring_hardware\sensors\environmental\Honeywell_HPM_Series.py",
    "src\monitoring_hardware\sensors\environmental\PlantowerPMS5003.py",
    "src\monitoring_hardware\sensors\environmental\resistance_MCP3221.py",
    "src\monitoring_hardware\sensors\environmental\Sensirion_SGP30.py",
    "src\monitoring_hardware\sensors\environmental\__init__.py",
    "src\utils\error_handling.py",
    "src\utils\logger.py",
    "src\utils\__init__.py",
    "src\visualization\dashboards.py",
    "src\visualization\plots.py",
    "src\visualization\__init__.py"
)

foreach ($file in $files) {
    New-Item -ItemType File -Path $file -Force
}