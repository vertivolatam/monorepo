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
| `{type}` | Tipo de sensor: `co2`, `humidity`, `temperature`, `nutrient_temperature`, `ph`, `ec`, `do`, `orp`, `tds` |

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

Cada mensaje `sensor/*` transporta este JSON (contrato verificado contra el
broker; solo `sensor/*` se persiste — `/telemetry` y `/status` los ignora la ingesta).
Ver también [Flujo de datos](../architecture/data-flow.md#contrato-de-payload-mqtt-ssot).

```json
{
  "value": 22.59,
  "unit": "C",
  "sensorId": "rpi-01/nutrient_temperature",
  "timestamp": 1789964162.4
}
```

| Campo | Tipo | Descripción |
|---|---|---|
| `value` | f64 | Lectura parseada del EZO |
| `unit` | string | `C`, `%`, `ppm`, `pH`, `uS/cm`, `mg/L`, `mV` según métrica |
| `sensorId` | string | `<deviceId>/<metric>` (ej. `rpi-01/ph`) |
| `timestamp` | f64 | Epoch en segundos |
```
