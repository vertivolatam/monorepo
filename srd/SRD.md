# SRD — Synthetic Reality Development Framework

## Vertivo Horticultura Urbana Vertical S.R.L.

> Framework completo de estrategia de producto derivado del análisis backwards-from-success.
> Cada sección referencia archivos detallados en `srd/`.

---

## Quick Reference

| Dato | Valor |
|------|-------|
| **Producto** | Micro-invernaderos autónomos aeropónicos urbanos con robot agrónomo embebido |
| **Target** | [MRR target] MRR a 18 meses |
| **Geo** | CR → PA → CO → MX → BR |
| **Monorepo** | `0.1.0` → `v0.2.0` (T0) → `v0.3.0` (T1) → `v0.4.0` (T2) → `v1.0.0` (T3) |
| **Linear** | [Vertivo → [MRR target]](https://linear.app/vertivolatam/project/vertivo-dollar500k-mrr-9b6ce5d7223c) · VRTV-5 to VRTV-32 |
| **Prioridad #1** | Billing (latam_payments) — VRTV-5 |
| **Prioridad #2** | Flutter app MVP (5 core screens) — VRTV-6 |

---

## Section 1 — Success Reality

**Archivo**: [`srd/success-reality.md`](success-reality.md)

A 18 meses, Vertivo cruza [MRR target] MRR con [volumen redactado] devices vendidos y [volumen redactado] MAU.

### Revenue Mix

| Stream | MRR | % |
|--------|-----|---|
| SaaS Monitoring ([ver pricing]) | [monto redactado] | 43% |
| Marketplace Insumos (Caja + on-demand) | [monto redactado] | 36% |
| Hardware ([precio redactado]-[precio redactado]) | [monto redactado] | 14% |
| Data & B2B | [monto redactado] | 7% |
| **Total** | **[MRR target]** | **100%** |

### Unit Economics

| Métrica | Valor |
|---------|-------|
| CAC (blended) | $250 |
| LTV (24mo) | $5,200 |
| LTV:CAC | REDACTED |
| Payback | 1.8 meses |
| Gross margin (blended) | 64% |
| SaaS churn (mensual) | 2.2% |

### Milestones

| Mes | MRR | Devices | Evento |
|-----|-----|---------|--------|
| 0-3 | [redactado] | 120 | Billing + app MVP, CR soft launch |
| 3-6 | [redactado] | 450 | Marketplace + Caja, PA launch |
| 6-9 | [redactado] | 1,000 | Commercial tier + API, CO launch |
| 9-12 | [redactado] | 1,700 | Data API beta, MX launch |
| 12-15 | [monto redactado] | [redactado] | Industrial tier, referral at scale |
| 15-18 | [MRR target] | [redactado] | **[MRR target] crossed** |

---

## Section 2 — Buyer Personas & Business Model Canvas

**Archivo**: [`srd/business-model-canvas.md`](business-model-canvas.md)

### 10 Personas

| # | Persona | Segmento | Plan | user% | rev% |
|---|---------|----------|------|-------|------|
| 1 | **María** — Mamá Urbana Consciente | Residential B2C | Basic $29 | 22% | 12% |
| 2 | **Carlos** — Techie Entusiasta | Residential B2C | Pro $59 | 15% | 10% |
| 3 | **Rosa** — Abuela Jardinera | Residential B2C | Basic $29 | 8% | 4% |
| 4 | **Diego** — Restaurante Farm-to-Table | Commercial B2B | Commercial $199 | 12% | 20% |
| 5 | **Valentina** — Emprendedora Bienestar | Commercial B2B | Commercial $199 | 8% | 12% |
| 6 | **Roberto** — Director Ops Agroindustrial | Industrial B2B | Industrial $499 | 4% | 22% |
| 7 | **Lucía** — Agrónoma Consultora | Expert | Commercial $199 | 3% | 4% |
| 8 | **Andrés** — Influencer de Barrio | Residential B2C | Pro $59 | 10% | 6% |
| 9 | **Directora Comedor Escolar** | B2G | UFaaS/PaaS | 3% | 3% |
| 10 | **AgriData Corp** | Ecosystem | Custom $2,500+ | 1% | 5% |

Cada persona tiene: Demografía, Comportamientos, Necesidades, Objetivos + matrices de Priorización, Severidad, y Relevancia.

### 3 Verticales

| Vertical | Modelo | Target |
|----------|--------|--------|
| **Farm Automation** | Venta hardware + SaaS + Insumos | Medio-alto poder adquisitivo |
| **Product-as-a-Service** | Alquiler hardware + SaaS + Insumos | Medio poder adquisitivo |
| **Urban-Farming-as-a-Service** | Suscripción de alimentos | Bajo poder adquisitivo, sin espacio |

### Propuesta de Valor

**"Una Huerta Pensada para Vos"** — Tu robot agrónomo personal: cultiva tus alimentos en casa sin saber nada de agronomía, sin luz solar, sin plagas, y con insumos en tu puerta cada mes.

**Top 3 Problemas**:
1. No pueden verificar que sus alimentos sean libres de pesticidas
2. Auto-cultivar en zonas urbanas es imposible sin automatización
3. Las cadenas de suministro de alimentos frescos son frágiles y caras

---

## Section 3 — Critical Journeys

**Archivo**: [`srd/journeys.md`](journeys.md)

### 8 Journeys mapeados pantalla por pantalla

| Journey | Personas | Revenue at risk | Estado |
|---------|----------|-----------------|--------|
| **J1** Compra/Onboarding | Todos | 100% | Gap total |
| **J2** Monitoreo Diario | Todos B2C | Retención SaaS | Gap total |
| **J3** Alerta Crítica Robot | María, Carlos | 24% conversiones | Parcial |
| **J4** Marketplace/Caja | María, Rosa, Diego | 36% MRR | Gap total |
| **J5** ROI/Fleet Commercial | Diego, Roberto | 54% revenue | Gap total |
| **J6** Agrónoma Fleet | Lucía | Multiplicador | Gap total |
| **J7** Enterprise | Roberto | 22% revenue | Parcial |
| **J8** Referral/Sharing | Andrés, María | 40% device sales | Gap total |

### Camino Crítico

```
J1 → J2 → J3 → J4 → J8 → J5 → J6/J7
```

### Estado del Codebase

| Componente | Funcional | Gap |
|------------|-----------|-----|
| **Serverpod backend** | 13 endpoints, 30 models, MQTT ingestion | Billing, marketplace, notifications send, referral |
| **Flutter app** | 2 screens (auth + test), M3 theme | Todas las screens de feature, GoRouter, Riverpod, FCM |
| **Jaspr dashboard** | 6 pages, D3.js charts | 100% hardcoded, 0% API connection |
| **Raspberry Pi** | 8 sensors, 4 orchestrators, MQTT publish | 0 actuators, 0 robot decision engine |

De 80 celdas persona×journey, **0 completas**, ~8 parciales, ~35 gaps.

---

## Section 4 — Gap Audit Matrix

**Archivo**: [`srd/gap-audit.md`](gap-audit.md)

### Fix List por Tier

| Tier | Semver | Issues | Points | Deadline | Revenue at risk |
|------|--------|--------|--------|----------|-----------------|
| **T0** | v0.2.0 | VRTV-5 to 8 | 29 | Jun 2026 | [revenue at risk] |
| **T1** | v0.3.0 | VRTV-9 to 17 | 39 | Ago 2026 | 68% ($340K) |
| **T2** | v0.4.0 | VRTV-18 to 25 | 40 | Nov 2026 | 19% ($95K) |
| **T3** | v1.0.0 | VRTV-26 to 32 | 81 | Dic 2026+ | Post [MRR target] |

### T0 — Bloqueantes (sin esto, revenue = $0)

| Fix | Issue | Cycle | Est. |
|-----|-------|-------|------|
| Integrar latam_payments (billing + checkout) | VRTV-5 | 1 | 8 pts |
| Flutter: GoRouter + 5 core screens | VRTV-6 | 2 | 8 pts |
| Flutter: onboarding wizard (device pairing) | VRTV-7 | 1 | 5 pts |
| Marketplace MVP (Caja Vertivo, checkout) | VRTV-8 | 3 | 8 pts |

### T1 — Críticos (funciona pero no escala)

| Fix | Issue | Cycle | Est. |
|-----|-------|-------|------|
| FCM push notifications | VRTV-9 | 4 | 5 pts |
| Email sending real (SendGrid/SES) | VRTV-10 | 4 | 3 pts |
| Landing page + web checkout | VRTV-11 | 4 | 5 pts |
| Referral system | VRTV-12 | 4 | 5 pts |
| Dashboard → API real | VRTV-13 | 5 | 5 pts |
| API key management + docs | VRTV-14 | 5 | 3 pts |
| Multi-user/roles | VRTV-15 | 5 | 5 pts |
| Order management backend | VRTV-16 | 5 | 5 pts |
| Flutter fleet management screens | VRTV-17 | 5 | 3 pts |

### T2 — Importantes (funciona pero no deleita)

| Fix | Issue | Cycle | Est. |
|-----|-------|-------|------|
| Robot agrónomo automation (actuadores) | VRTV-18 | 6 | 13 pts |
| Share/camera harvest moment | VRTV-19 | 6 | 3 pts |
| Robot-calculated Caja recommendations | VRTV-20 | 6 | 5 pts |
| ROI report PDF generation | VRTV-21 | 7 | 3 pts |
| Compliance report UI (COFEPRIS/SENASA) | VRTV-22 | 7 | 3 pts |
| Cross-user fleet view (agrónomo) | VRTV-23 | 7 | 5 pts |
| Expert Mode (robot sugiere, agrónomo aprueba) | VRTV-24 | 7 | 5 pts |
| Real-time WebSocket/SSE | VRTV-25 | 6 | 3 pts |

### T3 — Futuro (post [MRR target])

| Fix | Issue | Cycle | Est. |
|-----|-------|-------|------|
| Cross-client analytics | VRTV-26 | 8 | 8 pts |
| Enjambre Data API | VRTV-27 | 8 | 13 pts |
| Product-as-a-Service (alquiler) | VRTV-28 | 8 | 13 pts |
| Urban-Farming-as-a-Service | VRTV-29 | 8 | 21 pts |
| Gemelos digitales | VRTV-30 | 8 | 13 pts |
| B2G procurement flow | VRTV-31 | 8 | 8 pts |
| Bulk device provisioning | VRTV-32 | 8 | 5 pts |

### Anti-Patterns Detectados

| Anti-pattern | Severidad |
|-------------|-----------|
| Backend-ahead syndrome (13 endpoints, 0 screens) | Alta |
| Dashboard theater (6 pages hardcoded) | Alta |
| Sensor-rich, action-poor (8 sensors, 0 actuators) | Media |
| Notification model sin delivery (7 channels, 0 send) | Alta |
| Auth without identity (login pero no profile) | Media |
| Marketplace = 0 (36% MRR sin backend ni frontend) | Crítica |

---

## Section 5 — Claude Directive

**Archivo**: [`srd/claude-directive.yml`](claude-directive.yml)

### Priority Rules (resumen)

1. **billing_first** — Sin cobrar, revenue = $0
2. **flutter_screens_before_new_endpoints** — Conectar lo existente antes de crear más backend
3. **push_before_features** — 32% + 24% + 18% de conversiones dependen de push
4. **marketplace_is_36_percent** — Segundo stream más grande, debe ser T0
5. **never_ship_dashboard_without_real_data** — No "dashboard theater"
6. **referral_before_paid_acquisition** — Growth orgánico primero

### Guardrails

1. **no_new_endpoints_without_flutter_screen** — Cada endpoint necesita UI
2. **no_hardcoded_data_in_dashboard** — D3.js con datos reales
3. **rosa_test** — Si Rosa no puede usarlo, revisar UX
4. **latam_payments_only** — No Stripe/PayPal como primario
5. **aeroponic_not_hydroponic** — Nebuponía, nunca "hidropónico"
6. **semver_gate** — No mergear T1 hasta que T0 esté Done
7. **linear_taxonomy** — Type + Size labels obligatorios (AGENTS.md)

### Acceptance Criteria (quick)

| Milestone | Test Persona | Key Criteria |
|-----------|-------------|-------------|
| v0.2.0 | María | Puede comprar, configurar, monitorear, y reordenar sin ayuda |
| v0.3.0 | Diego | Puede gestionar 5 invernaderos, ver ROI, invitar a su chef |
| v0.4.0 | Lucía | Puede monitorear 20 clientes y aprobar acciones del robot remotamente |
| v1.0.0 | Roberto | Puede hacer rollout a 15 locations y exportar datos a SAP |

---

## File Index

| Archivo | Contenido |
|---------|-----------|
| `srd/success-reality.md` | KPIs, revenue breakdown, geo, milestones a [MRR target] |
| `srd/business-model-canvas.md` | 13 secciones BMC + 10 buyer personas con matrices |
| `srd/journeys.md` | 8 critical journeys pantalla por pantalla vs. codebase real |
| `srd/gap-audit.md` | Matriz persona×journey, heat map, fix list T0-T3, anti-patterns |
| `srd/claude-directive.yml` | Reglas machine-readable: prioridades, guardrails, acceptance criteria |
| `srd/SRD.md` | Este archivo — resumen ejecutivo combinado |

---

## How to Use This SRD

### Para desarrolladores
1. Antes de empezar un feature, consultar `claude-directive.yml` → `priority_rules`
2. Verificar que el feature está en el tier correcto (no saltar tiers)
3. Revisar `anti_patterns` — no caer en los 6 patrones detectados
4. Usar `codebase_map` para saber dónde hacer cambios
5. Validar contra `acceptance_criteria` del milestone correspondiente

### Para product owners
1. Usar la matriz persona×journey de `gap-audit.md` para priorizar
2. Revenue at risk por tier guía decisiones de scope
3. Los milestones del Success Reality son checkpoints de validación

### Para Claude / AI agents
1. Cargar `srd/claude-directive.yml` como contexto
2. Seguir `priority_rules` al sugerir o implementar features
3. Rechazar trabajo que viole `guardrails`
4. Validar PRs contra `acceptance_criteria` del milestone actual
5. Usar `persona_routing` para decidir si un feature es relevante ahora
