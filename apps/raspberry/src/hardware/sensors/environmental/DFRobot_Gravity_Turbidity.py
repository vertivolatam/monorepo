import smbus2
import time

class DFRobotGravityTurbidity:
    """
    Clase para interactuar con el sensor DFRobot Gravity Turbidity.

    Tipos de Contaminación Detectables:
    - Materia en suspensión
    - Efluentes industriales
    - Contaminación urbana
    """
    def __init__(self, address=0x68):
        self.bus = smbus2.SMBus(1)
        self.address = address

    def read_turbidity(self):
        # Leer turbidez (simulación)
        return self.bus.read_byte(self.address)

    def close(self):
        self.bus.close()
