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
  * RESUELTO: Serverpod se queda con :8080; el dashboard Jaspr se mueve a :8090 (jaspr.port en
    pubspec.yaml). Hoy ambos declaran :8080 — colisión que este change elimina.
```

El cableado de este change es el tramo **`vertivo_client` → repositories → pages**. El tramo
edge→backend ya existe (lo prueba `vertivo_flutter`); el dashboard solo se engancha al mismo
backend que el cliente Flutter. La vista admin lo hace cross-tenant vía `adminFleet.listAll`
(§2.5).

### Puerto: Serverpod :8080, dashboard :8090

`apps/vertivo_dashboard/pubspec.yaml` declara hoy `jaspr: { mode: server, port: 8080 }` — el
mismo puerto donde corre Serverpod (`localhost:8080`, ver `vertivo_flutter/lib/main.dart` y
`getServerUrl()` default). El SSR del dashboard no puede levantar en un puerto ocupado por el
backend al que llama. **Resolución (aprobada):** el dashboard Jaspr pasa a `port: 8090`;
Serverpod conserva `:8080`. El `Client` del dashboard apunta a `http://localhost:8080/`.

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
    // Vista admin: flota cross-tenant (todos los clientes). Ver §2.5.
    final ghs = await client.adminFleet.listAll();
    final unread = await client.alert.getUnreadCount();
    return FleetSnapshot(greenhouses: ghs, unreadAlerts: unread);
  }
}
```

## 2.5 Endpoint admin cross-tenant (NUEVO — scope ampliado)

El cockpit aprobado es un **panel de operador interno** que ve **toda la flota de todos los
tenants**. Los 13 endpoints existentes son per-tenant (`listByUser` filtra por
`session.authenticated.userIdentifier`) o per-greenhouse; ninguno lista la flota completa. Se
añade **un** método nuevo al `GreenhouseEndpoint`, protegido admin-only con el `Scope.admin`
nativo de Serverpod 3.4 (`requiredScopes` implica `requireLogin`):

```dart
// apps/vertivo_server/lib/src/greenhouses/admin_fleet_endpoint.dart  (impl real)
class AdminFleetEndpoint extends Endpoint {
  // Override de clase: Serverpod rechaza toda sesión sin Scope.admin ANTES de
  // ejecutar el método (requiredScopes implica requireLogin). Sin chequeo manual.
  @override
  Set<Scope> get requiredScopes => {Scope.admin};

