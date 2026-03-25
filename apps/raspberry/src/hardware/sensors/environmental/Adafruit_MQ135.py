import time
import Adafruit_ADS1x15

class Adafruit_MQ135:
    """
    Clase para el sensor MQ-135, que detecta gases tóxicos como NH3, NOx, alcohol, benceno, humo y gases industriales.

    Tipos de Contaminación Detectables:
    - Gases tóxicos (NH3, NOx, alcohol, benceno, humo, gases industriales)
    """

    def __init__(self, address=0x48, channel=0, adc_gain=1):
        """
        Inicializa el sensor MQ-135 con el adaptador ADS1115.

        Args:
            address (int): Dirección I2C del ADS1115 (por defecto 0x48).
            channel (int): Canal del ADS1115 al que está conectado el sensor (0 a 3).
            adc_gain (int): Ganancia del ADC (puede ser 2/3, 1, 2, o 4, según las especificaciones del ADS1115).
        """
        self.adc = Adafruit_ADS1x15.ADS1115(address)
        self.channel = channel
        self.adc_gain = adc_gain

    def read_sensor_data(self):
        """
        Lee los datos del sensor y convierte el valor analógico en un valor legible.

        Returns:
            float: Valor analógico leído del sensor MQ-135.
        """
        # Leer el valor analógico del ADS1115 en el canal especificado
        raw_value = self.adc.read_adc(self.channel, gain=self.adc_gain)
        
        # Convertir el valor crudo a un valor en voltios
        voltage = (raw_value / 32767.0) * 3.3  # Asumiendo un rango de 0 a 3.3V
        
        # Este es un valor de ejemplo. Deberías calibrar el sensor para obtener
        # valores de concentración específicos basados en las características del sensor.
        concentration = voltage  # Aquí deberías agregar la conversión específica si la tienes.

        return concentration

# Ejemplo de uso
if __name__ == "__main__":
    mq135 = Adafruit_MQ135()
    while True:
        concentration = mq135.read_sensor_data()
        print(f"Concentración de gases tóxicos (MQ-135): {concentration:.2f} V")
        time.sleep(2)
