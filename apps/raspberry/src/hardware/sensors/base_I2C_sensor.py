# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

import smbus2
import time

# Dirección I2C del PCF8591
PCF8591_ADDRESS = 0x48

# Inicializa el bus I2C
i2c_bus = smbus2.SMBus(1)  # En Raspberry Pi, el bus I2C es generalmente 1

def read_analog(channel):
    """Lee un canal analógico del PCF8591 (0-3)"""
    if channel < 0 or channel > 3:
        raise ValueError("El canal debe estar entre 0 y 3")
    
    # Escribe la dirección del canal al que queremos acceder
    i2c_bus.write_byte(PCF8591_ADDRESS, channel)
    
    # Lee el valor analógico del PCF8591 (el primer valor es de referencia, ignorarlo)
    i2c_bus.read_byte(PCF8591_ADDRESS)
    
    # Lee el valor analógico real
    value = i2c_bus.read_byte(PCF8591_ADDRESS)
    return value

# Leer los 4 canales del PCF8591
for channel in range(4):
    analog_value = read_analog(channel)
    print(f"Valor en canal {channel}: {analog_value}")
    time.sleep(0.5)
