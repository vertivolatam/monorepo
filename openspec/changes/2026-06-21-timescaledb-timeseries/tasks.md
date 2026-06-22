# TimescaleDB time-series — Tasks

> **SPEC ONLY hasta aprobación.** Ninguna casilla se ejecuta antes del gate `design-approval`.
> **OQ1–OQ7 RESUELTAS** (ver design §5). Lo único pendiente es la **aprobación general de merge**.
> Esta implementación es la **costura (Fase 1)** del strangler hacia `timeseries_core`
> (`chimeranext/better-microservices` #76); la extracción del microservicio es out-of-scope.
> Status: **OQs cerradas — pendiente aprobación de merge.**

## Fase 0 — Decisiones previas (gate) — TODAS CERRADAS
- [x] **OQ1 (imagen):** `timescale/timescaledb-ha:pg16` + pgvector. **dev y prod.**
- [x] **OQ2 (chunk interval):** **1 día**.
- [x] **OQ3 (compresión/retención):** comprimir crudos **>7d**, dropear crudos **>90d** (CAGGs persisten).
- [x] **OQ4 (vehículo SQL):** **Kubernetes `Job` idempotente** en `k8s/` (base, aplicado a ambos overlays).
- [x] **OQ5/R1 (PK):** Opción 3 — **desacople del ORM** (quitar `table:`). Conflicto de PK eliminado.
- [x] **OQ6 (resoluciones):** **1m/5m/1h/1d**; el **1d** es CAGG jerárquico (sobre 1h), sobrevive al drop de crudos.
- [x] **OQ7 (alcance):** **dev + prod en este change** (StatefulSet/PVC/storage de prod + ventana de mantenimiento).

## Fase 0.5 — Desacople del ORM (D0, habilita todo lo demás)
- [ ] Auditar usos de `EnvironmentalReading.db.*` en el backend (esperado: ingesta + `getReadings`) — R7.
- [ ] Quitar `table:` de `environmental_reading.spy.yaml` → modelo serializable sin tabla;
      regenerar `vertivo_client` y confirmar que el tipo de API no cambia.
- [ ] Confirmar que `--apply-migrations` ya **no** crea/gestiona `environmental_readings`.
- [ ] Commit: `refactor(server): decouple EnvironmentalReading from Serverpod ORM (untable)`.

## Fase 1 — Imagen Postgres (base kustomize → dev y prod)
- [ ] Imagen `timescale/timescaledb-ha:pg16` + `pgvector` instalado encima (OQ1).
- [ ] `k8s/base/database/`: apuntar `image:` a esa imagen; verificar `shared_preload_libraries=timescaledb` (R3).
- [ ] Verificar arranque (dev primero): pod `postgres` `Running`, `pg_isready` OK, `\dx` lista `timescaledb` y `vector` (R4).
- [ ] Commit: `feat(k8s): postgres image with timescaledb + pgvector (base)`.

## Fase 2 — SQL custom: crea y posee el hypertable
- [ ] Escribir `.sql` idempotente versionado (ubicación según OQ4): `CREATE EXTENSION IF NOT EXISTS timescaledb;`.
- [ ] **`CREATE TABLE IF NOT EXISTS "environmental_readings"`** con la forma de columnas de referencia
      pero **sin `PRIMARY KEY ("id")` solo** (forma TimescaleDB-friendly; D0/D2). La tabla la posee
      esta migración, no Serverpod.
- [ ] `create_hypertable('environmental_readings','createdAt', chunk_time_interval=>INTERVAL '1 day', if_not_exists=>TRUE, migrate_data=>TRUE)` (chunk **1 día**, OQ2).
- [ ] (Si se requiere unicidad) índice único que **incluya `createdAt`** (p.ej. `("greenhouseId","measurementType","createdAt")`) — sub-decisión de OQ5.
- [ ] Verificar: `SELECT * FROM timescaledb_information.hypertables` muestra la tabla; inserts vía MQTT (SQL crudo) siguen funcionando.
- [ ] Commit: `feat(db): environmental_readings hypertable owned by SQL migration`.

## Fase 3 — Continuous aggregates 1m / 5m / 1h / 1d
- [ ] Crear `environmental_readings_1m` / `_5m` / `_1h` (`time_bucket` + avg/min/max/count, group by `greenhouseId,measurementType`) **sobre crudos**.
- [ ] Crear `environmental_readings_1d` como **CAGG jerárquico sobre `_1h`** (no sobre crudos): re-agrega `min/max/sum(sample_count)` exacto; definir si `avg` es simple o ponderado por `sample_count` (nota de ponderación en design D3).
- [ ] `add_continuous_aggregate_policy` por vista, **incluido el 1d** (refresco incremental).
- [ ] Decidir `real_time` aggregate o no (R6, borde de ventana).
- [ ] Verificar: las cuatro vistas se pueblan y refrescan; el 1d refresca desde el 1h; comparar contra agregación manual.
- [ ] Commit: `feat(db): continuous aggregates 1m/5m/1h + hierarchical 1d for environmental_readings`.

## Fase 4 — Compresión + retención
- [ ] `ALTER TABLE ... SET (timescaledb.compress, compress_segmentby='"greenhouseId","measurementType"')`.
- [ ] `add_compression_policy('environmental_readings', INTERVAL '7 days')` + `add_retention_policy('environmental_readings', INTERVAL '90 days')` (OQ3).
- [ ] Confirmar que la retención de crudos **no** afecta los CAGGs (sin retention policy en las vistas, o mucho más larga) — en especial que el **1d sobrevive**.
- [ ] Verificar: `timescaledb_information.jobs` lista las policies; chunks viejos se comprimen; tras simular >90d, el 1d sigue poblado y los crudos se dropean.
- [ ] Commit: `feat(db): compression (>7d) + retention (>90d) policies for telemetry`.

## Fase 5 — Ingesta + Lectura por SQL crudo (D2bis) detrás de la frontera de telemetría
- [ ] **Ingesta:** migrar `SensorIngestionService._handleMessage` de `insertRow` a
      `session.db.unsafeExecute(INSERT ...)` parametrizado (sin cambiar el flujo MQTT).
- [ ] **Lectura:** migrar `getReadings` a `session.db.unsafeQuery` contra la tabla cruda (últimas-N).
- [ ] Encapsular ingesta + lectura tras una **frontera estrecha de telemetría** (la costura hacia
      `timeseries_core`, §6): solver de resolución/ventana y contratos como **lógica canónica en un
      solo lugar**, no dispersos por el endpoint.
- [ ] Variante de lectura por ventana que sirva del CAGG adecuado: última hora→1m · día→5m · semana→1h · **temporada/histórico→1d**.
- [ ] Definir la política de borde de ventana (R6) dentro de esa frontera canónica.
- [ ] Verificar: charts del dashboard/app consumen el rollup (sin full-scan de crudos); la vista de temporada usa el 1d.
- [ ] Commit: `feat(server): raw-SQL telemetry seam (ingest + chart windows from CAGGs)`.

## Fase 6 — Bootstrap / orden de migración (dev)
- [ ] Cablear el Job SQL custom para que corra tras el arranque de Postgres con la extensión
      (D1). Con D0 ya **no** depende de `--apply-migrations` para esta tabla (R2 relajado).
- [ ] Documentar que el SQL custom NO vive en `apps/vertivo_server/migrations/` (Serverpod regenera ese dir) — R2.
- [ ] Verificar: `make bootstrap-dev` desde cero llega a hypertable + aggregates (incl. 1d) + policies sin intervención manual.

## Fase 7 — Despliegue a producción (D6, OQ7)
- [ ] Overlay `k8s/overlays/prod/`: **StatefulSet + PVC durable** con StorageClass de prod dimensionada al volumen real (Postgres es stateful; identidad de pod estable).
- [ ] Confirmar que el overlay prod reusa la **misma base** (imagen, Job SQL, políticas chunk-1d/7d/90d, CAGGs 1m/5m/1h/1d) — sin drift de motor ni de política entre entornos.
- [ ] **Ventana de mantenimiento** para la conversión inicial en prod (R5): si `environmental_readings` ya tiene volumen, `create_hypertable(... migrate_data=>TRUE)` copia/bloquea; planificar el paso siguiendo la guía de migración self-hosted de TigerData.
- [ ] Confirmar interacción retención↔backup de prod: el drop de crudos >90d es consistente con la política de backup (los CAGGs, en especial el 1d, preservan el agregado).
- [ ] Promoción ordenada: validar en dev → aplicar base con overlay prod (SQL idempotente hace segura la re-aplicación).
- [ ] Commit: `feat(k8s): prod overlay — StatefulSet/PVC + timescaledb policies`.

## Cross-cutting
- [ ] Smoke test end-to-end: simulador → EMQX → ingesta (SQL crudo) → hypertable → continuous aggregate → chart.
- [ ] **Costura (§6):** confirmar que la lógica del solver/contratos quedó canónica (un solo lugar),
      de modo que extraer `timeseries_core` (#76) sea cambiar el backend de la costura, no reescribir.
- [ ] Linkear el PR de OpenSpec ↔ el issue `VRTV` ↔ el spike `#76` ↔ los PRs de implementación entre sí.
