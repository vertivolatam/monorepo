# Section 4 — Gap Audit Matrix

> Cross-reference de cada persona × cada journey. Identifica el revenue en riesgo,
> el estado real del codebase, y produce una lista de fixes priorizada por tiers (T0–T3).

---

## 4.1 Matriz Persona × Journey (detalle)

### María (#1) — Mamá Urbana Consciente

| Journey | Estado | Blocker principal | Revenue at risk (mensual) | Fix tier |
|---------|--------|-------------------|---------------------------|----------|
| J1 Compra/Onboarding | **GAP** | No hay checkout ni billing | [precio redactado] hardware + [ver pricing] (SaaS+Caja) | T0 |
| J2 Monitoreo Diario | **GAP** | No hay Flutter dashboard screens | Churn → pierde [ver pricing] recurrente | T0 |
| J3 Alerta Crítica | **PARCIAL** | Backend detecta, pero no llega push a su iPhone | Pierde trust → no upgrade → -$30/mo potencial | T1 |
| J4 Marketplace/Caja | **GAP** | No existe marketplace ni suscripción Caja | $25/mo Caja + ~$15/mo on-demand | T0 |
| J8 Referral | **GAP** | No existe share flow ni referral system | ~1 referral cada 6 meses = $750 hardware lost | T1 |

**María total at risk**: [ver pricing] recurrente + [precio redactado] one-time + referral pipeline
**María % de la base**: 22% de usuarios, 12% del revenue

---

### Carlos (#2) — Techie Entusiasta

| Journey | Estado | Blocker principal | Revenue at risk (mensual) | Fix tier |
|---------|--------|-------------------|---------------------------|----------|
| J1 Compra/Onboarding | **GAP** | No hay checkout | [precio redactado] + [ver pricing] | T0 |
| J2 Monitoreo Diario | **GAP** | No hay Flutter screens | Churn — Carlos es tolerante si hay API | T0 |
| J3 Alerta Crítica | **PARCIAL** | Push no llega, pero Carlos checkearía la API | Menor riesgo — workaround técnico | T1 |
| J4 Marketplace | **GAP** | No existe | $35/mo on-demand | T0 |
| J8 Referral | **GAP** | No existe | Alto potencial — Carlos tiene comunidad tech | T1 |

**Nota**: Carlos es el más tolerante a UX incompleta si tiene API access. Podría ser early adopter con API-only + dashboard hardcoded como beta.

---

### Rosa (#3) — Abuela Jardinera

| Journey | Estado | Blocker principal | Revenue at risk (mensual) | Fix tier |
|---------|--------|-------------------|---------------------------|----------|
| J1 Compra/Onboarding | **GAP** | No hay onboarding simplificado (letras grandes, asistido) | [precio redactado] (su hijo paga) + [ver pricing] | T0 |
| J2 Monitoreo Diario | **GAP** | No hay pantallas — Rosa no puede ver sus plantas | Churn inmediato — se desconecta | T0 |
| J3 Alerta Crítica | **PARCIAL** | Sin push, Rosa no se entera que el pH bajó | Plantas mueren → ella abandona | T1 |
| J4 Marketplace/Caja | **GAP** | No puede reordenar semillas ni nutritivas | $20/mo Caja | T0 |

**Riesgo especial**: Rosa es la persona con menor tolerancia a fricción técnica. Si el onboarding no es guiado y la app no es accesible, churn es 100%.

---

### Diego (#4) — Restaurante Farm-to-Table

| Journey | Estado | Blocker principal | Revenue at risk (mensual) | Fix tier |
|---------|--------|-------------------|---------------------------|----------|
| J1 Compra/Onboarding | **GAP** | No hay checkout B2B ni onboarding multi-módulo | [precio redactado] + [ver pricing] (SaaS+Caja) | T0 |
| J2 Monitoreo Diario | **GAP** | No hay Flutter fleet view | Churn → pierde [ver pricing] | T0 |
| J3 Alerta Crítica | **PARCIAL** | Backend funciona, push no | Pérdida de cosecha = $200+ en hierbas desperdiciadas | T1 |
| J4 Marketplace/Caja | **GAP** | No existe Caja Comercial ($120/mo) | $120/mo Caja | T0 |
| J5 ROI/Fleet | **GAP** | No hay reportes de ROI ni API para POS | No puede justificar inversión → no renueva | T1 |

**Diego total at risk**: [ver pricing] recurrente + [precio redactado] one-time
**Diego % de la base**: 12% usuarios, 20% del revenue

