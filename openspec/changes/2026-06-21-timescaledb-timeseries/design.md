# ADR — TimescaleDB time-series para la telemetría de sensores

**Date:** 2026-06-21
**Status:** OQ1–OQ7 RESUELTAS (ver §5) — pendiente aprobación general de merge. SPEC ONLY.
**Context owner:** Andrés (andres@dojocoding.io)

---

## 1. Contexto

`environmental_readings` es la tabla destino de toda la telemetría de sensores. Hoy:

- **Imagen Postgres:** `pgvector/pgvector:pg16` (`k8s/base/database/deployment.yaml`).
  Es Postgres vanilla + la extensión `pgvector` (usada por otros dominios, p.ej. vision/embeddings).
  **No** trae TimescaleDB.
- **Tabla (forma actual — DDL autogenerado por Serverpod, migración `20260309110422651/definition.sql`).**
  Tras este change (D0) esta forma la **posee la migración SQL**, no Serverpod; el `PRIMARY KEY
  ("id")` solo es justamente lo que se elimina para que el hypertable no choque:
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
  regenerar migraciones sobrescribe cualquier cosa que metamos a mano en esos archivos. La salida
  de este change (D0) es **sacar `environmental_readings` del set de tablas que Serverpod gestiona**,
  precisamente para que esa regeneración deje de tocarla.
- **Ingesta:** `SensorIngestionService._handleMessage` → hoy `EnvironmentalReading.db.insertRow`
  (CRUD generado); este change lo lleva a `session.db.unsafeExecute` (SQL crudo, D2bis).
- **Lectura:** `GreenhouseEndpoint.getReadings(greenhouseId, measurementType, {limit})` → hoy
  `find(... orderBy createdAt DESC limit n)` (CRUD generado); este change lo lleva a
  `session.db.unsafeQuery` contra la tabla cruda o el continuous aggregate (D2bis).

## 2. Decisión

> Orden de lectura: **D0 es la decisión central** (desacople del ORM, resuelve el crux de la PK);
> lógicamente precede a las demás. Se enumera D0 para no recorrer la numeración existente (D1–D5).

### D1 — Imagen Postgres con TimescaleDB **y** pgvector (OQ1 → cerrada)

`pgvector` ya está en uso, así que **no** podemos simplemente cambiar a la imagen oficial
`timescale/timescaledb` (que no trae pgvector). Se evaluaron dos caminos:

- **(a) ELEGIDA** — Imagen base **`timescale/timescaledb-ha:pg16`** + instalar `pgvector` encima
  (ambas son sólo extensiones de Postgres 16; conviven en el mismo cluster con `CREATE EXTENSION`).
- (b) Imagen base `pgvector/pgvector:pg16` (actual) + instalar el paquete `timescaledb` encima vía
  un Dockerfile propio. **Descartada.**

**Decisión (OQ1): (a) `timescale/timescaledb-ha:pg16` + pgvector**, en **ambos overlays (dev y
prod)**. La imagen `-ha` oficial ya trae `shared_preload_libraries=timescaledb` configurado
(requisito de la extensión, R3), evitando tocar `postgresql.conf` a mano. La migración SQL ejecuta
`CREATE EXTENSION IF NOT EXISTS timescaledb;` (y `vector`). La misma imagen sirve dev y prod; lo que
difiere por overlay es el storage (PVC/StorageClass), no la imagen — ver D6 (despliegue prod).

### D0 — Desacoplar el modelo del ORM Serverpod (decisión central, resuelve R1)

`EnvironmentalReading` deja de ser una **tabla gestionada por Serverpod**: se le quita la clave
`table:` de `environmental_reading.spy.yaml`, de modo que pasa a ser un **modelo serializable
sin tabla**. Sigue siendo el tipo de la API y de `vertivo_client` (los clientes lo serializan/
deserializan igual), pero Serverpod **deja de generarle CRUD y deja de gestionarle una tabla**.

Consecuencia clave: como la tabla **ya no es "de" Serverpod**, el ORM **nunca intenta ponerle el
`id`-PK autogenerado**. El conflicto de PK con TimescaleDB (la PK/unique de un hypertable debe
incluir la columna de partición) **desaparece de raíz**: no hay PK compuesta que sintetizar, no
hay drift contra el SQL regenerado, no hay cirugía sobre `apps/vertivo_server/migrations/`.

