import serial
import smbus2
import time

class PlantowerPMS5003:
    """
    Clase para manejar el sensor Plantower PMS5003.

    Tipos de Contaminación Detectables: Partículas en suspensión (PM1.0, PM2.5, PM10).

    Args:
        serial_port (str): Puerto serial donde está conectado el sensor (por defecto '/dev/ttyUSB0').
        baudrate (int): Velocidad de transmisión del puerto serial (por defecto 9600).
        i2c_address (int): Dirección I2C del dispositivo donde enviar los datos (por defecto 0x04).
    """

    def __init__(self, serial_port='/dev/ttyUSB0', baudrate=9600, i2c_address=0x04):
        self.serial = serial.Serial(serial_port, baudrate, timeout=1)
        self.bus = smbus2.SMBus(1)
        self.i2c_address = i2c_address

    def read_sensor_data(self):
        """
        Lee datos del sensor a través de la interfaz UART.
        
        Returns:
            str: Línea de datos leída del sensor.
        """
        # Lee una línea de datos del sensor
        line = self.serial.readline().decode('utf-8').strip()
        return line

    def send_to_i2c(self, data):
        """
        Envía los datos leídos al dispositivo I2C.
        
        Args:
            data (str): Datos leídos del sensor que se enviarán a través de I2C.
        """
        # Convierte la cadena de datos a un número entero y envía a I2C
        try:
            value = int(data)  # Asegúrate de que el formato sea correcto
            self.bus.write_byte(self.i2c_address, value)
            print(f"Datos enviados a I2C: {value}")
        except ValueError:
            print("Error al convertir los datos a entero para I2C.")

    def process_data(self):
        """
        Procesa los datos del sensor y los envía a I2C.
        """
        sensor_data = self.read_sensor_data()
        if sensor_data:
            print(f"Datos del sensor leídos: {sensor_data}")
            self.send_to_i2c(sensor_data)

if __name__ == "__main__":
    sensor = PlantowerPMS5003()
    while True:
        sensor.process_data()
        time.sleep(1)
