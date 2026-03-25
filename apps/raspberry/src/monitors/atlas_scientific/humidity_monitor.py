# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

from src.hardware.sensors.atlas_scientific.EZO_humidity_sensor import EZO_HumiditySensor
import json

class HumidityMonitor:
    def __init__(self, lower_bound: float, upper_bound: float, input_EZO_HumiditySensor: EZO_HumiditySensor = None):
        """
        Inicializa la clase con las cotas inferior, superior y una instancia del sensor de humedad.

        :param lower_bound: Valor mínimo aceptable de humedad.
        :param upper_bound: Valor máximo aceptable de humedad.
        :param input_EZO_HumiditySensor: Instancia del sensor de humedad. Si no se pasa, se instancia uno automáticamente.
        """
        self.lower_bound = lower_bound
        self.upper_bound = upper_bound
        self.current_humidity = 0.0
        if not hasattr(self, 'sensor'):
            if input_EZO_HumiditySensor is not None:
                self.sensor = input_EZO_HumiditySensor
            else:
                self.sensor = EZO_HumiditySensor()

    def set_current_humidity(self, current_humidity: float):
        """
        Establece el valor actual de humedad.

        :param current_humidity: El nuevo valor de humedad.
        """
        self.current_humidity = current_humidity

    def is_below_lower_bound(self) -> bool:
        """
        Evalúa si la humedad actual es MENOR O IGUAL a la cota inferior.

        :return: True si la humedad actual es MENOR O IGUAL a la cota inferior, False en caso contrario.
        """
        return self.current_humidity <= self.lower_bound

    def is_above_lower_bound(self) -> bool:
        """
        Evalúa si la humedad actual es MAYOR a la cota inferior.

        :return: True si la humedad actual es MAYOR a la cota inferior, False en caso contrario.
        """
        return self.current_humidity > self.lower_bound

    def is_below_upper_bound(self) -> bool:
        """
        Evalúa si la humedad actual es MENOR a la cota superior.

        :return: True si la humedad actual es MENOR a la cota superior, False en caso contrario.
        """
        return self.current_humidity < self.upper_bound

    def is_above_upper_bound(self) -> bool:
        """
        Evalúa si la humedad actual es MAYOR O IGUAL a la cota superior.

        :return: True si la humedad actual es MAYOR O IGUAL a la cota superior, False en caso contrario.
        """
        return self.current_humidity >= self.upper_bound

    def read_humidity(self):
        """
        Actualiza el valor actual de humedad llamando al método read_humidity del sensor.
        """
        self.current_humidity = self.sensor.read_humidity()

    def debug_print(self):
        print("===================")
        print(f"{'Humedad:':<40} {self.current_humidity:.2f} %")
        print(f"{'Cota Superior:':<40} {self.upper_bound:.2f}")
        print(f"{'Cota Inferior:':<40} {self.lower_bound:.2f}")

    def json_serialize_spec(self):
        """
        Serializa las cotas inferior y superior en formato JSON.

        :return: JSON con los límites de humedad.
        """
        boundaries = {
            'lower_bound': self.lower_bound,
            'upper_bound': self.upper_bound
        }
        return json.dumps(boundaries)
    
    def json_serialize_status(self):
        """
        Serializa el estado actual de humedad en formato JSON.

        :return: JSON con el valor actual de humedad.
        """
        status = {
            'current_humidity': self.current_humidity
        }
        return json.dumps(status)
