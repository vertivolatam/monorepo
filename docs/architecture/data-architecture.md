# Arquitectura de datos multi-nodo — Referencia (tri-nodo fractal)

**Fecha:** 2026-06-25
**Estado:** Diseño aprobado (brainstorm 2026-06-25). Roadmap por fases Pre-0 → 5, en implementación.
**SSOT de la decisión:** este documento es **referencia/overview**. Las decisiones canónicas
(PDR + ADR-1..6 + tasks) viven en el OpenSpec change
[`2026-06-25-multinode-data-architecture`](../../openspec/changes/2026-06-25-multinode-data-architecture/)
— ante cualquier discrepancia, **gana el OpenSpec**.

> **Alcance.** Cómo viajan y se almacenan los datos de Vertivo entre los tres nodos del sistema
> (server, Raspberry, móvil), qué motor sirve a cada clase de dato, y cómo el sistema degrada con
> gracia cuando se cae internet. No describe la UI ni el modelo de negocio (ver `content/docs/`).

---

## Glosario rápido (para leer antes del resto)

| Término | Definición corta | Inglés (referencia) |
|---|---|---|
| Nodo | Cada uno de los tres ejecutores de datos: server, Raspberry (Pi), móvil. | node |
| Fractal | Misma pareja de motores en los tres nodos, a escala/rol distintos. | fractal |
| OLTP | Datos operativos/transaccionales (config, alertas, comandos). | OLTP |
| OLAP | Consulta analítica sobre histórico (los charts). | OLAP |
| Réplica embebida | Copia local de una DB libSQL que sincroniza contra un primario. | embedded replica |
| Sync de frames | Replicación binaria a nivel WAL (no SQL-text ni JSON). | frame/WAL sync |
| CQRS | Separar el modelo de escritura del de lectura. | Command Query Responsibility Segregation |
| Device-shadow | Estado deseado/reportado/override de un dispositivo. | device shadow |
| Provenance | Metadata de quién/cómo/por qué cambió un parámetro. | provenance |
| Outbox | Cola local de comandos que sincroniza al volver la conexión. | command-queue-over-sync |
| Ladder de transportes | Cascada de transportes por prioridad (WiFi → … → satélite). | transport ladder |
| Cohorte | Segmento de cuentas (free/paid/B2C/B2B/B2G). | cohort |

---

## 1. Tres nodos, los mismos motores (fractal)

Los tres nodos corren **la misma pareja de motores** — **libSQL/Turso** (OLTP + sync, con concurrencia
que SQLite vanilla no tiene) y **DuckDB** (OLAP columnar + Parquet) — con roles y escala distintos pero
**contratos idénticos** (schema libSQL, schema Parquet, sobre de comando CBOR, JWT de sync). El server
suma **TimescaleDB** como backbone canónico del histórico grande. Implementaciones políglotas: Python en
el Pi, Dart en server y móvil.

| Nodo | libSQL/Turso | DuckDB | Extra | Rol |
|------|-------------|--------|-------|-----|
| **Server** (Serverpod/Dart, k8s) | `sqld` self-hosted o Turso = **primario de sync** | export worker → Parquet | **TimescaleDB** (canónico) + Postgres (Serverpod/auth) + MinIO (Parquet) | Ingesta MQTT, histórico grande, autoridad de auth/tokens, origen de snapshots |
| **Raspberry** (Python, Balena) | buffer crudo local + **primario de sync de fallback** | rollups de borde → Parquet | broker MQTT local (EMQX/mosquitto/NanoMQ) | Durabilidad de borde, analítica de fallback, server directo al móvil en outage |
| **Móvil** (Flutter/Dart, Android) | **réplica embebida** (OLTP/config + outbox de comandos) | motor de los charts Grafana-style | `fl_chart` + **suscriptor MQTT** (live) | Offline-first, live por MQTT, análisis interactivo local |

---

## 2. Tres clases de dato, cada una por su canal

El móvil (y el resto de los nodos) trata **tres clases de dato distintas**, y cada una viaja por **su
canal correcto**. Éste es el corazón de la arquitectura:

1. **OLTP operativo/config** (atributos de invernadero, config del orquestador, alertas, outbox)
   → **libSQL/Turso** réplica embebida (sync de frames binarios, leído con SQL local; offline-first).
   Reemplaza `getReadings` y el CRUD por RPC.
2. **Telemetría live de monitoreo** → **MQTT** (el móvil es **suscriptor**). Fuente = **server (EMQX
   cloud) o Raspberry (broker local)** según el modo del `ConnectivityManager`. El live se bufferea en un
   `recent_readings` **local-only** (no sincroniza por Turso → no paga writes de telemetría), ventana
   **7 días por defecto, parametrizable (3/7/15/30)** desde la app.
