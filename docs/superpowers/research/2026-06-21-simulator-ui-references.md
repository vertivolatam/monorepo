# Referencias para la UI del simulador de Raspberry (track aparte)

- **Fecha:** 2026-06-21
- **Estado:** Material de referencia — pendiente de brainstorm propio antes de cualquier OpenSpec/implementación.
- **Origen:** Aportado por el owner mientras se diseñaba el slice de pH. NO bloquea ese slice.
- **Relación:** El simulador headless (`apps/raspberry/src/simulation/`) ya basta para el slice de pH; esto es una capa de control/visualización opcional encima.

## Qué es este track

Una UI de **control y demo** del simulador: permite manipular sensores en vivo (sin
hardware) y ver/forzar la telemetría que se publica a MQTT. Audiencia probable: dev/QA y
**demos a inversionistas** (mostrar el pipeline sin esperar a que un escenario derive solo).

## Fuentes

1. **Raspberry Pi Azure IoT Online Simulator**
   - Repo: https://github.com/Azure-Samples/raspberry-pi-web-simulator
   - Demo: https://azure-samples.github.io/raspberry-pi-web-simulator/
   - Aporta el **layout de página**: panel izquierdo = protoboard/wiring (fritzing-style con
     Pi + sensor + LED); panel derecho = editor/datos en vivo + botones **Run / Reset** +
     consola de telemetría en streaming.
2. **Atlas Scientific — EZO™ pH Circuit**
   - https://atlas-scientific.com/embedded-solutions/ezo-ph-circuit/
   - Datasheets, **archivos 3D**, pinout del carrier board aislado. Mina durante el brainstorm
     para los diagramas de sensor y el pinout (VCC, OFF, GND, TX/RX o PRB/PGND).

## Vocabulario de UI extraído (del medidor de mesa Atlas — imagen 3)

Cada **instrumento** (uno por sensor Atlas) debería exponer:

| Elemento | Función | Mapea a (simulador) |
|----------|---------|---------------------|
| Valor gigante + unidad (`9.23` `pH`) | Lectura en vivo | valor actual de `SimulatedSensorBase` |
| Temperatura / **MTC** | Compensación de temp manual | param de temperatura del escenario |
| **Read** | Lectura puntual | publish único a MQTT |
| **Timed Reading** + perilla intervalo + On/Off | Lectura periódica | `mqtt_publish_interval` / loop de publish |
| **On/Off** por sensor | **Kill switch** individual | habilita/deshabilita publish de ese sensor |
| **Calibración** (4.0 / 7.0 / 10.0) | Puntos de calibración | offset/cosmético (o modelar calibración) |
| **Slope** (mV, %) | Salud de la sonda | métrica derivada/simulada |
| Extended Range | Modo rango extendido | flag de escenario |

## Requisitos adicionales pedidos por el owner

- **Kill switches** — además de los On/Off por sensor (imagen 3), un **paro de emergencia
  global** (detiene todo publish). Falta en el sim de Azure.
- **Diagramas de los sensores Atlas Scientific** (pH, EC, DO, ORP, RTD, CO₂…) — panel de
  wiring tipo imagen 1, usando el carrier board EZO (imagen 2) y los **archivos 3D** de Atlas.
- Cobertura de los sensores que ya existen en `apps/raspberry/src/monitors/atlas_scientific/`
  (pH, EC, TDS, DO, ORP, temp de solución, CO₂, humedad).

## Mapeo al simulador existente (para el brainstorm)

- `apps/raspberry/src/simulation/simulated_sensors.py` — `SimulatedSensorBase(mean, std,
  anomaly_probability, anomaly_magnitude, reversion_rate, diurnal_*)`. La UI manipularía estos.
- `apps/raspberry/src/simulation/scenarios.py` — `SCENARIOS` (`normal`, `heat_wave`,
  `nutrient_imbalance`…). La UI podría seleccionar/editar escenarios.
- Publish a MQTT vía `networking/` → topics `vertivo/{user}/greenhouse/{gh}/sensor/{type}`.

## Preguntas a resolver en el brainstorm (antes de OpenSpec)

1. **Audiencia primaria:** ¿dev/QA, demo a inversionistas, o ambas? (define fidelidad visual).
2. **Plataforma:** ¿pantalla dev dentro de `vertivo_flutter`, app/web Flutter aparte, o TUI?
3. **Acoplamiento:** ¿la UI manipula `scenarios.py`/params del simulador Python, o publica
   directo a MQTT por su cuenta? (¿quién es la fuente de verdad?)
4. **Alcance de calibración/slope:** ¿cosmético (demo) o se modela de verdad?
5. **Kill switch global:** ¿solo detiene publish, o también un "estado seguro" por sensor?
6. ¿Se reusan los **archivos 3D** de Atlas para los diagramas, o íconos/SVG propios?
