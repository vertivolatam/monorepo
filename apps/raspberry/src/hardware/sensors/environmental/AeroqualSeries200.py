import serial
import smbus2

class AeroqualSeries200:
    """
    Clase para interactuar con el sensor Aeroqual Series 200.
    
    Tipos de Contaminación Detectables: Contaminantes atmosféricos (O3, NO2, SO2, VOCs)
    Protocolo: RS-232 convertido a TTL usando MAX232.
    """

    def __init__(self, serial_port='/dev/ttyUSB0', baudrate=9600, i2c_address=0x04):
        """
        Inicializa la clase AeroqualSeries200.

        Parámetros:
        - serial_port: Puerto serie donde está conectado el convertidor MAX232.
        - baudrate: Velocidad de comunicación del puerto serie.
        - i2c_address: Dirección I2C del dispositivo que recibirá los datos.
        """
        self.serial_port = serial_port
        self.baudrate = baudrate
        self.i2c_address = i2c_address
        
        # Configuración del puerto serie
        self.serial = serial.Serial(self.serial_port, self.baudrate, timeout=1)
        
        # Configuración del bus I2C
        self.bus = smbus2.SMBus(1)  # Usualmente el bus I2C en Raspberry Pi es 1

    def read_sensor_data(self):
        """
        Lee los datos del sensor a través del puerto serie.

        Retorna:
        - Los datos leídos del sensor.
        """
        line = self.serial.readline().decode('utf-8').strip()
        return line

    def send_to_i2c(self, data):
        """
        Envía los datos leídos al dispositivo I2C.

        Parámetros:
        - data: Datos a enviar al dispositivo I2C.
        """
        try:
            self.bus.write_byte(self.i2c_address, int(data))
        except Exception as e:
            print(f"Error al enviar datos a I2C: {e}")

    def process_data(self):
        """
        Procesa los datos del sensor y los envía a I2C.
        """
        sensor_data = self.read_sensor_data()
        if sensor_data:
            print(f"Datos del sensor leídos: {sensor_data}")
            self.send_to_i2c(sensor_data)

# Ejemplo de uso:
if __name__ == "__main__":
    sensor = AeroqualSeries200()
    while True:
        sensor.process_data()
