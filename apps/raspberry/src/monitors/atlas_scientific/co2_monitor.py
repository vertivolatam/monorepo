# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

from src.hardware.sensors.atlas_scientific.EZO_co2_sensor import EZO_CO2Sensor
import json

class CO2Monitor:
    def __init__(self, lower_bound: float, upper_bound: float, input_EZO_CO2Sensor: EZO_CO2Sensor = None):
        """
        Inicializa la clase con las cotas inferior, superior y una instancia del sensor de CO2.

        :param lower_bound: Valor mínimo aceptable de CO2.
        :param upper_bound: Valor máximo aceptable de CO2.
        :param input_EZO_CO2Sensor: Instancia del sensor de CO2. Si no se pasa, se instancia uno automáticamente.
        """
        self.lower_bound = lower_bound
        self.upper_bound = upper_bound
        self.current_co2 = 0.0
        if not hasattr(self, 'sensor'):
            if input_EZO_CO2Sensor is not None:
                self.sensor = input_EZO_CO2Sensor
            else:
                self.sensor = EZO_CO2Sensor()

    def set_current_co2(self, current_co2: float):
        """
        Establece el valor actual de CO2.

        :param current_co2: El nuevo valor de CO2.
        """
        self.current_co2 = current_co2

    def is_below_lower_bound(self) -> bool:
        """
        Evalúa si el CO2 actual es MENOR O IGUAL a la cota inferior.

        :return: True si el CO2 actual es MENOR O IGUAL a la cota inferior, False en caso contrario.
        """
        return self.current_co2 <= self.lower_bound

    def is_above_lower_bound(self) -> bool:
        """
        Evalúa si el CO2 actual es MAYOR a la cota inferior.

        :return: True si el CO2 actual es MAYOR a la cota inferior, False en caso contrario.
        """
        return self.current_co2 > self.lower_bound

    def is_below_upper_bound(self) -> bool:
        """
        Evalúa si el CO2 actual es MENOR a la cota superior.

        :return: True si el CO2 actual es MENOR a la cota superior, False en caso contrario.
        """
        return self.current_co2 < self.upper_bound

    def is_above_upper_bound(self) -> bool:
        """
        Evalúa si el CO2 actual es MAYOR O IGUAL a la cota superior.

        :return: True si el CO2 actual es MAYOR O IGUAL a la cota superior, False en caso contrario.
        """
        return self.current_co2 >= self.upper_bound

    def read_co2(self):
        """
        Actualiza el valor actual de CO2 llamando al método read_co2 del sensor.
        """
        self.current_co2 = self.sensor.read_co2()

    def debug_print(self):
        print("===================")
        print(f"{'CO2:':<40} {self.current_co2:.2f} ppm")
        print(f"{'Cota Superior:':<40} {self.upper_bound:.2f}")
        print(f"{'Cota Inferior:':<40} {self.lower_bound:.2f}")

    def json_serialize_spec(self):
        """
        Serializa las cotas inferior y superior en formato JSON.

        :return: JSON con los límites de CO2.
        """
        boundaries = {
            'lower_bound': self.lower_bound,
            'upper_bound': self.upper_bound
        }
        return json.dumps(boundaries)
    
    def json_serialize_status(self):
        """
        Serializa el estado actual de CO2 en formato JSON.

        :return: JSON con el valor actual de CO2.
        """
        status = {
            'current_co2': self.current_co2
        }
        return json.dumps(status)
