# TimescaleDB time-series — migrar la telemetría de sensores a hypertable + continuous aggregates

**Date:** 2026-06-21
**Owner:** Andrés (andres@dojocoding.io)
**Status:** Open Questions RESUELTAS (OQ1–OQ7, ver §Decisiones cerradas) — pendiente aprobación general de merge del usuario. SPEC ONLY, sin implementar.
**Domain:** `apps/vertivo_server/` (modelo `EnvironmentalReading`, endpoint `getReadings`) + `k8s/` (imagen Postgres + StatefulSet/PVC en **overlays dev y prod**)
**Tracking issue:** Linear `VRTV` — `[infra/data] TimescaleDB time-series para telemetría de sensores`

---

## Why (Problema)

La telemetría de los sensores (simulador Raspberry → EMQX → backend Serverpod) se persiste
hoy como **filas planas** en la tabla `environmental_readings` de un PostgreSQL **vanilla**
(`pgvector/pgvector:pg16`, `k8s/base/database/deployment.yaml`). El flujo de ingesta vive en
`SensorIngestionService._handleMessage` (`apps/vertivo_server/lib/src/greenhouses/sensor_ingestion_service.dart`):
cada mensaje MQTT hace un `insertRow` plano.

Esto **funciona pero no escala** para IoT time-series. La carga es el producto cartesiano
**flota (tenants) × invernaderos × sensores × tipos de medición × alta frecuencia**:

| # | Síntoma | Efecto |
|---|---|---|
| **P1** | `environmental_readings` es una tabla B-tree única que crece monotónicamente sin particionado temporal. | Inserts y queries se degradan a medida que la tabla crece (índices más grandes, autovacuum más caro). No hay forma barata de archivar/borrar lo viejo. |
| **P2** | `getReadings` (`greenhouse_endpoint.dart`) hace `ORDER BY "createdAt" DESC LIMIT n` sobre la tabla cruda. Los charts del dashboard/app que muestran ventanas (última hora / día / semana) terminan haciendo **full-scan + sort** de datos crudos a alta resolución. | Latencia de los charts crece con la historia; el cliente recibe miles de puntos crudos que igual va a downsamplear en pantalla. |
| **P3** | No hay compresión ni retención. Cada lectura cruda se guarda para siempre a resolución completa en almacenamiento caliente. | Costo de almacenamiento y de backup crece sin techo; el PVC (`k8s/base/database/pvc.yaml`) se llena. |

La telemetría de sensores **es, por definición, time-series**. Persistirla como filas planas
en Postgres vanilla deja sobre la mesa todo lo que TimescaleDB (extensión de Postgres, de
TigerData) ofrece nativamente: particionado temporal automático, rollups pre-computados,
compresión columnar y políticas de retención. Ref de migración:
https://www.tigerdata.com/docs/deploy/self-hosted/migration

## What (Decisiones y recomendaciones)

### Decisión central — D0: desacoplar el hypertable del ORM Serverpod

Antes que cualquier detalle de TimescaleDB, **la decisión que destraba todo lo demás** es sacar
`environmental_readings` del ORM de Serverpod. Es el corazón del change (todas las decisiones de
infra de abajo cuelgan de ésta); por eso se enuncia primero y aparte de la tabla.

> **D0.** `EnvironmentalReading` deja de ser una tabla gestionada por Serverpod (se le quita `table:`
> del `.spy.yaml`); pasa a ser un **modelo serializable** de la API/`vertivo_client`. **La migración
> SQL (el Job idempotente) crea y posee el hypertable**, con la estructura amigable a TimescaleDB.
> Ingesta y lectura usan **SQL crudo** (`session.db.unsafeQuery`/`unsafeExecute`), no el CRUD
> generado; las lecturas de rollup mapean a un modelo nuevo **`EnvironmentalReadingRollup`** (no a
> `EnvironmentalReading`).
>
> **Por qué es central:** como la tabla deja de ser "de Serverpod", el ORM **nunca intenta ponerle
> el `id`-PK** → el conflicto de PK con TimescaleDB (R1) **desaparece de raíz**: sin PK compuesta,
> sin drift, sin cirugía sobre SQL autogenerado. Para telemetría de alta frecuencia, SQL crudo es lo
> correcto de todos modos. Detalle completo en [`design.md` §2 D0](./design.md).

