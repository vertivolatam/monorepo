# Arquitectura de datos multi-nodo — Architecture (ADRs)

**Issue:** _to be created_ (`area:mobile` / `area:server` / `area:raspberry`)
**Status:** Decision 2026-06-25 (brainstorm aprobado)
**PDR:** [`proposal.md`](./proposal.md)

## TL;DR

Arquitectura tri-nodo **fractal**: los tres nodos (server, Raspberry, móvil) corren **la misma pareja de
motores** — **libSQL/Turso** (OLTP + sync, concurrencia que SQLite vanilla no tiene) y **DuckDB** (OLAP
columnar + Parquet) — con roles/escala distintos pero **contratos compartidos**. El server suma
**TimescaleDB** como backbone canónico de histórico grande. Cada clase de dato viaja por su canal:
**OLTP/config por libSQL sync, telemetría live por MQTT (server o Pi), histórico OLAP por Parquet→DuckDB**;
los comandos como cola sobre sync (offline-first).

```
                         ┌──────────────── SERVER (k8s) ────────────────┐
  Raspberry (Pi)         │ Postgres+Serverpod (write model, ÚNICO ORM)   │      Móvil (Flutter)
  ┌───────────────┐ MQTT │ + TimescaleDB (canónico) + MinIO (Parquet)    │      ┌───────────────┐
  │ sensores I2C  │─────▶│ + Turso/sqld (read model, DB-por-cohorte+RLS) │      │ libSQL replica │
  │ libSQL (gh DB)│◀────▶│ worker proyección MULTI-RESOLUCIÓN            │◀────▶│ (cuenta DB)    │
  │ DuckDB (edge) │ sync │   invernadero ⊂ cuenta ⊂ cohorte             │ sync │ DuckDB (charts)│
  │ broker MQTT   │      │ DuckDB export → Parquet → MinIO (URL firmada) │      │ MQTT subscriber│
  └───────┬───────┘      └───────────────────────────────────────────────┘      └───────▲───────┘
          │  fallback directo (LAN/WiFi/BT/LoRa/satélite, ConnectivityManager)            │
          └──────────────────────────────────────────────────────────────────────────────┘
```

## ADR-1 — Tres clases de dato, cada una por su canal

El móvil recibe tres clases con transportes distintos:
1. **OLTP operativo/config** (atributos de invernadero, config del orquestador, alertas, outbox) →
   **libSQL/Turso** embedded replica (sync de frames binarios, leído con SQL local; offline-first).
2. **Telemetría live** → **MQTT** (el móvil es suscriptor). Fuente = EMQX cloud o broker local del Pi,
   según `ConnectivityManager`. Buffer `recent_readings` **local-only** (no paga writes de Turso),
   ventana 7d default parametrizable (3/7/15/30) desde la app.
3. **Histórico OLAP** → **Parquet/rollups** (Timescale o Pi) → **DuckDB** on-device para los charts.

*Matiz:* MQTT solo el live, Parquet solo el histórico. Solo config/comandos/alertas pagan writes de Turso.

## ADR-2 — Timescale + DuckDB combinados (no sustitución)

