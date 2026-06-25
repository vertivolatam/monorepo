# Canonicalización de setpoints — Architecture (ADR)

**Issue:** _to be created_ (`area:server` / `area:raspberry`)
**Status:** Decision 2026-06-25 (remediación SCH)
**PDR:** [`proposal.md`](./proposal.md)

## TL;DR

Un solo modelo `setpoint` (Postgres/Serverpod) es la fuente de verdad de todos los bounds agronómicos.
Las 5 superficies actuales se reducen a: **canónico** (SQL) → **proyección** (libSQL, change multinode) →
**seed** (`defaults/*.json`). El vocabulario de `policy` (atributo gobernado) desambigua magnitud y unidad.

## 1. Modelo canónico

```
setpoint
  id
  scope            : enum(crop_model | greenhouse | growth_stage)   # a qué aplica
  scope_ref_id     : FK al crop_model / greenhouse / growth_stage
  policy           : enum  # vocabulario único y desambiguado:
                     air_temperature | solution_temperature | humidity | photoperiod_hours
                     | co2 | ph | ec | do | orp | tds
  unit             : text  # explícita (°C, %, µS/cm, mg/L, mV, ppm, h)
  lower_bound      : double
  upper_bound      : double
  source           : enum(crop_default | greenhouse_override | stage_override | edge_override)
  -- provenance (portado de crops.db setpoint_audit):
  mechanism        : enum(mobile_app|local_web_ui|local_python_ui|ssh|manual_file_edit|api|projection)
  actor, reason, channel, applied_at, version, is_active, warranty_void
```

Resuelve los 7 findings: una fila por (scope, scope_ref, policy) → no más `idealPhMin` vs `phMin` vs
`…Override` vs `nutrient_solution_ph_input_lower_bound`. EC/DO/ORP/TDS son `policy` de primera clase
(SCH-006). `air_temperature` ≠ `solution_temperature` (SCH-004). `unit` explícita (SCH-005).

## 2. Mapeo de las superficies viejas → canónico

| Vieja | scope | policy | source |
|---|---|---|---|
| `crop_models.idealPhMin/Max` | crop_model | ph | crop_default |
| `greenhouses.phMin/Max` | greenhouse | ph | greenhouse_override |
| `growth_stage_definitions.*Override` | growth_stage | (temp/humidity/photoperiod) | stage_override |
| `config/*.json *_input_*_bound` | greenhouse | (mapear nombre) | edge_override (seed) |
| `crops.db setpoints(field,value)` | crop_model | (field→policy) | crop_default |

## 3. Resolución de valor efectivo (precedencia)

`crop_default` < `greenhouse_override` < `stage_override` < `edge_override` (con provenance). El `reported`
del device-shadow es el efectivo que corre el Pi; el `desired` es el canónico cloud. Reconciliación con
precedencia cloud (ver change multinode, ADR-5).

## 4. Migración (sin pérdida)

1. Crear `setpoint` (SQL migration controlada — NO regenerar ciegamente; recordar el incidente `idealCo2`).
2. Backfill desde las 3 tablas SQL + parse de los JSON del Pi + (si disponible) `crops.db`.
3. Dejar las columnas viejas como **deprecated** (lectura) un release; luego dropear.
4. El orquestador del Pi pasa a leer de la réplica libSQL; `defaults/*.json` queda como seed.

## 5. Gobernanza (cures del audit)

CODEOWNERS (owner = lapc506) + CI guard anti-reaparición de bounds fuera del canónico + hook PreToolUse que
exige provenance en cualquier edición de bound en el edge. Ver cure proposals C1–C4 del audit.
