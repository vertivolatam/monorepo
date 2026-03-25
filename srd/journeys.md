# Section 3 — Critical Journeys

> Cada journey mapea pantalla por pantalla la experiencia de una persona, referenciando
> rutas reales del codebase (Flutter, Serverpod, Jaspr, Raspberry). Los pasos marcados
> con **[GAP]** no existen aún en el código.

---

## Inventario del Codebase (estado actual)

### Flutter App (`apps/vertivo_flutter/`)
| Pantalla | Ruta | Estado |
|----------|------|--------|
| `GreetingsScreen` | `/` | Funcional (test de conexión) |
| `SignInScreen` | `/` (wrapper) | Funcional (Serverpod IdP) |
| *Todo lo demás* | — | **No existe** |

**Faltan**: Router (GoRouter), state management (Riverpod), todas las pantallas de feature, FCM, pagos, marketplace.

### Serverpod Backend (`apps/backend/`)
| Endpoint | Métodos | Estado |
|----------|---------|--------|
| `alert` | create, getMyAlerts, getUnreadCount, markAsRead, acknowledge, resolve, getForGreenhouse, getTemplates | Funcional |
| `anomaly` | record, getForGreenhouse, getUnresolved, classify, resolve | Funcional |
| `auth` | createSession, revokeSession, getActiveSessions, logSecurityEvent | Funcional |
| `emailIdp` | login, register, verify, reset password | Stub (logs a console) |
| `cropCatalog` | list, get, search, create, getGrowthStages | Funcional |
| `greenhouse` | CRUD, getTrays, getPlants, recordReading, getReadings, recordIrrigation, quarantinePlant | Funcional |
| `harvestPrediction` | getForGreenhouse, getForPlant, create, recordActual, getQuality | Funcional |
| `management` | getMetrics, record, getDashboardSummary | Funcional |
| `phytopathology` | detectDisease, identifyPest, detectNutrientIssue, recommendTreatment, markTreatmentApplied | Funcional |
| `traceability` | addRecord, getChain, verifyChain, generateReport, getTemplates | Funcional |
| `user` | getProfile, updateProfile, getPreferences, updatePreferences, getSubscriptionPlan | Funcional |
| **billing/payments** | — | **No existe** |
| **marketplace/orders** | — | **No existe** |
| **notifications (send)** | — | **No existe** (modelo NotificationDelivery existe, pero no envía) |
| **referral** | — | **No existe** |

### Jaspr Dashboard (`apps/dashboard/`)
| Ruta | Página | Estado |
|------|--------|--------|
| `/` | Home (KPIs, alertas, status) | Hardcoded |
| `/greenhouses` | Grid de invernaderos | Hardcoded |
| `/greenhouses/:id` | Detalle con 8 gauges + charts | Hardcoded |
| `/alerts` | Centro de alertas | Hardcoded |
| `/anomalies` | Dashboard de anomalías | Hardcoded |
| `/users` | Gestión de usuarios | Hardcoded |

**Todas las páginas usan datos sintéticos.** 0% conectado a backend.

### Raspberry Pi Orchestrator (`apps/raspberry/`)
| Módulo | Estado |
|--------|--------|
| 8 sensor drivers Atlas Scientific EZO (pH, EC, DO, ORP, RTD, CO2, humidity, TDS) | Funcional |
| 4 orchestrator modes (indoor, outdoor, soil, environmental) | Funcional |
| MQTT publish a AWS IoT / EMQX | Funcional |
| Bounds checking + alert generation | Funcional |
| 7 simulation scenarios | Funcional |
| **Automation control** (LEDs, bomba, dosificación) | **No existe** |
| **Robot agrónomo decision engine** | **No existe** |

---

## J1 — Compra y Onboarding

