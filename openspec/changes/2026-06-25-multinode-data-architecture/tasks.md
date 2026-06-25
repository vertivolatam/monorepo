# Arquitectura de datos multi-nodo — Tasks

> Roadmap por fases. Cada fase = un PR/spec independiente que deja algo verificable. El "primer slice"
> (`vertivo_flutter` con Turso+DuckDB) se materializa en **Fase 2**, habilitada por **Fase 1**.
> Tests por nodo: Dart (`serverpod_test`, `flutter_test`) server/móvil; pytest para el Pi.

## Fase Pre-0 — Consolidación del schema drift de config
- [ ] Correr `/make-no-mistakes:audit-schema-drift` sobre la config del orquestador.
- [ ] Mapear fuentes duplicadas: `config/{current,defaults}/*.json` (Pi), columnas threshold de `greenhouse.spy.yaml`, setpoints de `crop_explorer/crops.db`.
- [ ] Producir **modelo canónico** `orchestrator_config`/`setpoint` (un solo source of truth) + plan de migración.
- [ ] Salidas del skill: findings doc, OpenSpec remediation change, issues Linear bilingües, scaffolds.

## Fase 0 — Contratos & ADRs (sin código de runtime)
- [ ] **Schema libSQL SINCRONIZADO**: `orchestrator_config`/`setpoint` (cada `policy` con `desired`/`reported`/`override`), `commands_outbox`, `alerts`.
- [ ] **Schema libSQL LOCAL-ONLY**: `recent_readings` (buffer del MQTT live / sensores; ventana 7d default param 3/7/15/30; no sincroniza).
- [ ] **Provenance/auditoría**: `mechanism`, `actor`, `reason`/experiment_id, `channel`, `appliedAt`, `version`, `warranty_void`. Confirmar nomenclatura final.
- [ ] **Schema Parquet de rollups**: `bucket, greenhouseId, measurementType, avgValue, minValue, maxValue, sampleCount` (alineado a `EnvironmentalReadingRollup`).
- [ ] **Sobre de comando (CBOR)** para tiers de baja banda + envelope JSON para alta banda.
- [ ] **Interfaz `Transport`** (priority, capabilityProfile {bandwidth, mtu, latency}, health, send/recv) — contrato común Dart/Python.
- [ ] **Auth de sync**: claim/scope del JWT que Serverpod mintea para libSQL.
- [ ] Tests de round-trip cross-lenguaje de los contratos (Parquet/libSQL/CBOR).

## Fase 1 — Backbone del server (habilita el móvil)
- [ ] Implementar **PR#14**: TimescaleDB (`timescale/timescaledb-ha:pg16`+pgvector), hypertable `environmental_readings` (chunk 1d), CAGGs 1m/5m/1h/1d, compress 7d, retención 90d (k8s Job). Quitar `table:` de `environmental_reading.spy.yaml`. Aislar acceso en `lib/src/telemetry/`.
- [ ] **DuckDB export worker** (sidecar Python+duckdb o CLI; NO FFI en el server Dart): Timescale/Postgres → Parquet → MinIO.
- [ ] **Turso cloud**, granularidad por rol de nodo (DB-por-invernadero / cuenta / cohorte+RLS). Escape hatch `sqld` documentado.
- [ ] **Worker de proyección MULTI-RESOLUCIÓN** (Postgres → Turso): jerarquía `invernadero ⊂ cuenta ⊂ cohorte`, cliente libSQL delgado; aplica outbox entrante y re-proyecta. RLS en cohorte.
- [ ] Endpoint `AnalyticsEndpoint.getSnapshotManifest(greenhouseId, window)` → metadata + URL firmada MinIO.
- [ ] Serverpod auth mintea JWT de sync (`lib/src/auth/`).
- [ ] (Negocio, paralelo) aplicar al **Turso Partner Program** (chimeranext, Technology/Solution).
- [ ] Verificar: telemetría simulada → hypertable + CAGGs; export → Parquet en MinIO; `getSnapshotManifest` → descarga OK.

