import smbus2
import time

class HoneywellHPM:
    """
    Clase para interactuar con el sensor Honeywell HPM Series.

    Tipos de Contaminación Detectables:
    - PM2.5
    - PM10 (partículas en suspensión)
    - Calidad del aire en interiores
    """
    def __init__(self, address=0x5A):
        self.bus = smbus2.SMBus(1)
        self.address = address

    def read_pm_levels(self):
        # Leer PM2.5 y PM10 (simulación)
        return self.bus.read_i2c_block_data(self.address, 0x00, 4)

    def close(self):
        self.bus.close()