---

### Valentina (#5) — Emprendedora Bienestar

| Journey | Estado | Blocker principal | Revenue at risk (mensual) | Fix tier |
|---------|--------|-------------------|---------------------------|----------|
| J1 Compra/Onboarding | **GAP** | Igual que Diego | [precio redactado] + [ver pricing] | T0 |
| J2 Monitoreo Diario | **GAP** | Sin app, no puede monitorear | Churn | T0 |
| J3 Alerta Crítica | **PARCIAL** | Push no llega | Riesgo de pérdida de plantas | T1 |
| J4 Marketplace | **GAP** | No existe | $95/mo mixto | T0 |
| J5 ROI/Fleet | **GAP** | No hay reportes | No puede medir ahorro vs. proveedor | T1 |

**Nota especial**: Valentina necesita que el invernadero sea "Instagrammable". El hardware + app deben tener estética premium. La app actual no tiene ni pantalla de monitoreo.

---

### Roberto (#6) — Director Ops Agroindustrial

| Journey | Estado | Blocker principal | Revenue at risk (mensual) | Fix tier |
|---------|--------|-------------------|---------------------------|----------|
| J1 Compra/Onboarding | **GAP** | No hay enterprise onboarding ni bulk provisioning | [precio redactado] hardware + $979/mo | T0 |
| J2 Monitoreo Diario | **GAP** | Dashboard hardcoded — no puede ver datos reales | No firma contrato sin POC real | T0 |
| J5 ROI/Fleet | **GAP** | No hay fleet mgmt, API keys, ni reportes | No presenta al board sin ROI report | T1 |
| J7 Enterprise | **PARCIAL** | Demo con dashboard hardcoded funciona, POC real no | Pierde deal de [monto redactado]+ si POC falla | T1 |

**Roberto total at risk**: $979/mo recurrente + [precio redactado] one-time
**Roberto % de la base**: 4% usuarios, 22% del revenue — el segmento de mayor LTV

---

### Lucía (#7) — Agrónoma Consultora

| Journey | Estado | Blocker principal | Revenue at risk (mensual) | Fix tier |
|---------|--------|-------------------|---------------------------|----------|
| J2 Monitoreo Diario | **PARCIAL** | Dashboard existe pero hardcoded | No puede monitorear remotamente | T1 |
| J5 ROI/Fleet | **GAP** | No hay cross-user fleet view | No puede escalar a 25 clientes | T2 |
| J6 Agrónoma Fleet | **GAP** | No existe Expert Mode ni messaging | Sin propuesta de valor diferenciada | T2 |

**Nota**: Lucía no genera revenue directo alto, pero cada cliente que ella trae compra hardware ([precio redactado]) + SaaS. Es un **canal de adquisición**, no solo una usuaria. Su fleet view puede esperar a T2 porque ella puede funcionar con el dashboard básico + visitas presenciales al inicio.

---

### Andrés (#8) — Influencer de Barrio

| Journey | Estado | Blocker principal | Revenue at risk (mensual) | Fix tier |
|---------|--------|-------------------|---------------------------|----------|
| J1 Compra/Onboarding | **GAP** | No hay checkout | [precio redactado] + [ver pricing] | T0 |
| J2 Monitoreo Diario | **GAP** | Sin app | Churn | T0 |
| J4 Marketplace | **GAP** | No existe | $45/mo | T0 |
| J8 Referral | **GAP** | No existe referral program ni share flow | Pierde el 100% de su valor como canal — sin referral, Andrés es solo otro usuario Pro | T1 |

**Riesgo especial**: Sin referral system, Andrés no tiene incentivo para promocionar Vertivo. Su valor como multiplicador de growth cae a cero. Referral program es T1 porque sin J1 no hay nada que referir.

---

### Directora Comedor Escolar (#9) — B2G

| Journey | Estado | Blocker principal | Revenue at risk (mensual) | Fix tier |
|---------|--------|-------------------|---------------------------|----------|
| J1 Compra/Onboarding | **GAP** | No existe UFaaS/PaaS flow | Variable — contrato público | T3 |
| J7 Enterprise (adaptado) | **GAP** | No hay procurement público, compliance SENASA | — | T3 |

**Nota**: B2G es fase 2-3. La directora no es target para los primeros 18 meses excepto como piloto municipal. No bloquea el camino a [MRR target].

---

### AgriData Corp (#10) — Comprador de Datos

