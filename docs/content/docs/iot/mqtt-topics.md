---
title: MQTT Topics
description: Estructura de topics MQTT — vertivo/{userId}/greenhouse/{ghId}/sensor/{type} con categorias environmental y nutrient_solution.
---

# MQTT Topics

La comunicacion entre los dispositivos Raspberry Pi y el backend Serverpod se organiza mediante una estructura jerarquica de topics MQTT que permite filtrar y enrutar mensajes de forma eficiente.

## Estructura de topics

```
vertivo/{userId}/greenhouse/{ghId}/sensor/{type}
```

| Segmento | Descripcion |
|----------|-------------|
| `vertivo` | Prefijo raiz de todos los topics de la plataforma |
| `{userId}` | UUID del usuario propietario del greenhouse |
| `greenhouse` | Literal que indica el recurso |
| `{ghId}` | ID del greenhouse |
| `sensor` | Literal que indica lectura de sensor |
| `{type}` | Tipo de sensor: `co2`, `humidity`, `ph`, `ec`, `do`, `orp`, `tds`, `temperature` |

## Categorias de sensores

### Environmental (Ambiental)

Topics relacionados con las condiciones ambientales del greenhouse:

- `vertivo/{userId}/greenhouse/{ghId}/sensor/co2`
- `vertivo/{userId}/greenhouse/{ghId}/sensor/humidity`
- `vertivo/{userId}/greenhouse/{ghId}/sensor/temperature`

### Nutrient Solution (Solucion nutritiva)

Topics relacionados con las mediciones de la solucion nutritiva:

- `vertivo/{userId}/greenhouse/{ghId}/sensor/ph`
- `vertivo/{userId}/greenhouse/{ghId}/sensor/ec`
- `vertivo/{userId}/greenhouse/{ghId}/sensor/do`
- `vertivo/{userId}/greenhouse/{ghId}/sensor/orp`
- `vertivo/{userId}/greenhouse/{ghId}/sensor/tds`

## Formato del payload

Cada mensaje MQTT transporta un payload JSON con la lectura del sensor, timestamp y metadatos del dispositivo. El formato exacto del payload se detallara una vez estabilizada la interfaz de ingesta.

```json
{
  "value": 6.8,
  "unit": "pH",
  "timestamp": "2026-03-09T12:00:00Z",
  "device_id": "rpi-001"
}
```