**Personas**: María (#1), Carlos (#2), Rosa (#3), Andrés (#8)
**Revenue impact**: 55% de usuarios, primer ingreso hardware + primer SaaS + primer Caja
**Criticidad**: BLOQUEANTE — sin este journey no hay revenue

### Pantalla por pantalla

| Paso | Pantalla / Acción | Sistema | Endpoint / Ruta | Estado |
|------|-------------------|---------|-----------------|--------|
| 1 | Landing page `vertivo.com` — hero, video, precios, CTA "Comprar" | Web (fuera del monorepo) | — | **[GAP]** No existe landing page |
| 2 | Checkout — seleccionar plan (Home/Pro/Scale), datos de envío, método de pago | Web o Flutter | — | **[GAP]** No existe checkout |
| 3 | Procesar pago hardware ([precio redactado]) + primer mes SaaS ([ver pricing]) | Backend | latam_payments (OnvoPay/Tilopay/Wompi) | **[GAP]** No existe billing endpoint |
| 4 | Confirmación de compra + email con tracking de envío | Backend | NotificationDelivery (email) | **[GAP]** Modelo existe, sending no |
| 5 | **Hardware llega** — usuario desempaca Vertivo Home | Físico | — | Fuera del software |
| 6 | Descarga app Flutter → `SignInScreen` — crear cuenta con email | Flutter | `SignInScreen` → `emailIdp.startRegistration()` | **Parcial** — UI existe, email verification logs a console |
| 7 | Onboarding wizard — "Conecta tu invernadero" (escanear QR/Bluetooth del device) | Flutter | — | **[GAP]** No existe onboarding flow |
| 8 | Device se registra — Raspberry Pi publica primer `status` vía MQTT | Raspberry | `mqtt.py` → topic `device/{id}/status` | **Funcional** |
| 9 | Backend recibe status → crea `Greenhouse` + `Tray` para el usuario | Backend | `greenhouse.create()`, `greenhouse.createTray()` | **Funcional** (endpoint existe, no hay trigger automático desde MQTT) |
| 10 | App muestra dashboard con datos en vivo — gauges de pH, temp, humidity | Flutter | `greenhouse.getReadings()` | **[GAP]** Endpoint existe, pantalla no |
| 11 | Robot agrónomo sugiere primer cultivo según condiciones detectadas | Raspberry + Backend | `cropCatalog.getRecommendations()` | **Parcial** — endpoint existe, robot decision engine no |
| 12 | Usuario planta semillas — confirma en app | Flutter | `greenhouse.createPlant()` | **[GAP]** Endpoint existe, pantalla no |
| 13 | **Día 28**: Push notification "Tu albahaca está lista para cosechar!" | Backend → FCM → Flutter | `harvestPrediction` + FCM | **[GAP]** Predicción existe, FCM no, push no |
| 14 | Usuario cosecha → foto → compartir → **WOW MOMENT** | Flutter | — | **[GAP]** No existe share/camera flow |

### Gaps críticos de J1

| Gap | Bloquea | Prioridad |
|-----|---------|-----------|
| **Billing/checkout** (latam_payments) | Todo el revenue | **T0** |
| **Flutter onboarding wizard** | Activación de device | **T0** |
| **Flutter dashboard con datos reales** | Retención día 1 | **T0** |
| **FCM push notifications** | Conversión (32% de upgrades) | **T1** |
| **Landing page / web checkout** | Adquisición | **T1** |
| Email sending real (verification, receipts) | Onboarding completeness | **T1** |
| Robot agrónomo suggestions | Primera cosecha optimizada | **T2** |
| Share/camera harvest moment | Viralidad | **T2** |

---

## J2 — Monitoreo Diario

**Personas**: Todos los B2C (María, Carlos, Rosa, Andrés) + Diego, Valentina
**Revenue impact**: Retención SaaS — si esta experiencia es mala, churn
**Criticidad**: ALTA — es el loop diario que justifica el pago mensual

### Pantalla por pantalla

| Paso | Pantalla / Acción | Sistema | Endpoint / Ruta | Estado |
|------|-------------------|---------|-----------------|--------|
| 1 | Abrir app → Home screen con resumen | Flutter | `management.getDashboardSummary()` | **[GAP]** Endpoint existe, pantalla no |
| 2 | Ver KPIs: plantas activas, próxima cosecha, alertas pendientes | Flutter | `harvestPrediction.getForGreenhouse()`, `alert.getUnreadCount()` | **[GAP]** Endpoints existen, pantalla no |
| 3 | Tap en invernadero → detalle con 8 gauges en tiempo real | Flutter | `greenhouse.getReadings(type: 'all')` | **[GAP]** Endpoint existe, pantalla no |
| 4 | Ver histórico de sensor (chart 24h/7d/30d) | Flutter | `greenhouse.getReadings(from, to)` | **[GAP]** Endpoint existe, charting no |
| 5 | Ver estado de cada planta en cada bandeja | Flutter | `greenhouse.getPlants()` | **[GAP]** Endpoint existe, pantalla no |
| 6 | Notificación: "pH bajó a 5.2 — el robot ajustó automáticamente" | Raspberry → MQTT → Backend → FCM | `alert.create()` + FCM push | **Parcial** — alert se crea en backend vía sensor ingestion, pero FCM no envía |
| 7 | Tap en alerta → detalle con recomendación | Flutter | `alert.getMyAlerts()`, `phytopathology.recommendTreatment()` | **[GAP]** Endpoints existen, pantalla no |
| 8 | Marcar alerta como resuelta | Flutter | `alert.resolve()` | **[GAP]** Endpoint existe, pantalla no |

### Dashboard admin (Lucía, equipo Vertivo)

| Paso | Pantalla / Acción | Sistema | Ruta | Estado |
|------|-------------------|---------|------|--------|
| 1 | Abrir dashboard Jaspr → Home con KPIs globales | Dashboard | `/` | **Hardcoded** — UI existe, datos falsos |
| 2 | Ver lista de invernaderos → filtrar por segmento | Dashboard | `/greenhouses` | **Hardcoded** |
| 3 | Click en invernadero → 8 gauges + charts | Dashboard | `/greenhouses/:id` | **Hardcoded** — D3.js funciona con datos sintéticos |
| 4 | Ver alertas globales → filtrar por severidad | Dashboard | `/alerts` | **Hardcoded** |
| 5 | Ver anomalías → clasificar (AI/ML vs rule-based) | Dashboard | `/anomalies` | **Hardcoded** |

### Gaps críticos de J2

| Gap | Bloquea | Prioridad |
|-----|---------|-----------|
| **Flutter: todas las pantallas de monitoreo** | Loop diario de retención | **T0** |
| **Dashboard: conectar a API real** | Operaciones internas | **T1** |
| **FCM push para alertas** | Engagement (24% de conversiones) | **T1** |
| Real-time WebSocket/SSE en Flutter | Datos "vivos" sin pull-to-refresh | **T2** |

---

## J3 — Alerta Crítica del Robot Agrónomo

**Personas**: María (#1), Carlos (#2) — los que más valoran "el robot me salvó las plantas"
**Revenue impact**: 24% de las conversiones free→paid vienen de este momento
**Criticidad**: ALTA — es el momento emocional que genera trust y pago

### Pantalla por pantalla

| Paso | Pantalla / Acción | Sistema | Endpoint / Ruta | Estado |
|------|-------------------|---------|-----------------|--------|
| 1 | Raspberry detecta pH 4.8 (debajo de 5.5 lower bound) | Raspberry | `nutrient_solution_pH_monitor.is_below_lower_bound()` | **Funcional** |
| 2 | Raspberry publica alerta MQTT `device/{id}/alert` | Raspberry | `mqtt.py` publish | **Funcional** |
| 3 | Backend `SensorIngestionService` recibe → crea `Anomaly` (severity: high) | Backend | `anomaly.record()` auto-trigger | **Funcional** |
| 4 | Backend crea `Alert` (type: ph_critical, severity: high) | Backend | `alert.create()` auto-trigger | **Funcional** |
| 5 | Backend debería enviar push notification via FCM | Backend → FCM | NotificationDelivery + FCM SDK | **[GAP]** Modelo existe, envío no |
| 6 | Usuario ve push en lock screen: "pH crítico en tu invernadero — tocá para ver" | Flutter | FCM foreground/background handler | **[GAP]** No existe FCM integration |
| 7 | Tap → app abre detalle de alerta con lectura actual, rango esperado, gráfico | Flutter | `alert.getMyAlerts()` + `greenhouse.getReadings()` | **[GAP]** Endpoints existen, pantalla no |
| 8 | Robot agrónomo sugiere: "Agregá 2ml de pH Up a la solución" | Raspberry → Backend | `phytopathology.recommendTreatment()` | **Parcial** — endpoint existe, lógica de recomendación no automatizada |
| 9 | **Robot ejecuta corrección automáticamente** (dosifica pH Up via bomba peristáltica) | Raspberry | GPIO control → bomba | **[GAP]** No existe automation control |
| 10 | Backend registra corrección → actualiza alerta como auto-resolved | Backend | `alert.resolve(autoResolved: true)` | **Funcional** (endpoint existe) |
| 11 | Push: "El robot corrigió el pH. Ahora está en 6.1 — todo normal" | Backend → FCM | — | **[GAP]** FCM no existe |
| 12 | Usuario ve en app: "Problema resuelto automáticamente" → **TRUST MOMENT** | Flutter | Alert detail view | **[GAP]** Pantalla no existe |

### Gaps críticos de J3

| Gap | Bloquea | Prioridad |
|-----|---------|-----------|
| **FCM push notifications** | Momento emocional completo | **T1** |
| **Flutter alert detail screen** | Visualización del save | **T0** |
| **Robot agrónomo automation** (bomba, dosificación) | Auto-corrección real | **T2** (funciona con corrección manual al inicio) |
| Automated treatment recommendation engine | Sugerencias inteligentes | **T2** |

---

## J4 — Marketplace: Caja Vertivo + On-Demand

**Personas**: María (#1), Rosa (#3), Diego (#4)
**Revenue impact**: 36% del MRR total ([monto redactado]/mo target)
**Criticidad**: ALTA — segundo stream de revenue más grande

### Pantalla por pantalla

| Paso | Pantalla / Acción | Sistema | Endpoint / Ruta | Estado |
|------|-------------------|---------|-----------------|--------|
| 1 | Robot detecta nutrientes bajos → push: "Tu solución nutritiva se está agotando" | Raspberry → Backend → FCM | Bounds checking + FCM | **[GAP]** Bounds checking funciona, FCM no |
| 2 | Tap en notificación → app abre Marketplace | Flutter | — | **[GAP]** No existe marketplace |
| 3 | Ver "Caja Vertivo Recomendada" — el robot calculó qué necesita tu invernadero | Flutter | — | **[GAP]** |
| 4 | Opciones: Caja Básica ($25), Caja Pro ($45), Caja Comercial ($120) | Flutter | — | **[GAP]** |
| 5 | Seleccionar → ver contenido de la caja (nutritivas, semillas, cantidades) | Flutter | — | **[GAP]** |
| 6 | "Suscribirme" → checkout con método de pago guardado | Flutter | latam_payments | **[GAP]** No existe billing |
| 7 | Confirmación + fecha estimada de envío | Flutter + Backend | — | **[GAP]** |
| 8 | Browse on-demand: semillas, repuestos, kits temáticos | Flutter | — | **[GAP]** |
| 9 | Agregar al carrito → checkout | Flutter | — | **[GAP]** |
| 10 | Fulfillment: preparar y enviar desde bodega | Operaciones | — | Manual al inicio |
| 11 | Push: "Tu Caja Vertivo fue enviada — llega en 3 días" | Backend → FCM | — | **[GAP]** |
| 12 | Caja llega → usuario aplica nutritivas → robot confirma niveles OK | Raspberry | Sensor readings confirm | **Funcional** (lectura de sensores) |

### Gaps críticos de J4

| Gap | Bloquea | Prioridad |
|-----|---------|-----------|
| **Marketplace completo** (catálogo, carrito, checkout, suscripción) | 36% del MRR | **T0** |
| **Billing/payments** (latam_payments) | Cobro de Caja | **T0** |
| **Order management backend** (orders, inventory, fulfillment tracking) | Operaciones | **T1** |
| FCM push para reorder reminders | Conversión 18% | **T1** |
| Robot-calculated Caja recommendations | Personalización | **T2** |

---

## J5 — ROI Comercial y Fleet Management

**Personas**: Diego (#4), Valentina (#5), Roberto (#6)
**Revenue impact**: 54% del revenue (Commercial + Industrial)
**Criticidad**: ALTA — los clientes de mayor LTV

### Pantalla por pantalla

| Paso | Pantalla / Acción | Sistema | Endpoint / Ruta | Estado |
|------|-------------------|---------|-----------------|--------|
| 1 | Login en app → ver lista de invernaderos (fleet view) | Flutter | `greenhouse.listByUser()` | **[GAP]** Endpoint existe, pantalla no |
| 2 | Dashboard fleet: status de cada invernadero, alertas activas, rendimiento | Flutter | `management.getDashboardSummary()` | **[GAP]** |
| 3 | Tap invernadero → detalle con sensores, plantas, predicciones | Flutter | `greenhouse.get()`, `greenhouse.getReadings()`, `harvestPrediction.getForGreenhouse()` | **[GAP]** Endpoints existen |
| 4 | Ver predicción de cosecha: fecha estimada, rendimiento esperado, calidad | Flutter | `harvestPrediction.getForGreenhouse()`, `harvestPrediction.getQuality()` | **[GAP]** |
| 5 | Ver KPIs: yield/m², water efficiency, ROI mensual | Flutter | `management.getMetrics()` | **[GAP]** Endpoint existe |
| 6 | Generar reporte de ROI → exportar PDF | Flutter o Dashboard | `management.exportReport()` | **[GAP]** Endpoint existe pero sin generación PDF |
| 7 | API access: conectar con POS/ERP externo | Backend | API REST (Serverpod auto-generated) | **Parcial** — endpoints existen, no hay API key management, no docs |
| 8 | Multi-user: agregar staff de cocina como viewers | Flutter/Backend | — | **[GAP]** No existe multi-user/roles |
| 9 | Compliance: generar reporte de trazabilidad para auditoría | Flutter | `traceability.generateReport()`, `traceability.getChain()` | **[GAP]** Endpoints existen, UI no |
| 10 | Dashboard admin: Roberto ve las 15 locations desde Jaspr | Dashboard | `/greenhouses` filtrado por org | **Hardcoded** |

### Gaps críticos de J5

| Gap | Bloquea | Prioridad |
|-----|---------|-----------|
| **Flutter fleet management screens** | Experiencia Commercial/Industrial | **T1** |
| **API key management + docs** | Integración POS/ERP (Diego, Roberto) | **T1** |
| **Multi-user/roles** (owner, viewer, admin) | Staff access | **T1** |
| ROI report generation (PDF) | Justificación ante board | **T2** |
| Compliance report UI | Auditorías COFEPRIS/SENASA | **T2** |
| Dashboard conectado a API real | Operaciones internas | **T1** |

---

## J6 — Agrónoma Consultora (Fleet Remoto)

**Personas**: Lucía (#7)
**Revenue impact**: 4% directo, pero multiplicador — cada cliente de Lucía compra hardware + SaaS
**Criticidad**: MEDIA — pero alto valor estratégico como canal de adquisición

### Pantalla por pantalla

| Paso | Pantalla / Acción | Sistema | Endpoint / Ruta | Estado |
|------|-------------------|---------|-----------------|--------|
| 1 | Login → ver dashboard con TODOS sus clientes (12-25 invernaderos) | Dashboard o Flutter | `greenhouse.listByUser()` (con permiso cross-user) | **[GAP]** No existe cross-user fleet view |
| 2 | Filtrar por cliente → ver estado de cada invernadero | Dashboard | `/greenhouses` con filtro owner | **[GAP]** Hardcoded, sin filtro real |
| 3 | Robot sugiere acción → Lucía revisa y aprueba/modifica (Expert Mode) | Flutter/Dashboard | `phytopathology.recommendTreatment()` | **[GAP]** Endpoint existe, Expert Mode no |
| 4 | Enviar recomendación al cliente como mensaje in-app | Flutter | — | **[GAP]** No existe messaging |
| 5 | Ver analytics cross-client: "tus clientes en Heredia tienen 20% más yield que los de San José" | Dashboard | `management.getMetricsByUser()` cross-reference | **[GAP]** Endpoint existe, cross-analysis no |
| 6 | Generar reporte mensual por cliente → enviar PDF | Dashboard | `management.exportReport()` | **[GAP]** |

### Gaps críticos de J6

| Gap | Bloquea | Prioridad |
|-----|---------|-----------|
| **Cross-user fleet view** (agrónomo ve clientes) | Propuesta de valor completa para Lucía | **T2** |
| **Expert Mode** (robot sugiere, agrónomo aprueba) | Diferenciación vs. robot-only | **T2** |
| Cross-client analytics | Insights de alto valor | **T3** |

---

## J7 — Enterprise Procurement (Industrial)

**Personas**: Roberto (#6)
**Revenue impact**: 22% del revenue ($110K/mo)
**Criticidad**: MEDIA — ciclo de venta largo (6-12mo), pero LTV altísimo

### Pantalla por pantalla

| Paso | Pantalla / Acción | Sistema | Endpoint / Ruta | Estado |
|------|-------------------|---------|-----------------|--------|
| 1 | Roberto recibe demo en feria AgTech → ve Jaspr dashboard | Dashboard | `/` + `/greenhouses/:id` | **Hardcoded** (funciona para demo con datos ficticios) |
| 2 | Equipo de ventas crea POC con 1 device en 1 location | Raspberry + Backend | Deploy manual + `greenhouse.create()` | **Funcional** |
| 3 | POC corre 30 días → Roberto ve datos reales en dashboard | Dashboard | Debería conectar a API | **[GAP]** Dashboard hardcoded |
| 4 | Roberto pide integración SAP/ERP → acceso API | Backend | API REST + API keys | **[GAP]** API keys no gestionados |
| 5 | Contrato firmado → rollout a 15 locations | Operaciones | Bulk provisioning | **[GAP]** No existe bulk provisioning |
| 6 | SLA: soporte dedicado, uptime garantizado | Operaciones | — | Proceso manual |
| 7 | Compliance: reportes mensuales de trazabilidad | Backend | `traceability.generateReport()` | **Funcional** (endpoint) — UI **[GAP]** |
| 8 | Data export: Roberto baja datos para su BI tool | Backend | `management.exportReport()` | **[GAP]** Export real no implementado |

---

## J8 — Referral y Sharing (Viral Loop)

**Personas**: Andrés (#8), María (#1)
**Revenue impact**: 18% referral rate → 40% de devices vendidos por referral
**Criticidad**: MEDIA-ALTA — motor de crecimiento orgánico

### Pantalla por pantalla

| Paso | Pantalla / Acción | Sistema | Endpoint / Ruta | Estado |
|------|-------------------|---------|-----------------|--------|
| 1 | Push: "Tu albahaca está lista!" → usuario cosecha | Backend → FCM → Flutter | `harvestPrediction` + FCM | **[GAP]** |
| 2 | App muestra "Compartir tu cosecha" — genera card con foto + datos + logo Vertivo | Flutter | — | **[GAP]** No existe share flow |
| 3 | Share card a WhatsApp/Instagram con link de referral embebido | Flutter | — | **[GAP]** |
| 4 | Amigo ve card → click link → landing page con descuento de referral | Web | — | **[GAP]** |
| 5 | Amigo compra → referrer recibe crédito en marketplace | Backend | — | **[GAP]** No existe referral system |
| 6 | Push al referrer: "Tu amigo compró un Vertivo — tienes $50 de crédito" | Backend → FCM | — | **[GAP]** |
| 7 | Andrés ve su dashboard de referrals: referidos, créditos, earnings | Flutter | — | **[GAP]** |

### Gaps críticos de J8

| Gap | Bloquea | Prioridad |
|-----|---------|-----------|
| **Referral system backend** (links, tracking, credits) | Growth engine | **T1** |
| **Share flow** (harvest card generator + deep links) | Viralidad | **T1** |
| Referral dashboard (earnings, history) | Motivación para Andrés | **T2** |

---

## Resumen de Gaps por Prioridad (Tier)

### T0 — Bloqueantes (sin esto no hay revenue)

| Gap | Journeys | Personas | Revenue at risk |
|-----|----------|----------|-----------------|
| **Billing/payments (latam_payments)** | J1, J4 | Todos | 100% — no se puede cobrar |
| **Flutter app screens (dashboard, greenhouse detail, alerts)** | J1, J2, J3 | Todos B2C | 55% users, loop de retención |
| **Flutter onboarding wizard** (device pairing) | J1 | Todos | Activación — sin esto el device es un pisapapeles |
| **Marketplace** (catálogo, carrito, checkout, suscripción Caja) | J4 | María, Rosa, Diego | 36% MRR ([monto redactado]/mo) |

### T1 — Críticos (escalan revenue y retención)

| Gap | Journeys | Personas | Revenue at risk |
|-----|----------|----------|-----------------|
| **FCM push notifications** | J1, J2, J3, J4, J8 | Todos | 32% conversiones + 24% trust moments + 18% reorders |
| **Landing page / web checkout** | J1 | Todos nuevos | Adquisición — funnel de entrada |
| **Email sending real** (Serverpod email service) | J1 | Todos | Verificación, receipts, password reset |
| **Dashboard conectado a API** (Jaspr → Serverpod) | J2, J5, J7 | Lucía, Roberto, equipo | Operaciones + demos |
| **Referral system** | J8 | Andrés, María | 40% de device sales |
| **API key management + docs** | J5, J7 | Diego, Roberto | Integración POS/ERP |
| **Multi-user/roles** | J5 | Diego, Roberto | Staff access |
| **Order management backend** | J4 | Todos marketplace | Fulfillment tracking |

### T2 — Importantes (optimizan y diferencian)

| Gap | Journeys | Personas | Impact |
|-----|----------|----------|--------|
| **Robot agrónomo automation** (control de actuadores) | J3 | Todos | Auto-corrección real (vs. manual) |
| **Robot-calculated Caja recommendations** | J4 | María, Rosa | Personalización marketplace |
| **Share/camera harvest moment** | J1, J8 | Andrés, María | Viralidad orgánica |
| **ROI report PDF generation** | J5 | Diego, Roberto | Justificación de inversión |
| **Compliance report UI** | J5, J7 | Roberto, B2G | Auditorías regulatorias |
| **Cross-user fleet view** (agrónomo) | J6 | Lucía | Propuesta de valor Expert |
| **Expert Mode** (robot sugiere, agrónomo decide) | J6 | Lucía | Diferenciación |
| **Real-time WebSocket/SSE** | J2 | Carlos | Datos live sin refresh |

### T3 — Futuro (post [MRR target])

| Gap | Journeys | Impact |
|-----|----------|--------|
| Cross-client analytics para agrónomos | J6 | Insights de alto valor |
| Enjambre Data API para B2B | J7 | Revenue stream Data & B2B (7%) |
| Product-as-a-Service (rental flow) | — | Vertical #2 |
| Urban-Farming-as-a-Service (food subscription) | — | Vertical #3 |
| Gemelos digitales (recipe simulation) | — | I+D acceleration |

---

## Matriz Journey × Persona

> Cada celda: **C** = journey completo, **P** = parcial, **G** = gap total, **—** = no aplica

| Journey | María | Carlos | Rosa | Diego | Valentina | Roberto | Lucía | Andrés | B2G | AgriData |
|---------|-------|--------|------|-------|-----------|---------|-------|--------|-----|----------|
| J1 Compra/Onboarding | **G** | **G** | **G** | **G** | **G** | **G** | — | **G** | — | — |
| J2 Monitoreo Diario | **G** | **G** | **G** | **G** | **G** | **G** | **P** | **G** | — | — |
| J3 Alerta Crítica | **P** | **P** | **P** | **P** | **P** | **P** | **P** | **P** | — | — |
| J4 Marketplace/Caja | **G** | **G** | **G** | **G** | **G** | **G** | — | **G** | — | — |
| J5 ROI/Fleet | — | — | — | **G** | **G** | **G** | **G** | — | — | — |
| J6 Agrónoma Fleet | — | — | — | — | — | — | **G** | — | — | — |
| J7 Enterprise | — | — | — | — | — | **P** | — | — | — | — |
| J8 Referral/Sharing | **G** | **G** | — | — | — | — | — | **G** | — | — |

**Leyenda**: De 80 celdas relevantes, **0 están completas**, ~8 parciales, ~35 gaps, ~37 no aplican.

---

## Dependencias entre Journeys

```
J1 (Compra/Onboarding)
 ├── REQUIERE: billing, onboarding wizard, Flutter dashboard
 ├── DESBLOQUEA: J2, J3, J4, J8
 │
 ├── J2 (Monitoreo Diario)
 │    ├── REQUIERE: Flutter screens, dashboard API connection
 │    └── DESBLOQUEA: retención, engagement
 │
 ├── J3 (Alerta Crítica)
 │    ├── REQUIERE: FCM push, alert detail screen
 │    └── DESBLOQUEA: trust, conversion free→paid
 │
 ├── J4 (Marketplace)
 │    ├── REQUIERE: marketplace UI, billing (reutiliza J1)
 │    └── DESBLOQUEA: 36% MRR
 │
 └── J8 (Referral)
      ├── REQUIERE: share flow, referral backend
      └── DESBLOQUEA: growth engine (40% de sales)

J5 (ROI/Fleet) ← REQUIERE: J2 funcional + fleet view + reports
J6 (Agrónoma)  ← REQUIERE: J5 + cross-user permissions
J7 (Enterprise) ← REQUIERE: J5 + API keys + bulk provisioning
```

**Camino crítico**: J1 → J2 → J3 → J4 → J8 → J5 → J6/J7
