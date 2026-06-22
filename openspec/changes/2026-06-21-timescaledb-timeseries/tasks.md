# TimescaleDB time-series — Tasks

> **SPEC ONLY hasta aprobación.** Ninguna casilla se ejecuta antes del gate `design-approval`.
> **OQ5/R1 ya RESUELTA** (Opción 3 — desacople del ORM Serverpod, D0). Resolver aún OQ1 (imagen),
> OQ4 (vehículo del SQL custom) y OQ2/OQ3/OQ6/OQ7.
> Esta implementación es la **costura (Fase 1)** del strangler hacia `timeseries_core`
> (`chimeranext/better-microservices` #76); la extracción del microservicio es out-of-scope.
> Status: **Proposed — pendiente aprobación.**

## Fase 0 — Decisiones previas (gate)
- [ ] Cerrar OQ1: imagen elegida (recomendada: `timescale/timescaledb-ha:pg16` + pgvector).
- [ ] Cerrar OQ4: vehículo del SQL custom (recomendado: Kubernetes `Job` idempotente en `k8s/`).
- [x] ~~Cerrar OQ5/R1~~ **RESUELTA: Opción 3 — desacople del ORM** (quitar `table:`; hypertable
      poseído por la migración SQL; ingesta + lectura por SQL crudo). El conflicto de PK desaparece.
- [ ] Confirmar dev-first vs incluir prod (OQ7).

## Fase 0.5 — Desacople del ORM (D0, habilita todo lo demás)
- [ ] Auditar usos de `EnvironmentalReading.db.*` en el backend (esperado: ingesta + `getReadings`) — R7.
- [ ] Quitar `table:` de `environmental_reading.spy.yaml` → modelo serializable sin tabla;
      regenerar `vertivo_client` y confirmar que el tipo de API no cambia.
- [ ] Confirmar que `--apply-migrations` ya **no** crea/gestiona `environmental_readings`.
- [ ] Commit: `refactor(server): decouple EnvironmentalReading from Serverpod ORM (untable)`.

## Fase 1 — Imagen Postgres (overlay dev)
- [ ] Construir/seleccionar la imagen con `timescaledb` **y** `pgvector` (según OQ1).
- [ ] `k8s/base/database/deployment.yaml`: apuntar `image:` a esa imagen; verificar
      `shared_preload_libraries=timescaledb` (R3).
- [ ] Verificar arranque: pod `postgres` `Running`, `pg_isready` OK, `\dx` lista `timescaledb` y `vector` (R4).
- [ ] Commit: `feat(k8s): postgres image with timescaledb + pgvector (dev overlay)`.

## Fase 2 — SQL custom: crea y posee el hypertable
- [ ] Escribir `.sql` idempotente versionado (ubicación según OQ4): `CREATE EXTENSION IF NOT EXISTS timescaledb;`.
- [ ] **`CREATE TABLE IF NOT EXISTS "environmental_readings"`** con la forma de columnas de referencia
      pero **sin `PRIMARY KEY ("id")` solo** (forma TimescaleDB-friendly; D0/D2). La tabla la posee
      esta migración, no Serverpod.
- [ ] `create_hypertable('environmental_readings','createdAt', if_not_exists=>TRUE, migrate_data=>TRUE)` con el chunk interval de OQ2.
- [ ] (Si se requiere unicidad) índice único que **incluya `createdAt`** — sub-pregunta de OQ5.
- [ ] Verificar: `SELECT * FROM timescaledb_information.hypertables` muestra la tabla; inserts vía MQTT (SQL crudo) siguen funcionando.
- [ ] Commit: `feat(db): environmental_readings hypertable owned by SQL migration`.

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

## Fase 5 — Ingesta + Lectura por SQL crudo (D2bis) detrás de la frontera de telemetría
- [ ] **Ingesta:** migrar `SensorIngestionService._handleMessage` de `insertRow` a
      `session.db.unsafeExecute(INSERT ...)` parametrizado (sin cambiar el flujo MQTT).
- [ ] **Lectura:** migrar `getReadings` a `session.db.unsafeQuery` contra la tabla cruda (últimas-N).
- [ ] Encapsular ingesta + lectura tras una **frontera estrecha de telemetría** (la costura hacia
      `timeseries_core`, §6): solver de resolución/ventana y contratos como **lógica canónica en un
      solo lugar**, no dispersos por el endpoint.
- [ ] Variante de lectura por ventana que sirva del continuous aggregate adecuado (rango+resolución).
- [ ] Definir la política de borde de ventana (R6) dentro de esa frontera canónica.
- [ ] Verificar: charts del dashboard/app consumen el rollup (sin full-scan de crudos).
- [ ] Commit: `feat(server): raw-SQL telemetry seam (ingest + chart windows from CAGGs)`.

## Fase 6 — Bootstrap / orden de migración
- [ ] Cablear el Job/hook SQL custom para que corra tras el arranque de Postgres con la extensión
      (D1). Con D0 ya **no** depende de `--apply-migrations` para esta tabla (R2 relajado).
- [ ] Documentar que el SQL custom NO vive en `apps/vertivo_server/migrations/` (Serverpod regenera ese dir) — R2.
- [ ] Verificar: `make bootstrap-dev` desde cero llega a hypertable + aggregates + policies sin intervención manual.

## Cross-cutting
- [ ] Smoke test end-to-end: simulador → EMQX → ingesta (SQL crudo) → hypertable → continuous aggregate → chart.
- [ ] Documentar la ventana de mantenimiento de `migrate_data` para la futura promoción a prod (R5, OQ7).
- [ ] **Costura (§6):** confirmar que la lógica del solver/contratos quedó canónica (un solo lugar),
      de modo que extraer `timeseries_core` (#76) sea cambiar el backend de la costura, no reescribir.
- [ ] Linkear el PR de OpenSpec ↔ el issue `VRTV` ↔ el spike `#76` ↔ los PRs de implementación entre sí.