**Quién crea la tabla entonces:** la migración SQL (el Job idempotente, D5) crea y posee el
hypertable con la estructura amigable a TimescaleDB — sin `id`-PK conflictivo, o con un índice
único que **incluya `createdAt`** si se necesita unicidad. El esquema relacional de esta tabla
deja de ser responsabilidad de Serverpod y pasa a ser responsabilidad de infra (la costura).

**Trade-off (asumido y aceptable):** se pierde el CRUD generado por Serverpod para esta tabla
(`EnvironmentalReading.db.insertRow` / `find`). Ingesta y lectura pasan a SQL crudo (D2bis). Para
telemetría IoT de alta frecuencia, el SQL crudo es lo correcto de todos modos: el ORM fila-a-fila
no aporta y el acceso por ventana/resolución (rollups, `time_bucket`) no es expresable con el CRUD
generado. Se cede una comodidad que esta tabla no iba a usar, a cambio de eliminar por completo la
fricción Serverpod↔TimescaleDB.

### D2 — Hypertable poseído por la migración SQL

La migración SQL (D5) crea la tabla **ya como hypertable**, sin pasar por el DDL de Serverpod:

```sql
-- la migración SQL crea la tabla con forma amigable a TimescaleDB
CREATE TABLE IF NOT EXISTS "environmental_readings" (
    "id"              bigserial,
    "greenhouseId"    bigint  NOT NULL,
    "measurementType" text    NOT NULL,
    "value"           double precision NOT NULL,
    "unit"            text    NOT NULL,
    "source"          text,
    "isAnomaly"       boolean NOT NULL,
    "createdAt"       timestamp without time zone NOT NULL
    -- sin PRIMARY KEY ("id") solo: evita el conflicto con el particionado.
    -- Si se requiere unicidad, el índice único incluye "createdAt".
);
SELECT create_hypertable('environmental_readings', 'createdAt',
                         chunk_time_interval => INTERVAL '1 day',
                         if_not_exists => TRUE, migrate_data => TRUE);
```
El particionado es por `createdAt` con **chunk interval de 1 día** (OQ2 → cerrada; no el default de
7 días). El chunk fino da **granularidad para comprimir/dropear por antigüedad**: las fronteras de
compresión (>7d) y retención (>90d) caen limpias entre chunks completos, sin un chunk a medias en la
frontera. `migrate_data => TRUE` + `if_not_exists` mantiene la idempotencia si la tabla ya tuviera
filas. **Ya no hay restricción de PK que mitigar** (D0): la tabla nace sin la `PRIMARY KEY (id)`
sola que generaba Serverpod.

### D2bis — Ingesta y lectura por SQL crudo

Como la tabla deja de tener CRUD generado (D0), ambos extremos usan el API de SQL crudo de
Serverpod (`session.db.unsafeQuery` / `session.db.unsafeExecute`), no `EnvironmentalReading.db.*`:

- **Ingesta** (`SensorIngestionService._handleMessage`): el `insertRow` por mensaje MQTT pasa a un
  `unsafeExecute('INSERT INTO "environmental_readings" (...) VALUES (...)')` parametrizado. El
  mensaje MQTT, el flujo y la deserialización del payload no cambian; sólo el `insert`.
- **Lectura** (`getReadings` y las variantes por ventana): `unsafeQuery` contra la tabla cruda
  (últimas-N) o contra el continuous aggregate (charts por rango+resolución), mapeando filas a
  `EnvironmentalReading` (que sigue siendo serializable para `vertivo_client`).

Esta capa de acceso SQL crudo, encapsulada detrás de una frontera estrecha (un servicio/módulo de
telemetría), **es la costura** hacia `timeseries_core` (ver §6).

### D3 — Continuous aggregates 1m / 5m / 1h / 1d (OQ6 → cerrada)

