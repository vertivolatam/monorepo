---
title: Sensores
description: 8 sensores Atlas Scientific EZO conectados via bus I2C al Raspberry Pi.
---

# Sensores Atlas Scientific EZO

Vertivo utiliza **8 sensores Atlas Scientific de la linea EZO** conectados al Raspberry Pi via **bus I2C**. Estos sensores cubren las variables ambientales y de solucion nutritiva necesarias para el monitoreo de cultivos en ambientes controlados.

## Sensores disponibles

| Sensor | Modelo EZO | Direccion I2C | Categoria |
|--------|-----------|---------------|-----------|
| CO2 | EZO-CO2 | `0x69` | Ambiental |
| Humidity | EZO-HUM | `0x6F` | Ambiental |
| RTD Temperature | EZO-RTD | `0x66` | Ambiental |
| pH | EZO-pH | `0x63` | Solucion nutritiva |
| EC (Conductividad) | EZO-EC | `0x64` | Solucion nutritiva |
| DO (Oxigeno disuelto) | EZO-DO | `0x61` | Solucion nutritiva |
| ORP (Redox) | EZO-ORP | `0x62` | Solucion nutritiva |
| TDS (Solidos disueltos) | EZO-EC* | `0x64` | Solucion nutritiva |

> *TDS se calcula a partir de la lectura de EC con un factor de conversion configurable.

## Bus I2C

Todos los sensores se comunican por el bus I2C del Raspberry Pi. Cada sensor tiene una direccion unica que permite leerlos secuencialmente desde un solo bus. El protocolo de comunicacion sigue el formato de comandos ASCII de Atlas Scientific.

## Clases base

El codigo Python del Raspberry Pi define una clase base `AtlasI2C` que encapsula la comunicacion I2C con los sensores EZO. Cada sensor hereda de esta clase y agrega la logica de calibracion y parsing especifica de su tipo de medicion.

```python
class AtlasI2C:
    """Clase base para comunicacion I2C con sensores Atlas Scientific EZO."""
    def __init__(self, address: int, bus: int = 1):
        # Inicializacion del bus I2C
        pass

    def read(self) -> str:
        # Lectura del sensor
        pass
```