| Journey | Estado | Blocker principal | Revenue at risk (mensual) | Fix tier |
|---------|--------|-------------------|---------------------------|----------|
| J7 Enterprise | **GAP** | No existe Data API pública | $2,500+/mo por contrato | T3 |

**Nota**: Data API requiere masa crítica (50+ devices por metro area). No es viable hasta ~mes 9-12. Depende de que J1 funcione y se vendan devices.

---

## 4.2 Heat Map — Revenue at Risk por Persona × Journey

```
           J1      J2      J3      J4      J5      J6      J7      J8
           Compra  Monitor Alerta  Market  ROI     Agro    Enterp  Refer
           ─────── ─────── ─────── ─────── ─────── ─────── ─────── ───────
María      ██████  ████    ██      ████    ·       ·       ·       ██
Carlos     ██████  ████    █       ███     ·       ·       ·       ██
Rosa       █████   ████    ██      ██      ·       ·       ·       ·
Diego      ███████ █████   ███     █████   ████    ·       ·       ·
Valentina  ███████ █████   ███     ████    ████    ·       ·       ·
Roberto    █████████████   ███     ·       ██████  ·       █████   ·
Lucía      ·       ██      ·       ·       ███     ████    ·       ·
Andrés     ██████  ████    █       ███     ·       ·       ·       █████
B2G        ·       ·       ·       ·       ·       ·       █       ·
AgriData   ·       ·       ·       ·       ·       ·       ██      ·

Leyenda: █ = ~$25K MRR at risk   · = no aplica o mínimo
```

---

## 4.3 Fix List Priorizada

### T0 — Bloqueantes ([MRR target] MRR at risk → 100%)

> Sin estos, no existe producto vendible. Revenue = $0.

| # | Fix | Codebase target | Journeys | Personas | Esfuerzo est. |
|---|-----|-----------------|----------|----------|---------------|
| T0.1 | **Integrar latam_payments** — checkout, cobro SaaS recurrente, cobro Caja | `apps/backend/` nuevo endpoint `billing.*` + `apps/vertivo_flutter/` payment screens | J1, J4 | Todos | 3-4 semanas |
| T0.2 | **Flutter: GoRouter + 5 core screens** — home dashboard, greenhouse list, greenhouse detail (8 gauges), alert list, profile | `apps/vertivo_flutter/lib/screens/` + `lib/router.dart` + Riverpod providers | J1, J2 | Todos | 3-4 semanas |
| T0.3 | **Flutter: onboarding wizard** — crear cuenta, parear device (QR/BLE), elegir primer cultivo, confirmar setup | `apps/vertivo_flutter/lib/screens/onboarding/` | J1 | Todos | 1-2 semanas |
| T0.4 | **Marketplace MVP** — catálogo de Caja Vertivo (3 tiers), suscripción, checkout reutilizando T0.1 | `apps/backend/` endpoints `marketplace.*`, `order.*` + Flutter screens | J4 | María, Rosa, Diego | 2-3 semanas |

**Tiempo total T0**: ~10-13 semanas (2.5-3 meses) — alineado con OKR corto plazo (3mo)

---

### T1 — Críticos ($340K MRR at risk → 68%)

> Sin estos, el producto funciona pero no escala. Churn alto, conversion baja, growth orgánico nulo.

| # | Fix | Codebase target | Journeys | Personas | Esfuerzo est. |
|---|-----|-----------------|----------|----------|---------------|
| T1.1 | **FCM push notifications** — Firebase integration, foreground/background handlers, notification templates | `apps/vertivo_flutter/` FCM setup + `apps/backend/` notification service que envía via FCM SDK | J1, J2, J3, J4, J8 | Todos | 1-2 semanas |
| T1.2 | **Email sending real** — reemplazar console.log por servicio de email (SendGrid/SES) para verificación, receipts, password reset | `apps/backend/lib/src/auth/email_idp_endpoint.dart` | J1 | Todos | 1 semana |
| T1.3 | **Landing page + web checkout** — vertivo.com con hero, pricing, video, CTA → checkout flow | Nuevo repo o `apps/landing/` | J1 | Todos nuevos | 2-3 semanas |
| T1.4 | **Referral system** — generar links, tracking, créditos, dashboard de referrer | `apps/backend/` endpoints `referral.*` + Flutter screens | J8 | Andrés, María | 2 semanas |
| T1.5 | **Dashboard → API real** — conectar Jaspr a Serverpod endpoints (eliminar hardcoded) | `apps/dashboard/lib/pages/*.dart` → HTTP client a backend | J2, J5, J7 | Lucía, Roberto, equipo | 2-3 semanas |
| T1.6 | **API key management + docs** — crear/revocar API tokens, documentación OpenAPI | `apps/backend/lib/src/auth/` + API docs gen | J5, J7 | Diego, Roberto | 1-2 semanas |
| T1.7 | **Multi-user/roles** — owner, admin, viewer por greenhouse/org | `apps/backend/` user roles + permission checks | J5 | Diego, Roberto | 1-2 semanas |
| T1.8 | **Order management backend** — orders, inventory, fulfillment status, shipping tracking | `apps/backend/` endpoints `order.*` | J4 | Todos marketplace | 2 semanas |
| T1.9 | **Flutter: fleet management screens** — lista multi-greenhouse, status cards, KPIs comparativos | `apps/vertivo_flutter/lib/screens/fleet/` | J5 | Diego, Valentina, Roberto | 1-2 semanas |

