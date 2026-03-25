# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

from src.hardware.sensors.atlas_scientific.EZO_rtd_sensor import EZO_RTD_Sensor
import json

class NutrientSolutionTempMonitor:
    def __init__(self, lower_bound: float, upper_bound: float, input_EZO_RTD_Sensor: EZO_RTD_Sensor = None):
        """
        Inicializa la clase con las cotas inferior, superior y una instancia del sensor de temperatura RTD.

        :param lower_bound: Valor mínimo aceptable de temperatura.
        :param upper_bound: Valor máximo aceptable de temperatura.
        :param input_EZO_RTD_Sensor: Instancia del sensor de temperatura. Si no se pasa, se instancia uno automáticamente.
        """
        self.lower_bound = lower_bound
        self.upper_bound = upper_bound
        self.current_temperature = 0.0
        if not hasattr(self, 'sensor'):
            if input_EZO_RTD_Sensor is not None:
                self.sensor = input_EZO_RTD_Sensor
            else:
                self.sensor = EZO_RTD_Sensor()

    def set_current_temperature(self, current_temperature: float):
        """
        Establece el valor actual de temperatura.

        :param current_temperature: El nuevo valor de temperatura.
        """
        self.current_temperature = current_temperature

    def is_below_lower_bound(self) -> bool:
        """
        Evalúa si la temperatura actual es MENOR O IGUAL a la cota inferior.

        :return: True si la temperatura actual es MENOR O IGUAL a la cota inferior, False en caso contrario.
        """
        return self.current_temperature <= self.lower_bound

    def is_above_lower_bound(self) -> bool:
        """
        Evalúa si la temperatura actual es MAYOR a la cota inferior.

        :return: True si la temperatura actual es MAYOR a la cota inferior, False en caso contrario.
        """
        return self.current_temperature > self.lower_bound

    def is_below_upper_bound(self) -> bool:
        """
        Evalúa si la temperatura actual es MENOR a la cota superior.

        :return: True si la temperatura actual es MENOR a la cota superior, False en caso contrario.
        """
        return self.current_temperature < self.upper_bound

    def is_above_upper_bound(self) -> bool:
        """
        Evalúa si la temperatura actual es MAYOR O IGUAL a la cota superior.

        :return: True si la temperatura actual es MAYOR O IGUAL a la cota superior, False en caso contrario.
        """
        return self.current_temperature >= self.upper_bound

    def read_temperature(self):
        """
        Actualiza el valor actual de temperatura llamando al método read_temperature del sensor.
        """
        self.current_temperature = self.sensor.read_temperature()

    def debug_print(self):
        print("===================")
        print(f"{'Temperatura:':<40} {self.current_temperature:.2f} °C")
        print(f"{'Cota Superior:':<40} {self.upper_bound:.2f}")
        print(f"{'Cota Inferior:':<40} {self.lower_bound:.2f}")

    def json_serialize_spec(self):
        """
        Serializa las cotas inferior y superior en formato JSON.

        :return: JSON con los límites de temperatura.
        """
        boundaries = {
            'lower_bound': self.lower_bound,
            'upper_bound': self.upper_bound
        }
        return json.dumps(boundaries)
    
    def json_serialize_status(self):
        """
        Serializa el estado actual de temperatura en formato JSON.

        :return: JSON con el valor actual de temperatura.
        """
        status = {
            'current_temperature': self.current_temperature
        }
        return json.dumps(status)
