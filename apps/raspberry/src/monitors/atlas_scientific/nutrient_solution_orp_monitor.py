# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

from src.hardware.sensors.atlas_scientific.EZO_orp_sensor import EZO_ORPSensor
import json

class NutrientSolutionORPMonitor:
    def __init__(self, lower_bound: float, upper_bound: float, input_EZO_ORPSensor: EZO_ORPSensor = None):
        """
        Inicializa la clase con las cotas inferior, superior y una instancia del sensor de ORP.

        :param lower_bound: Valor mínimo aceptable de ORP.
        :param upper_bound: Valor máximo aceptable de ORP.
        :param input_EZO_ORPSensor: Instancia del sensor de ORP. Si no se pasa, se instancia uno automáticamente.
        """
        self.lower_bound = lower_bound
        self.upper_bound = upper_bound
        self.current_orp = 0.0
        if not hasattr(self, 'sensor'):
            if input_EZO_ORPSensor is not None:
                self.sensor = input_EZO_ORPSensor
            else:
                self.sensor = EZO_ORPSensor()

    def set_current_orp(self, current_orp: float):
        """
        Establece el valor actual de ORP.

        :param current_orp: El nuevo valor de ORP.
        """
        self.current_orp = current_orp

    def is_below_lower_bound(self) -> bool:
        """
        Evalúa si el ORP actual es MENOR O IGUAL a la cota inferior.

        :return: True si el ORP actual es MENOR O IGUAL a la cota inferior, False en caso contrario.
        """
        return self.current_orp <= self.lower_bound

    def is_above_lower_bound(self) -> bool:
        """
        Evalúa si el ORP actual es MAYOR a la cota inferior.

        :return: True si el ORP actual es MAYOR a la cota inferior, False en caso contrario.
        """
        return self.current_orp > self.lower_bound

    def is_below_upper_bound(self) -> bool:
        """
        Evalúa si el ORP actual es MENOR a la cota superior.

        :return: True si el ORP actual es MENOR a la cota superior, False en caso contrario.
        """
        return self.current_orp < self.upper_bound

    def is_above_upper_bound(self) -> bool:
        """
        Evalúa si el ORP actual es MAYOR O IGUAL a la cota superior.

        :return: True si el ORP actual es MAYOR O IGUAL a la cota superior, False en caso contrario.
        """
        return self.current_orp >= self.upper_bound

    def read_orp(self):
        """
        Actualiza el valor actual de ORP llamando al método read_orp del sensor.
        """
        self.current_orp = self.sensor.read_orp()

    def debug_print(self):
        print("===================")
        print(f"{'Potencial Oxidación Reducción:':<40} {self.current_orp:.2f} mV")
        print(f"{'Cota Superior:':<40} {self.upper_bound:.2f}")
        print(f"{'Cota Inferior:':<40} {self.lower_bound:.2f}")

    def json_serialize_spec(self):
        """
        Serializa las cotas inferior y superior en formato JSON.

        :return: JSON con los límites de ORP.
        """
        boundaries = {
            'lower_bound': self.lower_bound,
            'upper_bound': self.upper_bound
        }
        return json.dumps(boundaries)
    
    def json_serialize_status(self):
        """
        Serializa el estado actual de ORP en formato JSON.

        :return: JSON con el valor actual de ORP.
        """
        status = {
            'current_orp': self.current_orp
        }
        return json.dumps(status)
