# Dashboard fleet cockpit — cablear `vertivo_dashboard` al backend Serverpod

**Date:** 2026-06-21
**Owner:** Andrés (andres@dojocoding.io)
**Status:** Proposed — pendiente aprobación
**Domain:** `vertivo_dashboard` (Jaspr + D3) + `vertivo_client` (Serverpod client)
**Tracking issue:** VRTV-99 (Linear) — https://linear.app/vertivolatam/issue/VRTV-99

---

## Why (Problema)

`apps/vertivo_dashboard` (Jaspr SSR + D3.js) **ya tiene la estructura completa de un cockpit
de flota** — 6 pages (home, greenhouses, greenhouse_detail, alerts, anomalies, users) y 7
componentes (dashboard_shell, kpi_card, sensor_chart, gauge_chart, sensor_panel, data_table,
alert_item) — pero **no está cableado al backend**: renderiza valores hardcoded
(`'24'` invernaderos, `'186'` sensores, filas `GH-001`…`GH-024` literales). Su
`pubspec.yaml` **no depende de `vertivo_client` ni de serverpod** y no hace ninguna llamada
de red.

En contraste, `apps/vertivo_flutter` **sí está cableado**: depende de `vertivo_client`, y
`PhMonitorRepository` (`lib/features/monitoring/data/ph_monitor_repository.dart`) ya invoca
`client.greenhouse.getReadings(...)` y `client.alert.getForGreenhouse(...)` contra Serverpod
en `localhost:8080`. Existe un patrón de repository probado que el dashboard puede reusar.

Esto es exactamente la **regla #2 de `CLAUDE.md` — "Connect before create"**:

> *13 Serverpod endpoints exist with 0 Flutter screens. Build UI first.*

El dashboard es el caso inverso y complementario: **UI completa con 0 conexiones**. Cablearlo
materializa la directiva — pasamos de mock a flota real sin construir UI nueva, solo
conectando la que ya existe. El backend ya ingesta toda la flota (múltiples enjambres ×
múltiples micro-invernaderos, cada uno un device `balena_os` que publica MQTT con topic
`{user_id}/greenhouse/{greenhouse_id}`) en PostgreSQL multi-tenant. El dashboard debe ser el
cockpit central sobre esa data — hoy es una maqueta desconectada de ella.

## What (Decisiones)

| # | Decisión | Rationale |
|---|----------|-----------|
| 1 | **Añadir dep `vertivo_client` (path `../vertivo_client`) al `pubspec.yaml` del dashboard.** | Es el client generado de Serverpod; lo mismo que ya usa `vertivo_flutter`. Sin esto no hay backend. |
| 2 | **Introducir una capa de repositories en el dashboard** (`lib/data/`), espejo de `PhMonitorRepository`, que envuelve `vertivo_client` y expone snapshots tipados por page. | Aísla las pages del transporte; reusa el patrón probado en `vertivo_flutter`. |
| 3 | **Cablear cada page a endpoints REALES** (ver mapa en `design.md`): `greenhouse.listByUser`, `greenhouse.get`, `greenhouse.getReadings`, `alert.getForGreenhouse`/`getMyAlerts`, `anomaly.getForGreenhouse`/`getUnresolved`, `cropCatalog.*`, `user.*`. | Reemplaza los literales por data de PostgreSQL. Solo se usan endpoints que existen hoy. |
| 4 | **Scope multi-tenant vía sesión autenticada de Serverpod**, no por param. `greenhouse.listByUser` ya filtra por `session.authenticated.userIdentifier`. | El backend ya es la fuente de verdad del ownership; el dashboard hereda el tenant de la sesión. |
| 5 | **Colorear in/out-of-range con el concepto `InstrumentCard`** (de VRTV-96 / crop_explorer): cada gauge usa los setpoints del greenhouse (`phMin/phMax`, `temperatureMin/Max`, …) con fallback a los `ideal*` del `CropModel` del cultivo. | Hoy los rangos del gauge están hardcoded en cada page; deben venir de la data real del invernadero/cultivo. |

**In scope (este change):** la dep `vertivo_client`; la capa de repositories; el cableado
page-por-page de las 6 pages a endpoints existentes; el InstrumentCard de rangos; manejo de
loading/error/empty.

**Out of scope:**
- **Nuevos endpoints de backend.** Si una page necesita un agregado que no existe (p.ej.
  "todos los invernaderos de TODOS los clientes" para la vista admin, o conteos KPI globales),
  se documenta como gap pero **no se construye aquí** (sería otro change, regla #1/#2).
- **Auth/login del dashboard.** Se asume sesión Serverpod disponible; el flujo de sign-in del
  cockpit es un change aparte.
- **Rediseño visual / nuevos componentes D3.** Se reusa la UI existente tal cual.
- **Realtime/streaming (MQTT push al browser).** El cableado inicial es fetch/polling, igual
  que `PhMonitorRepository`. Streaming es fase futura.

## Open questions para el owner

1. **Vista admin multi-cliente:** las pages `users` y el "todos los clientes" de `greenhouses`
   asumen ver la flota de *todos* los usuarios. Hoy solo existe `greenhouse.listByUser` (un
   tenant) y `user.listBySegment` (admin). ¿El cockpit es (a) per-tenant —cada cliente ve su
   flota— o (b) panel de operador interno que ve toda la flota? La respuesta define si hace
   falta un endpoint nuevo `greenhouse.listAll`/agregados (otro change). **Recomendación:**
   fase 1 per-tenant con lo que existe; vista admin como change separado.
2. **Conflicto de puerto:** el dashboard Jaspr corre `mode: server, port: 8080` — el **mismo
   puerto** que Serverpod (`localhost:8080`). Hay que mover uno (p.ej. dashboard a `:8090`)
   antes de que el SSR pueda llamar al backend. ¿Confirmas el puerto destino del dashboard?
3. **SSR vs client-side fetch:** `vertivo_client` está pensado para Flutter/Dart VM. ¿Las
   llamadas se hacen server-side en el render Jaspr, o se hidratan client-side? Afecta dónde
   vive la sesión auth. **Recomendación:** validar en un spike chico en la fase 1.

## References

- ADR: [`design.md`](./design.md) · Tasks: [`tasks.md`](./tasks.md)
- Regla cableada: `CLAUDE.md` → Critical Rule #2 "Connect before create"
- Patrón de referencia: `apps/vertivo_flutter/lib/features/monitoring/data/ph_monitor_repository.dart`
- Change hermano: `openspec/changes/2026-06-21-canonical-flutter-app/` (arquitectura del cliente Flutter)