Timescale (en el Postgres de Serverpod, PR#14): ingesta MQTT alta tasa, CAGGs 1m/5m/1h/1d, compresión
7d, retención 90d. DuckDB: motor OLAP/export (Postgres→Parquet en el server; charts interactivos
on-device). DuckDB es single-writer → malo como destino de ingesta concurrente; Timescale es lo opuesto.

## ADR-3 — CQRS con un solo ORM, sin GraphQL

La OLTP/config **no viaja como SQL-text ni JSON/GraphQL**: libSQL replica a nivel de **frames/WAL
(binario)**; el `SELECT` corre contra la réplica local. Patrón CQRS:
- **Write model = Postgres/Serverpod** (único ORM — preserva FKs, auth/`userId`, relacional).
- **Read model = libSQL** poblado por un **worker de proyección delgado** (cliente libSQL con SQL
  parametrizado, NO un segundo ORM tipo Drizzle).
- **Escrituras de device = outbox-over-sync** → worker del server aplica al write model → re-proyecta.
- **Sin Apollo/GraphQL** → queda 1 ORM + 1 worker de proyección + 1 cliente libSQL acotado.
- Ni RPC ni GraphQL cargan el Parquet inline: un RPC `analytics.getSnapshotManifest` devuelve metadata +
  URL firmada a MinIO; el binario se baja por HTTP.

## ADR-4 — Tenancy multi-resolución por rol de nodo

La frontera de la DB libSQL = la frontera de sync del nodo (embedded replica es **1:1 de una DB entera**;
no hay replicación filtrada por fila). Cada nodo replica la **resolución** de su alcance — DBs derivadas:

| Nodo | Granularidad | Por qué |
|------|-------------|---------|
| **Raspberry** | DB-por-invernadero | El Pi vive en 1 gh; réplica chica, blast radius mínimo, sin RLS |
| **Móvil** | DB-por-tenant/cuenta | El teléfono = 1 cuenta; replica sus invernaderos, nada ajeno |
| **Server** | DB-por-cohorte + RLS | Tiene a todos; segmenta free/paid/B2C/B2B/B2G; analytics cross-cohorte + billing |

**Jerarquía de proyección** `invernadero ⊂ cuenta ⊂ cohorte`, todas derivadas del write model canónico por
el worker multi-resolución. Config `desired` baja cohorte→cuenta→invernadero; telemetría sube Pi→server
por MQTT; overrides/comandos suben por outbox; alertas burbujean. **RLS solo en el tier cohorte.** El
segmento es un atributo en todos los tiers; solo es frontera de DB en el server.

## ADR-5 — Config del orquestador: device-shadow + provenance

Consolidar el drift (Pi JSON + columnas `greenhouse` + `crops.db`) a un modelo canónico (Fase Pre-0). El
orquestador del Pi lee bounds de la **réplica libSQL local** (no de `config/current/*.json`);
`defaults/*.json` → seed. Modelo device-shadow con **precedencia cloud**:
- **`policy`** = atributo gobernado (p.ej. `ph_lower_bound`) con sus reglas; cada policy tiene
  **`desired`** (cloud, autoritativo) / **`reported`** (lo que corre el Pi) / **`override`** (desviación local).

**Provenance gate (no guardar ciego):** cada cambio del edge carga `mechanism`
(mobile_app · local_web_ui · local_python_ui · ssh · manual_file_edit · api), `actor`, `reason`,
`channel`, `appliedAt`, `version`, `warranty_void`. El worker de reconciliación inspecciona antes de
aceptar → `quarantine/review`, no upsert ciego; el cloud puede *snap-back*. **Triple función:**
trazabilidad · gate de seguridad (bound peligroso en review) · **evidencia de garantía anti-fraude**
(jailbreak/overclock vía ssh/manual_file_edit prueba que el cliente anuló garantía → no reembolso de mala
fe). El provenance es inmutable/tamper-evident reusando la hash-chain del endpoint `traceability`
(`addRecord`/`getChain`/`verifyChain`).

## ADR-6 — Ladder de transportes + satélite asimétrico

`ConnectivityManager` (móvil y Pi) con prioridad [100..10] + perfil de capacidad; **el tier decide la
clase de dato**:

| Prio | Transporte | Hardware | Clase de dato |
|------|-----------|----------|---------------|
| 100 | WiFi (móvil) / LAN-Ethernet (Pi) | Anybus / NIC | sync completa + MQTT live + Parquet |
| 80 | Celular 4G/5G (add-on) | InHand · Quectel EC25 + Sixfab/Oratek (ModemManager) | sync completa + MQTT live + Parquet |
| 60 | Bluetooth | BLE | MQTT live + ventana reciente |
| 40 | Zigbee/DigiMesh/Wi-SUN | Digi | telemetría crítica + alertas + comandos |
| 20 | LoRa/LoRaWAN/Meshtastic | RAKwireless | escalares críticos + alertas (CBOR) |
| 10 | Satélite (solo Pi) | Heltec LoRa 32 V2 / RAK por I2C | bidireccional: ↑alarma/heartbeat · ↓comando crítico (bytes) |

WiFi/LAN = 100 (estabilidad MQTT, sin costo de datos); celular = 80 (respaldo + add-on hardware en el
Pi). **Satélite (tier 10)** es asimétrico, solo Pi, transceiver LoRa en el bus I2C del multiplexor de
sensores: uplink store-and-forward (alarma crítica) vía **TinyGS** (PoC, red receptora); downlink
(comando crítico, latencia horas) requiere operador bidireccional (FOSSA / Orbital Space CR) — diferido.

## Riesgos

1. **Multi-primario libSQL (crítico):** sync contra UN primario. Pi = fallback read-mostly; escrituras en
   outage → outbox idempotente, reconcilia al cloud (autoridad única).
2. **FFI/NDK Android** (DuckDB+libSQL): spike temprano en Fase 2 (ABIs, tamaño `.so`).
3. **Proyección multi-resolución:** consistencia `invernadero⊂cuenta⊂cohorte` desde un write model →
   proyección idempotente + tests cross-resolución; RLS correcto en cohorte (no filtrar tenants).
4. **Dual-store server** (Postgres+libSQL+Timescale+MinIO): libSQL como subconjunto, no espejo total.
5. **Soberanía/costo Turso:** residencia LATAM solo Enterprise BYOC → escape hatch `sqld` self-hosted.
6. **Warranty-void legal:** alinear con ToS; cuidar privacidad del `actor`.
