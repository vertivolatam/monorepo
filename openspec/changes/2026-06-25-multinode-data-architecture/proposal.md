# Arquitectura de datos multi-nodo — Turso/libSQL + DuckDB (fractal, resiliente)

**Date:** 2026-06-25
**Owner:** Andrés (andres@dojocoding.io)
**Status:** Proposed — diseño aprobado vía brainstorm
**Domain:** `apps/vertivo_flutter` (móvil) + `apps/vertivo_server` (Serverpod/k8s) + `apps/raspberry` (edge)
**Tracking issue:** _to be created (`area:mobile` / `area:server` / `area:raspberry`)_

---

## Why (Problem)

`vertivo_flutter` hoy es casi una cáscara: solo auth (serverpod_auth_idp) + una pantalla de monitoreo de
pH que lee `greenhouse.getReadings` (scan crudo de Postgres). El transporte es 100% Serverpod RPC; **no
hay GraphQL, ni DB local en el móvil, ni storage/agregación en el Raspberry, ni TimescaleDB** (es solo
spec, PR#14 sin mergear), ni capa de transporte alterno (`apps/raspberry/src/networking/local_communication.py`
es un stub vacío).

El objetivo: que el móvil tenga **charts timeseries estilo Grafana on-device** para analizar la
telemetría de los invernaderos, con **resiliencia a desastres** (graceful degradation
WiFi/LAN → celular → BT → Zigbee → LoRa/Meshtastic → satélite) y comunicación directa Raspberry→móvil
cuando se cae internet. Además, la config del orquestador está **fragmentada en múltiples fuentes de
verdad** (`config/{current,defaults}/*.json` del Pi, columnas threshold de `greenhouse.spy.yaml`,
setpoints de `crop_explorer/crops.db`) → schema drift que hay que consolidar.

## What (Decisions)

| # | Decisión | Razón |
|---|----------|-------|
| 1 | **No GraphQL.** El query flexible corre on-device sobre DuckDB; el server solo entrega snapshots paramétricos. | GraphQL duplicaría Serverpod sin beneficio; su flexibilidad se muda a DuckDB local. |
| 2 | **Timescale se queda, DuckDB se suma (no se sustituyen).** | Timescale = ingesta alta tasa + CAGGs + retención (PR#14). DuckDB = OLAP/export. Sustituir Timescale rompería la ingesta concurrente. |
| 3 | **Serverpod/Postgres no se reemplaza por libSQL.** libSQL entra como fabric de replicación paralelo. | Serverpod está casado con Postgres (ORM/migraciones/cliente generado). |
| 3b | **Un solo ORM, CQRS.** Postgres/Serverpod = write model; libSQL = read model proyectado por worker delgado (no Drizzle); sin Apollo/GraphQL. | Evita el smell de 3 stacks de acceso a datos. |
| 4 | **RPC se encoge a auth + token minting.** Reads → sync libSQL; comandos → outbox-over-sync. | Resiliencia > respuesta inmediata; comandos offline se encolan y reconcilian. |
| 5 | **Turso cloud (dev/PoC + prod inicial), granularidad por rol de nodo.** Escape hatch: `sqld` self-hosted. | Many-DB + embedded replicas nativas; telemetría en Timescale mantiene writes bajos; `sqld` open-source si soberanía LATAM/costo lo exigen. |
| 6 | **Tres clases de dato al móvil:** OLTP/config por libSQL sync · live por MQTT (server o Pi) · histórico OLAP por Parquet→DuckDB. | Cada dato por su canal correcto; MQTT solo live, Parquet solo histórico. |
| 7 | **Config = device-shadow con precedencia cloud + provenance.** `policy` con estados `desired`/`reported`/`override`. | Override on-site posible pero auditado; provenance = trazabilidad + gate de seguridad + evidencia de garantía anti-fraude. |
| 8 | **Tenancy multi-resolución:** DB-por-invernadero (Pi) ⊂ DB-por-cuenta (móvil) ⊂ DB-por-cohorte+RLS (server). | La frontera de la DB = la frontera de sync del nodo (embedded replica es 1:1). |

**In scope (este change = decision records):** PDR + ADRs + roadmap por fases. La implementación se
ejecuta en changes/PRs por fase (Pre-0 → 5).

**Out of scope:** implementación de runtime (se entrega por fase); el operador satelital bidireccional
para downlink (TinyGS solo cubre uplink — diferido a Fase 4 comercial); semántica legal de
`warranty_void` (alineación ToS — legal).

## Open questions for the owner

Las decisiones estructurales quedaron cerradas en el brainstorm. Restan **decisiones de implementación
diferidas por fase** (no bloquean):

1. Fase 1: export worker DuckDB (Python+duckdb vs `duckdb` CLI) · object store (MinIO vs S3).
2. Fase 2: package libSQL Dart (`libsql_dart` vs `turso_dart`) · charts (`fl_chart` vs syncfusion) — spike FFI/NDK.
3. Fase 3: broker MQTT del Pi (mosquitto vs NanoMQ).
4. Fase 4: operador satelital bidireccional (TinyGS solo uplink; FOSSA / Orbital Space CR para downlink).
5. Legal: qué `mechanism` marca `warranty_void`, alineado a ToS/garantía.

## References

- ADR: [`design.md`](./design.md) · Tasks: [`tasks.md`](./tasks.md)
- Plan de brainstorm: `~/.claude-andres/plans/purring-sauteeing-kay.md` (sesión 2026-06-25).
- PR#14 TimescaleDB (worktree `timescaledb-spec`): `openspec/changes/2026-06-21-timescaledb-timeseries/`.
- Spike timeseries_core (diferido): `chimeranext/better-microservices` #76/#77.
- Contrato de datos del pipeline: `apps/raspberry/config/current/mqtt_dev.json` (topics) +
  `apps/vertivo_server/lib/src/greenhouses/sensor_ingestion_service.dart` (ingestor).
- Hardware transporte: Vencoel (InHand 4G/5G · RAKwireless LoRa · Digi Zigbee · Anybus WiFi); celular Pi
  add-on (Quectel EC25 + Sixfab HAT u Oratek Tofu, vía ModemManager); satélite LoRa I2C (Heltec LoRa 32
  V2 / TinyGS / FOSSA / Orbital Space CR).