## Fase 2 — Motores on-device en el móvil ← *primer slice*
- [ ] `apps/vertivo_flutter/pubspec.yaml`: `dart_duckdb`, `libsql_dart`/`turso_dart`, `fl_chart`, `mqtt_client`.
- [ ] `lib/core/data/`: cliente libSQL embedded replica (OLTP/config), cliente MQTT suscriptor (live), descargador Parquet (HTTP), wrapper DuckDB (`ATTACH` Parquet + libSQL vía `sqlite_scanner`).
- [ ] `lib/features/analytics/` (patrón de `lib/features/monitoring/`): charts Grafana-style — live por MQTT, histórico por DuckDB/Parquet, config por libSQL; selección métrica/ventana/resolución.
- [ ] **Spike FFI/NDK Android** (arm64/armeabi-v7a, tamaño `.so` y APK).
- [ ] Verificar: `flutter run` real → (a) replica sincroniza OLTP, (b) MQTT actualiza chart en vivo, (c) Parquet abre en DuckDB; modo avión offline-first.

## Fase 3 — Simetría de borde (Raspberry)
- [ ] Reemplazar cache en memoria de `src/networking/mqtt.py` por **persistencia local libSQL** (buffer crudo).
- [ ] **Migrar config a réplica libSQL**: `src/config.py` y los `orchestrator.py` leen bounds de la réplica (no de `config/current/*.json`); `defaults/*.json` = seed. Overrides locales con provenance → outbox.
- [ ] **DuckDB en el Pi** (pip, wheels ARM): `ATTACH` libSQL → rollups `time_bucket` → Parquet de borde.
- [ ] Pi como **peer de sync + server de fallback** (libSQL fallback read-mostly).
- [ ] **Broker MQTT local** (mosquitto/NanoMQ) para live directo al móvil en outage.
- [ ] Verificar: matar broker cloud → Pi bufferea sin pérdida; móvil recibe live del Pi; rollups del Pi == server.

## Fase 4 — Mesh multi-transporte
- [ ] `ConnectivityManager` + drivers en Pi (`local_communication.py`) y móvil (`lib/core/connectivity/`).
- [ ] Ladder por prioridad + health; scheduler gateado por capability (incluye elegir broker MQTT y target de sync).
- [ ] mDNS/Bonjour para descubrir el Pi en LAN → re-apuntar replica libSQL + suscripción MQTT al Pi.
- [ ] Path crítico LoRa/Zigbee/Meshtastic: escalares+alertas en CBOR (duty-cycle/regulación).
- [ ] **Driver satelital (solo Pi)**: transceiver LoRa I2C; uplink store-and-forward (TinyGS PoC); downlink (abstracción; operador bidireccional diferido).
- [ ] Verificar: simular caída de internet → failover de tier, mDNS, re-apuntado, clase de dato correcta por tier.

## Fase 5 — Plano de comando sobre sync
- [ ] `commands_outbox` en libSQL; el móvil encola comandos offline.
- [ ] Workers en server y Pi consumen el outbox y aplican (actuación/efectos); reconciliación con quarantine.
- [ ] Encoger RPC a auth + token minting + ops pesadas.
- [ ] Verificar: comando offline → encolado → reconexión → aplicación idempotente + reconciliación.

## Done when
- [ ] Pre-0 cerrada (modelo canónico de config, drift eliminado).
- [ ] El móvil renderiza charts Grafana-style on-device (DuckDB+Parquet) + live por MQTT + config por libSQL, offline-first.
- [ ] Graceful degradation verificada end-to-end (WiFi/LAN → … → satélite) con la clase de dato correcta por tier.
- [ ] Provenance/auditoría de config anclada (hash-chain) y reconciliación con precedencia cloud funcionando.
