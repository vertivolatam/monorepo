# Canonicalización de setpoints — Tasks

> Remediación del audit SCH 2026-06-25. Es la Fase Pre-0 de `2026-06-25-multinode-data-architecture`.

## Fase 1 — Modelo canónico
- [ ] Definir `setpoint` (`apps/vertivo_server/lib/src/setpoints/setpoint.spy.yaml`) con `scope`/`policy`/`unit`/`lower`/`upper`/`source` + campos de provenance.
- [ ] Vocabulario `policy` desambiguado (air_temperature ≠ solution_temperature; EC/DO/ORP/TDS de primera clase).
- [ ] Tests del modelo + de resolución de valor efectivo (precedencia crop_default < greenhouse < stage < edge).

## Fase 2 — Migración sin pérdida
- [ ] SQL migration controlada que crea `setpoint` (NO regenerar Serverpod a ciegas — ver incidente `idealCo2`).
- [ ] Backfill desde `crop_models.ideal*`, `greenhouses.*Min/Max`, `growth_stage_definitions.*Override`, parse de `config/*.json`, y `crops.db setpoints` si disponible.
- [ ] Marcar columnas viejas como deprecated (un release) → dropear después.

## Fase 3 — Consumo edge
- [ ] El orquestador del Pi (`src/config.py`, `orchestrators/*/orchestrator.py`) lee bounds del canónico (vía réplica libSQL del change multinode); `defaults/*.json` → seed.
- [ ] Portar `setpoint_audit` (provenance + rollback) de crops.db al modelo canónico.

## Fase 4 — Gobernanza (cures del audit)
- [ ] CODEOWNERS: owner canónico = lapc506 (C1).
- [ ] CI guard anti-reaparición de bounds fuera del canónico (C2).
- [ ] Regla atómica + hook PreToolUse exigiendo provenance en edits de bound en el edge (C3/C4).

## Done when
- [ ] Un solo `setpoint` es la fuente de verdad; 0 columnas/keys de bound fuera de él (CI verde).
- [ ] EC/DO/ORP/TDS gobernables desde el cloud; temperatura desambiguada (aire vs solución).
- [ ] Provenance de cada bound auditable; el Pi lee del canónico, no de los JSON.
