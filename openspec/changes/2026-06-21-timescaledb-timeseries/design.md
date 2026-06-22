# ADR — TimescaleDB time-series para la telemetría de sensores

**Date:** 2026-06-21
**Status:** Proposed — pendiente aprobación
**Context owner:** Andrés (andres@dojocoding.io)

---

## 1. Contexto

`environmental_readings` es la tabla destino de toda la telemetría de sensores. Hoy:

- **Imagen Postgres:** `pgvector/pgvector:pg16` (`k8s/base/database/deployment.yaml`).
  Es Postgres vanilla + la extensión `pgvector` (usada por otros dominios, p.ej. vision/embeddings).
  **No** trae TimescaleDB.
- **Tabla (DDL autogenerado por Serverpod, migración `20260309110422651/definition.sql`):**
  ```sql
  CREATE TABLE "environmental_readings" (
      "id" bigserial PRIMARY KEY,
      "greenhouseId" bigint NOT NULL,
      "measurementType" text NOT NULL,
      "value" double precision NOT NULL,
      "unit" text NOT NULL,
      "source" text,
      "isAnomaly" boolean NOT NULL,
      "createdAt" timestamp without time zone NOT NULL
  );
  ```
  Nota: la columna temporal es **`createdAt`** (no `timestamp`), y es `timestamp without time zone`.
- **Migraciones Serverpod:** SQL autogenerado en `apps/vertivo_server/migrations/`, aplicado por
  `dart bin/main.dart --apply-migrations` (`Makefile:290`). Serverpod **desconoce TimescaleDB**:
  regenerar migraciones sobrescribe cualquier cosa que metamos a mano en esos archivos.
- **Ingesta:** `SensorIngestionService._handleMessage` → `EnvironmentalReading.db.insertRow`.
- **Lectura:** `GreenhouseEndpoint.getReadings(greenhouseId, measurementType, {limit})` →
  `find(... orderBy createdAt DESC limit n)` sobre la tabla cruda.

## 2. Decisión

### D1 — Imagen Postgres con TimescaleDB **y** pgvector

`pgvector` ya está en uso, así que **no** podemos simplemente cambiar a la imagen oficial
`timescale/timescaledb` (que no trae pgvector). Dos caminos (ver Open Question OQ1):

- **(a)** Imagen base `timescale/timescaledb:*-pg16` + instalar `pgvector` encima (ambas son
  sólo extensiones de Postgres 16; conviven en el mismo cluster con `CREATE EXTENSION`).
- **(b)** Imagen base `pgvector/pgvector:pg16` (actual) + instalar el paquete `timescaledb`
  encima vía un Dockerfile propio.

En ambos casos el `deployment.yaml` apunta a esa imagen y la migración SQL ejecuta
`CREATE EXTENSION IF NOT EXISTS timescaledb;` (y `vector`). **Recomendación:** (a) — partir de
la imagen oficial de TimescaleDB, que ya trae `shared_preload_libraries=timescaledb` configurado
(requisito de la extensión), y añadir pgvector; evita tener que tocar `postgresql.conf` a mano.

### D2 — Hypertable sobre la tabla existente

Sobre la **misma** tabla `environmental_readings`, sin cambiar columnas:
```sql
SELECT create_hypertable('environmental_readings', 'createdAt',
                         if_not_exists => TRUE, migrate_data => TRUE);
```
`migrate_data => TRUE` permite convertir una tabla que ya tiene filas (idempotente con
`if_not_exists`). El particionado es por `createdAt`; intervalo de chunk a definir (default
TimescaleDB = 7 días; ver OQ2).

> Restricción de TimescaleDB: la PK/unique de una hypertable debe incluir la columna de
> particionado. Serverpod genera `PRIMARY KEY (id)` solo. **Riesgo R1** abajo.

### D3 — Continuous aggregates 1m / 5m / 1h

