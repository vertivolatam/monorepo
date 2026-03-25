import smbus2
import time
from Adafruit_ADS1x15.analog_in import AnalogIn
from Adafruit_ADS1x15.ads1115 import ADS1115
import board

class ADC_ADS1115:
    def __init__(self, address=0x48):
        self.i2c = board.I2C()  # Usar la bus I2C
        self.ads = ADS1115(self.i2c, address=address)

    def read_voltage(self, channel):
        """ Lee el voltaje en el canal especificado """
        adc_channel = AnalogIn(self.ads, channel)
        voltage = adc_channel.voltage  # Lee el voltaje
        return voltage

    def read_current(self, channel, known_resistor):
        """ Lee la corriente a través de la resistencia conocida """
        voltage = self.read_voltage(channel)
        current = voltage / known_resistor  # Ley de Ohm: I = V/R
        return current

    def read_resistance(self, channel, known_resistor):
        """ Calcula la resistencia usando la ley de Ohm """
        voltage = self.read_voltage(channel)
        current = self.read_current(channel, known_resistor)
        if current == 0:
            return float('inf')  # Evitar división por cero
        resistance = voltage / current  # Ley de Ohm: R = V/I
        return resistance

# Ejemplo de uso
if __name__ == "__main__":
    sensor = ADC_ADS1115()
    try:
        while True:
            resistance = sensor.read_resistance(0, 1000.0)  # Canal 0, resistencia conocida de 1kΩ
            print(f"Resistencia medida: {resistance:.2f} Ω")
            time.sleep(1)  # Espera 1 segundo entre lecturas
    except KeyboardInterrupt:
        print("Terminando la lectura.")