Materialized views incrementales, agregando por `(greenhouseId, measurementType)`. Las tres
resoluciones finas se computan **sobre los crudos**:
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
-- idem _5m ('5 minutes') y _1h ('1 hour'), todos sobre environmental_readings (crudos)
```

**Rollup diario 1d — CAGG jerárquico (agregado en esta iteración por decisión del usuario, OQ6).**
El 1d **no** se computa sobre crudos sino **sobre el `_1h`** (continuous aggregate sobre continuous
aggregate). Esto es deliberado: cuando la retención dropea los crudos a 90 días, el 1d sigue
refrescándose desde el 1h (que vive más), y el histórico largo no depende de los crudos.
```sql
CREATE MATERIALIZED VIEW environmental_readings_1d
WITH (timescaledb.continuous) AS
SELECT time_bucket('1 day', bucket) AS bucket,
       "greenhouseId", "measurementType",
       -- re-agregación correcta desde el 1h:
       avg(avg_value)               AS avg_value,   -- (aprox; ver nota de ponderación)
       min(min_value)               AS min_value,
       max(max_value)               AS max_value,
       sum(sample_count)            AS sample_count
FROM environmental_readings_1h
GROUP BY time_bucket('1 day', bucket), "greenhouseId", "measurementType";
```
> Nota de ponderación: `avg(avg_value)` asume buckets horarios de peso parejo. Si se requiere el
> promedio diario exacto ponderado por muestras, computar `sum(avg_value*sample_count)/sum(sample_count)`
> — decisión de la fase de implementación. `min`/`max`/`count` re-agregan exacto.

Más una `add_continuous_aggregate_policy` por vista (incl. el 1d) para refresco incremental
automático. Los charts consultan la vista de la resolución adecuada según el rango pedido
(última hora → 1m · último día → 5m · última semana → 1h · **temporada / histórico largo → 1d**).

### D4 — Compresión + retención (OQ3 → cerrada)

```sql
ALTER TABLE environmental_readings SET (timescaledb.compress,
  timescaledb.compress_segmentby = '"greenhouseId","measurementType"');