**Tiempo total T1**: ~14-20 semanas (~4-5 meses post-T0)

---

### T2 — Importantes ($95K MRR at risk → 19%)

> Optimizan la experiencia y diferencian de competidores. Sin estos el producto funciona pero no deleita.

| # | Fix | Codebase target | Journeys | Personas | Esfuerzo est. |
|---|-----|-----------------|----------|----------|---------------|
| T2.1 | **Robot agrónomo automation** — PID controllers para bomba peristáltica (pH Up/Down), dosificación de nutrientes, control de LEDs (foto-período) | `apps/raspberry/src/actuators/` + `src/controllers/` | J3 | Todos | 4-6 semanas |
| T2.2 | **Share/camera harvest moment** — generar harvest card con foto, datos, branding, deep link | `apps/vertivo_flutter/` camera + share | J1, J8 | Andrés, María | 1-2 semanas |
| T2.3 | **Robot-calculated Caja recommendations** — analizar consumo de nutrientes + plantas activas → sugerir Caja óptima | `apps/raspberry/` + `apps/backend/` recommendation engine | J4 | María, Rosa | 2-3 semanas |
| T2.4 | **ROI report PDF generation** — calcular ahorro vs. proveedor, yield/m², generar PDF descargable | `apps/backend/lib/src/management/` export | J5 | Diego, Roberto | 1-2 semanas |
| T2.5 | **Compliance report UI** — visualizar cadena de trazabilidad, exportar para COFEPRIS/SENASA | `apps/vertivo_flutter/` + dashboard compliance view | J5, J7 | Roberto, B2G | 1-2 semanas |
| T2.6 | **Cross-user fleet view** (agrónomo) — Lucía ve invernaderos de sus clientes con permisos delegados | `apps/backend/` permission delegation + dashboard view | J6 | Lucía | 2-3 semanas |
| T2.7 | **Expert Mode** — robot sugiere, agrónomo aprueba/modifica antes de ejecutar | `apps/raspberry/` + backend approval queue | J6 | Lucía | 2-3 semanas |
| T2.8 | **Real-time WebSocket/SSE** — datos de sensores en vivo sin pull-to-refresh | `apps/backend/` WebSocket endpoint + Flutter listener | J2 | Carlos | 1-2 semanas |

**Tiempo total T2**: ~15-23 semanas (~4-6 meses, paralelo a T1)

---

### T3 — Futuro (post [MRR target])

| # | Fix | Journeys | Esfuerzo est. |
|---|-----|----------|---------------|
| T3.1 | Cross-client analytics para agrónomos | J6 | 3-4 semanas |
| T3.2 | Enjambre Data API pública + docs + SLA | J7 | 4-6 semanas |
| T3.3 | Product-as-a-Service (rental billing, device recovery) | — | 6-8 semanas |
| T3.4 | Urban-Farming-as-a-Service (food subscription, delivery logistics) | — | 8-12 semanas |
| T3.5 | Gemelos digitales (recipe simulation UI) | — | 6-8 semanas |
| T3.6 | B2G procurement flow (licitaciones, compliance SENASA/MEP) | J7 | 4-6 semanas |
| T3.7 | Bulk device provisioning para enterprise | J7 | 2-3 semanas |

---

## 4.4 Roadmap de Implementación vs. Milestones del Success Reality

