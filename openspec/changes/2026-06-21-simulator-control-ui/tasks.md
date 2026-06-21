# Simulator Control UI — Tasks

> Plan por fases. Cada fase deja algo verificable. Python en `apps/raspberry`; web UI nueva en
> `apps/raspberry/sim_control/`. Toolchain Python vía el `.venv` del raspberry (lint con `ruff`,
> `make dev-raspberry-lint`).

## Phase 0 — Setters en vivo en el simulador
- [ ] `SimulatedSensorBase`: añadir `set_target(mean)`, `inject_anomaly(magnitude)`, `enable(bool)` + flag `_enabled`.
- [ ] `read()`/loop: respetar `_enabled` (no publicar si está off).
- [ ] Test unit: cada setter cambia el comportamiento esperado (target mueve la media; anomaly mete spike; disabled no publica).

## Phase 1 — Modelo de calibración (solo EZO aislados: pH · EC · DO · ORP)
- [ ] `SimulatedSensorBase`: `requires_calibration: bool` (default False) + estado `calibrated: bool` + `bias`/`slope`; `read()` aplica sesgo solo si `requires_calibration and not calibrated`.
- [ ] Marcar `requires_calibration=True` en **pH, EC, DO, ORP**. **HUM, CO₂, RTD** quedan factory (`requires_calibration=False`, siempre 🟢). **TDS** deriva de EC (sin estado propio; usa el de EC).
- [ ] EC/DO/ORP: `calibrate()` (sin args) → `calibrated=True`, sesgo a 0.
- [ ] `SimulatedPHSensor`: `calibrate(point, value)` con `point ∈ {low,mid,high}`; offset desde `mid`, `slope%` desde par low/high; `mtc(temp)` afecta la lectura.
- [ ] Tests: pH offset tras `mid`, slope tras low+high; EC/DO/ORP simple-flip quita sesgo; HUM/CO₂/RTD nunca sesgan; TDS sigue a EC; default de sesgo por tipo.

## Phase 2 — Dispatcher + subscriber de control
- [ ] `_dispatch(command: dict)` puro: mapea `{sensor, action, ...}` y acciones globales (`kill_all`, `set_interval`) a efectos en el modelo. Sensor/acción desconocida → log + no-op.
- [ ] `Simulator`: subscriber MQTT al topic `vertivo/sim/greenhouse/{gh}/control` → `_dispatch`. Loop respeta `kill_all`.
- [ ] Tests: `_dispatch` para cada acción (JSON → efecto); `kill_all` detiene publish; `set_interval` cambia el intervalo.

## Phase 3 — Web UI: server + grid
- [ ] `apps/raspberry/sim_control/server.py` (FastAPI): sirve `index.html`; `POST /control` valida + publica JSON a MQTT (paho); suscribe `sensor/#` → SSE al navegador.
- [ ] `apps/raspberry/sim_control/index.html` + JS vanilla: barra global (estado MQTT · intervalo · KILL ALL) + grid de 8 tarjetas (valor vivo · color · target · anomalía · on/off); tarjeta pH con calibración (4/7/10 · MTC · slope).
- [ ] `requirements.txt`: añadir `fastapi`, `uvicorn` (paho-mqtt ya está).
- [ ] Verificar: levantar server → publicar un comando desde la UI → ver el efecto en MQTT (mosquitto_sub).

## Phase 4 — Vista de wiring InterLink (config-driven)
- [ ] `sim_control/topology.yaml`: mapa `sensor → {interlink: i3|i4, port}` (default del design.md; TDS derivado de EC).
- [ ] Render 2D en `index.html` (toggle "Instrumentos | Wiring"): nodos EZO → InterLinks → Pi, color = mismo estado del grid.
- [ ] Click en sensor del wiring = enable/disable (mismo comando que el grid). Sensor sin mapear → "sin asignar".

## Phase 5 — Makefile + E2E
- [ ] Target `dev-raspberry-sim-ui` (levanta el FastAPI server, p.ej. localhost:8090) + entrada en help/.PHONY.
- [ ] E2E manual: sim + sim-ui + `dev-all-port-forward` → forzar pH fuera de rango / dejar sin calibrar → `Alert` en `MonitorPhScreen`.
- [ ] `dev-raspberry-lint` (ruff) limpio sobre `sim_control/` y `simulation/`.

## Done when
- [ ] El panel controla el simulador en vivo (target/anomaly/on-off/kill/intervalo) vía MQTT.
- [ ] Calibración: pH fiel (4/7/10+MTC+slope), otros 7 estado simple; sin-calibrar publica sesgo.
- [ ] Grid + wiring InterLink interactivo (config-driven) reflejan el mismo estado.
- [ ] Tests Python verdes; `openspec/README.md` lista este change.