SELECT add_compression_policy('environmental_readings', INTERVAL '7 days');
SELECT add_retention_policy('environmental_readings', INTERVAL '90 days');
```
Crudos: **comprimidos > 7 días, dropeados > 90 días** (OQ3 cerrada con estos valores). Los
continuous aggregates **sobreviven** a la retención de crudos: **no** llevan `add_retention_policy`
(o llevan una mucho más larga/infinita), de modo que el histórico agregado persiste. En particular
el **1d** (D3, computado desde el 1h, no desde crudos) es el rollup que mantiene la serie de
temporada completa después de que los crudos se dropean a los 90 días — esa es su razón de existir.

> Misma política (7d/90d) en **dev y prod**; lo que cambia entre overlays es el storage subyacente
> (tamaño del PVC / StorageClass), no los intervalos. Ver D6.

### D5 — Migración SQL custom: crea y posee el hypertable (no Serverpod)

Con el desacople (D0), Serverpod **ya no crea esta tabla**. La migración SQL es ahora la **dueña
del esquema** de `environmental_readings`: crea la tabla (D2), la convierte en hypertable, y
añade aggregates (1m/5m/1h/1d) + compresión + retention, todo en un **paso SQL idempotente** que
corre en el bootstrap. **Vehículo (OQ4 → cerrada): un Kubernetes `Job` idempotente** versionado en
`k8s/` que aplica un `.sql` versionado contra la DB, con todas las sentencias `IF NOT EXISTS` /
idempotentes para que re-ejecutar sea seguro. El `Job` vive en la **base de kustomize** y se aplica
en **ambos overlays (dev y prod)** — mismo SQL, misma idempotencia, distinto cluster/DB. Este SQL
**no** vive en `apps/vertivo_server/migrations/` (Serverpod regenera ese directorio); vive como
recurso de infra versionado aparte — es la **fuente de verdad del esquema de telemetría** y, por
tanto, la pieza canónica que `timeseries_core` heredará el día de la extracción (§6).

> Nota de orden: como Serverpod ya no gestiona la tabla, el Job SQL ya **no** depende de que
> `--apply-migrations` cree primero la tabla. El acoplamiento de orden de R2 se relaja: el Job es
> autosuficiente para esta tabla. Sólo debe correr después de que el extension `timescaledb` esté
> disponible (imagen, D1).

### D6 — Despliegue a producción (OQ7 → cerrada: dev + prod en este change)

El change **ya no es dev-first**: cubre dev **y** prod. La estructura kustomize es la palanca —
**una base** (`k8s/base/database/`) con la imagen, el StatefulSet/PVC y el `Job` de migración SQL,
y **dos overlays** (`k8s/overlays/dev/`, `k8s/overlays/prod/`) que sólo patchean lo que difiere.

| Dimensión | Dev | Prod |
|-----------|-----|------|
| **Imagen** | `timescale/timescaledb-ha:pg16` + pgvector | **idéntica** (sin drift de motor entre entornos) |
| **Storage** | PVC chico, StorageClass de dev | **StatefulSet con PVC dimensionado + StorageClass de prod** (durable, con backup); tamaño acorde al volumen real de telemetría |
| **Migración SQL** | mismo `Job` idempotente | mismo `Job` idempotente |
| **Políticas (chunk 1d, compresión 7d, retención 90d, CAGGs 1m/5m/1h/1d)** | iguales | **iguales** (la política no cambia por entorno) |
| **Conversión inicial (`migrate_data`)** | trivial (tabla chica) | **ventana de mantenimiento** si la tabla ya tiene volumen (R5): `create_hypertable(... migrate_data=>TRUE)` copia/bloquea; planificar como paso operativo |

Puntos de diseño específicos de prod:

- **StatefulSet, no Deployment, para la DB de prod.** Postgres es stateful; el PVC debe ser durable
  y la identidad de pod estable. (Si dev hoy usa un Deployment con PVC, prod estandariza a
  StatefulSet; documentar la diferencia en el overlay.)
- **La migración inicial en prod es una ventana de mantenimiento** (R5): si `environmental_readings`
  ya tiene filas en prod al momento de convertir, `migrate_data => TRUE` es una operación que copia
  y toma locks. Debe correrse en ventana, siguiendo la guía de migración self-hosted de TigerData.
- **Retención/compresión y backup interactúan:** la retención dropea crudos > 90d; el backup de prod
  debe ser consistente con eso (no se "pierde" nada que el negocio espere conservar, porque los
  CAGGs —en especial el 1d— preservan el agregado). Confirmado por OQ3.
- **Promoción ordenada:** validar primero en dev (hypertable + CAGGs + policies vía el Job), luego
  aplicar el mismo base con el overlay de prod. El SQL idempotente hace segura la re-aplicación.

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
                                        │ unsafeExecute INSERT  (SQL crudo, desacoplado del ORM)
                                        ▼
                          ┌─ frontera telemetría (la COSTURA → timeseries_core, §6) ─┐
                          │                                                          │
                          │  environmental_readings  ◄── HYPERTABLE (chunks 1 día)    │
                          │            │                  ├─ compresión   > 7 días    │
                          │            │                  └─ retención    > 90 días   │
                          │            │ refresh incremental                          │
                          │            ▼                                              │
                          │ ┌──────────┼──────────┐                                   │
                          │ ▼          ▼          ▼                                   │
                          │_1m       _5m        _1h   ◄── rollups avg/min/max/count   │
                          │                       │      (sobre crudos)               │
                          │                       ▼                                   │
                          │                      _1d   ◄── CAGG jerárquico (sobre _1h)│
                          │                       │       SOBREVIVE al drop de crudos │
                          └───────────────────────┼─────────────────────────────────┘
                                        ▲
                                        │ getReadings/charts: unsafeQuery del rollup según el rango
                                        │ (1h→semana · 1d→temporada/histórico largo)
                                  Dashboard / App charts
```

Orden de bootstrap (clave):
```
1. Postgres (timescale/timescaledb-ha:pg16 + pgvector) arranca   [dev y prod, misma imagen]
2. Serverpod --apply-migrations  → crea las demás tablas; NO environmental_readings (desacoplada, D0)
3. Job SQL custom (idempotente)  → CREATE EXTENSION timescaledb;
                                   CREATE TABLE environmental_readings (forma TimescaleDB-friendly);
                                   create_hypertable(... chunk 1 día);
                                   continuous aggregates 1m/5m/1h (sobre crudos) + 1d (sobre 1h);
                                   compresión > 7 días; retención de crudos > 90 días (CAGGs persisten)
```
El Job ahora **crea** la tabla de telemetría (ya no sólo la convierte): es su dueño. Ya no hay
dependencia de orden frente al paso 2 para esta tabla concreta (R2 relajado).