| Milestone | Mes | MRR target | Devices | Requires (from fix list) |
|-----------|-----|------------|---------|--------------------------|
| **Billing + App MVP ship** | 0-3 | $0 → $12K | 0 → 120 | T0.1 + T0.2 + T0.3 + T1.1 + T1.2 |
| **Marketplace + Caja live, Panamá launch** | 3-6 | $12K → $45K | 120 → 450 | T0.4 + T1.3 + T1.4 + T1.8 |
| **Commercial tier + API, Colombia launch** | 6-9 | $45K → $110K | 450 → 1,000 | T1.5 + T1.6 + T1.7 + T1.9 |
| **Data API beta, México launch** | 9-12 | $110K → $230K | 1,000 → 1,700 | T2.1 + T2.3 + T2.4 + T2.8 |
| **Industrial tier, referral at scale** | 12-15 | $230K → [monto redactado] | 1,700 → [redactado] | T2.5 + T2.6 + T2.7 |
| **[MRR target] crossed** | 15-18 | [monto redactado] → [MRR target] | 2,300 → [redactado] | T3.1 + T3.2 |

---

## 4.5 Verificación de Consistencia

### Revenue math check

| Segment | Users at [MRR target] | Avg revenue/user/mo (REDACTED) | Segment MRR | % |
|---------|---------------|---------------------|-------------|---|
| María × 616 users (22%) | 616 | $54 (Basic+Caja) | $33,264 | ~7% |
| Carlos × 420 (15%) | 420 | $94 (Pro+on-demand) | $39,480 | ~8% |
| Rosa × 224 (8%) | 224 | $49 (Basic+Caja) | $10,976 | ~2% |
| Diego × 336 (12%) | 336 | $319 (Comm+Caja) | $107,184 | ~21% |
| Valentina × 224 (8%) | 224 | $294 (Comm+mix) | $65,856 | ~13% |
| Roberto × 112 (4%) | 112 | $979 (Ind+Caja) | $109,648 | ~22% |
| Lucía × 84 (3%) | 84 | $199 (Comm) | $16,716 | ~3% |
| Andrés × 280 (10%) | 280 | $104 (Pro+Caja) | $29,120 | ~6% |
| B2G × 84 (3%) | 84 | $179 (UFaaS est.) | $15,036 | ~3% |
| AgriData × 28 (1%) | 28 | $2,500 (Data) | $70,000 | ~14% |
| Inactivos × 308 (11%) | 308 | $10 (partial) | $3,080 | ~1% |
| **Total** | **2,800** | | **$500,360** | **~100%** |

Revenue sum: **[MRR target]** — alineado con target de [MRR target] MRR.

### User% check
22+15+8+12+8+4+3+10+3+1+11 = **97%** (3% rounding, aceptable)

### Journey coverage check
- J1 (Compra): cubre 100% de users que generan revenue → **correct, is T0**
- J4 (Marketplace): cubre ~36% MRR ([monto redactado]) → **correct, is T0**
- J3 (Alerta): backend funciona para 100% de devices, push falta → **correct, is T1**
- J5 (ROI/Fleet): cubre 56% del revenue (Diego+Valentina+Roberto) → **correct, is T1**

---

## 4.6 Anti-Patterns Detectados

| Anti-pattern | Evidencia | Riesgo | Mitigación |
|--------------|-----------|--------|------------|
| **Backend-ahead syndrome** | 13 endpoints funcionales, 0 pantallas en Flutter los consumen | Falsa sensación de progreso — el usuario no puede interactuar con nada | T0.2: priorizar Flutter screens que conecten con endpoints existentes |
| **Dashboard theater** | 6 páginas Jaspr con datos hardcoded, D3.js funcionando con datos ficticios | Se puede hacer demo, pero no POC real — Roberto descubriría la farsa | T1.5: conectar dashboard a API antes de hacer POCs enterprise |
| **Sensor-rich, action-poor** | 8 sensores leen, 0 actuadores controlan | El "robot agrónomo" es realmente un "monitor agrónomo" — no toma acciones | T2.1: implementar control de actuadores (bomba, LEDs, dosificación) |
| **Auth without identity** | Login funciona, pero no hay perfil, preferencias, ni suscripción visible | El usuario se logea pero no sabe quién es ni qué plan tiene | T0.2: incluir profile screen en core 5 |
| **Notification model sin delivery** | `NotificationDelivery` tabla con 7 canales, pero ningún canal realmente envía | Las alertas se crean en DB pero nunca llegan al usuario | T1.1: FCM es el canal mínimo viable |
| **Marketplace = 0** | No hay ni un endpoint de orders/catalog/cart | 36% del MRR target no tiene ni backend ni frontend | T0.4: marketplace MVP |
