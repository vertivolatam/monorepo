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
I2C_ADDRESS = 0x48

# Crear el bus I2C
bus = smbus2.SMBus(1)

def read_analog(channel):
    # Leer un canal analógico del PCF8591 (0-3)
    bus.write_byte(I2C_ADDRESS, channel)
    return bus.read_byte(I2C_ADDRESS)

try:
    while True:
        # Leer los 4 canales analógicos
        for ch in range(4):
            value = read_analog(ch)
            print(f"Canal {ch}: {value}")
        time.sleep(1)
except KeyboardInterrupt:
    bus.close()