Materialized views incrementales, agregando por `(greenhouseId, measurementType)`:
```sql
CREATE MATERIALIZED VIEW environmental_readings_1m
WITH (timescaledb.continuous) AS
SELECT time_bucket('1 minute', "createdAt") AS bucket,
       "greenhouseId", "measurementType",
       avg("value")  AS avg_value,
       min("value")  AS min_value,
       max("value")  AS max_value,
       count(*)      AS sample_count
FROM environmental_readings
GROUP BY bucket, "greenhouseId", "measurementType";
-- idem _5m ('5 minutes') y _1h ('1 hour')
```
Más una `add_continuous_aggregate_policy` por vista para refresco incremental automático.
Los charts del dashboard/app consultan la vista de la resolución adecuada según el rango pedido
(p.ej. última hora → 1m, último día → 5m, última semana → 1h).

### D4 — Compresión + retención

```sql
ALTER TABLE environmental_readings SET (timescaledb.compress,
  timescaledb.compress_segmentby = '"greenhouseId","measurementType"');
SELECT add_compression_policy('environmental_readings', INTERVAL '7 days');
SELECT add_retention_policy('environmental_readings', INTERVAL '90 days');
```
Crudos: comprimidos > 7 días, dropeados > 90 días (valores tentativos, OQ3). Los continuous
aggregates **sobreviven** a la retención de crudos (mantienen su propia política, más larga o
infinita) — esa es la razón de existir de los rollups.

### D5 — Migración SQL custom post-deploy (no Serverpod)

Serverpod crea/posee la tabla; la conversión a hypertable + aggregates + policies va en un
**paso SQL idempotente separado** que corre **después** de `--apply-migrations`. Implementación
candidata (OQ4): un Kubernetes `Job` (o initContainer/post-hook) que aplica un `.sql`
versionado contra la DB, con todas las sentencias `IF NOT EXISTS` / idempotentes para que
re-ejecutar sea seguro. Este SQL **no** vive en `apps/vertivo_server/migrations/` (Serverpod lo
sobrescribiría); vive como recurso de infra versionado aparte.

## 3. Flujo (antes → después)

```
ANTES:
  Simulador RPi ──MQTT──► EMQX ──► Serverpod (SensorIngestionService)
                                        │ insertRow
                                        ▼
                               environmental_readings           (tabla plana B-tree)
                                        ▲
                                        │ getReadings: ORDER BY createdAt DESC LIMIT n
                                  Dashboard / App charts         (full-scan + sort de crudos)

DESPUÉS:
  Simulador RPi ──MQTT──► EMQX ──► Serverpod (SensorIngestionService)
                                        │ insertRow  (sin cambios)
                                        ▼
                               environmental_readings   ◄── HYPERTABLE (chunks por createdAt)
                                        │                     ├─ compresión   > 7 días
                                        │                     └─ retención    > 90 días
                                        │ refresh incremental
                                        ▼
                    ┌───────────────────┼───────────────────┐
                    ▼                   ▼                   ▼
            _1m (cont.agg)      _5m (cont.agg)      _1h (cont.agg)   ◄── rollups avg/min/max/count
                    └───────────────────┼───────────────────┘
                                        ▲
                                        │ getReadings/charts leen el rollup según el rango
                                  Dashboard / App charts
```

Orden de bootstrap (clave):
```
1. Postgres (imagen con timescaledb+pgvector) arranca
2. Serverpod --apply-migrations  → CREATE TABLE environmental_readings
3. Job SQL custom (idempotente)  → CREATE EXTENSION timescaledb; create_hypertable(...);
                                   continuous aggregates; compresión; retención
```

## 4. Riesgos