## 4. Riesgos

| # | Riesgo | Mitigación |
|---|---|---|
| **R1** | ~~**PK incompatible con hypertable.**~~ **RESUELTO por D0.** TimescaleDB exige que toda unique/PK incluya la columna de partición; Serverpod generaba `PRIMARY KEY (id)` solo. | **Desacople (D0):** al quitar `table:` del modelo, Serverpod deja de gestionar la tabla y nunca le pone el `id`-PK. La migración SQL crea la tabla sin esa PK conflictiva (o con un único que incluye `createdAt`). El conflicto desaparece de raíz: sin PK compuesta sintética, sin drift, sin tocar el SQL autogenerado. Ver OQ5 (cerrada). |
| **R2** | **Orden de migración / regeneración.** ~~Si alguien recrea la tabla vía Serverpod~~ — ya **no aplica** a esta tabla (D0: Serverpod no la gestiona). Queda sólo el orden frente a la extensión: el Job SQL no debe correr sin `timescaledb` precargado. | Job idempotente (`IF NOT EXISTS`, `if_not_exists => TRUE`) dueño de la tabla; depende sólo de la imagen con la extensión (D1), no de `--apply-migrations`. Documentar que el SQL custom NO va en `apps/vertivo_server/migrations/` (Serverpod regenera ese dir). |
| **R3** | **`shared_preload_libraries`.** TimescaleDB requiere precargar la librería; sin eso `CREATE EXTENSION timescaledb` falla. | Imagen elegida `timescale/timescaledb-ha:pg16` (D1, OQ1) que ya lo configura — en dev y prod. |
| **R4** | **pgvector + timescaledb en la misma imagen.** Cambiar de imagen no debe romper el uso actual de pgvector. | Verificar que ambas extensiones cargan (`\dx`) y que el dominio que usa vector sigue funcionando antes de mergear — en ambos overlays. |
| **R5** | **`migrate_data => TRUE` en tabla grande (ahora IN-SCOPE: prod).** Convertir una tabla con muchas filas bloquea/copia. Con prod dentro del change (OQ7), esto deja de ser un follow-up. | En dev la tabla es chica. **En prod: ventana de mantenimiento** para la conversión inicial (D6), siguiendo la guía de migración self-hosted de TigerData. Chunk de 1 día (OQ2) acota el costo por chunk. |
| **R6** | **Doble fuente de lectura.** Si `getReadings` (ahora SQL crudo, D2bis) mezcla crudos (recientes, aún no agregados) con rollup, puede haber gaps en el borde de la ventana. | Definir política de lectura en la frontera de telemetría (la costura): rollup para histórico + crudos para el último bucket, o `real_time` continuous aggregates (que combinan materializado + datos frescos). Esta política es **lógica canónica** → debe vivir en un solo lugar (§6). |
| **R7** | **Pérdida del CRUD generado (trade-off de D0).** Quitar `table:` elimina `EnvironmentalReading.db.*`; cualquier código que hoy dependa del CRUD generado para esta tabla deja de compilar. | Auditar usos de `EnvironmentalReading.db.*` antes de quitar `table:` (hoy: ingesta + `getReadings`, ambos migran a SQL crudo en este change). El modelo sigue serializable, así que `vertivo_client` y la API no se ven afectados. Trade-off aceptado: esta tabla no iba a beneficiarse del ORM fila-a-fila. |

## 5. Decisiones cerradas (OQ1–OQ7)

El usuario resolvió todas las open questions; quedan registradas como decisiones del change. Lo
único pendiente es la **aprobación general de merge** (este change sigue SPEC ONLY).

- **OQ1 — Imagen. CERRADA: `timescale/timescaledb-ha:pg16` + pgvector** (D1), en dev y prod. La
  variante (b) (pgvector base + instalar timescaledb) queda descartada.
- **OQ2 — Chunk interval. CERRADA: 1 día** (D2). Más fino que el default de 7 días para que las
  fronteras de compresión/retención caigan limpias entre chunks.
- **OQ3 — Compresión/retención. CERRADA: comprimir crudos > 7 días, dropear crudos > 90 días** (D4).
  Los CAGGs persisten (sin retención o con una mucho más larga); el 1d preserva el histórico largo.
