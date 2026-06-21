# Dashboard fleet cockpit — Arquitectura

**Issue:** VRTV-99 (Linear) — https://linear.app/vertivolatam/issue/VRTV-99
**Status:** Decision 2026-06-21
**PDR:** [`proposal.md`](./proposal.md)

## TL;DR

`vertivo_dashboard` (Jaspr SSR) deja de renderizar mock y se convierte en el cockpit real de
la flota: añade `vertivo_client`, introduce una capa de repositories que envuelve los
endpoints Serverpod existentes, y cada page consume data de PostgreSQL. El scope multi-tenant
lo da la sesión autenticada de Serverpod (`session.authenticated.userIdentifier`), no params.
Los gauges colorean in/out-of-range con los setpoints del greenhouse (fallback al `CropModel`)
vía el patrón `InstrumentCard`.

## 1. Flujo de datos flota → backend → dashboard

```
  FLOTA (edge)                         BACKEND (Serverpod)              COCKPIT (Jaspr)
  ┌────────────────────────┐
  │ swarm A                │           ┌───────────────────────┐       ┌──────────────────────┐
  │  ┌──────────────────┐  │  MQTT     │ EMQX broker           │       │ vertivo_dashboard    │
  │  │ µ-greenhouse 1   │──┼──────────▶│  topic:               │       │  (mode: server,      │
  │  │  balena_os +     │  │  publish  │  {user_id}/greenhouse/│       │   port :8090*)       │
  │  │  RaspberryOrch.  │  │           │  {greenhouse_id}      │       │                      │
  │  └──────────────────┘  │           └───────────┬───────────┘       │  pages/ (6)          │
  │  ┌──────────────────┐  │                       │ ingest            │   home, greenhouses, │
  │  │ µ-greenhouse 2   │──┼──────────▶            ▼                   │   greenhouse_detail, │
  │  └──────────────────┘  │           ┌───────────────────────┐       │   alerts, anomalies, │
  └────────────────────────┘           │ PostgreSQL            │       │   users              │
  ┌────────────────────────┐           │  (multi-tenant por    │       │        ▲             │
  │ swarm B                │           │   user_id / swarm)    │       │        │ render       │
  │  ┌──────────────────┐  │           │  - greenhouses        │       │  data/ repositories  │
  │  │ µ-greenhouse N   │──┼──────────▶│  - environmental_..   │       │   (NUEVO, este change)│
  │  └──────────────────┘  │           │  - alerts / anomalies │       │        ▲             │
  └────────────────────────┘           │  - crop_models        │       │        │ client.*    │
                                        └───────────┬───────────┘       │        │             │
                                                    │ 13 endpoints       │  vertivo_client      │
                                                    ▼  (Serverpod)       │   (NUEVO dep)        │
                                        ┌───────────────────────┐  RPC  │        │             │
                                        │ *_endpoint.dart       │◀──────┼────────┘             │
                                        │  greenhouse / alert / │ :8080 │  scope = sesión auth  │
                                        │  anomaly / cropCatalog│       │  (userIdentifier)    │
                                        │  / user               │       └──────────────────────┘
                                        └───────────────────────┘
  * puerto a confirmar (open question #2): hoy el dashboard colisiona con Serverpod en :8080.
```

El cableado de este change es el tramo **`vertivo_client` → repositories → pages**. El tramo
edge→backend ya existe (lo prueba `vertivo_flutter`); el dashboard solo se engancha al mismo
backend que el cliente Flutter.

## 2. Dependencia y capa de repositories

`pubspec.yaml` del dashboard añade (espejo de `vertivo_flutter`):

```yaml
dependencies:
  vertivo_client:
    path: ../vertivo_client
```

Se crea `lib/data/` con un repository por dominio, cada uno modelado sobre
`PhMonitorRepository` (snapshot tipado + un `fetch()` que agrega los endpoints que la page
necesita):

```dart
// lib/data/fleet_repository.dart  (patrón; no es la impl final)
class FleetSnapshot {
  final List<Greenhouse> greenhouses;
  final int unreadAlerts;
  const FleetSnapshot({required this.greenhouses, required this.unreadAlerts});
}

class FleetRepository {
  final Client client;
  const FleetRepository(this.client);

  Future<FleetSnapshot> fetch() async {
    final ghs = await client.greenhouse.listByUser();
    final unread = await client.alert.getUnreadCount();
    return FleetSnapshot(greenhouses: ghs, unreadAlerts: unread);
  }
}
```

## 3. Mapa page → endpoint (solo endpoints que existen hoy)