| # | Riesgo | Mitigación |
|---|---|---|
| **R1** | **PK incompatible con hypertable.** TimescaleDB exige que toda unique/PK incluya la columna de partición (`createdAt`); Serverpod genera `PRIMARY KEY (id)` solo. `create_hypertable` fallará o exigirá relajar la constraint. | Decidir en la implementación: (i) `create_hypertable` con `id` como PK puede requerir cambiar a PK compuesta `(id, createdAt)` — que Serverpod no genera; o (ii) operar sin unique sobre `id` salvo el índice. Esto es la fricción real Serverpod↔TimescaleDB. Ver OQ5. |
| **R2** | **Orden de migración / regeneración.** Si alguien corre `make migrate` (regenera Serverpod) y recrea la tabla, o el Job SQL corre antes de que la tabla exista, el bootstrap rompe. | Job idempotente (`IF NOT EXISTS`, `if_not_exists => TRUE`) que corre estrictamente después de `--apply-migrations`; documentar que el SQL custom NO va en `apps/vertivo_server/migrations/`. |
| **R3** | **`shared_preload_libraries`.** TimescaleDB requiere precargar la librería; sin eso `CREATE EXTENSION timescaledb` falla. | Partir de la imagen oficial `timescale/timescaledb` que ya lo configura (D1 opción a). |
| **R4** | **pgvector + timescaledb en la misma imagen.** Cambiar de imagen no debe romper el uso actual de pgvector. | Verificar que ambas extensiones cargan (`\dx`) y que el dominio que usa vector sigue funcionando antes de mergear. |
| **R5** | **`migrate_data => TRUE` en tabla grande.** Convertir una tabla con muchas filas bloquea/copia. | En dev la tabla es chica; documentar para prod que la conversión inicial es una ventana de mantenimiento (la migración TigerData cubre esto). |
| **R6** | **Doble fuente de lectura.** Si `getReadings` mezcla crudos (recientes, aún no agregados) con rollup, puede haber gaps en el borde de la ventana. | Definir política de lectura: rollup para histórico + crudos para el último bucket, o `real_time` continuous aggregates (que combinan materializado + datos frescos). |

## 5. Open Questions (para el usuario)

- **OQ1 — Imagen.** ¿Vamos con (a) `timescale/timescaledb-ha:pg16` + pgvector encima, o (b)
  mantener `pgvector/pgvector:pg16` + instalar timescaledb? (Recomiendo (a).)
- **OQ2 — Chunk interval.** ¿Default de 7 días, o algo más fino (1 día) dado el volumen IoT esperado?
- **OQ3 — Compresión/retención.** ¿7 días para comprimir y 90 días para dropear crudos son
  correctos para el negocio (compliance/trazabilidad podría exigir conservar más)?
- **OQ4 — Vehículo del SQL custom.** ¿Kubernetes `Job` dedicado, initContainer del backend, o
  post-deploy hook en el `Makefile`/bootstrap? (Recomiendo `Job` idempotente versionado en `k8s/`.)
- **OQ5 — PK de la hypertable (R1).** ¿Aceptamos relajar/recomponer la PK que genera Serverpod,
  o preferimos un workaround que no toque el esquema Serverpod?
- **OQ6 — Resoluciones de los charts.** ¿1m/5m/1h cubre los rangos que el dashboard/app van a
  pedir, o hace falta también 1d para la vista de "última temporada"?
- **OQ7 — Prod.** ¿Este change se queda dev-first y la promoción a prod (overlay prod + ventana
  de mantenimiento para `migrate_data`) es un follow-up separado, o lo incluimos?

## 6. Referencias

- PDR: [`proposal.md`](./proposal.md) · Tasks: [`tasks.md`](./tasks.md)
- Migración self-hosted TigerData: https://www.tigerdata.com/docs/deploy/self-hosted/migration
- `k8s/base/database/deployment.yaml`, `k8s/base/database/pvc.yaml`
- `apps/vertivo_server/lib/src/greenhouses/environmental_reading.spy.yaml`
- `apps/vertivo_server/lib/src/greenhouses/greenhouse_endpoint.dart` (`getReadings`)
- `apps/vertivo_server/lib/src/greenhouses/sensor_ingestion_service.dart` (ingesta MQTT)
- `apps/vertivo_server/migrations/20260309110422651/definition.sql` (DDL actual de la tabla)