- **OQ4 — Vehículo del SQL custom. CERRADA: Kubernetes `Job` idempotente** versionado en `k8s/` (D5),
  en la base de kustomize, aplicado a ambos overlays.
- **OQ5 — PK de la hypertable (R1). CERRADA (Opción 3 — desacople del ORM, D0).** Se saca la tabla
  de Serverpod (quitar `table:`); la migración SQL crea/posee el hypertable; ingesta y lectura por
  SQL crudo. El conflicto de PK desaparece de raíz. Sub-decisión menor delegada a implementación:
  si se necesita unicidad explícita, el índice único **debe incluir `createdAt`** (p.ej.
  `("greenhouseId","measurementType","createdAt")`); o el hypertable sin unique — ya sin fricción
  con Serverpod.
- **OQ6 — Resoluciones de los charts. CERRADA: 1m / 5m / 1h / 1d** (D3). El **1d se agregó en esta
  iteración** como CAGG jerárquico (sobre el 1h) para la vista de temporada completa; es el rollup
  que sobrevive al drop de crudos a 90 días.
- **OQ7 — Prod. CERRADA: dev + prod en este mismo change** (D6). El change deja de ser dev-first:
  cubre StatefulSet/PVC/storage de prod, las mismas políticas, y la ventana de mantenimiento de la
  conversión inicial (R5).

## 6. Costura hacia `timeseries_core` (Strangler seam)

Este change es, intencionadamente, la **Fase 1 / costura** de un Strangler Fig hacia un
**microservicio compartido de series temporales** — `timeseries_core`, cross-producto (no sólo
Vertivo). El spike que lo define vive en `chimeranext/better-microservices` **issue #76**.

- **Qué es la costura aquí:** la frontera estrecha de telemetría (la capa de acceso SQL crudo de
  ingesta + lectura, D2bis) más la migración SQL que posee el esquema (D5). Hoy esa frontera
  resuelve contra el Postgres+TimescaleDB local de Vertivo; el día de la extracción, resuelve
  contra `timeseries_core` sin que el caller del endpoint cambie.
- **Por qué el desacople (D0) la habilita:** al no atar `environmental_readings` al CRUD generado
  de Serverpod, la telemetría queda detrás de una capa de acceso explícita y reemplazable —
  exactamente el punto de corte que un microservicio extraído necesita sustituir. Si siguiera atada
  al ORM, extraer significaría desenredar el CRUD generado de medio backend.
- **Invariante de diseño para no reescribir después:** la **lógica canónica** — la convención del
  solver de resolución/ventana (qué rollup sirve cada rango), el contrato de ingesta y el de
  lectura, la política de borde de ventana (R6) — debe vivir en **un solo lugar** detrás de esa
  frontera, no esparcida por el endpoint ni duplicada por cliente. Así, mover el cómputo a
  `timeseries_core` es cambiar el *backend* de la costura, no reescribir el dominio.
- **Estado:** la extracción de `timeseries_core` es **out-of-scope pero anticipada**, gatillada por
  el spike #76 — no por este change. Aquí sólo se deja la costura limpia.

## 7. Referencias

- PDR: [`proposal.md`](./proposal.md) · Tasks: [`tasks.md`](./tasks.md)
- Spike `timeseries_core` (microservicio compartido, gatillo de la extracción):
  `chimeranext/better-microservices` issue **#76**
- Serverpod — modelos sin tabla y SQL crudo: modelo serializable (sin `table:`),
  `session.db.unsafeQuery` / `session.db.unsafeExecute`
- Migración self-hosted TigerData: https://www.tigerdata.com/docs/deploy/self-hosted/migration
- `k8s/base/database/deployment.yaml`, `k8s/base/database/pvc.yaml`
- `apps/vertivo_server/lib/src/greenhouses/environmental_reading.spy.yaml` (se le quita `table:`, D0)
- `apps/vertivo_server/lib/src/greenhouses/greenhouse_endpoint.dart` (`getReadings` → SQL crudo)
- `apps/vertivo_server/lib/src/greenhouses/sensor_ingestion_service.dart` (ingesta MQTT → SQL crudo)
- `apps/vertivo_server/migrations/20260309110422651/definition.sql` (forma de columnas de referencia)
