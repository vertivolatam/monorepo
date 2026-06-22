# TimescaleDB time-series — migrar la telemetría de sensores a hypertable + continuous aggregates

**Date:** 2026-06-21
**Owner:** Andrés (andres@dojocoding.io)
**Status:** Proposed — pendiente aprobación del usuario (SPEC ONLY, sin implementar)
**Domain:** `apps/vertivo_server/` (modelo `EnvironmentalReading`, endpoint `getReadings`) + `k8s/` (imagen Postgres del overlay dev)
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

| # | Decisión | Racional |
|---|---|---|
| 1 | **Habilitar la extensión `timescaledb`** en el Postgres del overlay dev y convertir `environmental_readings` en **hypertable** particionada por `createdAt` (`create_hypertable('environmental_readings','createdAt')`). | Particionado temporal transparente: chunks por intervalo de tiempo, inserts/queries acotados al chunk relevante en vez de a la tabla completa. |
| 2 | **Continuous aggregates** (materialized views incrementales) para ventanas **1 min / 5 min / 1 hora**, agregando por `(greenhouseId, measurementType)` con `avg/min/max/count` del `value`. | Los charts consultan el rollup pre-downsampleado en vez de hacer full-scan de crudos. `getReadings` (o una variante por ventana) sirve directo del continuous aggregate. |
| 3 | **Compresión** de los chunks viejos (más allá de una ventana caliente, p.ej. > 7 días) + **retention policy** que dropea chunks crudos antiguos (los rollups sobreviven). | Baja el costo de almacenamiento caliente sin perder la serie agregada; los crudos se conservan solo durante la ventana operativa. |
| 4 | **Desacoplar el hypertable del ORM Serverpod.** `EnvironmentalReading` deja de ser una tabla gestionada por Serverpod (se le quita `table:` del `.spy.yaml`); pasa a ser un modelo serializable de la API/`vertivo_client`. **La migración SQL (el Job idempotente) crea y posee el hypertable**, con la estructura amigable a TimescaleDB. Ingesta y `getReadings` usan **SQL crudo** (`session.db.unsafeQuery`/`unsafeExecute`), no el CRUD generado. | Como la tabla deja de ser "de Serverpod", el ORM **nunca intenta ponerle el `id`-PK** → el conflicto de PK con TimescaleDB (R1) **desaparece de raíz**: sin PK compuesta, sin drift, sin cirugía sobre SQL autogenerado. Para telemetría de alta frecuencia, SQL crudo es lo correcto de todos modos. |

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
- El **desacople del ORM** (decisión 4) refuerza esto: al no atar la tabla al CRUD generado de
  Serverpod, la telemetría ya queda detrás de una capa de acceso explícita — exactamente lo que
  un microservicio extraído necesita reemplazar.
- La **extracción a `timeseries_core` es out-of-scope pero anticipada**: gatillada por el spike
  #76, no por este change. Aquí sólo dejamos la costura limpia (lógica canónica, una sola fuente
  de verdad de la convención) para que mover el cómputo a un servicio compartido sea un cambio de
  backend de la costura, no una reescritura del dominio.

## Scope

**In scope (este change):** documentar la decisión (PDR + ADR + tasks); la imagen Postgres
con `timescaledb` en el overlay dev; el **desacople del modelo `EnvironmentalReading` del ORM
Serverpod** (quitar `table:`, hypertable poseído por la migración SQL, ingesta + lectura por SQL
crudo); la migración SQL custom post-deploy (hypertable + continuous aggregates 1m/5m/1h +
compresión + retention); el impacto en `getReadings` / los charts (servir del continuous
aggregate); el orden frente a las migraciones Serverpod; dejar la **costura** hacia `timeseries_core`
limpia (lógica canónica en un solo lugar).

**Out of scope:** cambiar la **forma de columnas** de `EnvironmentalReading` (la forma se
conserva; sólo cambia quién posee la tabla); migrar otras tablas a hypertable (sólo telemetría);
**extraer el microservicio `timeseries_core`** (anticipado, gatillado por el spike #76 de
`chimeranext/better-microservices`); el overlay de producción (este change es dev-first, la
promoción a prod es un follow-up); cualquier implementación de código — **este change es SPEC ONLY**.

## References

- ADR: [`design.md`](./design.md) · Tasks: [`tasks.md`](./tasks.md)
- Tocará (en la implementación, no ahora): `k8s/base/database/deployment.yaml` (imagen),
  un manifiesto/Job de migración SQL custom, y posiblemente una variante de `getReadings`
  en `apps/vertivo_server/lib/src/greenhouses/greenhouse_endpoint.dart`.
- Modelo actual: `apps/vertivo_server/lib/src/greenhouses/environmental_reading.spy.yaml`
- Ingesta: `apps/vertivo_server/lib/src/greenhouses/sensor_ingestion_service.dart`
- Migración de referencia TigerData: https://www.tigerdata.com/docs/deploy/self-hosted/migration