  /// Lista toda la flota activa de TODOS los tenants, ordenada por owner.
  Future<List<Greenhouse>> listAll(
    Session session, {
    int limit = 500,
    int offset = 0,
  }) async {
    return await Greenhouse.db.find(
      session,
      where: (t) => t.isActive.equals(true),
      limit: limit, offset: offset,
      orderBy: (t) => t.userId,
    );
  }
}
```

**Decisión de aislamiento (elegida: A).** `GreenhouseEndpoint` mezcla métodos per-tenant
(`listByUser`, `getReadings`), así que un override de clase `requiredScopes` ahí aplicaría a
todos sus métodos — incorrecto. Se usa un **endpoint nuevo aparte** `AdminFleetEndpoint` con
`requiredScopes => {Scope.admin}` a nivel de clase (patrón que Serverpod recomienda para
admin), manteniendo `greenhouse.*` intacto. El gating es **declarativo** (no manual): Serverpod
valida el scope antes del cuerpo. Cliente: `client.adminFleet.listAll()`.

**Supuesto de roles documentado:** NO existe tabla de roles ni campo `isAdmin` en `User`
(`User.segment` es residential/commercial/industrial/expert, no un rol de autorización). El
`Scope.admin` se otorga vía el auth token de Serverpod. Una gestión de roles real (asignar
admin desde UI, tabla `roles`) es un change aparte — ver `proposal.md` out-of-scope.

## 3. Mapa page → endpoint

| Page | Componentes | Endpoint(s) | Notas |
|------|-------------|-------------|-------|
| `home_page` (admin) | kpi_card×4, sensor_chart, alert_item, data_table | **`adminFleet.listAll`** (flota cross-tenant), `alert.getMyAlerts(limit)`, por greenhouse `greenhouse.getReadings(id, type, limit)` | KPI "invernaderos activos" = `listAll().length` (todos los tenants). "sensores online"/"anomalías globales" sin endpoint agregado → **"N/D"**, no inventar. |
| `greenhouses_page` (admin) | gh-card grid, filtros | **`adminFleet.listAll`** | Vista operador: toda la flota. Filtros segmento/estado/búsqueda en cliente. Modo cliente (futuro) usaría `listByUser`. |
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

0. **Backend admin endpoint** — `AdminFleetEndpoint.listAll` (admin-only, TDD) + `serverpod
   generate` + regenerar `vertivo_client`. Habilita la vista cross-tenant.
1. **Fundación dashboard** — mover puerto a :8090, dep `vertivo_client`, init `Client`,
   `FleetRepository` + `instrument_range` con tests. **Spike SSR vs client-side** antes de auth.
2. **home + greenhouses** (admin) — flota cross-tenant vía `adminFleet.listAll`.
3. **greenhouse_detail** — la más densa: 8 gauges + 8 charts, InstrumentCard real.
4. **alerts + anomalies** — agregados; documentar gaps de endpoints multi-greenhouse.
5. **users** — vista admin (`user.listBySegment`).

## 7. Riesgos

- **Endpoint nuevo vs regla AGENTS.md** — añadir `adminFleet.listAll` rompe "do not build new
  endpoints"; es excepción **aprobada** y trazada en `proposal.md` §Tensión. Mantenerlo mínimo
  y admin-only.
- **Fuga cross-tenant** — el endpoint admin expone la flota de TODOS los clientes. Debe ser
  admin-only por `Scope.admin` (Serverpod rechaza sin scope). Test obligatorio: sesión sin
  admin → rechazada; sesión sin auth → rechazada.
- **`vertivo_client` en contexto Jaspr SSR** — RESUELTO (spike + e2e 2026-06-21): el client
  corre en el server Jaspr (Dart VM); las pages son `AsyncStatelessComponent` (fetch
  server-side); la sesión admin/JWT vive server-side, no se envía al browser. **Verificado
  e2e**: el binario SSR compila (`dart compile exe`), levanta, y con el backend caído renderiza
  el `errorState` (no crash, no datos falsos).
- **Puerto en runtime del binario** — `jaspr.port: 8090` solo aplica al dev server
  `jaspr serve`. El **exe compilado lee `PORT`** (default 8080). El deployment DEBE arrancar
  con `PORT=8090` (Dockerfile/manifest) o colisiona con Serverpod en :8080. Verificado e2e.
- **Gaps de endpoints agregados** (KPIs globales "sensores online", anomalías multi-greenhouse)
  — sin endpoint hoy. No inventar: **"N/D"** explícito + registrar gap para change futuro.
- **Nomenclatura (regla #6)** — el mock dice "Hydroponics/Hidroponico"; al cablear data real,
  `Greenhouse.irrigationType` usa `aeroponic`/nebuponía. Eliminar los literales "hydroponic".

## References

- PDR: [`proposal.md`](./proposal.md) · Tasks: [`tasks.md`](./tasks.md)
- Patrón repository: `apps/vertivo_flutter/lib/features/monitoring/data/ph_monitor_repository.dart`
- Endpoints: `apps/vertivo_server/lib/src/{greenhouses,alerts,anomaly_management,crop_catalog,users}/*_endpoint.dart`
- Modelos/setpoints: `apps/vertivo_server/lib/src/greenhouses/greenhouse.spy.yaml`, `crop_catalog/crop_model.spy.yaml`