### Decisiones de infra TimescaleDB (cuelgan de D0)

| # | Decisión | Racional |
|---|---|---|
| 1 | **Habilitar la extensión `timescaledb`** (imagen `timescale/timescaledb-ha:pg16` + pgvector, OQ1) en el Postgres de **dev y prod** y convertir `environmental_readings` en **hypertable** particionada por `createdAt`, con **chunk interval de 1 día** (OQ2). | Particionado temporal transparente: chunks por intervalo de tiempo, inserts/queries acotados al chunk relevante. Chunk de 1 día (no el default de 7) da **granularidad fina** para comprimir/dropear por antigüedad a nivel de chunk: la frontera de compresión (>7d) y de retención (>90d) cae limpia entre chunks, sin medio-chunk caliente. |
| 2 | **Continuous aggregates** (materialized views incrementales) para ventanas **1 min / 5 min / 1 hora / 1 día** (OQ6), agregando por `(greenhouseId, measurementType)` con `avg/min/max/count` del `value`. El **1d es un CAGG jerárquico** (se computa sobre el 1h, no sobre crudos). | Los charts consultan el rollup pre-downsampleado en vez de full-scan de crudos. El **1d sobrevive al drop de crudos a 90 días** → habilita la vista de "temporada completa" / histórico largo sin conservar crudos. Las variantes por ventana sirven del CAGG de la resolución adecuada, mapeando a `EnvironmentalReadingRollup`. |
| 3 | **Compresión** de chunks crudos **> 7 días** + **retention policy** que dropea chunks crudos **> 90 días** (los CAGGs sobreviven, con su propia política más larga o infinita; el `_1h` fuente del `_1d` **no** lleva retención corta). | Baja el costo de almacenamiento caliente sin perder la serie agregada; los crudos se conservan solo durante la ventana operativa (90d), mientras los rollups —en especial el 1d— preservan el histórico largo. |

El modelo `EnvironmentalReading` (`environmental_reading.spy.yaml`) **conserva su forma**
(mismas columnas: `greenhouseId`, `measurementType`, `value`, `unit`, `source`, `isAnomaly`,
`createdAt`) y sigue siendo el tipo de la API y de `vertivo_client`. Lo que cambia es la
**propiedad** de la tabla: ya no la gestiona Serverpod sino la migración SQL. El path de ingesta
MQTT mantiene su forma (mismo mensaje, mismo flujo), pero su `insert` pasa a SQL crudo en vez del
CRUD generado.

## Fase 1 / Costura hacia `timeseries_core`

Esta implementación local en Vertivo es deliberadamente la **costura (strangler seam)** de un
patrón Strangler Fig hacia un **microservicio compartido de series temporales** — `timeseries_core`,
cross-producto (no sólo Vertivo). El spike que define ese microservicio vive en
`chimeranext/better-microservices` **issue #76**.

Implicaciones de diseño para que la extracción futura no requiera reescribir:

- **La lógica canónica (la convención del solver de resolución/ventana, el contrato de ingesta y
  de lectura) debe vivir en un solo lugar.** Ingesta y `getReadings` van contra SQL crudo detrás
  de una frontera estrecha y bien nombrada (un servicio/módulo de telemetría), no esparcidos por
  el endpoint. Esa frontera es la costura: hoy resuelve contra el Postgres+TimescaleDB local de
  Vertivo; mañana resuelve contra `timeseries_core` sin que el caller cambie.
- El **desacople del ORM** (decisión central D0) refuerza esto: al no atar la tabla al CRUD generado de
  Serverpod, la telemetría ya queda detrás de una capa de acceso explícita — exactamente lo que
  un microservicio extraído necesita reemplazar.
- La **extracción a `timeseries_core` es out-of-scope pero anticipada**: gatillada por el spike
  #76, no por este change. Aquí sólo dejamos la costura limpia (lógica canónica, una sola fuente
  de verdad de la convención) para que mover el cómputo a un servicio compartido sea un cambio de
  backend de la costura, no una reescritura del dominio.

## Decisiones cerradas (OQ1–OQ7)

El usuario resolvió las open questions. Dejan de ser "abiertas" y pasan a ser decisiones del change:

| OQ | Decisión | Nota |
|----|----------|------|
| **OQ1 — Imagen** | `timescale/timescaledb-ha:pg16` + pgvector encima. | La imagen oficial trae `shared_preload_libraries=timescaledb` (R3); pgvector se añade con `CREATE EXTENSION`. |
| **OQ2 — Chunk interval** | **1 día** (no el default de 7). | Granularidad fina para comprimir/dropear por antigüedad a nivel de chunk; las fronteras 7d/90d caen limpias entre chunks. |
| **OQ3 — Compresión / retención** | Comprimir crudos **> 7 días**; dropear crudos **> 90 días**. Los CAGGs persisten. | Política idéntica en dev y prod (mismo intervalo); la diferencia dev↔prod es el storage, no la política. |
| **OQ4 — Vehículo del SQL** | **Kubernetes `Job` idempotente** versionado en `k8s/`. | Mismo Job (kustomize base) aplicado en ambos overlays; idempotente para re-ejecución segura. |
| **OQ5 — PK de la hypertable (R1)** | **RESUELTA por el desacople del ORM** (decisión central D0): se quita `table:`, la tabla deja de ser de Serverpod, el conflicto de PK desaparece de raíz. | Sin cambios respecto al reframe; ver design D0. |
| **OQ6 — Resoluciones de charts** | **1m / 5m / 1h / 1d**. El **1d** es un CAGG jerárquico (sobre el 1h) **agregado por el usuario** para vistas de temporada completa. | El 1d es el rollup que **sobrevive al drop de crudos a 90d** → habilita el histórico largo. |
| **OQ7 — Alcance** | **DEV + PROD en este mismo change.** | Amplía el scope: design y tasks cubren el StatefulSet/PVC/storage de prod + la ventana de mantenimiento de la conversión inicial, no sólo dev. |

> El change ya **no** es dev-first: cubre la promoción a producción dentro de su alcance. Lo único
> que sigue pendiente es la **aprobación general de merge** del usuario.

## Scope

**In scope (este change):** documentar la decisión (PDR + ADR + tasks); la imagen
`timescale/timescaledb-ha:pg16` + pgvector en **ambos overlays (dev y prod)**; el **desacople del
modelo `EnvironmentalReading` del ORM Serverpod** (quitar `table:`, hypertable poseído por la
migración SQL, ingesta + lectura por SQL crudo); la migración SQL custom (Kubernetes Job
idempotente: hypertable con chunk de 1 día + continuous aggregates **1m/5m/1h/1d** + compresión >7d
+ retención >90d); el impacto en `getReadings` / los charts (servir del CAGG de la resolución
adecuada, incl. 1d para temporada); el orden frente a las migraciones Serverpod; el **despliegue a
producción** (StatefulSet/PVC/storage de prod + ventana de mantenimiento de la conversión inicial,
R5); dejar la **costura** hacia `timeseries_core` limpia (lógica canónica en un solo lugar).

**Out of scope:** cambiar la **forma de columnas** de `EnvironmentalReading` (la forma se
conserva; sólo cambia quién posee la tabla); migrar otras tablas a hypertable (sólo telemetría);
**extraer el microservicio `timeseries_core`** (anticipado, gatillado por el spike #76 de
`chimeranext/better-microservices`); cualquier implementación de código — **este change es SPEC ONLY**.

## References

- ADR: [`design.md`](./design.md) · Tasks: [`tasks.md`](./tasks.md)
- Spike `timeseries_core` (gatillo de la extracción): `chimeranext/better-microservices` issue **#76**
- Tocará (en la implementación, no ahora): `k8s/base/database/` (imagen + StatefulSet/PVC) y los
  overlays `k8s/overlays/dev/` y `k8s/overlays/prod/`; el `Job` de migración SQL custom (base +
  ambos overlays); y posiblemente una variante de `getReadings` en
  `apps/vertivo_server/lib/src/greenhouses/greenhouse_endpoint.dart`.
- Modelo actual: `apps/vertivo_server/lib/src/greenhouses/environmental_reading.spy.yaml`
- Ingesta: `apps/vertivo_server/lib/src/greenhouses/sensor_ingestion_service.dart`
- Migración de referencia TigerData: https://www.tigerdata.com/docs/deploy/self-hosted/migration
