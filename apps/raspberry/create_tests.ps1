# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

# $directories = @(
#     "tests\communication",
#     "tests\monitoring_algorithms\agronomic",
#     "tests\monitoring_algorithms\environmental\air_quality",
#     "tests\monitoring_algorithms\environmental\gases",
#     "tests\monitoring_algorithms\environmental\oxidation_reduction_potential",
#     "tests\monitoring_algorithms\environmental\particulate_matter",
#     "tests\monitoring_algorithms\environmental\water_quality",
#     "tests\monitoring_hardware\sensors\atlas_scientific",
#     "tests\monitoring_hardware\sensors\environmental",
#     "tests\utils"
# )

# $files = @(
#     "tests\communication\test_aws_iot.py",
#     "tests\communication\test_local_network.py",
#     "tests\monitoring_algorithms\agronomic\test_indoor_urban_vertical_farming.py",
#     "tests\monitoring_algorithms\agronomic\test_outdoor_agricultural_farming.py",
#     "tests\monitoring_algorithms\agronomic\test_soil.py",
#     "tests\monitoring_algorithms\environmental\air_quality\test_air_quality.py",
#     "tests\monitoring_algorithms\environmental\gases\test_gases.py",
#     "tests\monitoring_algorithms\environmental\oxidation_reduction_potential\test_oxidation_reduction_potential.py",
#     "tests\monitoring_algorithms\environmental\particulate_matter\test_particulate_matter.py",
#     "tests\monitoring_algorithms\environmental\water_quality\test_water_quality.py",
#     "tests\monitoring_hardware\sensors\atlas_scientific\test_co2_sensor.py",
#     "tests\monitoring_hardware\sensors\atlas_scientific\test_do_sensor.py",
#     "tests\monitoring_hardware\sensors\atlas_scientific\test_ec_sensor.py",
#     "tests\monitoring_hardware\sensors\atlas_scientific\test_humidity_sensor.py",
#     "tests\monitoring_hardware\sensors\atlas_scientific\test_orp_sensor.py",
#     "tests\monitoring_hardware\sensors\atlas_scientific\test_ph_sensor.py",
#     "tests\monitoring_hardware\sensors\atlas_scientific\test_rtd_temperature_sensor.py",
#     "tests\monitoring_hardware\sensors\atlas_scientific\test_tds_sensor.py",
#     "tests\monitoring_hardware\sensors\environmental\test_adafruit_ads1115.py",
#     "tests\monitoring_hardware\sensors\environmental\test_adafruit_mq135.py",
#     "tests\monitoring_hardware\sensors\environmental\test_aeroqual_series200.py",
#     "tests\monitoring_hardware\sensors\environmental\test_ams_iaq2000.py",
#     "tests\monitoring_hardware\sensors\environmental\test_bosch_bme680.py",
#     "tests\monitoring_hardware\sensors\environmental\test_dfrog_gravity_tds.py",
#     "tests\monitoring_hardware\sensors\environmental\test_dfrog_gravity_turbidity.py",
#     "tests\monitoring_hardware\sensors\environmental\test_figaro_tgs2600.py",
#     "tests\monitoring_hardware\sensors\environmental\test_honeywell_hpm_series.py",
#     "tests\monitoring_hardware\sensors\environmental\test_plantower_pms5003.py",
#     "tests\monitoring_hardware\sensors\environmental\test_resistance_mcp3221.py",
#     "tests\monitoring_hardware\sensors\environmental\test_sensirion_sgp30.py",
#     "tests\utils\test_error_handling.py",
#     "tests\utils\test_logger.py"
# )

# # Crea los directorios
# foreach ($dir in $directories) {
#     New-Item -ItemType Directory -Path $dir -Force
# }

# # Crea los archivos
# foreach ($file in $files) {
#     New-Item -ItemType File -Path $file -Force
# }

# Crear la estructura de directorios para los tests
$directories = @(
    "tests\monitors\atlas_scientific",
    "tests\monitors\environmental"
)

foreach ($dir in $directories) {
    New-Item -ItemType Directory -Path $dir -Force
}

# Crear archivos de prueba en monitors/atlas_scientific
$atlas_scientific_tests = @(
    "co2_monitor_tests.py",
    "humidity_monitor_tests.py",
    "nutrient_solution_do_monitor_tests.py",
    "nutrient_solution_ec_monitor_tests.py",
    "nutrient_solution_orp_monitor_tests.py",
    "nutrient_solution_pH_monitor_tests.py",
    "nutrient_solution_tds_monitor_tests.py",
    "nutrient_solution_temp_monitor_tests.py"
)

foreach ($file in $atlas_scientific_tests) {
    New-Item -ItemType File -Path "tests\monitors\atlas_scientific\$file" -Force
}

# Crear archivos de prueba en monitors/environmental
$environmental_tests = @(
    "air_quality_tests.py",
    "gases_tests.py",
    "oxidation_reduction_potential_tests.py",
    "particulate_matter_tests.py",
    "water_quality_tests.py"
)

foreach ($file in $environmental_tests) {
    New-Item -ItemType File -Path "tests\monitors\environmental\$file" -Force
}

Write-Host "Estructura de directorios y archivos de pruebas creada exitosamente."
