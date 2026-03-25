# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

from src.hardware.sensors.atlas_scientific.EZO_ec_sensor import EZO_ECSensor
import json

class NutrientSolutionECMonitor:
    def __init__(self, lower_bound: float, upper_bound: float, input_EZO_ECSensor: EZO_ECSensor = None):
        """
        Inicializa la clase con las cotas inferior, superior y una instancia del sensor de EC.

        :param lower_bound: Valor mínimo aceptable de EC.
        :param upper_bound: Valor máximo aceptable de EC.
        :param sensor: Instancia del sensor de EC. Si no se pasa, se instancia uno automáticamente.
        """
        self.lower_bound = lower_bound
        self.upper_bound = upper_bound
        self.current_ec = 0.0
        if not hasattr(self, 'sensor'):
            if input_EZO_ECSensor is not None:
                self.sensor = input_EZO_ECSensor
            else:
                self.sensor = EZO_ECSensor()

    def set_current_ec(self, current_ec: float):
        """
        Establece el valor actual de EC.

        :param current_ec: El nuevo valor de EC.
        """
        self.current_ec = current_ec

    def is_below_lower_bound(self) -> bool:
        """
        Evalúa si la EC actual es MENOR O IGUAL a la cota inferior.

        :return: True si la EC actual es MENOR O IGUAL a la cota inferior, False en caso contrario.
        """
        return self.current_ec <= self.lower_bound

    def is_above_lower_bound(self) -> bool:
        """
        Evalúa si la EC actual es MAYOR a la cota inferior.

        :return: True si la EC actual es MAYOR a la cota inferior, False en caso contrario.
        """
        return self.current_ec > self.lower_bound

    def is_below_upper_bound(self) -> bool:
        """
        Evalúa si la EC actual es MENOR a la cota superior.

        :return: True si la EC actual es MENOR a la cota superior, False en caso contrario.
        """
        return self.current_ec < self.upper_bound

    def is_above_upper_bound(self) -> bool:
        """
        Evalúa si la EC actual es MAYOR O IGUAL a la cota superior.

        :return: True si la EC actual es MAYOR O IGUAL a la cota superior, False en caso contrario.
        """
        return self.current_ec >= self.upper_bound

    def read_ec(self):
        """
        Actualiza el valor actual de EC llamando al método read_ec del sensor.
        """
        self.current_ec = self.sensor.read_ec()
    
    def debug_print(self):
        print("===================")
        print(f"{'Electro-conductividad:':<40} {self.current_ec:.2f} µS/cm")
        print(f"{'Cota Superior:':<40} {self.upper_bound:.2f}")
        print(f"{'Cota Inferior:':<40} {self.lower_bound:.2f}")
        
    def json_serialize_spec(self):
        """
        Serializa las cotas inferior y superior en formato JSON.

        :return: JSON con los límites de EC.
        """
        boundaries = {
            'lower_bound': self.lower_bound,
            'upper_bound': self.upper_bound
        }
        return json.dumps(boundaries)
    
    def json_serialize_status(self):
        """
        Serializa el estado actual de EC en formato JSON.

        :return: JSON con el valor actual de EC.
        """
        status = {
            'current_ec': self.current_ec
        }
        return json.dumps(status)
