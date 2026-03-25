# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

import board
import busio
from adafruit_mcp230xx.mcp23017 import MCP23017
import smbus2

# Inicializa el bus I2C
i2c = busio.I2C(board.SCL, board.SDA)

# Configura MCP23017
mcp = MCP23017(i2c)
pin0 = mcp.get_pin(0)
pin0.switch_to_output(value=False)  # Configura pin 0 como salida

# Configura PCF8591
PCF8591_ADDRESS = 0x48
i2c_bus = smbus2.SMBus(1)  # Para Raspberry Pi o microcontroladores con I2C

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

# Ejemplo de uso
pin0.value = True  # Enciende el pin 0 en el MCP23017
print(f"Lectura del canal 0 del PCF8591: {read_analog(0)}")
