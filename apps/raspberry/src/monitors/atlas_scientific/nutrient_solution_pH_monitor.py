# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

from src.hardware.sensors.atlas_scientific.EZO_ph_sensor import EZO_PHSensor
import json

class NutrientSolutionPhMonitor:
    def __init__(self, lower_bound: float, upper_bound: float, input_EZO_PHSensor: EZO_PHSensor = None):
        """
        Inicializa la clase con las cotas inferior, superior y una instancia del sensor de pH.

        :param lower_bound: Valor mínimo aceptable de pH.
        :param upper_bound: Valor máximo aceptable de pH.
        :param sensor: Instancia del sensor de pH.
        """
        self.lower_bound = lower_bound
        self.upper_bound = upper_bound
        self.current_ph = 0.0
        if not hasattr(self, 'sensor'):
            if input_EZO_PHSensor is not None:
                self.sensor = input_EZO_PHSensor
            else:
                self.sensor = EZO_PHSensor()

    def set_current_ph(self, current_ph: float):
        """
        Establece el valor actual de pH.

        :param current_ph: El nuevo valor de pH.
        """
        self.current_ph = current_ph

    def is_below_lower_bound(self) -> bool:
        """
        Evalúa si el pH actual es MENOR O IGUAL a la cota inferior.

        :return: True si el pH actual es MENOR O IGUAL a la cota inferior, False en caso contrario.
        """
        return self.current_ph <= self.lower_bound

    def is_above_lower_bound(self) -> bool:
        """
        Evalúa si el pH actual es MAYOR a la cota inferior.

        :return: True si el pH actual es MAYOR a la cota inferior, False en caso contrario.
        """
        return self.current_ph > self.lower_bound

    def is_below_upper_bound(self) -> bool:
        """
        Evalúa si el pH actual es MENOR a la cota superior.

        :return: True si el pH actual es MENOR a la cota superior, False en caso contrario.
        """
        return self.current_ph < self.upper_bound

    def is_above_upper_bound(self) -> bool:
        """
        Evalúa si el pH actual es MAYOR O IGUAL a la cota superior.

        :return: True si el pH actual es MAYOR O IGUAL a la cota superior, False en caso contrario.
        """
        return self.current_ph >= self.upper_bound

    def read_ph(self):
        """
        Actualiza el valor actual de pH llamando al método read_ph del sensor.
        """
        self.current_ph = self.sensor.read_ph()

    def debug_print(self):
        print("===================")
        print(f"{'pH (Acidez - Alcalinidad):':<40} {self.current_ph:.2f}")
        print(f"{'Cota Superior:':<40} {self.upper_bound:.2f}")
        print(f"{'Cota Inferior:':<40} {self.lower_bound:.2f}")

    def json_serialize_spec(self):
        boundaries = {
            'lower_bound': self.lower_bound,
            'upper_bound': self.upper_bound
        }
        return json.dumps(boundaries)
    
    def json_serialize_status(self):
        status = {
            'current_ph': self.current_ph
        }
        return json.dumps(status)