---
title: SRD Framework
description: Synthetic Reality Development — framework de estrategia de producto backwards-from-success.
---

# SRD Framework

El **SRD (Synthetic Reality Development)** es el framework de estrategia de producto de Vertivo. Analiza la realidad de exito deseada ([MRR target] MRR a 18 meses) y trabaja hacia atras para identificar que construir, en que orden y por que.

## Secciones del SRD

| Seccion | Archivo | Contenido |
|---------|---------|-----------|
| **1. Success Reality** | `srd/success-reality.md` | KPIs, revenue breakdown, geo, milestones a [MRR target] |
| **2. Business Model Canvas** | `srd/business-model-canvas.md` | 13 secciones BMC + 10 buyer personas con matrices |
| **3. Critical Journeys** | `srd/journeys.md` | 8 journeys pantalla por pantalla vs. codebase real |
| **4. Gap Audit Matrix** | `srd/gap-audit.md` | Matriz persona×journey, heat map, fix list T0-T3 |
| **5. Claude Directive** | `srd/claude-directive.yml` | Reglas machine-readable: prioridades, guardrails, acceptance criteria |
| **Combinado** | `srd/SRD.md` | Resumen ejecutivo de todas las secciones |

## Reglas de Prioridad

Definidas en `claude-directive.yml` → `priority_rules`:

1. **billing_first** — Sin cobrar, revenue = $0
2. **flutter_screens_before_new_endpoints** — Conectar lo existente antes de crear mas backend
3. **push_before_features** — 32% + 24% + 18% de conversiones dependen de push
4. **marketplace_is_36_percent** — Segundo stream mas grande, debe ser T0
5. **never_ship_dashboard_without_real_data** — No "dashboard theater"
6. **referral_before_paid_acquisition** — Growth organico primero

## Guardrails

1. **no_new_endpoints_without_flutter_screen** — Cada endpoint necesita UI
2. **no_hardcoded_data_in_dashboard** — D3.js con datos reales
3. **rosa_test** — Si Rosa no puede usarlo, revisar UX
4. **latam_payments_only** — No Stripe/PayPal como primario
5. **aeroponic_not_hydroponic** — Nebuponia. Nunca "hidroponico"
6. **semver_gate** — No mergear T1 hasta que T0 este Done
7. **linear_taxonomy** — Type + Size labels obligatorios

## Acceptance Criteria por Milestone

| Milestone | Test Persona | Key Criteria |
|-----------|-------------|-------------|
| v0.2.0 | Maria | Puede comprar, configurar, monitorear, y reordenar sin ayuda |
| v0.3.0 | Diego | Puede gestionar 5 invernaderos, ver ROI, invitar a su chef |
| v0.4.0 | Lucia | Puede monitorear 20 clientes y aprobar acciones del robot remotamente |
| v1.0.0 | Roberto | Puede hacer rollout a 15 locations y exportar datos a SAP |

## 8 Critical Journeys

| Journey | Personas | Revenue at risk | Estado |
|---------|----------|-----------------|--------|
| **J1** Compra/Onboarding | Todos | 100% | Gap total |
| **J2** Monitoreo Diario | Todos B2C | Retencion SaaS | Gap total |
| **J3** Alerta Critica Robot | Maria, Carlos | 24% conversiones | Parcial |
| **J4** Marketplace/Caja | Maria, Rosa, Diego | 36% MRR | Gap total |
| **J5** ROI/Fleet Commercial | Diego, Roberto | 54% revenue | Gap total |
| **J6** Agronoma Fleet | Lucia | Multiplicador | Gap total |
| **J7** Enterprise | Roberto | 22% revenue | Parcial |
| **J8** Referral/Sharing | Andres, Maria | 40% device sales | Gap total |

### Camino Critico

```
J1 → J2 → J3 → J4 → J8 → J5 → J6/J7
```

## Como Usar el SRD

### Para desarrolladores

1. Antes de empezar un feature, consultar `claude-directive.yml` → `priority_rules`
2. Verificar que el feature esta en el tier correcto (no saltar tiers)
3. Revisar `anti_patterns` — no caer en los 6 patrones detectados
4. Validar contra `acceptance_criteria` del milestone correspondiente

### Para AI agents

1. Cargar `srd/claude-directive.yml` como contexto
2. Seguir `priority_rules` al sugerir o implementar features
3. Rechazar trabajo que viole `guardrails`
4. Validar PRs contra `acceptance_criteria` del milestone actual

---

> Archivo maestro: [`srd/SRD.md`](https://github.com/vertivolatam/monorepo/blob/main/srd/SRD.md)