| Page | Componentes | Endpoint(s) real(es) | Notas |
|------|-------------|----------------------|-------|
| `home_page` | kpi_card×4, sensor_chart, alert_item, data_table | `greenhouse.listByUser`, `alert.getUnreadCount`, `alert.getMyAlerts(limit)`, por greenhouse `greenhouse.getReadings(id, type, limit)` | KPIs "invernaderos activos" = `listByUser().length`; "alertas activas" = `getUnreadCount`. KPI "sensores online" y "anomalías globales" **no tienen endpoint agregado** → gap (open q#1). |
| `greenhouses_page` | gh-card grid, filtros | `greenhouse.listByUser` | Filtros segmento/estado/búsqueda en cliente sobre la lista. "Todos los clientes" depende de open q#1. |
| `greenhouse_detail_page` | gauge_chart×8, sensor_chart×8 | `greenhouse.get(id)`, `greenhouse.getReadings(id, measurementType, limit)` ×N tipos, `greenhouse.getTrays(id)` | Un `getReadings` por measurementType (co2/humidity/ph/temperature/ec/do/tds/orp). Rangos del gauge → InstrumentCard (§4). |
| `alerts_page` | alert_item, summary, filtros | `alert.getMyAlerts(limit, offset)` (o `alert.getForGreenhouse` si se filtra por uno) | Summary por severidad = agregación cliente. Acciones `markAsRead`/`acknowledge`/`resolve` disponibles para fase interactiva (out of scope inicial). |
| `anomalies_page` | data_table, stat-card, method-card | por greenhouse `anomaly.getForGreenhouse(id, limit)` / `anomaly.getUnresolved(id)` | **No hay** `anomaly.getAll` multi-greenhouse → para la tabla global se itera la flota o se documenta gap (open q#1). |
| `users_page` | data_table, segment-card, filtros | `user.listBySegment(segment, limit, offset)`, `user.getProfile` | Solo vista admin/operador. Conteo de greenhouses por usuario no tiene endpoint directo → gap. |

**Catálogo transversal:** `cropCatalog.list`, `cropCatalog.get(id)`,
`cropCatalog.getGrowthStages(cropModelId)` alimentan el InstrumentCard y cualquier vista de
cultivo del detalle.

## 4. InstrumentCard — rangos in/out-of-range

Cada `gauge_chart` hoy recibe `lowerBound`/`upperBound` hardcoded por page. Se reemplaza por
una resolución de rango por capas (concepto `InstrumentCard` de VRTV-96):

1. **Setpoint del greenhouse** (preferente): `Greenhouse.phMin/phMax`,
   `temperatureMin/Max`, `humidityMin/Max`, `co2Min/Max`, `lightMin/Max` (campos nullable del
   modelo).
2. **Fallback al cultivo**: si el greenhouse no define el rango, se usa el `CropModel` del
   cultivo plantado (`idealPhMin/Max`, `idealTemperatureMin/Max`, `idealHumidityMin/Max`,
   `idealCo2Min/Max`, `idealLightHoursMin/Max`) vía `cropCatalog.get`.
3. **Fallback estático** (último recurso): constante por measurementType, como hoy.

El gauge colorea verde dentro de `[min,max]`, ámbar/rojo fuera. La lógica de resolución vive
en un helper testeable (`lib/data/instrument_range.dart`) — es la única lógica con tests
unitarios obligatorios en este change.

## 5. Manejo de loading / error / empty

Cada page pasa por tres estados explícitos (no más mock silencioso):

- **loading:** skeleton/placeholder mientras `fetch()` resuelve.
- **error:** banner con el error y un retry; nunca un valor inventado (regla anti
  silent-failure). Si Serverpod no responde, se ve "sin conexión al backend", no `'24'`.
- **empty:** estado vacío explícito cuando `listByUser()` retorna `[]` (tenant sin flota).

## 6. Fases (resumen; detalle en `tasks.md`)

1. **Fundación** — dep `vertivo_client`, init del `Client`, resolver puerto (open q#2),
   `FleetRepository` + `instrument_range` con tests. Validar SSR vs client-side (open q#3).
2. **home + greenhouses** — las dos vistas de flota agregada (menor riesgo, endpoints simples).
3. **greenhouse_detail** — la más densa: 8 gauges + 8 charts cableados, InstrumentCard real.
4. **alerts + anomalies** — agregados; documentar gaps de endpoints multi-greenhouse.
5. **users** — vista admin; depende de la respuesta a open q#1.

## 7. Riesgos

- **Conflicto de puerto :8080** (dashboard Jaspr vs Serverpod) — bloqueante; resolver en fase 1.
- **`vertivo_client` en contexto Jaspr SSR** — el client se diseñó para Flutter; validar que
  corre en el server de Jaspr (Dart VM) y dónde vive la sesión auth. Spike en fase 1.
- **Gaps de endpoints agregados** (KPIs globales, anomalías multi-greenhouse, flota
  all-tenants) — algunos KPIs del mock **no tienen** endpoint hoy. No inventar valores:
  mostrarlos como "N/D" o iterar, y registrar el gap para un change de backend (regla #2).
- **Multi-tenant mal entendido** — si el cockpit debe ver TODA la flota (operador interno),
  `listByUser` no basta; ver open q#1 antes de cablear `users`/`greenhouses` all-tenant.

## References

- PDR: [`proposal.md`](./proposal.md) · Tasks: [`tasks.md`](./tasks.md)
- Patrón repository: `apps/vertivo_flutter/lib/features/monitoring/data/ph_monitor_repository.dart`
- Endpoints: `apps/vertivo_server/lib/src/{greenhouses,alerts,anomaly_management,crop_catalog,users}/*_endpoint.dart`
- Modelos/setpoints: `apps/vertivo_server/lib/src/greenhouses/greenhouse.spy.yaml`, `crop_catalog/crop_model.spy.yaml`
