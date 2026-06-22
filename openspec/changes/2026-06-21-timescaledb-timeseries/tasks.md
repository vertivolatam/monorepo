# TimescaleDB time-series — Tasks

> **SPEC ONLY hasta aprobación.** Ninguna casilla se ejecuta antes del gate `design-approval`.
> Resolver primero las Open Questions del ADR (OQ1–OQ7), en especial OQ1 (imagen), OQ4
> (vehículo del SQL custom) y OQ5 (PK de la hypertable, riesgo R1).
> Status: **Proposed — pendiente aprobación.**

## Fase 0 — Decisiones previas (gate)
- [ ] Cerrar OQ1: imagen elegida (recomendada: `timescale/timescaledb-ha:pg16` + pgvector).
- [ ] Cerrar OQ4: vehículo del SQL custom (recomendado: Kubernetes `Job` idempotente en `k8s/`).
- [ ] Cerrar OQ5/R1: estrategia para la PK de la hypertable frente al DDL Serverpod.
- [ ] Confirmar dev-first vs incluir prod (OQ7).

## Fase 1 — Imagen Postgres (overlay dev)
- [ ] Construir/seleccionar la imagen con `timescaledb` **y** `pgvector` (según OQ1).
- [ ] `k8s/base/database/deployment.yaml`: apuntar `image:` a esa imagen; verificar
      `shared_preload_libraries=timescaledb` (R3).
- [ ] Verificar arranque: pod `postgres` `Running`, `pg_isready` OK, `\dx` lista `timescaledb` y `vector` (R4).
- [ ] Commit: `feat(k8s): postgres image with timescaledb + pgvector (dev overlay)`.

## Fase 2 — SQL custom: hypertable
- [ ] Escribir `.sql` idempotente versionado (ubicación según OQ4): `CREATE EXTENSION IF NOT EXISTS timescaledb;`.
- [ ] `create_hypertable('environmental_readings','createdAt', if_not_exists=>TRUE, migrate_data=>TRUE)` con el chunk interval de OQ2.
- [ ] Resolver R1 (PK): aplicar la estrategia de OQ5 sin romper el esquema que regenera Serverpod.
- [ ] Verificar: `SELECT * FROM timescaledb_information.hypertables` muestra la tabla; inserts vía MQTT siguen funcionando.
- [ ] Commit: `feat(db): convert environmental_readings to hypertable (SQL custom)`.

## Fase 3 — Continuous aggregates 1m / 5m / 1h
- [ ] Crear `environmental_readings_1m` / `_5m` / `_1h` (`time_bucket` + avg/min/max/count, group by `greenhouseId,measurementType`).
- [ ] `add_continuous_aggregate_policy` por vista (refresco incremental).
- [ ] Decidir `real_time` aggregate o no (R6, borde de ventana).
- [ ] Verificar: las vistas se pueblan y refrescan; comparar contra agregación manual de crudos.
- [ ] Commit: `feat(db): continuous aggregates 1m/5m/1h for environmental_readings`.

## Fase 4 — Compresión + retención
- [ ] `ALTER TABLE ... SET (timescaledb.compress, compress_segmentby='"greenhouseId","measurementType"')`.
- [ ] `add_compression_policy` (intervalo de OQ3) + `add_retention_policy` (intervalo de OQ3).
- [ ] Confirmar que la retención de crudos **no** afecta los continuous aggregates.
- [ ] Verificar: `timescaledb_information.jobs` lista las policies; chunks viejos se comprimen.
- [ ] Commit: `feat(db): compression + retention policies for telemetry`.

## Fase 5 — Lectura (getReadings / charts)
- [ ] Definir variante de lectura por ventana que sirva del continuous aggregate adecuado
      (`apps/vertivo_server/lib/src/greenhouses/greenhouse_endpoint.dart`).
- [ ] Mantener `getReadings` crudo para el caso de últimas-N lecturas; añadir un endpoint/param de rango+resolución para charts.
- [ ] Verificar: charts del dashboard/app consumen el rollup (sin full-scan de crudos).
- [ ] Commit: `feat(server): serve chart windows from continuous aggregates`.

## Fase 6 — Bootstrap / orden de migración
- [ ] Cablear el Job/hook SQL custom para que corra **después** de `dart bin/main.dart --apply-migrations` (`Makefile:290`).
- [ ] Documentar que el SQL custom NO vive en `apps/vertivo_server/migrations/` (Serverpod lo sobrescribe) — R2.
- [ ] Verificar: `make bootstrap-dev` desde cero llega a hypertable + aggregates + policies sin intervención manual.

## Cross-cutting
- [ ] Smoke test end-to-end: simulador → EMQX → ingesta → hypertable → continuous aggregate → chart.
- [ ] Documentar la ventana de mantenimiento de `migrate_data` para la futura promoción a prod (R5, OQ7).
- [ ] Linkear el PR de OpenSpec ↔ el issue `VRTV` ↔ los PRs de implementación entre sí.
