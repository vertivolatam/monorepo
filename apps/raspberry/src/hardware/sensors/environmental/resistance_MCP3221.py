import smbus2
import time

class MCP3221:
    def __init__(self, address=0x48, bus_number=1):
        self.address = address
        self.bus = smbus2.SMBus(bus_number)

    def read_voltage(self):
        """ Lee el voltaje desde el MCP3221 """
        # Leer 2 bytes
        data = self.bus.read_i2c_block_data(self.address, 0, 2)
        # Convertir los datos a un valor de voltaje
        raw_value = (data[0] << 8) | data[1]
        voltage = (raw_value * 5.0) / 4096.0  # Escala de 0-5V para 12-bit
        return voltage

    def read_current(self, known_resistor):
        """ Lee la corriente a través de la resistencia conocida """
        voltage = self.read_voltage()
        current = voltage / known_resistor  # Ley de Ohm: I = V/R
        return current

    def read_resistance(self, known_resistor):
        """ Calcula la resistencia usando la ley de Ohm """
        voltage = self.read_voltage()
        current = self.read_current(known_resistor)
        if current == 0:
            return float('inf')  # Evitar división por cero
        resistance = voltage / current  # Ley de Ohm: R = V/I
        return resistance

# Ejemplo de uso
if __name__ == "__main__":
    sensor = MCP3221()
    try:
        while True:
            resistance = sensor.read_resistance(1000.0)  # Resistencia conocida de 1kΩ
            print(f"Resistencia medida: {resistance:.2f} Ω")
            time.sleep(1)  # Espera 1 segundo entre lecturas
    except KeyboardInterrupt:
        print("Terminando la lectura.")
