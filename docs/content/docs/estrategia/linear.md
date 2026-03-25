---
title: Linear y Ciclos
description: Gestion de proyecto en Linear — 28 issues, 8 ciclos, 4 milestones, taxonomia de labels.
---

# Linear y Ciclos

## Proyecto

| Dato | Valor |
|------|-------|
| **Proyecto** | [Vertivo → [MRR target]](https://linear.app/vertivolatam/project/vertivo-dollar500k-mrr-9b6ce5d7223c) |
| **Team** | Vertivolatam (VRTV) |
| **Issues** | VRTV-5 a VRTV-32 (28 issues) |
| **Ciclos** | 8 ciclos de 4 semanas (Mar — Dic 2026) |
| **Milestones** | v0.2.0, v0.3.0, v0.4.0, v1.0.0 |

## Milestones

| Milestone | Tier | Fecha | Issues |
|-----------|------|-------|--------|
| **v0.2.0** | T0 Bloqueante | 22 Jun 2026 | VRTV-5 a 8 |
| **v0.3.0** | T1 Critico | 31 Ago 2026 | VRTV-9 a 17 |
| **v0.4.0** | T2 Importante | 9 Nov 2026 | VRTV-18 a 25 |
| **v1.0.0** | T3 Futuro | 14 Dic 2026+ | VRTV-26 a 32 |

## Ciclos y Mapeo

| Ciclo | Periodo | Tier | Issues |
|-------|---------|------|--------|
| Cycle 1 | Mar-Abr 2026 | T0 | VRTV-5, VRTV-7 |
| Cycle 2 | Abr-May 2026 | T0 | VRTV-6 |
| Cycle 3 | May-Jun 2026 | T0 | VRTV-8 |
| Cycle 4 | Jun-Jul 2026 | T1 | VRTV-9 a 12 |
| Cycle 5 | Jul-Ago 2026 | T1 | VRTV-13 a 17 |
| Cycle 6 | Ago-Sep 2026 | T2 | VRTV-18, 19, 20, 25 |
| Cycle 7 | Sep-Oct 2026 | T2 | VRTV-21 a 24 |
| Cycle 8 | Oct-Dic 2026 | T3 | VRTV-26 a 32 |

## Taxonomia de Labels

### Grupos Exclusivos (solo uno por grupo por issue)

**Type** (requerido):

| Label | Cuando usarlo |
|-------|---------------|
| Bug | Algo esta roto. Crashes, errores, violaciones de spec. |
| Chore | Mantenimiento sin cambio visible para el usuario. |
| Feature | Capacidad nueva que no existe. |
| Spike | Investigacion con tiempo acotado. Output = conocimiento. |
| Improvement | Mejora a funcionalidad existente. |
| Design | Trabajo UI/UX o creativo. |

**Size** (requerido, mapea a presupuesto de tokens AI):

| Label | Tokens | Tiempo | Alcance |
|-------|--------|--------|---------|
| XS | <50K | ~30 min | Un archivo, cambio obvio |
| S | 50-100K | ~2-4 hrs | 2-3 archivos, bien acotado |
| M | 100-200K | ~1-2 dias | Cross-modulo |
| L | 200-500K | ~3-5 dias | Cross-capa, afecta arquitectura |
| XL | 500K+ | — | Scope de epic. Requiere descomposicion |

**Strategy** (opcional):

| Label | Cuando usarlo |
|-------|---------------|
| Solo | Un agente, end-to-end |
| Explore | Scope desconocido — investigar antes |
| Team | Multiples agentes en paralelo |
| Human | Requiere decision humana |
| Worktree | Aislamiento git worktree |
| Review | Solo auditoria, sin cambios de codigo |

### Labels Combinables

- **Component**: Frontend, Backend, Database, Security, Performance, Infra, Testing
- **Impact**: Critical Path, Revenue, Grant
- **Flags**: Blocked, Quick Win, Epic

### Reglas

1. Siempre asignar al menos **Type + Size** al crear un issue
2. **XL = descomponer** — nunca crear un issue XL sin sub-issues
3. **Strategy determina la ejecucion** — Solo→agente individual, Team→Agent Teams, Human→esperar decision
4. Verificar labels existentes con `list_issue_labels` antes de crear duplicados
