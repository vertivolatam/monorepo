# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

from src.hardware.sensors.atlas_scientific.EZO_do_sensor import EZO_DOSensor
import json

class NutrientSolutionDOMonitor:
    def __init__(self, lower_bound: float, upper_bound: float, input_EZO_DOSensor: EZO_DOSensor = None):
        """
        Inicializa la clase con las cotas inferior, superior y una instancia del sensor de DO.

        :param lower_bound: Valor mínimo aceptable de DO.
        :param upper_bound: Valor máximo aceptable de DO.
        :param input_EZO_DOSensor: Instancia del sensor de DO. Si no se pasa, se instancia uno automáticamente.
        """
        self.lower_bound = lower_bound
        self.upper_bound = upper_bound
        self.current_do = 0.0
        if not hasattr(self, 'sensor'):
            if input_EZO_DOSensor is not None:
                self.sensor = input_EZO_DOSensor
            else:
                self.sensor = EZO_DOSensor()

    def set_current_do(self, current_do: float):
        """
        Establece el valor actual de DO.

        :param current_do: El nuevo valor de DO.
        """
        self.current_do = current_do

    def is_below_lower_bound(self) -> bool:
        """
        Evalúa si el DO actual es MENOR O IGUAL a la cota inferior.

        :return: True si el DO actual es MENOR O IGUAL a la cota inferior, False en caso contrario.
        """
        return self.current_do <= self.lower_bound

    def is_above_lower_bound(self) -> bool:
        """
        Evalúa si el DO actual es MAYOR a la cota inferior.

        :return: True si el DO actual es MAYOR a la cota inferior, False en caso contrario.
        """
        return self.current_do > self.lower_bound

    def is_below_upper_bound(self) -> bool:
        """
        Evalúa si el DO actual es MENOR a la cota superior.

        :return: True si el DO actual es MENOR a la cota superior, False en caso contrario.
        """
        return self.current_do < self.upper_bound

    def is_above_upper_bound(self) -> bool:
        """
        Evalúa si el DO actual es MAYOR O IGUAL a la cota superior.

        :return: True si el DO actual es MAYOR O IGUAL a la cota superior, False en caso contrario.
        """
        return self.current_do >= self.upper_bound

    def read_do(self):
        """
        Actualiza el valor actual de DO llamando al método read_do del sensor.
        """
        self.current_do = self.sensor.read_do()

    def debug_print(self):
        print("===================")
        print(f"{'Oxígeno Disuelto en el Agua:':<40} {self.current_do:.2f} mg/L")
        print(f"{'Cota Superior:':<40} {self.upper_bound:.2f}")
        print(f"{'Cota Inferior:':<40} {self.lower_bound:.2f}")

    def json_serialize_spec(self):
        """
        Serializa las cotas inferior y superior en formato JSON.

        :return: JSON con los límites de DO.
        """
        boundaries = {
            'lower_bound': self.lower_bound,
            'upper_bound': self.upper_bound
        }
        return json.dumps(boundaries)
    
    def json_serialize_status(self):
        """
        Serializa el estado actual de DO en formato JSON.

        :return: JSON con el valor actual de DO.
        """
        status = {
            'current_do': self.current_do
        }
        return json.dumps(status)
