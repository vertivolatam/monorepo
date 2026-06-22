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
| 4 | **Migración SQL custom post-deploy** (NO una migración Serverpod). Las migraciones Serverpod (`apps/vertivo_server/migrations/`, aplicadas con `dart bin/main.dart --apply-migrations`, `Makefile:290`) son SQL autogenerado que **desconoce TimescaleDB**: deben seguir creando la tabla; la conversión a hypertable + aggregates + policies va en un paso SQL idempotente que corre **después** de que Serverpod crea la tabla. | Serverpod es la fuente de verdad del esquema relacional; TimescaleDB es una capa de almacenamiento sobre esa misma tabla. El orden (Serverpod crea → SQL custom convierte) es el riesgo central, tratado en el ADR. |

El modelo `EnvironmentalReading` (`environmental_reading.spy.yaml`) y su tabla **no cambian de
forma** (mismas columnas: `greenhouseId`, `measurementType`, `value`, `unit`, `source`,
`isAnomaly`, `createdAt`). La hypertable es la misma tabla; sólo cambia cómo Postgres la
almacena por debajo. El path de ingesta MQTT no cambia.

## Scope

**In scope (este change):** documentar la decisión (PDR + ADR + tasks); la imagen Postgres
con `timescaledb` en el overlay dev; la migración SQL custom post-deploy (hypertable +
continuous aggregates 1m/5m/1h + compresión + retention); el impacto en `getReadings` / los
charts (servir del continuous aggregate); el orden frente a las migraciones Serverpod.

**Out of scope:** cambiar el modelo `EnvironmentalReading` o su forma de columnas; reescribir
el path de ingesta MQTT (`SensorIngestionService`); migrar otras tablas a hypertable (sólo
telemetría); el overlay de producción (este change es dev-first, la promoción a prod es un
follow-up); cualquier implementación de código — **este change es SPEC ONLY**.

## References

- ADR: [`design.md`](./design.md) · Tasks: [`tasks.md`](./tasks.md)
- Tocará (en la implementación, no ahora): `k8s/base/database/deployment.yaml` (imagen),
  un manifiesto/Job de migración SQL custom, y posiblemente una variante de `getReadings`
  en `apps/vertivo_server/lib/src/greenhouses/greenhouse_endpoint.dart`.
- Modelo actual: `apps/vertivo_server/lib/src/greenhouses/environmental_reading.spy.yaml`
- Ingesta: `apps/vertivo_server/lib/src/greenhouses/sensor_ingestion_service.dart`
- Migración de referencia TigerData: https://www.tigerdata.com/docs/deploy/self-hosted/migration
