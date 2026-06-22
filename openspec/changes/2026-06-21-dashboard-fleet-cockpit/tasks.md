# Dashboard fleet cockpit — Tasks

> Aprobado 2026-06-21 — scope ampliado a **vista admin cross-tenant**. En implementación.
> TDD donde haya lógica (resolución de rangos + autorización del endpoint admin).
> Rutas relativas a la raíz del monorepo. Disciplina make-no-mistakes: 1 commit por sub-task.
> **Excepción trazada:** este change añade 1 endpoint a `vertivo_server` (ver proposal §Tensión).

## Fase 0a — Backend: endpoint admin cross-tenant (TDD)

- [ ] **0a.1** [TDD] Test primero: `apps/vertivo_server/test/integration/admin_fleet_test.dart`
  — (1) sesión SIN auth → rechazada; (2) sesión autenticada SIN `Scope.admin` → rechazada;
  (3) sesión con `Scope.admin` → devuelve greenhouses de >1 tenant.
  → commit: `test(server): admin fleet listAll authorization (red)`
- [ ] **0a.2** Crear `apps/vertivo_server/lib/src/greenhouses/admin_fleet_endpoint.dart`:
  `class AdminFleetEndpoint extends Endpoint` con `requiredScopes => {Scope.admin}` (implica
  `requireLogin`) y `listAll(session, {limit=500, offset=0})` → `Greenhouse.db.find` activos,
  cross-tenant, `orderBy userId`. Opción (A) del design §2.5 (endpoint aparte, no tocar
  `GreenhouseEndpoint`).
  → commit: `feat(server): AdminFleetEndpoint.listAll (admin-only, green)`
- [ ] **0a.3** `dart run serverpod_cli generate` en `apps/vertivo_server` → regenera protocol +
  `vertivo_client`. Verificar que `client.adminFleet.listAll` existe en el client generado.
  → commit: `chore(server): serverpod generate — admin fleet endpoint in client`

## Fase 0b — Fundación dashboard (dep + cliente + helper testeado)

- [ ] **0b.1** Añadir dep a `apps/vertivo_dashboard/pubspec.yaml`:
  ```yaml
  dependencies:
    vertivo_client:
      path: ../vertivo_client
  ```
  y resolver con el pnpm/dart workspace (lock único en raíz).
  → commit: `build(dashboard): add vertivo_client dependency`
- [ ] **0b.2** Resolver el **conflicto de puerto**: mover `jaspr.port` de `8080` a `8090` en
  `pubspec.yaml` (Serverpod conserva :8080).
  → commit: `fix(dashboard): move jaspr server to :8090 to free Serverpod :8080`
- [ ] **0b.3** Crear init del `Client` Serverpod en `apps/vertivo_dashboard/lib/data/client.dart`
  (espejo de `vertivo_flutter/lib/main.dart`: `Client(serverUrl)` → `http://localhost:8080/`).
  **Spike (bloqueante para auth):** confirmar que el client corre en el server Jaspr (Dart VM)
  y dónde vive la sesión admin (cookie/header SSR vs hidratación client-side). Documentar el
  hallazgo en `design.md` §7.
  → commit: `feat(dashboard): wire Serverpod Client init + SSR spike notes`
- [ ] **0.4** [TDD] Test primero: `apps/vertivo_dashboard/test/instrument_range_test.dart` —
  cubre las 3 capas de resolución (greenhouse setpoint → CropModel ideal → fallback estático)
  y el coloreo in/out-of-range por measurementType.
  → commit: `test(dashboard): instrument range resolution (red)`
- [ ] **0.5** Implementar `apps/vertivo_dashboard/lib/data/instrument_range.dart` hasta verde.
  → commit: `feat(dashboard): instrument range resolver (green)`
- [ ] **0b.4** [TDD] Test primero `apps/vertivo_dashboard/test/instrument_range_test.dart`
  (3 capas + coloreo) → commit `test(dashboard): instrument range resolution (red)`; luego
  `lib/data/instrument_range.dart` → commit `feat(dashboard): instrument range resolver (green)`.
- [ ] **0b.5** Crear `apps/vertivo_dashboard/lib/data/fleet_repository.dart` (snapshot tipado +
  `fetch()` agregando **`adminFleet.listAll`** (cross-tenant) + `alert.getUnreadCount`), patrón
  `PhMonitorRepository`.
  → commit: `feat(dashboard): FleetRepository over admin fleet endpoint`

## Fase 1 — home + greenhouses (vista admin cross-tenant)