3. **Histórico OLAP analítico** → **Parquet/rollups** generados por **DuckDB en el server**
   (Timescale→Parquet) **o en el Pi** (rollups de borde) → consumidos por el **DuckDB del móvil** para
   los charts, y por el **DuckDB del Pi** sirviendo analítica directa al móvil en el fallback de desastre.
   (DuckDB corre en los **tres** nodos — principio fractal; "on-device" en los charts = el motor del teléfono.)

> **Matiz clave:** MQTT lleva **solo el live**, NO el histórico desagregado (eso va por Parquet). Solo
> config/comandos/alertas sincronizan por Turso; **la telemetría nunca paga writes de Turso** → el costo
> se mantiene bajo y el histórico grande vive en Timescale.

### Entrega de Parquet (no inline)
Ni RPC ni GraphQL cargan el binario. Un RPC liviano `analytics.getSnapshotManifest(greenhouseId, window)`
devuelve **metadata JSON** (qué snapshots, rango, checksum) + **URL firmada** a MinIO/S3; el móvil baja
el Parquet por HTTP y lo abre con DuckDB. Por eso **no se agrega GraphQL**: su flexibilidad se mudó a
DuckDB on-device.

---

## 3. Diagrama tri-nodo

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

  Leyenda de canales:
    ──▶ MQTT (telemetría live)      ◀──▶ sync libSQL (OLTP/config + outbox)     Parquet → DuckDB (histórico OLAP)
