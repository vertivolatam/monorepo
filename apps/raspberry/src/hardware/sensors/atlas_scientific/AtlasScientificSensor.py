# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

try:
    import smbus2
except ImportError:
    smbus2 = None

class AtlasScientificSensor:
    """
    AtlasScientificSensor class for communicating with Atlas Scientific I2C sensors.

    Supported sensor types:
    - pH
    - Conductivity (EC)
    - Dissolved Oxygen (DO)
    - ORP
    - RTD Temperature
    - CO2
    - Humidity
    - Total Dissolved Solids (TDS)
    
    Usage:
    sensor = AtlasScientificSensor(sensor_type="pH")  # Initializes the pH sensor with default I2C address 0x63
    sensor.read_data()  # Example method for reading data
    """

    # Default I2C addresses for Atlas Scientific sensors
    SENSOR_ADDRESSES = {
        "pH": 0x63,
        "Conductivity (EC)": 0x64,
        "Dissolved Oxygen (DO)": 0x61,
        "ORP": 0x62,
        "RTD Temperature": 0x66,
        "CO2": 0x67,
        "Humidity": 0x6F,
        "Total Dissolved Solids (TDS)": 0x68
    }

    def __init__(self, sensor_type, bus_number=1):
        """
        Initialize the sensor with the given sensor type.

        :param sensor_type: A string representing the type of sensor (e.g., "pH", "Conductivity (EC)")
        :param bus_number: The I2C bus number (default is 1 for Raspberry Pi)
        :raises ValueError: If the sensor type is not recognized
        """
        if sensor_type not in self.SENSOR_ADDRESSES:
            raise ValueError(f"Unsupported sensor type: {sensor_type}. Supported types: {list(self.SENSOR_ADDRESSES.keys())}")
        
        self.sensor_type = sensor_type
        self.i2c_address = self.SENSOR_ADDRESSES[sensor_type]
        if smbus2 is None:
            raise RuntimeError(
                f"smbus2 is not installed — cannot instantiate real I2C sensor '{sensor_type}'. "
                "Install smbus2 on Raspberry Pi or use --simulate mode."
            )
        self.bus = smbus2.SMBus(bus_number)

    def read_data(self, i2c_registry=0x00):
        """
        This method reads data from the sensor.
        :param i2c_registry: Should be customized based on the specific sensor data format (refer to Atlas Scientific sensor datasheet)
        :raises ValueError: If unable to read data, when i2c_registry is not recognized
        """
        try:
            data = self.bus.read_byte_data(self.i2c_address, i2c_registry)
            data_float = float(data)
            return data_float
        except Exception as e:
            raise ValueError(f"Error reading data from sensor {self.sensor_type} from I2C registry: {hex(i2c_registry)}: {e}")

    def write_data(self, data, i2c_registry=0x00):
        """
        This method writes data back to the sensor.
        :param i2c_registry: Should be customized based on the specific sensor data format (refer to Atlas Scientific sensor datasheet)
        :raises ValueError: If unable to write data, when i2c_registry is not recognized
        """
        try:
            self.bus.write_byte_data(self.i2c_address, i2c_registry, data)
        except Exception as e:
            raise ValueError(f"Error writing data back to sensor {self.sensor_type} into I2C registry: {hex(i2c_registry)}: {e}")