- [ ] **1.1** Cablear `apps/vertivo_dashboard/lib/pages/home_page.dart`: KPIs reales
  (`adminFleet.listAll().length`, `getUnreadCount`), alertas recientes (`alert.getMyAlerts`),
  tabla de estado desde `adminFleet.listAll`. KPIs sin endpoint ("sensores online", "anomalías
  globales") → mostrar "N/D" + TODO con referencia al gap, **nunca** un literal inventado.
  → commit: `feat(dashboard): wire home_page to admin fleet endpoints`
- [ ] **1.2** Cablear `apps/vertivo_dashboard/lib/pages/greenhouses_page.dart` a
  `adminFleet.listAll`; filtros segmento/estado/búsqueda en cliente sobre la lista. **Eliminar
  los literales "Hydroponics/Hidroponico"** del mock (regla #6 aeroponic-only): los nombres y
  `irrigationType` vienen de la DB.
  → commit: `feat(dashboard): wire greenhouses_page to admin fleet (drop hydroponic literals)`
- [ ] **1.3** Estados loading/error/empty en ambas pages (banner de error + retry; empty state
  cuando la flota está vacía). Sin silent-failure.
  → commit: `feat(dashboard): loading/error/empty states for fleet views`

## Fase 2 — greenhouse_detail (la más densa)

- [ ] **2.1** Cablear `apps/vertivo_dashboard/lib/pages/greenhouse_detail_page.dart`:
  `greenhouse.get(id)` para metadata; un `greenhouse.getReadings(id, type, limit)` por
  measurementType (co2/humidity/ph/temperature/ec/do/tds/orp) alimentando los 8
  `sensor_chart`.
  → commit: `feat(dashboard): wire greenhouse_detail readings`
- [ ] **2.2** Conectar los 8 `gauge_chart` al `instrument_range` (Fase 0): rangos desde el
  greenhouse, fallback al `CropModel` vía `cropCatalog.get`. Eliminar los `lowerBound`/
  `upperBound` hardcoded de la page.
  → commit: `feat(dashboard): gauges use real setpoints via InstrumentCard`
- [ ] **2.3** Estados loading/error/empty del detalle.
  → commit: `feat(dashboard): loading/error/empty states for greenhouse detail`

## Fase 3 — alerts + anomalies (agregados)

- [ ] **3.1** Cablear `apps/vertivo_dashboard/lib/pages/alerts_page.dart` a
  `alert.getMyAlerts`; summary por severidad = agregación cliente.
  → commit: `feat(dashboard): wire alerts_page to getMyAlerts`
- [ ] **3.2** Cablear `apps/vertivo_dashboard/lib/pages/anomalies_page.dart`. **No existe**
  `anomaly.getAll` multi-greenhouse: iterar la flota (`anomaly.getForGreenhouse` por
  greenhouse) o documentar el gap. Registrar el gap como item de un futuro change de backend.
  → commit: `feat(dashboard): wire anomalies_page (per-greenhouse aggregation)`
- [ ] **3.3** Estados loading/error/empty en ambas.
  → commit: `feat(dashboard): loading/error/empty states for alerts & anomalies`

## Fase 4 — users (vista admin)

- [ ] **4.1** Cablear `apps/vertivo_dashboard/lib/pages/users_page.dart` a
  `user.listBySegment` (vista operador). Conteo de greenhouses por usuario no tiene endpoint
  directo → "N/D" + gap registrado. Estados loading/error/empty.
  → commit: `feat(dashboard): wire users_page (admin segment view)`

## Done when

- [ ] `AdminFleetEndpoint.listAll` existe, es admin-only (test: sin-auth y sin-admin rechazados,
  con-admin devuelve >1 tenant), y `client.adminFleet.listAll` está en el `vertivo_client`
  regenerado.
- [ ] `vertivo_dashboard` depende de `vertivo_client` y arranca en :8090 sin colisionar con
  Serverpod (:8080).
- [ ] Las 6 pages renderizan data de PostgreSQL (o "N/D" explícito donde no hay endpoint),
  cero literales `'24'`/`GH-001`/"Hydroponics"/etc.
- [ ] `instrument_range` tiene tests verdes; los gauges usan setpoints reales.
- [ ] Cada page tiene loading/error/empty; sin valores inventados ante fallo de backend.
- [ ] Spike SSR documentado: dónde vive la sesión admin en Jaspr.
- [ ] Gaps de endpoints agregados (KPIs globales, anomalías multi-gh) documentados como items
  de un change de backend separado.
- [ ] `openspec/README.md` Active Changes refleja el scope cross-tenant.
