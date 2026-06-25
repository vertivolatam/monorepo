# Canonicalización de setpoints/bounds del orquestador (remediación SCH)

**Date:** 2026-06-25
**Owner:** Andrés (andres@dojocoding.io) · canonical owner propuesto: lapc506
**Status:** Proposed — remediación emitida por el audit SCH 2026-06-25
**Domain:** `apps/vertivo_server` (modelo canónico) + `apps/raspberry` (seed/consumo) + `crop_explorer`
**Tracking issue:** _to be created (`area:server` / `area:raspberry` / `type:tech-debt`)_

---

## Why (Problem)

El audit de schema drift ([`docs/repo-health/SCH-audit-2026-06-25.md`](../../../docs/repo-health/SCH-audit-2026-06-25.md))
confirmó **7 findings** (4 high): el mismo bound/setpoint de sensor está realizado de forma inconsistente
en **5 superficies sin source-of-truth** — `crop_models`, `greenhouses`, `growth_stage_definitions` (SQL),
JSON del Pi (`config/{current,defaults}/*.json`) y `setpoints` (crops.db). Renombrado en cada superficie
(`idealPhMin` / `phMin` / `…Override` / `nutrient_solution_ph_input_lower_bound` / `setpoints.field`) → el
drift es semántico y no gobernado. Casos agravantes: "temperature" cubre dos magnitudes (aire vs solución,
SCH-004); EC/DO/ORP/TDS solo viven en el Pi sin hogar canónico (SCH-006).

## What (Decisions)

| # | Decisión | Razón |
|---|----------|-------|
| 1 | **Un modelo canónico `setpoint`** (Postgres/Serverpod write model) como única fuente de verdad de bounds. | Mata el drift en raíz (1NF / DRY / single owner). |
| 2 | **Desambiguar magnitudes**: `air_temperature` vs `solution_temperature`, unidad explícita por bound. | SCH-004/005 mezclan magnitudes/unidades bajo el mismo nombre coloquial. |
| 3 | **Incluir EC/DO/ORP/TDS** en el canónico (hoy solo en JSON del Pi). | SCH-006: el cloud/móvil no puede gobernar los parámetros más críticos de la nebuponía. |
| 4 | **JSON del Pi → seed derivado, no fuente.** `defaults/*.json` = bootstrap; `current/*.json` reemplazado por la réplica libSQL (ver change multinode). | Alinea con CQRS + device-shadow del change `2026-06-25-multinode-data-architecture`. |
| 5 | **Reusar `setpoint_audit`** (provenance + rollback `is_active`) de crops.db como base del provenance del device-shadow. | Ya existe el patrón; portarlo evita reinventar. |
| 6 | **Owner canónico = lapc506** + CODEOWNERS + CI guard anti-reaparición. | SCH-007: hoy hay múltiples escritores sin dueño. |

**In scope:** modelo canónico + migración de las 5 superficies + CODEOWNERS/CI guard + mapeo de los
nombres viejos al canónico.

**Out of scope:** la implementación del sync libSQL/proyección (vive en el change multinode, Fases 0–3);
la UI de edición de setpoints (device-shadow, Fase 3).

## Open questions for the owner

1. ¿`crop_models` (catálogo) y `greenhouses` (instancia) se unifican bajo un solo `setpoint` con scope
   (`crop` | `greenhouse` | `growth_stage`), o se mantienen separados referenciando el mismo vocabulario de `policy`?
2. ¿La migración preserva los valores actuales del Pi (`current/*.json`) como override inicial, o se
   resetea a los `ideal*` del crop_model?

## References

- Audit: [`docs/repo-health/SCH-audit-2026-06-25.md`](../../../docs/repo-health/SCH-audit-2026-06-25.md)
- Épica: [`2026-06-25-multinode-data-architecture`](../2026-06-25-multinode-data-architecture/) (Fase Pre-0)
- ADR: [`design.md`](./design.md) · Tasks: [`tasks.md`](./tasks.md)
