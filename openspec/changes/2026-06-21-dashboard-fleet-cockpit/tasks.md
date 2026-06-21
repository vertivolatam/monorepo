# Dashboard fleet cockpit — Tasks

> Decisión registrada 2026-06-21. **Pendiente aprobación** antes de ejecutar.
> TDD donde haya lógica (resolución de rangos). Rutas relativas a la raíz del monorepo.
> Todas las llamadas usan endpoints que YA existen — este change no toca `vertivo_server`.

## Fase 0 — Fundación (dep + cliente + helper testeado)

- [ ] **0.1** Añadir dep a `apps/vertivo_dashboard/pubspec.yaml`:
  ```yaml
  dependencies:
    vertivo_client:
      path: ../vertivo_client
  ```
  y resolver con el pnpm/dart workspace (lock único en raíz).
  → commit: `build(dashboard): add vertivo_client dependency`
- [ ] **0.2** Resolver el **conflicto de puerto** (open q#2): mover `jaspr.port` de `8080` a
  `8090` en `pubspec.yaml` (o el que confirme el owner), para no colisionar con Serverpod.
  → commit: `fix(dashboard): move jaspr server to :8090 to free Serverpod :8080`
- [ ] **0.3** Crear init del `Client` Serverpod en `apps/vertivo_dashboard/lib/data/client.dart`
  (espejo de `vertivo_flutter/lib/main.dart`: `Client(serverUrl)` apuntando a
  `http://localhost:8080/`). **Spike** (open q#3): confirmar que el client corre en el server
  Jaspr (Dart VM) y dónde vive la sesión auth. Documentar el hallazgo en `design.md` §7.
  → commit: `feat(dashboard): wire Serverpod Client init`
- [ ] **0.4** [TDD] Test primero: `apps/vertivo_dashboard/test/instrument_range_test.dart` —
  cubre las 3 capas de resolución (greenhouse setpoint → CropModel ideal → fallback estático)
  y el coloreo in/out-of-range por measurementType.
  → commit: `test(dashboard): instrument range resolution (red)`
- [ ] **0.5** Implementar `apps/vertivo_dashboard/lib/data/instrument_range.dart` hasta verde.
  → commit: `feat(dashboard): instrument range resolver (green)`
- [ ] **0.6** Crear `apps/vertivo_dashboard/lib/data/fleet_repository.dart` (snapshot tipado +
  `fetch()` agregando `greenhouse.listByUser` + `alert.getUnreadCount`), patrón
  `PhMonitorRepository`.
  → commit: `feat(dashboard): FleetRepository over Serverpod client`

## Fase 1 — home + greenhouses (flota agregada, menor riesgo)

- [ ] **1.1** Cablear `apps/vertivo_dashboard/lib/pages/home_page.dart`: KPIs reales
  (`listByUser().length`, `getUnreadCount`), alertas recientes (`alert.getMyAlerts`), tabla de
  estado desde `listByUser`. KPIs sin endpoint ("sensores online", "anomalías globales") →
  mostrar "N/D" + TODO con referencia al gap, **nunca** un literal inventado.
  → commit: `feat(dashboard): wire home_page to fleet endpoints`
- [ ] **1.2** Cablear `apps/vertivo_dashboard/lib/pages/greenhouses_page.dart` a
  `greenhouse.listByUser`; filtros segmento/estado/búsqueda en cliente sobre la lista.
  → commit: `feat(dashboard): wire greenhouses_page to listByUser`
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

## Fase 4 — users (vista admin; depende de open q#1)

- [ ] **4.1** Resolver open q#1 con el owner (cockpit per-tenant vs operador all-tenants) antes
  de cablear. Si admin: `user.listBySegment`. Si falta endpoint de conteo de greenhouses por
  usuario, documentar gap.
  → commit: `feat(dashboard): wire users_page (admin segment view)`

## Done when

- [ ] `vertivo_dashboard` depende de `vertivo_client` y arranca sin colisionar con Serverpod.
- [ ] Las 6 pages renderizan data de PostgreSQL (o "N/D" explícito donde no hay endpoint),
  cero literales `'24'`/`GH-001`/etc.
- [ ] `instrument_range` tiene tests verdes; los gauges usan setpoints reales.
- [ ] Cada page tiene loading/error/empty; sin valores inventados ante fallo de backend.
- [ ] Gaps de endpoints (KPIs globales, anomalías multi-gh, flota all-tenants) documentados
  como items de un change de backend separado (regla #2 — connect before create).
- [ ] `openspec/README.md` Active Changes incluye este change.
