# Simulator Control UI — Architecture

**Issue:** _to be created_ (`area:raspberry` / `area:devtools`)
**Status:** Decision 2026-06-21 (brainstorm aprobado)
**PDR:** [`proposal.md`](./proposal.md)

## TL;DR

Una web UI en Python (FastAPI, en `apps/raspberry/sim_control/`) comanda al simulador de sensores
**vía MQTT** (topic de control dedicado). El simulador gana un *subscriber* de control + *setters* en
vivo + un modelo de calibración (pH fiel 4/7/10+MTC+slope; otros 7 = estado sin-calibrar/calibrado).
La UI tiene dos vistas del mismo estado: **grid de instrumentos** y **wiring InterLink interactivo**
(topología config-driven). Propósito: dev/QA del pipeline ingestor → backend → `MonitorPhScreen`.

## 1. Arquitectura — el loop de comando

```
Web UI (FastAPI + JS, navegador localhost)
  │  POST /control  → el server publica JSON (paho) a MQTT
  ▼
EMQX :1883   topic control:  vertivo/sim/greenhouse/{gh}/control
  │  el Simulador se SUSCRIBE (hoy solo publica → se le añade subscriber)
  ▼
Simulador Python  → muta Simulated*Sensor en vivo (target/anomaly/on-off/calibración)
  │  publish normal de sensores (payload REAL):  vertivo/{u}/greenhouse/{gh}/sensor/{tipo}
  ▼
EMQX → SensorIngestionService → backend → app
       └──────── la web UI también se suscribe a sensor/#  → refleja valores REALES en el grid/wiring
```

La UI **cierra el lazo**: muestra lo que el simulador realmente publica, no solo lo pedido. Es la fuente
de verdad visual.

## 2. Protocolo de comandos

Topic dedicado (separado del `command/` de actuadores reales del orquestador):
`vertivo/sim/greenhouse/{greenhouseId}/control`. Payload JSON, una acción por mensaje:

```json
{ "sensor": "ph", "action": "set_target", "value": 6.2 }
{ "sensor": "ph", "action": "inject_anomaly", "magnitude": 3.0 }
{ "sensor": "ec", "action": "enable", "on": false }
{ "action": "kill_all" }
{ "action": "set_interval", "seconds": 10 }
{ "sensor": "ph", "action": "calibrate", "point": "mid", "value": 7.0 }   // pH fiel: low|mid|high
{ "sensor": "do", "action": "calibrate" }                                  // simple: marca calibrado
```

`greenhouseId`/`userId` salen de config (como `mqtt_dev.json`). Acciones sin `sensor` son globales.

## 3. Cambios en el simulador Python (`apps/raspberry/src/simulation/`)

- **`SimulatedSensorBase`** gana estado y setters: `set_target(mean)`, `inject_anomaly(mag)`,
  `enable(bool)`, y estado de calibración (ver §5). `read()` aplica el sesgo de calibración.
- **`Simulator`** gana un *subscriber* MQTT al topic de control + un `_dispatch(command)` que mapea cada
  acción a un setter del sensor o a estado global (`kill_all` → flag que el loop respeta; `set_interval`
  → ajusta `mqtt_publish_interval`). El loop de publish **salta** sensores `enable=False` y, si
  `kill_all`, no publica nada.
- El `_dispatch` es puro/testeable (JSON dict → efecto en el modelo), aislado del transporte MQTT.

## 4. Web UI (`apps/raspberry/sim_control/`)

- **`server.py` (FastAPI)**: sirve `index.html`; endpoint `POST /control` que valida y publica el JSON a
  MQTT (cliente paho); se suscribe a `sensor/#` y empuja valores al navegador por **SSE** (simple) o
  WebSocket. Estado en memoria (dev-only, sin auth).
- **`index.html` + JS vanilla** (sin framework): barra global (● estado MQTT · Intervalo ▾ · ⏻ KILL ALL)
  + **toggle de vista**:
  - **Grid de instrumentos**: 8 tarjetas (valor en vivo · color de estado · target slider · ⚡anomalía ·
    On/Off). La tarjeta pH expande la calibración fiel (4/7/10 · MTC · slope%).
  - **Wiring InterLink** (§6).
- **Target Makefile** `dev-raspberry-sim-ui` → levanta el server (p.ej. localhost:8090).

## 5. Modelo de calibración

Todos los sensores arrancan **sin calibrar** → `read()` devuelve la lectura con **sesgo** (offset +
slope degradado) y bandera de baja confianza. La UI lo marca 🟡.

- **pH (fiel)**: puntos `low (4.0) / mid (7.0) / high (10.0)`. `calibrate(point, value)` captura un punto;
  el offset se fija con `mid`, el `slope%` se deriva del par low/high (ideal ≈ 59.16 mV/pH a 25 °C = 100%).
  **MTC** (temperatura manual) corrige la lectura. 1 punto = offset; 2–3 puntos = slope + rango.
- **Otros 7 (estado simple)**: `calibrate` (sin args) voltea `sin-calibrar → calibrado` y elimina el
  sesgo de un paso. Sin química de soluciones de referencia.

El sesgo "sin calibrar" por tipo tiene un default razonable (open question #2 del PDR).

## 6. Vista de wiring InterLink (interactiva, config-driven)

- **Topología desde config** (`sim_control/topology.yaml` o similar): mapa `sensor → {interlink: i3|i4,
  port: N}`. Default: `i4 #1 = pH·EC·DO·ORP`, `i3 #2 = RTD·HUM·CO₂`; **TDS = derivado de EC** (no nodo
  físico). No hardcodear — el InterLink es hardware objetivo y la topología real puede cambiar.
- **Render**: esquemático 2D — nodos EZO → cajas InterLink → Raspberry Pi (I²C/UART). Cada nodo refleja
  el **mismo estado** que el grid (🟢 activo · ⚪ off · 🟡 sin-calibrar · 🔴 anomalía).
- **Interacción**: click en un sensor = `enable/disable` (publica el comando, espejo del grid). Es una
  segunda vista del mismo estado, no un modelo aparte.

## 7. Errores / edge cases

- Comando a sensor desconocido o JSON inválido → log + ignorar (nunca tumbar el sim).
- `KILL ALL` = estado seguro: no publica nada hasta re-enable; UI en rojo.
- UI sin EMQX → banner "MQTT desconectado", controles deshabilitados.
- Sensor `enable=False` → tarjeta/nodo atenuado; no publica.
- Topología con sensor sin mapear → se muestra "sin asignar", no rompe el render.

## 8. Testing

- **Python (unit):** `set_target`/`inject_anomaly`/`enable`; modelo de calibración pH (offset tras `mid`,
  slope tras low/high) y simple (flip quita sesgo); `_dispatch` (JSON → efecto); el loop respeta
  `enable=False` y `kill_all`.
- **Manual E2E:** `make dev-raspberry-i2c-sim` + `make dev-raspberry-sim-ui` + `dev-all-port-forward` →
  desde el panel forzar pH fuera de rango (o dejar pH sin calibrar) → ver el `Alert` en `MonitorPhScreen`.

## References

- PDR: [`proposal.md`](./proposal.md) · Tasks: [`tasks.md`](./tasks.md)
- Referencias UI: `docs/superpowers/research/2026-06-21-simulator-ui-references.md`.
- Ingestor/contrato: `apps/vertivo_server/lib/src/greenhouses/sensor_ingestion_service.dart`,
  `apps/raspberry/config/current/mqtt_dev.json`.
