---
title: Roadmap
description: Roadmap T0-T3 con semver, Linear cycles y milestones de revenue.
---

# Roadmap

## Tiers y Semver

| Tier | Semver | Issues | Puntos | Deadline | Revenue at risk | Foco |
|------|--------|--------|--------|----------|-----------------|------|
| **T0** | v0.2.0 | VRTV-5 a 8 | 29 | Jun 2026 | [revenue at risk] | Billing + App MVP + Marketplace |
| **T1** | v0.3.0 | VRTV-9 a 17 | 39 | Ago 2026 | 68% ($340K) | Push, referral, dashboard real, fleet |
| **T2** | v0.4.0 | VRTV-18 a 25 | 40 | Nov 2026 | 19% ($95K) | Robot automation, harvest sharing, compliance |
| **T3** | v1.0.0 | VRTV-26 a 32 | 81 | Dic 2026+ | Post [MRR target] | Data API, PaaS, UFaaS, digital twins |

## T0 — Bloqueantes (sin esto, revenue = $0)

| Fix | Issue | Estimacion |
|-----|-------|------------|
| Integrar latam_payments (billing + checkout) | VRTV-5 | 8 pts |
| Flutter: GoRouter + 5 core screens | VRTV-6 | 8 pts |
| Flutter: onboarding wizard (device pairing) | VRTV-7 | 5 pts |
| Marketplace MVP (Caja Vertivo, checkout) | VRTV-8 | 8 pts |

!!! danger "Regla: Billing First"
    Sin billing integrado, revenue = $0. VRTV-5 es la prioridad absoluta. VRTV-8 (marketplace, [porcentaje redactado] del MRR) esta bloqueado por VRTV-5.

## T1 — Criticos (funciona pero no escala)

| Fix | Issue | Estimacion |
|-----|-------|------------|
| FCM push notifications | VRTV-9 | 5 pts |
| Email sending real (SendGrid/SES) | VRTV-10 | 3 pts |
| Landing page + web checkout | VRTV-11 | 5 pts |
| Referral system | VRTV-12 | 5 pts |
| Dashboard → API real | VRTV-13 | 5 pts |
| API key management + docs | VRTV-14 | 3 pts |
| Multi-user/roles | VRTV-15 | 5 pts |
| Order management backend | VRTV-16 | 5 pts |
| Flutter fleet management screens | VRTV-17 | 3 pts |

## T2 — Importantes (funciona pero no deleita)

| Fix | Issue | Estimacion |
|-----|-------|------------|
| Robot agronomo automation (actuadores) | VRTV-18 | 13 pts |
| Share/camera harvest moment | VRTV-19 | 3 pts |
| Robot-calculated Caja recommendations | VRTV-20 | 5 pts |
| ROI report PDF generation | VRTV-21 | 3 pts |
| Compliance report UI (COFEPRIS/SENASA) | VRTV-22 | 3 pts |
| Cross-user fleet view (agronomo) | VRTV-23 | 5 pts |
| Expert Mode (robot sugiere, agronomo aprueba) | VRTV-24 | 5 pts |
| Real-time WebSocket/SSE | VRTV-25 | 3 pts |

## T3 — Futuro (post [MRR target])

| Fix | Issue | Estimacion |
|-----|-------|------------|
| Cross-client analytics | VRTV-26 | 8 pts |
| Enjambre Data API | VRTV-27 | 13 pts |
| Product-as-a-Service (alquiler) | VRTV-28 | 13 pts |
| Urban-Farming-as-a-Service | VRTV-29 | 21 pts |
| Gemelos digitales | VRTV-30 | 13 pts |
| B2G procurement flow | VRTV-31 | 8 pts |
| Bulk device provisioning | VRTV-32 | 5 pts |

## Milestones de Revenue

| Mes | MRR | Devices | Evento |
|-----|-----|---------|--------|
| 0-3 | [redactado] | 120 | Billing + app MVP, CR soft launch |
| 3-6 | [redactado] | 450 | Marketplace + Caja, PA launch |
| 6-9 | [redactado] | 1,000 | Commercial tier + API, CO launch |
| 9-12 | [redactado] | 1,700 | Data API beta, MX launch |
| 12-15 | [redactado] | 2,300 | Industrial tier, referral at scale |
| 15-18 | [MRR target] | [redactado] | **[MRR target] crossed** |

## Anti-Patterns Detectados

| Anti-pattern | Severidad | Mitigacion |
|-------------|-----------|------------|
| Backend-ahead syndrome (13 endpoints, 0 screens) | Alta | VRTV-6: conectar Flutter a endpoints existentes |
| Dashboard theater (6 paginas hardcoded) | Alta | VRTV-13: conectar D3.js a API real |
| Sensor-rich, action-poor (8 sensores, 0 actuadores) | Media | VRTV-18: robot automation (T2) |
| Notification model sin delivery (7 canales, 0 send) | Alta | VRTV-9: FCM push (T1) |
| Auth without identity (login pero no profile) | Media | VRTV-6: profile screen |
| Marketplace = 0 (36% MRR sin backend ni frontend) | Critica | VRTV-8: marketplace MVP (T0) |

---

> Fuentes: [`srd/gap-audit.md`](https://github.com/vertivolatam/monorepo/blob/main/srd/gap-audit.md) | [`srd/success-reality.md`](https://github.com/vertivolatam/monorepo/blob/main/srd/success-reality.md) | [Linear](https://linear.app/vertivolatam/project/vertivo-dollar500k-mrr-9b6ce5d7223c)
