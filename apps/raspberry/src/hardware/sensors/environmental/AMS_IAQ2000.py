import smbus2
import time

class AMSIAQ2000:
    """
    Clase para interactuar con el sensor AMS IAQ-2000.

    Tipos de Contaminación Detectables:
    - Contaminantes del aire (TVOCs)
    - CO2
    """
    def __init__(self, address=0x10):
        self.bus = smbus2.SMBus(1)
        self.address = address

    def read_iaq(self):
        # Leer calidad del aire (simulación)
        return self.bus.read_i2c_block_data(self.address, 0x00, 4)

    def close(self):
        self.bus.close()
