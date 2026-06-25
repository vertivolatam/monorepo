# Plan — Arquitectura de datos multi-nodo Vertivo (Turso/libSQL + DuckDB, fractal, resiliente)

## Context

Hoy `vertivo_flutter` es casi una cáscara: solo auth (serverpod_auth_idp) + una pantalla de monitoreo de pH que lee `greenhouse.getReadings` (scan crudo de Postgres). El transporte es 100% Serverpod RPC; **no hay GraphQL, ni DB local en el móvil, ni storage/agregación en el Raspberry, ni TimescaleDB** (es solo spec, PR#14 sin mergear), ni capa de transporte alterno (`apps/raspberry/src/networking/local_communication.py` es un stub vacío).

El objetivo: que el móvil tenga **charts timeseries estilo Grafana on-device** para analizar la telemetría de los invernaderos, con **resiliencia a desastres** (graceful degradation WiFi → BT → Zigbee → LoRa/Meshtastic → satélite) y comunicación directa Raspberry→móvil cuando se cae internet. La decisión de diseño: **misma pareja de motores en los tres nodos** — libSQL/Turso (OLTP + sync, con concurrencia que SQLite vanilla no tiene) y DuckDB (OLAP columnar + Parquet) — con roles/escala distintos pero **contratos compartidos**. El server suma TimescaleDB como backbone canónico de histórico grande.

Resultado buscado: arquitectura tri-nodo "fractal" donde cualquier nodo puede servir al teléfono, el query analítico flexible corre on-device sobre DuckDB, y cada clase de dato viaja por su canal correcto — **OLTP/config por libSQL sync, telemetría live por MQTT (server o Pi), histórico OLAP por Parquet** — con los comandos como cola sobre sync (offline-first real).

---

## Arquitectura objetivo

### Tres nodos, mismos motores (fractal)

| Nodo | libSQL/Turso | DuckDB | Extra | Rol |
|------|-------------|--------|-------|-----|
| **Server** (Serverpod/Dart, k8s) | `sqld` self-hosted = **primario de sync** | export worker → Parquet | **TimescaleDB** (canónico) + Postgres (Serverpod/auth) + MinIO (Parquet) | Ingesta MQTT, histórico grande, autoridad de auth/tokens, origen de snapshots |
| **Raspberry** (Python, Balena) | buffer crudo local + **primario de sync de fallback** | rollups de borde → Parquet | EMQX publisher | Durabilidad de borde, analítica de fallback, server directo al móvil en outage |
| **Móvil** (Flutter/Dart, Android) | **embedded replica** (OLTP/config + outbox de comandos) | motor de los charts Grafana | `fl_chart` + **suscriptor MQTT** (live) | Offline-first, live por MQTT, análisis interactivo local |

Misma tecnología, implementaciones políglotas (Python en Pi, Dart en server/móvil), **contratos idénticos**: schema libSQL, schema Parquet, sobre de comando (CBOR), JWT de sync.

### Dos planos

- **Plano de datos = TRES clases distintas al móvil:**
  1. **OLTP operativo/config** (atributos de invernadero, config del agente orquestador, alertas, outbox) → **SQL libSQL/Turso** embedded replica (sync, offline-first). Reemplaza `getReadings` y CRUD por RPC.
  2. **Telemetría live de monitoreo** → **MQTT** (el móvil es **suscriptor**). Fuente = **server (EMQX cloud) o Raspberry (broker local)** según el modo del `ConnectivityManager`. El móvil bufferea el live en un `recent_readings` **local-only** (no sincroniza por Turso → no paga writes de telemetría), ventana **7d default parametrizable (3/7/15/30)**.
  3. **Histórico OLAP analítico** → **Parquet/rollups** generados por **DuckDB en el server (Timescale→Parquet) o en el Pi (rollups de borde)** → consumidos por el **DuckDB del móvil** para los charts (y por el **DuckDB del Pi** sirviendo analítica directa al móvil en fallback). DuckDB corre en los **tres** nodos (fractal); "on-device" acá = el motor del teléfono.
  
  *Matiz clave:* MQTT lleva **solo el live**, NO el histórico desagregado (eso va por Parquet). Solo config/comandos/alertas sincronizan por Turso; telemetría nunca paga writes de Turso.
- **Plano de control** = Serverpod RPC reducido a **mintear el JWT que la sync necesita** + ops pesadas puntuales. Los comandos se mueven a un **command-queue-over-sync** (outbox): se encolan local y sincronizan contra cualquier primario alcanzable (cloud o Pi); workers del server/Pi los aplican. Esto es lo que hace el control resiliente a outages.

### Entrega de Parquet (no inline)
Ni RPC ni GraphQL cargan el binario. Un RPC liviano (`analytics.getSnapshotManifest`) devuelve **metadata JSON** (qué snapshots, rango, checksum) + **URL firmada** a MinIO/S3; el móvil baja el Parquet por HTTP y lo abre con DuckDB. Por eso **no se agrega GraphQL**: su flexibilidad se mudó a DuckDB on-device.

### OLTP/config: un solo ORM, CQRS, sin GraphQL
La OLTP/config **no viaja como "SQL" ni como "JSON/GraphQL"**: la sync libSQL replica a nivel de **frames/WAL (binario)**; el `SELECT` corre contra la **réplica local** y nunca cruza la red. Esto es replicación de estado (offline-first), no request/response.

Patrón **CQRS con un solo ORM**:
- **Write model = Postgres/Serverpod** (el único ORM — preserva FKs, auth/`userId`, modelo relacional).
- **Read model = libSQL `sqld`**, poblado por un **worker de proyección delgado** (cliente libSQL con SQL parametrizado, NO un segundo ORM tipo Drizzle). Los dispositivos leen esta proyección.
- **Escrituras de dispositivo = outbox-over-sync** → un worker del server las aplica al write model (Serverpod) → re-proyecta. Autoridad de escritura única (cloud).
- **Sin Apollo/GraphQL.** Evita el smell de 3 stacks (Serverpod ORM + Drizzle + Apollo): queda **1 ORM + 1 worker de proyección + 1 cliente libSQL acotado**.

### Tenancy: granularidad de DB libSQL POR ROL DE NODO (multi-resolución)
La frontera de la DB libSQL = la frontera de sync del nodo. Como la embedded replica es **1:1 de una DB entera** (no hay replicación filtrada por fila), cada nodo replica la **resolución** que coincide con su alcance — son DBs **derivadas por resolución**, no una DB compartida con vistas:

| Nodo | Granularidad | Por qué |
|------|-------------|---------|
| **Raspberry** | **DB-por-invernadero** | El Pi vive en 1 gh; réplica chica, offline-first, blast radius mínimo, sin RLS |
| **Móvil** | **DB-por-tenant/cuenta** | El teléfono = 1 cuenta; replica todos sus invernaderos, nada ajeno; privacidad perfecta |
| **Server k8s** | **DB-por-cohorte + RLS** | Tiene a todos; agrupa por segmento (free/paid/B2C/B2B/B2G); pocas DBs; analytics cross-cohorte + billing/SLA |

**Jerarquía de proyección:** `invernadero ⊂ cuenta ⊂ cohorte`, todas proyectadas desde el write model canónico (Postgres/Timescale) por el **worker de proyección multi-resolución**. Direcciones: config `desired` baja cohorte→cuenta→invernadero; telemetría sube Pi→server por **MQTT**; overrides/comandos suben por **outbox**; alertas burbujean. **RLS solo en el tier cohorte/server** (los tiers device están aislados por DB). El segmento es un **atributo** en todos los tiers; solo es *frontera de DB* en el server.

### Config del orquestador: device-shadow con precedencia cloud + provenance
Hoy los bounds viven fragmentados (`config/current/*.json` + `config/defaults/*.json` en el Pi, columnas `phMin/phMax`… en `greenhouse.spy.yaml`, setpoints en `crop_explorer/crops.db`) → **multiple-source-of-truth / schema drift**. Se consolida a **un modelo canónico** (ver Fase Pre-0) que es la clase OLTP/config: el orquestador del Pi **lee sus bounds de la réplica libSQL local** (no de los JSON); `defaults/*.json` → seed de bootstrap; `current/*.json` → reemplazado por la réplica.

Modelo **device-shadow con precedencia cloud** (nomenclatura estándar de industria + `policy` como contenedor del atributo):
- **`policy`** = el atributo de config gobernado (p.ej. `ph_lower_bound`) con sus reglas/límites permitidos. Cada policy tiene los 3 estados shadow:
  - **`desired`** = intención canónica (cloud/Postgres, autoritativa).
  - **`reported`** = lo que el Pi corre realmente (réplica libSQL).
  - **`override`** = desviación local (experimento de lab, usuario experto "overclock/jailbreak") con provenance.

**Provenance gate (no guardar ciego):** todo cambio originado en el edge carga metadata — `mechanism` (mobile_app · local_web_ui · local_python_ui · ssh · manual_file_edit · api), `actor`, `reason`/experiment_id, `channel`/tier usado, `appliedAt`, `version`. El worker de reconciliación **inspecciona la provenance antes de aceptar** → estado `quarantine/review`, NO upsert ciego; el cloud puede *snap-back* si rechaza. El cloud nunca pierde la autoridad final.

**Triple función del provenance:**
1. **Trazabilidad** de quién/cómo/por qué cambió un parámetro.
2. **Gate de seguridad** — un bound peligroso queda en review, no se propaga solo.
3. **Evidencia de garantía (anti-fraude / billing)** — si un cliente hace jailbreak/overclock vía `ssh`/`manual_file_edit` y daña equipo o cultivo, el registro prueba que **anuló la garantía** → no puede reclamar reembolso de mala fe. Ciertos `mechanism` marcan `warranty_void`.

Para servir como evidencia, el provenance es **inmutable / append-only / tamper-evident anclado en el server**. **Reuso:** el endpoint **`traceability`** ya existente (`addRecord` / `getChain` / **`verifyChain`**, `lib/src/traceability/traceability_endpoint.dart`) es una hash-chain — se reusa ese patrón para anclar la cadena de provenance de config.

### Ladder de transportes (en móvil y Pi)
`ConnectivityManager` con prioridad [100..10] + perfil de capacidad por driver. **El tier decide la clase de dato:**

| Prio | Transporte | Hardware | Clase de dato |
|------|-----------|----------|---------------|
| **100** | **WiFi (móvil) / LAN-Ethernet (Pi)** | Anybus Wireless Bolt / NIC on-board | sync libSQL completa + **MQTT live** + Parquet |
| **80** | **Celular 4G/5G (add-on)** | InHand router · Quectel EC25 + Sixfab HAT u Oratek Tofu | sync libSQL completa + **MQTT live** + Parquet |
| 60 | Bluetooth | BLE móvil | **MQTT live** + ventana reciente + rollups chicos |
| 40 | Zigbee/DigiMesh/Wi-SUN | Digi Gateway | telemetría crítica + alertas + comandos |
| 20 | LoRa/LoRaWAN/Meshtastic | RAKwireless RAK7268/RAK | solo escalares críticos + alertas (CBOR) |
| 10 | **Satélite (direct-to-sat LoRa, solo Pi)** | Heltec LoRa 32 V2 / RAK por **I2C** | bidireccional: ↑alarma crítica+heartbeat / ↓comando crítico (bytes, latencia horas) |

**Por qué WiFi/LAN = 100 y celular = 80:** WiFi (móvil) y Ethernet/LAN (Pi) son lo más estable para **mitigar pérdida de paquetes MQTT** de los sensores y no tienen costo de datos. El celular es respaldo: además **requiere hardware add-on en el Pi** (no viene embedded) — un módem miniPCIe (p.ej. **Quectel EC25-EFA**, ~$57 Digikey) + carrier (**Sixfab Base HAT** ~$45 u **Oratek Tofu**) + SIM activada + antenas/pigtails, manejado vía **ModemManager** (`mmcli -L` → enable → `--simple-connect "apn=..."` → configurar `wwan0`/ruta default). Varios módems traen **GNSS/GPS** (útil para geolocalizar invernaderos: `greenhouse` ya tiene lat/long).

Drivers hardware-agnósticos detrás de una interfaz común; el stub `local_communication.py` es la costura en el Pi (el driver celular envuelve ModemManager). Host de gateway en invernadero: Axiomtek Edge Computer u Oratek Tofu (opcional, sobre el Pi).

**Satélite (tier 10) es un caso especial — NO está en la malla teléfono↔Pi.** Es **direct-to-satellite LoRa**: un transceiver (Heltec LoRa 32 V2 ESP32/SX127x 433MHz, o RAK) colgado del **bus I2C del Pi** (el mismo del multiplexor de sensores `dag_I2C_multiplexor.py` — el módulo es otro periférico I2C). Características: **store-and-forward, intermitente** (pasadas LEO pocas veces/día), payload de **bytes**. Es el canal de **último recurso del Pi** cuando WiFi/celular/LoRa-terrestre están todos caídos.

- **Uplink** (↑, principal): Pi → satélite → operador/ground-station → internet → server. Solo alarma crítica + heartbeat. El teléfono lo recibe **indirectamente** por sync normal cuando recupere conexión; el teléfono nunca habla satélite.
- **Downlink** (↓, bidireccional): server → satélite → Pi, para **comando crítico de emergencia** (p.ej. corte/override remoto a un invernadero sin otra conectividad). Es **otro transporte del command-queue-over-sync** (Fase 5): el comando llega al Pi y se aplica idempotente. Latencia de **horas** (pasada LEO) → UX de "comando de emergencia eventualmente entregado", no control en vivo.

Proveedores/backhaul: **TinyGS** (red community, gratis — elegido para el PoC) valida el **uplink** (es una red *receptora*: satélite→tierra). El **downlink NO es el modelo de TinyGS** → requiere operador bidireccional comercial (FOSSA Systems; **Orbital Space Technologies**, Costa Rica, como partnership LATAM). Por eso el downlink queda en la abstracción del driver pero su habilitación real es decisión comercial de Fase 4. El driver satelital vive solo en el Pi.

---

## Decisiones clave (con rationale)

1. **No GraphQL.** El query flexible vive en DuckDB on-device; el server solo entrega snapshots paramétricos. GraphQL duplicaría Serverpod sin beneficio. (Reabrir solo si aparece un cliente web que necesite query server-side flexible.)
2. **Timescale se queda, DuckDB se suma (no se sustituyen).** Timescale = ingesta alta tasa + CAGGs + retención (PR#14). DuckDB = OLAP/export. Sustituir Timescale por DuckDB rompería la ingesta concurrente.
3. **Serverpod/Postgres no se reemplaza por libSQL.** Serverpod está casado con Postgres (ORM/migraciones/cliente generado). libSQL entra como **fabric de replicación paralelo**, no como store primario del server.
3b. **Un solo ORM, CQRS.** Postgres/Serverpod = write model (único ORM). libSQL `sqld` = read model proyectado por un worker delgado (cliente libSQL, no Drizzle). **Sin Apollo/GraphQL** → se evita el smell de 3 stacks. La OLTP/config viaja como frames binarios de sync, leída con SQL local (no JSON-over-GraphQL).
4. **RPC se encoge a auth + token minting.** Reads → sync; comandos → outbox-over-sync. Resiliencia > respuesta inmediata.
5. **Turso cloud para dev/PoC y prod inicial** (**granularidad por rol de nodo**: DB-por-invernadero en el Pi, DB-por-cuenta en el móvil, DB-por-cohorte+RLS en el server — ver sección Tenancy; DBs ilimitadas, embedded replicas nativas). El costo se mantiene bajo porque **la telemetría vive en Timescale, no en libSQL** → solo config/comandos/alertas escriben en Turso. **Escape hatch:** `sqld` self-hosted (mismo protocolo open-source, sin reescritura) si la **soberanía LATAM** (Turso solo da residencia vía Enterprise BYOC) o el costo a escala lo exigen. **Oportunidad:** aplicar al **Turso Partner Program** como Technology/Solution partner (chimeranext) por créditos/soporte.

---

## Roadmap por fases

> Cada fase es un PR/spec independiente (OpenSpec). El "primer slice" que el usuario quería correr (`vertivo_flutter` con Turso+DuckDB) se materializa en **Fase 2**, habilitada por **Fase 1**.

### Fase Pre-0 — Consolidación del schema drift de config (sub-proyecto previo)
Antes de definir contratos, limpiar la base. Correr **`/make-no-mistakes:audit-schema-drift`** sobre la config del orquestador:
- Mapear las fuentes duplicadas (`config/{current,defaults}/*.json` del Pi, columnas threshold de `greenhouse.spy.yaml`, setpoints de `crop_explorer/crops.db`).
- Producir **un modelo canónico** de `orchestrator_config`/`setpoint` (un solo source of truth) + plan de migración de las fuentes viejas.
- Salidas del skill: findings doc, OpenSpec remediation change, issues Linear bilingües, scaffolds de cura. Esto define el modelo que la Fase 0 contractualiza.

### Fase 0 — Contratos & ADRs (sin código de runtime)
Definir y versionar los contratos compartidos (un OpenSpec change):
- **Schema libSQL SINCRONIZADO** (vía Turso, write-volume bajo): `orchestrator_config`/`setpoint` (modelo canónico de Pre-0; cada `policy` con estados `desired`/`reported`/`override`), `commands_outbox`, `alerts`.
- **Schema libSQL LOCAL-ONLY** (NO sincroniza por Turso → no paga writes de telemetría): `recent_readings` — buffer llenado del **MQTT live** (teléfono) / sensores (Pi), **ventana 7 días default, parametrizable por el usuario (3/7/15/30) desde la Flutter app**. Alimenta DuckDB junto al Parquet.
- **Provenance/auditoría** del config: `mechanism`, `actor`, `reason`/experiment_id, `channel`, `appliedAt`, `version`, `warranty_void` — nomenclatura shadow confirmada: **`desired`/`reported`/`override` + `policy`** (contenedor del atributo).
- **Schema Parquet de rollups**: `bucket, greenhouseId, measurementType, avgValue, minValue, maxValue, sampleCount` (alineado a `EnvironmentalReadingRollup` del PR#14).
- **Sobre de comando (CBOR)** para tiers de baja banda + envelope JSON para alta banda.
- **Interfaz `Transport`** (priority, capabilityProfile {bandwidth, mtu, latency}, health, send/recv) — contrato común Dart/Python.
- **Auth de sync**: claim/scope del JWT que Serverpod mintea para libSQL.
- ADR confirmando decisiones 1–5.

### Fase 1 — Backbone del server (habilita el móvil)
- Implementar **PR#14**: TimescaleDB (`timescale/timescaledb-ha:pg16` + pgvector), hypertable `environmental_readings` (chunk 1d), CAGGs 1m/5m/1h/1d, compress 7d, retención 90d, vía k8s Job. Desacoplar `environmental_reading.spy.yaml` del ORM (quitar `table:`). Aislar acceso en `apps/vertivo_server/lib/src/telemetry/`.
- **DuckDB export worker** (sidecar — Python+duckdb o `duckdb` CLI; NO embeber FFI en el server Dart): lee Timescale/Postgres → escribe **Parquet** a **MinIO** (k8s).
- **Turso cloud (read model CQRS), granularidad POR ROL DE NODO**: DB-por-invernadero (Pi), DB-por-cuenta (móvil), DB-por-cohorte+RLS (server). (Escape hatch: `sqld` self-hosted en k8s/infra chimeranext si soberanía/costo lo exigen — mismo protocolo.)
- **Worker de proyección MULTI-RESOLUCIÓN** (Postgres → Turso): mantiene la jerarquía `invernadero ⊂ cuenta ⊂ cohorte` con cliente libSQL delgado (NO segundo ORM). CDC simple o polling por `updatedAt`. Aplica el outbox entrante (escrituras de device) al write model Serverpod y re-proyecta a las 3 resoluciones. RLS solo en el tier cohorte.
- (Acción de negocio paralela) aplicar al **Turso Partner Program** (chimeranext, Technology/Solution) por créditos/soporte.
- Endpoint RPC nuevo `AnalyticsEndpoint.getSnapshotManifest(greenhouseId, window)` → metadata + URL firmada MinIO. Reusar patrón de endpoints existentes (`lib/src/greenhouses/greenhouse_endpoint.dart`).
- Serverpod auth mintea JWT de sync (extender `lib/src/auth/`).

### Fase 2 — Motores on-device en el móvil  ← *el slice que querías correr*
- `apps/vertivo_flutter/pubspec.yaml`: agregar `dart_duckdb` (DuckDB FFI; APK grande aceptado), `libsql_dart`/`turso_dart` (embedded replica), `fl_chart` (charts), `mqtt_client` (suscriptor live — misma lib que ya usa el server).
- Nuevo `lib/core/data/`: cliente libSQL embedded replica (sync contra `sqld`, OLTP/config), **cliente MQTT suscriptor** (telemetría live, broker seleccionable), descargador de Parquet (HTTP desde manifest), wrapper DuckDB (`ATTACH` del Parquet + del archivo libSQL vía `sqlite_scanner`).
- Nuevo `lib/features/analytics/` (extendiendo el patrón de `lib/features/monitoring/`): pantalla **charts Grafana-style** — **live por MQTT**, histórico/agregado por DuckDB sobre Parquet, config/estado por libSQL; selección de métrica/ventana/resolución corriendo queries DuckDB locales.
- Validar FFI/NDK en Android (arm64/armeabi) — riesgo principal (ver Riesgos).

### Fase 3 — Simetría de borde (Raspberry)
- Reemplazar el cache en memoria de `apps/raspberry/src/networking/mqtt.py` por **persistencia local libSQL** (buffer crudo, durabilidad ante caída de MQTT/server).
- **Migrar la config del orquestador de JSON a la réplica libSQL**: `src/config.py` y los `orchestrator.py` leen bounds de la réplica local (no de `config/current/*.json`); `defaults/*.json` queda como seed. Los **overrides locales** (file edit / web UI / SSH / mobile) se escriben con **metadata de provenance** y van por outbox → reconciliación con quarantine en el server.
- **DuckDB en el Pi** (pip, wheels ARM): `ATTACH` del libSQL → rollups `time_bucket` → Parquet de borde.
- El Pi se vuelve **peer de sync + server de fallback** (libSQL de fallback read-mostly para el móvil; ver constraint multi-primario en Riesgos).
- **Broker MQTT local en el Pi** (mosquitto/NanoMQ) para que el móvil reciba **telemetría live directo del Pi** cuando el cloud está caído — el `ConnectivityManager` re-apunta la suscripción MQTT del móvil al broker del Pi.

### Fase 4 — Mesh multi-transporte
- Implementar `ConnectivityManager` + drivers en **Pi** (rellenar `local_communication.py`) y **móvil** (`lib/core/connectivity/`).
- Ladder por prioridad + health; **scheduler de sync gateado por capability** (qué clase de dato según tier) — incluye **seleccionar el broker MQTT del live** (EMQX cloud vs broker local del Pi) y el target de sync libSQL.
- **mDNS/Bonjour** para descubrir el Pi en LAN cuando no hay internet → el móvil re-apunta su replica libSQL **y su suscripción MQTT** al Pi.
- Path crítico LoRa/Zigbee/Meshtastic: solo escalares+alertas en CBOR (respetar duty-cycle/regulación).
- **Driver satelital (solo Pi)**: transceiver LoRa por I2C en el bus del multiplexor. Uplink: cola "alarma crítica" store-and-forward para la próxima pasada LEO, backhaul TinyGS (PoC). Downlink (comando crítico): abstracción lista, habilitación real requiere operador bidireccional (Fase 4 comercial). Todo idempotente.

### Fase 5 — Plano de comando sobre sync
- `commands_outbox` en libSQL; el móvil encola comandos offline.
- Workers en server y Pi consumen el outbox y aplican (actuación / efectos). Reconciliación al volver la conexión.
- Encoger RPC a auth + token minting + ops pesadas.

---

## Critical files

- **Server**: `apps/vertivo_server/lib/src/greenhouses/sensor_ingestion_service.dart` (ingesta, hoy `insertRow` línea ~59), `lib/src/data/data_sources/mqtt_data_source.dart`, `lib/src/greenhouses/environmental_reading.spy.yaml` (quitar `table:`), nuevo `lib/src/telemetry/`, nuevo `lib/src/analytics/analytics_endpoint.dart`, `docker-compose.yaml` + `k8s/` (Timescale Job, sqld, MinIO), `lib/src/auth/` (JWT de sync).
- **OpenSpec PR#14**: actualmente en worktree `timescaledb-spec` (`openspec/changes/2026-06-21-timescaledb-timeseries/`) — traer a `openspec/changes/` e implementar.
- **Móvil**: `apps/vertivo_flutter/pubspec.yaml`, nuevos `lib/core/data/` (libSQL+DuckDB+Parquet), `lib/core/connectivity/`, `lib/features/analytics/`; patrón base en `lib/features/monitoring/` y `features/monitoring/data/ph_monitor_repository.dart`.
- **Raspberry**: `apps/raspberry/src/networking/mqtt.py`, `src/networking/local_communication.py` (stub a rellenar), nuevos `src/storage/` (libSQL) y `src/analytics/` (DuckDB), `requirements.txt` (`duckdb`, `libsql-experimental`).

## Reuso
- Patrón endpoint Serverpod: `greenhouse_endpoint.dart` / `management_endpoint.dart` (ya tienen `getMetrics`, `getDashboardSummary`).
- Modelo `KpiMetric` (`lib/src/management/kpi_metric.spy.yaml`) ya es analítico pre-agregado por período — fuente para rollups iniciales.
- `EnvironmentalReadingRollup` ya diseñado en PR#14 para llevar CAGGs al cliente.
- `fl_chart` o `sparkline.dart` existente en monitoring como base de visualización.
- **`traceability` endpoint** (`lib/src/traceability/traceability_endpoint.dart`, con `verifyChain` hash-chain) — reusar el patrón para anclar la cadena inmutable de provenance/auditoría de config (evidencia de garantía).

---

## Riesgos / Open questions

1. **Multi-primario libSQL (CRÍTICO).** libSQL embedded replicas sincronizan contra **UN** primario; no hay merge nativo cloud+Pi. Propuesta: el Pi hospeda un libSQL de fallback **read-mostly**; las escrituras/comandos en outage se encolan local (outbox) y reconcilian al cloud al volver (last-writer-wins / dedupe por id). Confirmar antes de Fase 3/5.
2. **FFI/NDK en Android** para DuckDB + libSQL (madurez, ABIs arm64/armeabi-v7a, tamaño `.so`). Aceptado APK grande, pero hay que verificar build real temprano (spike en Fase 2).
3. **Dual-store en server** (Postgres + libSQL + Timescale + MinIO): carga operacional. Mantener libSQL como subconjunto, no espejo total.
4. **Costo operativo de `sqld`** self-hosted vs Turso cloud — decidir en Fase 1.
5. **LoRa/Meshtastic/satélite**: duty-cycle y regulación regional (banda 433/868/915 según país LATAM). Satélite: ventana de pasada LEO impredecible, link budget ajustado, payload de bytes → solo alarma crítica con dedupe/idempotencia (puede llegar duplicada o tarde). **TinyGS valida solo uplink** (red receptora); el **downlink bidireccional NO es soporte TinyGS** → exige operador comercial (FOSSA / Orbital Space CR) — el downlink-comando es capability diferida cuya habilitación real se decide en Fase 4 (afecta BOM, frecuencia, trama y latencia de horas).
6. **Reconciliación de comandos**: validación server-authoritative se vuelve eventual — definir UX para comandos pendientes/rechazados.
7. **Config drift (Pre-0)**: los bounds están duplicados en 3+ fuentes (Pi JSON, columnas `greenhouse`, `crops.db`) → consolidar a modelo canónico ANTES de construir, vía `/audit-schema-drift`.
8. **Warranty-void / provenance legal**: la semántica de qué `mechanism` anula garantía debe alinearse con los ToS/garantía del producto (legal), y el provenance debe ser tamper-evident (hash-chain `traceability`) para sostener una disputa de reembolso. Cuidar privacidad/consentimiento del registro de `actor`.
9. **Proyección multi-resolución (tenancy)**: mantener `invernadero ⊂ cuenta ⊂ cohorte` consistentes desde un solo write model es la pieza más compleja — riesgo de divergencia entre resoluciones. Mitigar con proyección idempotente derivada del canónico (Postgres) + tests de consistencia cross-resolución. RLS correcto en el tier cohorte es crítico para no filtrar entre tenants.

---

## Verification

- **Fase 1**: levantar k8s local (o docker-compose), publicar telemetría simulada (simulador del Pi → EMQX), verificar filas en hypertable + CAGGs (`SELECT` con `time_bucket`), correr el export worker y confirmar Parquet en MinIO, llamar `getSnapshotManifest` y bajar el Parquet por la URL firmada.
- **Fase 2**: `flutter run` en Android real; confirmar que (a) la embedded replica libSQL sincroniza OLTP/config, (b) la **suscripción MQTT** recibe telemetría live y el chart actualiza en vivo, (c) el Parquet baja y DuckDB lo abre con `ATTACH` para el histórico; medir tamaño de APK; probar modo avión (offline-first: config y último histórico siguen del cache local).
- **Fase 3**: matar el broker MQTT cloud y confirmar que el Pi bufferea local y no pierde datos; levantar el **broker MQTT local del Pi** y confirmar que el móvil recibe live directo del Pi; correr rollups DuckDB en el Pi y comparar contra los del server.
- **Fase 4**: simular caída de internet; confirmar failover de tier (WiFi→BT→LoRa), descubrimiento mDNS del Pi, **re-apuntado de la suscripción MQTT y la sync libSQL al Pi**, y que la clase de dato correcta fluye por cada tier.
- **Fase 5**: emitir comando offline, confirmar encolado en outbox, restaurar conexión, verificar aplicación idempotente y reconciliación.

> Tests por nodo: Dart (`serverpod_test`, `flutter_test`) para server/móvil; pytest para el Pi. Contratos (schemas Parquet/libSQL/CBOR) con tests de round-trip cross-lenguaje en Fase 0.

---

## Documentación (OpenSpec) y entrega

- Branch nuevo: `docs/multinode-libsql-duckdb-architecture`.
- Crear un **OpenSpec change** en `openspec/changes/2026-06-25-multinode-data-architecture/` con: `proposal.md` (PDR — problema, scope, fases), `design.md` (ADRs de las decisiones 1–5/3b: no-GraphQL, Timescale+DuckDB, CQRS un-ORM, RPC mínimo, Turso+tenancy por rol, device-shadow+provenance), `tasks.md` (roadmap Pre-0→5).
- Commitear este plan + el OpenSpec change en el branch.
- ADRs clave a registrar: (1) tres clases de dato (libSQL/MQTT/Parquet), (2) CQRS un-ORM sin GraphQL, (3) tenancy multi-resolución por rol de nodo, (4) device-shadow `desired/reported/override`+`policy` con provenance/warranty-evidence, (5) ladder de transportes + satélite asimétrico, (6) Turso cloud + escape hatch sqld.
