# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

from src.hardware.sensors.atlas_scientific.EZO_tds_sensor import EZO_TDSSensor
import json

class NutrientSolutionTDSMonitor:
    def __init__(self, lower_bound: float, upper_bound: float, input_EZO_TDSSensor: EZO_TDSSensor = None):
        """
        Inicializa la clase con las cotas inferior, superior y una instancia del sensor de TDS.

        :param lower_bound: Valor mínimo aceptable de TDS.
        :param upper_bound: Valor máximo aceptable de TDS.
        :param input_EZO_TDSSensor: Instancia del sensor de TDS. Si no se pasa, se instancia uno automáticamente.
        """
        self.lower_bound = lower_bound
        self.upper_bound = upper_bound
        self.current_tds = 0.0
        if not hasattr(self, 'sensor'):
            if input_EZO_TDSSensor is not None:
                self.sensor = input_EZO_TDSSensor
            else:
                self.sensor = EZO_TDSSensor()

    def set_current_tds(self, current_tds: float):
        """
        Establece el valor actual de TDS.

        :param current_tds: El nuevo valor de TDS.
        """
        self.current_tds = current_tds

    def is_below_lower_bound(self) -> bool:
        """
        Evalúa si el TDS actual es MENOR O IGUAL a la cota inferior.

        :return: True si el TDS actual es MENOR O IGUAL a la cota inferior, False en caso contrario.
        """
        return self.current_tds <= self.lower_bound

    def is_above_lower_bound(self) -> bool:
        """
        Evalúa si el TDS actual es MAYOR a la cota inferior.

        :return: True si el TDS actual es MAYOR a la cota inferior, False en caso contrario.
        """
        return self.current_tds > self.lower_bound

    def is_below_upper_bound(self) -> bool:
        """
        Evalúa si el TDS actual es MENOR a la cota superior.

        :return: True si el TDS actual es MENOR a la cota superior, False en caso contrario.
        """
        return self.current_tds < self.upper_bound

    def is_above_upper_bound(self) -> bool:
        """
        Evalúa si el TDS actual es MAYOR O IGUAL a la cota superior.

        :return: True si el TDS actual es MAYOR O IGUAL a la cota superior, False en caso contrario.
        """
        return self.current_tds >= self.upper_bound

    def read_tds(self):
        """
        Actualiza el valor actual de TDS llamando al método read_tds del sensor.
        """
        self.current_tds = self.sensor.read_tds()

    def debug_print(self):
        print("===================")
        print(f"{'Total de Sólidos Disueltos:':<40} {self.current_tds:.2f} mg/L")
        print(f"{'Cota Superior:':<40} {self.upper_bound:.2f}")
        print(f"{'Cota Inferior:':<40} {self.lower_bound:.2f}")

    def json_serialize_spec(self):
        """
        Serializa las cotas inferior y superior en formato JSON.

        :return: JSON con los límites de TDS.
        """
        boundaries = {
            'lower_bound': self.lower_bound,
            'upper_bound': self.upper_bound
        }
        return json.dumps(boundaries)
    
    def json_serialize_status(self):
        """
        Serializa el estado actual de TDS en formato JSON.

        :return: JSON con el valor actual de TDS.
        """
        status = {
            'current_tds': self.current_tds
        }
        return json.dumps(status)
