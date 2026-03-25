import smbus2
import time

class DFRobotGravityTDS:
    """
    Clase para interactuar con el sensor DFRobot Gravity TDS.

    Tipos de Contaminación Detectables:
    - Contaminación por nutrientes
    - Escorrentía urbana
    - Aguas residuales
    """
    def __init__(self, address=0x70):
        self.bus = smbus2.SMBus(1)
        self.address = address

    def read_tds(self):
        # Leer TDS (simulación)
        return self.bus.read_byte(self.address)

    def close(self):
        self.bus.close()
