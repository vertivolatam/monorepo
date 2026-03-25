import smbus2
import time

class SensirionSGP30:
    """
    Clase para interactuar con el sensor Sensirion SGP30.

    Tipos de Contaminación Detectables:
    - Gases (TVOCs)
    - CO2 equivalente
    """
    def __init__(self, address=0x58):
        self.bus = smbus2.SMBus(1)
        self.address = address

    def read_air_quality(self):
        # Leer calidad del aire (simulación)
        self.bus.write_byte(self.address, 0x20)
        time.sleep(0.1)  # Espera por los datos
        return self.bus.read_i2c_block_data(self.address, 0x00, 2)

    def close(self):
        self.bus.close()
