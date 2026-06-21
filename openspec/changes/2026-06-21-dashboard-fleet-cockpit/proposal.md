# Dashboard fleet cockpit — cablear `vertivo_dashboard` al backend Serverpod

**Date:** 2026-06-21
**Owner:** Andrés (andres@dojocoding.io)
**Status:** Approved (2026-06-21) — scope **ampliado a vista admin cross-tenant**. En implementación.
**Domain:** `vertivo_dashboard` (Jaspr + D3) + `vertivo_client` (Serverpod client) + `vertivo_server` (1 endpoint admin nuevo)
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
| 6 | **(NUEVO — scope ampliado)** Añadir **un endpoint admin cross-tenant** en `vertivo_server`: `greenhouse.listAllForAdmin` (lista toda la flota de todos los tenants), restringido con `requiredScopes => {Scope.admin}`. La vista admin (`home`/`greenhouses` modo operador, `users`) lo consume; el modo cliente sigue usando `listByUser`. | El cockpit aprobado es un **panel de operador interno** que ve toda la flota, no solo un tenant. `listByUser` no basta. Ver §"Tensión con AGENTS.md". |

**In scope (este change):** la dep `vertivo_client`; la capa de repositories; el cableado
page-por-page de las 6 pages; el InstrumentCard de rangos; manejo de loading/error/empty; **un
endpoint admin cross-tenant nuevo** (`greenhouse.listAllForAdmin`, admin-only) + regeneración
del `vertivo_client`.

**Out of scope:**
- **Sistema de roles/RBAC completo.** No hay tabla de roles hoy. El endpoint admin se protege
  con el `Scope.admin` nativo de Serverpod (el scope se otorga vía el auth token). Una gestión
  de roles real (asignar/revocar admin en UI) es un change aparte. **Supuesto documentado.**
- **Auth/login del dashboard.** Se valida en un spike (§SSR) pero el flujo de sign-in completo
  del cockpit es un change aparte.
- **Rediseño visual / nuevos componentes D3.** Se reusa la UI existente tal cual.
- **Realtime/streaming (MQTT push al browser).** El cableado inicial es fetch/polling, igual
  que `PhMonitorRepository`. Streaming es fase futura.
- **KPIs globales agregados sin endpoint** (p.ej. "sensores online"): se muestran como "N/D"
  explícito, no se inventan ni se construye su endpoint aquí.

## Tensión con AGENTS.md (decisión consciente, no descuido)

`AGENTS.md` → "What NOT to do yet" dice literalmente: *"Do not build new Serverpod endpoints —
13 exist with 0 Flutter screens consuming them."* Este change **añade 1 endpoint**
(`greenhouse.listAllForAdmin`), lo cual entra en tensión con esa regla. La decisión de
ampliar el scope a cross-tenant fue **aprobada explícitamente por el owner** sabiendo esto. El
endpoint es el **mínimo imprescindible** para la vista admin (no se puede derivar de los 13
existentes, que son todos per-tenant o per-greenhouse) y se mantiene **seguro por defecto**
(admin-only vía `Scope.admin`). Se registra aquí para que la excepción quede trazable, no
silenciosa.

## Open questions — resueltas por el owner (2026-06-21)

1. **Vista admin multi-cliente:** RESUELTO → **(b) panel de operador interno cross-tenant**.
   Implica el endpoint nuevo `greenhouse.listAllForAdmin` (decisión #6).
2. **Conflicto de puerto:** RESUELTO → **Serverpod se queda con `:8080`; el dashboard Jaspr se
   mueve** a otro puerto (`:8090`). Documentado en `design.md` §puerto.
3. **SSR vs client-side fetch:** se valida con un **spike chico** antes de cablear la auth
   (fase 0). Define dónde vive la sesión admin.

## References

- ADR: [`design.md`](./design.md) · Tasks: [`tasks.md`](./tasks.md)
- Regla cableada: `CLAUDE.md` → Critical Rule #2 "Connect before create"
- Patrón de referencia: `apps/vertivo_flutter/lib/features/monitoring/data/ph_monitor_repository.dart`
- Change hermano: `openspec/changes/2026-06-21-canonical-flutter-app/` (arquitectura del cliente Flutter)
