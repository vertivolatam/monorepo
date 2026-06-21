# Simulator Control UI — panel dev/QA para el simulador de sensores

**Date:** 2026-06-21
**Owner:** Andrés (andres@dojocoding.io)
**Status:** Proposed — diseño aprobado vía brainstorm (visual companion)
**Domain:** `apps/raspberry` (simulador Python) + nueva web UI co-ubicada
**Tracking issue:** _to be created (`area:raspberry` / `area:devtools`)_

---

## Why (Problem)

El simulador de sensores (`apps/raspberry/src/simulation/`) hoy es **CLI headless**: se elige un
escenario al arrancar (`--scenario normal|nutrient_imbalance|…`) y publica a MQTT en un intervalo,
sin forma de **controlarlo en vivo**. Para dev/QA del pipeline (ingestor → backend → `MonitorPhScreen`)
hace falta poder **forzar valores, inyectar anomalías y togglear sensores** sin esperar a que un
escenario derive solo.

Además, **la calibración es parte real del ciclo del producto**: los sensores Atlas EZO arrancan
**sin calibrar** y deben calibrarse antes de vender los invernaderos. El simulador no modela esto hoy,
así que no se puede ejercitar ni demostrar el flujo sin-calibrar → calibrado.

## What (Decisions)

| # | Decisión | Razón |
|---|----------|-------|
| 1 | **Propósito: dev/QA interno funcional** (no demo de alta fidelidad). | Prioriza control fino sobre estética; las referencias Atlas son inspiración funcional. |
| 2 | **Acoplamiento: la UI comanda al simulador Python vía MQTT** (no publica MQTT directo ni edita escenarios). | Reusa el código real del dispositivo → el payload nunca driftea; ejercita los monitores Python. |
| 3 | **Plataforma: web UI en Python (FastAPI) co-ubicada en `apps/raspberry/sim_control/`.** | Mismo repo/lenguaje que el sim; mantiene la herramienta dev FUERA del producto (`vertivo_flutter`). |
| 4 | **Controles: Core (set-target · inject-anomaly · on/off · KILL ALL · intervalo) + calibración.** | Lo mínimo para QA del pipeline + el workflow real de calibración. |
| 5 | **Calibración solo en los EZO aislados (pH·EC·DO·ORP): pH fiel (4/7/10+MTC+slope), EC/DO/ORP estado simple. HUM/CO₂/RTD = factory (sin cal); TDS deriva de EC.** | Los aislados del i3 InterLink son justo los que miden por electrodo → requieren calibración; el resto es de fábrica. Profundidad fiel donde más importa (pH = núcleo nebuponía). |
| 6 | **Layout: grid de instrumentos** (8 tarjetas visibles a la vez) + barra global. | Permite ver/forzar varios sensores en paralelo. |
| 7 | **Topic de control dedicado** `vertivo/sim/greenhouse/{gh}/control` (NO el `command/` de actuadores reales). | No conflar la herramienta dev con el canal de comandos del orquestador real. |
| 8 | **Vista de wiring InterLink interactiva** (segunda vista, tab junto al grid): EZO → InterLink (i3/i4) → Pi, refleja estado (on/off · sin-calibrar · anomalía), click = enable/disable. **Topología config-driven.** | Es requisito: el wiring es parte del modelo mental del dispositivo; el InterLink es el hardware objetivo (el código actual usa multiplexor I2C). |

**In scope (este change):** subscriber de control + setters en vivo + modelo de calibración en el
simulador; la web UI FastAPI con el **grid de instrumentos Y la vista de wiring InterLink interactiva**
(config-driven); el topic/protocolo de comandos; un target Makefile; tests unitarios Python.

**Out of scope:** demo de alta fidelidad (estética Atlas Desktop), **render 3D** de los archivos STEP del
InterLink (la vista de wiring es un esquemático 2D), calibración fiel de los otros 7 sensores,
persistencia del estado del sim entre reinicios, autenticación de la web UI (es dev-only, localhost).

## Open questions for the owner

1. ¿La web UI debe poder **seleccionar/cargar un escenario** (`scenarios.py`) además del control fino, o
   solo control manual en vivo?
2. ¿El sesgo de "sin calibrar" debe ser por-sensor configurable, o un default razonable por tipo?
3. ¿`greenhouse_id`/`user_id` del topic de control se fijan por config (como `mqtt_dev.json`) o se eligen
   en la UI?

## References

- ADR: [`design.md`](./design.md) · Tasks: [`tasks.md`](./tasks.md)
- Referencias de UI capturadas: `docs/superpowers/research/2026-06-21-simulator-ui-references.md`
  (medidor Atlas EZO-pH, Azure RPi sim, InterLink i3/i4, Atlas Desktop).
- Contrato de datos del pipeline: `apps/raspberry/config/current/mqtt_dev.json` (topics) +
  `apps/vertivo_server/lib/src/greenhouses/sensor_ingestion_service.dart` (ingestor).
- Relacionado: slice de pH (`docs/superpowers/plans/2026-06-21-vertivo-ph-monitoring-slice.md`) — este
  panel prueba ese pipeline.