```

---

## 4. CQRS con un solo ORM, sin GraphQL

La OLTP/config **no viaja como "SQL-text" ni como "JSON/GraphQL"**: la sync libSQL replica a nivel de
**frames/WAL (binario)**; el `SELECT` corre contra la **réplica local** y nunca cruza la red. Es
replicación de estado (offline-first), no request/response.

- **Write model = Postgres/Serverpod** (el **único ORM** — preserva FKs, auth/`userId`, modelo relacional).
- **Read model = libSQL `sqld`**, poblado por un **worker de proyección delgado** (cliente libSQL con SQL
  parametrizado, **NO** un segundo ORM tipo Drizzle). Los dispositivos leen esta proyección.
- **Escrituras de dispositivo = outbox-over-sync** → un worker del server las aplica al write model
  (Serverpod) → re-proyecta. Autoridad de escritura única (cloud).
- **Sin Apollo/GraphQL.** Se evita el smell de 3 stacks (Serverpod ORM + Drizzle + Apollo): queda
  **1 ORM + 1 worker de proyección + 1 cliente libSQL acotado**.

El **plano de control** = Serverpod RPC reducido a **mintear el JWT que la sync necesita** + ops pesadas
puntuales. Los comandos se mueven a un **command-queue-over-sync** (outbox): se encolan local y
sincronizan contra cualquier primario alcanzable (cloud o Pi); workers del server/Pi los aplican. Esto es
lo que hace el control resiliente a outages.

---

## 5. Tenancy: granularidad de DB por rol de nodo (multi-resolución)

La frontera de la DB libSQL = la frontera de sync del nodo. Como la réplica embebida es **1:1 de una DB
entera** (no hay replicación filtrada por fila), cada nodo replica la **resolución** que coincide con su
alcance — son DBs **derivadas por resolución**, no una DB compartida con vistas:

| Nodo | Granularidad | Por qué |
|------|-------------|---------|
| **Raspberry** | **DB-por-invernadero** | El Pi vive en 1 gh; réplica chica, offline-first, blast radius mínimo, sin RLS |
| **Móvil** | **DB-por-tenant/cuenta** | El teléfono = 1 cuenta; replica todos sus invernaderos, nada ajeno; privacidad perfecta |
| **Server (k8s)** | **DB-por-cohorte + RLS** | Tiene a todos; agrupa por segmento (free/paid/B2C/B2B/B2G); pocas DBs; analytics cross-cohorte + billing/SLA |

**Jerarquía de proyección:** `invernadero ⊂ cuenta ⊂ cohorte`, todas proyectadas desde el write model
canónico (Postgres/Timescale) por el worker multi-resolución. Direcciones: config `desired` baja
cohorte→cuenta→invernadero; telemetría sube Pi→server por **MQTT**; overrides/comandos suben por
**outbox**; alertas burbujean. **RLS solo en el tier cohorte/server** (los tiers device están aislados por
DB). El segmento es un **atributo** en todos los tiers; solo es *frontera de DB* en el server.

---

## 6. Config del orquestador: device-shadow con provenance

Hoy los bounds viven fragmentados en **5 superficies** (`config/{current,defaults}/*.json` del Pi,
columnas threshold en `greenhouse.spy.yaml`, setpoints en `crop_explorer/crops.db`, más tablas SQL de
Serverpod) → schema drift, auditado en
[`docs/repo-health/SCH-audit-2026-06-25.md`](../repo-health/SCH-audit-2026-06-25.md) y remediado en la
**Fase Pre-0** ([`2026-06-25-config-setpoint-canonicalization`](../../openspec/changes/2026-06-25-config-setpoint-canonicalization/)).
Se consolida a **un modelo canónico** que es la clase OLTP/config: el orquestador del Pi **lee sus bounds
de la réplica libSQL local** (no de los JSON); `defaults/*.json` → seed de bootstrap; `current/*.json` →
reemplazado por la réplica.

Modelo **device-shadow con precedencia cloud**:
- **`policy`** = el atributo de config gobernado (p.ej. `ph_lower_bound`) con sus reglas/límites permitidos.
  Cada policy tiene los 3 estados shadow:
  - **`desired`** = intención canónica (cloud/Postgres, autoritativa).
  - **`reported`** = lo que el Pi corre realmente (réplica libSQL).
  - **`override`** = desviación local (experimento de lab, usuario experto "overclock/jailbreak") con provenance.

**Provenance gate (no guardar ciego):** todo cambio originado en el edge carga metadata — `mechanism`
(`mobile_app` · `local_web_ui` · `local_python_ui` · `ssh` · `manual_file_edit` · `api`), `actor`,
`reason`/`experiment_id`, `channel`/tier usado, `appliedAt`, `version`, `warranty_void`. El worker de
reconciliación **inspecciona la provenance antes de aceptar** → estado `quarantine/review`, NO upsert
ciego; el cloud puede *snap-back* si rechaza. **Triple función:**

1. **Trazabilidad** de quién/cómo/por qué cambió un parámetro.
2. **Gate de seguridad** — un bound peligroso queda en review, no se propaga solo.
3. **Evidencia de garantía (anti-fraude / billing)** — si un cliente hace jailbreak/overclock vía
   `ssh`/`manual_file_edit` y daña equipo o cultivo, el registro prueba que **anuló la garantía** → no
   puede reclamar reembolso de mala fe. Ciertos `mechanism` marcan `warranty_void`.

Para servir como evidencia, el provenance es **inmutable / append-only / tamper-evident anclado en el
server**, reusando la hash-chain del endpoint `traceability` ya existente (`addRecord` / `getChain` /
`verifyChain`, `apps/vertivo_server/lib/src/traceability/traceability_endpoint.dart`).

---

## 7. Ladder de transportes (móvil y Pi)

`ConnectivityManager` con prioridad [100..10] + perfil de capacidad por driver. **El tier decide la clase
de dato** que fluye:

| Prio | Transporte | Hardware | Clase de dato |
|------|-----------|----------|---------------|
| **100** | **WiFi (móvil) / LAN-Ethernet (Pi)** | Anybus Wireless Bolt / NIC on-board | sync libSQL completa + **MQTT live** + Parquet |
| **80** | **Celular 4G/5G (add-on)** | InHand router · Quectel EC25 + Sixfab HAT u Oratek Tofu (vía ModemManager) | sync libSQL completa + **MQTT live** + Parquet |
| 60 | Bluetooth | BLE móvil | **MQTT live** + ventana reciente + rollups chicos |
| 40 | Zigbee/DigiMesh/Wi-SUN | Digi Gateway | telemetría crítica + alertas + comandos |
| 20 | LoRa/LoRaWAN/Meshtastic | RAKwireless RAK7268/RAK | solo escalares críticos + alertas (CBOR) |
| 10 | **Satélite (direct-to-sat LoRa, solo Pi)** | Heltec LoRa 32 V2 / RAK por **I2C** | bidireccional: ↑alarma crítica+heartbeat / ↓comando crítico (bytes, latencia horas) |

**Por qué WiFi/LAN = 100 y celular = 80:** WiFi (móvil) y Ethernet/LAN (Pi) son lo más estable para
mitigar pérdida de paquetes MQTT de los sensores y no tienen costo de datos. El celular es respaldo y
**requiere hardware add-on en el Pi** (no viene embedded): un módem miniPCIe (p.ej. Quectel EC25-EFA) +
carrier (Sixfab Base HAT u Oratek Tofu) + SIM + antenas, manejado vía **ModemManager**. Varios módems
traen GNSS/GPS (útil: `greenhouse` ya tiene lat/long).

Los drivers son hardware-agnósticos detrás de una interfaz común `Transport`; el stub
`apps/raspberry/src/networking/local_communication.py` es la costura en el Pi.

### Satélite (tier 10) — caso especial asimétrico
No está en la malla teléfono↔Pi. Es **direct-to-satellite LoRa**: un transceiver colgado del **bus I2C
del Pi** (el mismo del multiplexor de sensores `dag_I2C_multiplexor.py`). Características:
store-and-forward, intermitente (pasadas LEO pocas veces/día), payload de bytes. Es el canal de **último
recurso del Pi** cuando WiFi/celular/LoRa-terrestre están todos caídos.

- **Uplink** (↑, principal): Pi → satélite → ground-station → internet → server. Solo alarma crítica +
  heartbeat. El teléfono lo recibe **indirectamente** por sync normal al recuperar conexión. Backhaul:
  **TinyGS** (red community receptora, gratis — elegido para el PoC).
- **Downlink** (↓, bidireccional): server → satélite → Pi, para **comando crítico de emergencia** (otro
  transporte del command-queue-over-sync, idempotente, latencia de horas). **TinyGS no cubre downlink** →
  requiere operador bidireccional comercial (FOSSA Systems; Orbital Space Technologies, Costa Rica, como
  partnership LATAM) → habilitación real diferida a Fase 4 (decisión comercial).

---

## 8. Decisiones clave (rationale resumido)

Los ADRs canónicos están en
[`design.md`](../../openspec/changes/2026-06-25-multinode-data-architecture/design.md) (ADR-1..6). En
síntesis:

1. **No GraphQL** — el query flexible vive en DuckDB on-device; el server solo entrega snapshots paramétricos.
2. **Timescale se queda, DuckDB se suma** (no se sustituyen): ingesta concurrente vs OLAP/export.
3. **Serverpod/Postgres no se reemplaza por libSQL** — libSQL entra como fabric de replicación paralelo.
   **CQRS con un solo ORM**, sin Apollo/GraphQL.
4. **RPC se encoge a auth + token minting**; reads → sync, comandos → outbox-over-sync.
5. **Turso cloud para dev/PoC y prod inicial** (granularidad por rol de nodo); **escape hatch**: `sqld`
   self-hosted (mismo protocolo open-source) si la soberanía LATAM o el costo a escala lo exigen.
6. **Device-shadow `desired/reported/override` + `policy`** con provenance (seguridad + evidencia de garantía).

---

## 9. Roadmap por fases (resumen)

El detalle ejecutable vive en
[`tasks.md`](../../openspec/changes/2026-06-25-multinode-data-architecture/tasks.md).

| Fase | Qué entrega |
|------|-------------|
| **Pre-0** | Consolidación del schema drift de config a un modelo canónico (`setpoint`/`orchestrator_config`). Ver [`config-setpoint-canonicalization`](../../openspec/changes/2026-06-25-config-setpoint-canonicalization/) + [audit SCH](../repo-health/SCH-audit-2026-06-25.md). |
| **0** | Contratos & ADRs: schemas libSQL (sync + local-only), Parquet de rollups, sobre de comando CBOR, interfaz `Transport`, auth de sync. |
| **1** | Backbone del server: TimescaleDB (PR#14), DuckDB export worker → Parquet/MinIO, Turso read model + worker de proyección multi-resolución, `getSnapshotManifest`. |
| **2** | Motores on-device en el móvil (← *primer slice*): libSQL embedded replica + DuckDB + suscriptor MQTT + charts Grafana-style. |
| **3** | Simetría de borde (Raspberry): persistencia libSQL, config desde réplica, DuckDB de borde, broker MQTT local + server de fallback. |
| **4** | Mesh multi-transporte: `ConnectivityManager` + drivers, mDNS, ladder por prioridad, driver satelital. |
| **5** | Plano de comando sobre sync: `commands_outbox`, workers de aplicación, reconciliación idempotente. |

---

## Referencias

- **SSOT de la decisión:** [`openspec/changes/2026-06-25-multinode-data-architecture/`](../../openspec/changes/2026-06-25-multinode-data-architecture/) (proposal · design ADR-1..6 · tasks).
- **Fase Pre-0:** [`openspec/changes/2026-06-25-config-setpoint-canonicalization/`](../../openspec/changes/2026-06-25-config-setpoint-canonicalization/) + [`docs/repo-health/SCH-audit-2026-06-25.md`](../repo-health/SCH-audit-2026-06-25.md).
- **TimescaleDB (Fase 1, PR#14):** [`openspec/changes/2026-06-21-timescaledb-timeseries/`](../../openspec/changes/2026-06-21-timescaledb-timeseries/).
- **App Flutter canónica:** [`openspec/changes/2026-06-21-canonical-flutter-app/`](../../openspec/changes/2026-06-21-canonical-flutter-app/).
- **Bus de eventos (decisión relacionada de transporte/broker):** [`eventbus-broker-analysis.md`](./eventbus-broker-analysis.md).
- **Plan completo del brainstorm:** [`docs/superpowers/plans/2026-06-25-multinode-libsql-duckdb-architecture.md`](../superpowers/plans/2026-06-25-multinode-libsql-duckdb-architecture.md).
