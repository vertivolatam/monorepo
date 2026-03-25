# Vertivo Monorepo — Agent Instructions

## Product Context

Vertivo builds **autonomous aeroponic urban micro-greenhouses** with an embedded robot agronomist (Raspberry Pi + Atlas Scientific EZO sensors). The product uses **nebuponía** (aeroponics by nebulization) — NEVER refer to it as hydroponic.

**Revenue model**: Hardware ($4,500+) + SaaS ($29-$499/mo) + Marketplace (Caja Vertivo subscription + on-demand) + Data B2B.
**Target**: $501K MRR at 18 months. **Geo**: CR → PA → CO → MX → BR.

## Current Priorities (from SRD)

The full SRD framework is at `srd/SRD.md`. The machine-readable directive is at `srd/claude-directive.yml`.

### What to build NOW (T0 — v0.2.0)

1. **VRTV-5**: Billing — integrate latam_payments (OnvoPay/Tilopay/Wompi). Without this, revenue = $0.
2. **VRTV-6**: Flutter — GoRouter + Riverpod + 5 core screens (home, greenhouse list, greenhouse detail, alerts, profile).
3. **VRTV-7**: Flutter — onboarding wizard (device pairing via QR, name greenhouse, choose first crop).
4. **VRTV-8**: Marketplace MVP — Caja Vertivo tiers, subscribe, checkout. Blocked by VRTV-5.

### What NOT to do yet

- Do not build new Serverpod endpoints — 13 exist with 0 Flutter screens consuming them.
- Do not add new dashboard pages — connect existing 6 pages to real API first.
- Do not build robot automation (actuators) — monitoring works, control is T2.
- Do not integrate Stripe/PayPal — use latam_payments SDK only.

## Monorepo Structure

```
apps/
├── vertivo_flutter/     # Flutter mobile app (2 screens, M3 theme ready)
├── backend/             # Serverpod (13 endpoints, 30 models, MQTT ingestion)
├── dashboard/           # Jaspr SSR dashboard (6 pages, all hardcoded)
├── raspberry/           # Python orchestrator (8 sensors, 4 modes, MQTT pub)
├── widgetbook/          # Component catalog
infrastructure/
├── terraform/           # IaC
├── scripts/             # bootstrap-raspberry.sh, etc.
k8s/                     # Kubernetes manifests (ArgoCD GitOps)
srd/                     # SRD framework (product strategy source of truth)
```

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Mobile | Flutter + Riverpod + GoRouter + Serverpod client |
| Backend | Serverpod (Dart) + PostgreSQL + EMQX (MQTT) |
| Dashboard | Jaspr (Dart SSR) + D3.js + Material Web Components |
| Hardware | Raspberry Pi + Python + Atlas Scientific EZO (I2C) + Balena |
| Payments | latam_payments SDK (OnvoPay, Tilopay, Wompi, SPEI, PIX, OXXO) |
| Infra | Kubernetes + ArgoCD + Terraform + pnpm + Turborepo |

## Development Rules

1. **Billing first** — every feature that touches money routes through latam_payments.
2. **Connect before create** — use existing Serverpod endpoints before building new ones.
3. **Rosa test** — if a 63-year-old with WhatsApp-only tech skills can't use it, revise the UX.
4. **Semver gate** — T0 must be Done before merging T1 features. T1 before T2.
5. **No hardcoded dashboards** — D3.js charts must use real API data, not synthetic generators.
6. **Aeroponic only** — the system uses nebuponía. Never say "hydroponic" in code, UI, or docs.

## Linear

- **Project**: [Vertivo → $500K MRR](https://linear.app/vertivolatam/project/vertivo-dollar500k-mrr-9b6ce5d7223c)
- **Team**: Vertivolatam (VRTV)
- **Issues**: VRTV-5 to VRTV-32 (28 issues across 8 cycles)
- **Label taxonomy**: See section "Linear MCP — Taxonomía Obligatoria de Labels" below

## Key References

| Reference | Path |
|-----------|------|
| SRD combined doc | `srd/SRD.md` |
| Claude directive (YAML) | `srd/claude-directive.yml` |
| Gap audit (fix list) | `srd/gap-audit.md` |
| Journeys (screen-by-screen) | `srd/journeys.md` |
| Business model canvas | `srd/business-model-canvas.md` |
| Success reality ($500K MRR) | `srd/success-reality.md` |
| latam_payments reference | `altrupets-monorepo/apps/mobile/lib/core/payments/latam_payments.dart` |

---

# Agent Skills

Este proyecto utiliza el patrón de **Agent Skills** para proporcionar conocimiento contextual y capacidades especializadas a los asistentes de IA.

## ¿Qué son los Skills?

Los skills son carpetas con archivos `SKILL.md` que contienen instrucciones y contexto específico. Ofrecen:
- Eficiencia de tokens (carga progresiva)
- Menor carga cognitiva
- Composabilidad entre skills

Basado en [Anthropic y LangChain Deep Agents](https://blog.langchain.com/using-skills-with-deep-agents/).

## Estructura de Skills

```
skills/
├── flutter/           # Skills para desarrollo Flutter
├── cicd/              # Skills para CI/CD (Terraform, ArgoCD, etc.)
├── static-analysis/   # Skills para análisis estático de código
└── figma/             # Skills para integración con Figma Dev Mode
```

## Cómo Usar los Skills

### Invocación por Keywords
```bash
"Crea una app usando mvvm para gestión de usuarios"
"Implementa clean-arch para un módulo de productos"
"Configura cicd con GitHub Actions"
```

### Invocación Explícita
```bash
@skill:flutter/mvvm - Genera una app de notas
@skill:flutter/clean-architecture - Implementa módulo de auth
```

## Skills Disponibles

### Flutter

| Skill | Keywords | Nivel | Descripción |
|-------|----------|-------|-------------|
| [MVVM](skills/flutter/mvvm/SKILL.md) | mvvm, provider | Intermedio | Patrón MVVM con separación UI/lógica |
| [Clean Architecture](skills/flutter/clean-architecture/SKILL.md) | clean-arch, bloc | Avanzado | Arquitectura en capas Domain/Data/Presentation |
| [Project Setup](skills/flutter/project-setup/SKILL.md) | setup, init | Básico | Configuración inicial estándar |
| [Testing](skills/flutter/testing/SKILL.md) | test, tdd | Avanzado | Unit, widget e integration tests |
| [BLoC Avanzado](skills/flutter/bloc-advanced/SKILL.md) | bloc, cubit | Avanzado | Hydrated BLoC, Replay BLoC |
| [Riverpod](skills/flutter/riverpod/SKILL.md) | riverpod | Intermedio | State management reactivo |
| [Feature-First](skills/flutter/feature-first/SKILL.md) | feature-first | Intermedio | Organización por features |
| [Modular](skills/flutter/modular-architecture/SKILL.md) | modular | Avanzado | Módulos independientes |
| [Code Generation](skills/flutter/code-generation/SKILL.md) | code-gen, freezed | Básico | build_runner, json_serializable |
| [Performance](skills/flutter/performance/SKILL.md) | performance | Avanzado | Profiling y optimización |
| [Accessibility](skills/flutter/accessibility/SKILL.md) | a11y, wcag | Intermedio | Semantic widgets, screen readers |
| [Animation](skills/flutter/animation-motion/SKILL.md) | animation, rive | Avanzado | Rive, Lottie, Hero |
| [Theming](skills/flutter/theming/SKILL.md) | theme, dark-mode | Intermedio | Material 3, design system |
| [i18n](skills/flutter/i18n/SKILL.md) | i18n, l10n | Intermedio | Múltiples idiomas |
| [Firebase](skills/flutter/firebase/SKILL.md) | firebase | Intermedio | Auth, Firestore, Messaging |
| [GraphQL](skills/flutter/graphql/SKILL.md) | graphql | Avanzado | Queries, mutations, subscriptions |
| [Offline-First](skills/flutter/offline-first/SKILL.md) | offline, sync | Avanzado | Cache y sincronización |
| [Deep Linking](skills/flutter/deep-linking/SKILL.md) | deep-linking | Intermedio | Universal/App links |
| [Push Notifications](skills/flutter/push-notifications/SKILL.md) | fcm, notifications | Intermedio | Firebase Cloud Messaging |
| [Analytics](skills/flutter/analytics-tracking/SKILL.md) | analytics | Intermedio | Firebase, Mixpanel, Amplitude |
| [Error Tracking](skills/flutter/error-tracking/SKILL.md) | sentry, crashlytics | Intermedio | Monitoreo de errores |
| [Feature Flags](skills/flutter/feature-flags/SKILL.md) | feature-flags | Intermedio | Remote Config, LaunchDarkly |
| [IAP](skills/flutter/in-app-purchases/SKILL.md) | iap, subscriptions | Avanzado | RevenueCat |
| [App Distribution](skills/flutter/app-distribution/SKILL.md) | testflight | Intermedio | TestFlight, Firebase Distribution |
| [Platform Channels](skills/flutter/platform-channels/SKILL.md) | methodchannel | Avanzado | Comunicación nativa |
| [Native Integration](skills/flutter/native-integration/SKILL.md) | swift, kotlin | Avanzado | iOS/Android SDKs |
| [WebView](skills/flutter/webview-integration/SKILL.md) | webview | Intermedio | flutter_inappwebview |
| [Security](skills/flutter/security/SKILL.md) | security | Avanzado | Obfuscation, pinning |

### CI/CD

| Skill | Keywords | Descripción |
|-------|----------|-------------|
| [GitHub Actions](skills/cicd/github-actions/SKILL.md) | ci, cd, pipeline | CI/CD nativo de GitHub |
| [ArgoCD](skills/cicd/argocd/SKILL.md) | gitops, kubernetes | GitOps deployment |
| [Terraform](skills/cicd/terraform/SKILL.md) | iac, hcl | Infrastructure as Code |
| [AWS](skills/cicd/aws/SKILL.md) | eks, rds, lambda | Amazon Web Services |
| [GCP](skills/cicd/gcp/SKILL.md) | gke, cloud-run | Google Cloud Platform |
| [Azure](skills/cicd/azure/SKILL.md) | aks, functions | Microsoft Azure |
| [OVHCloud](skills/cicd/ovhcloud/SKILL.md) | ovh | OVHCloud EU-based |
| [Ansible AWX](skills/cicd/ansible-awx/SKILL.md) | ansible | Configuration management |
| [Crossplane](skills/cicd/crossplane/SKILL.md) | multi-cloud | K8s-native infra |

### Otros

| Skill | Keywords | Descripción |
|-------|----------|-------------|
| [Figma](skills/figma/SKILL.md) | figma, design | Extracción de assets |
| [GraphQL](skills/graphql/SKILL.md) | graphql | Cliente GraphQL |
| [Static Analysis](skills/static-analysis/SKILL.md) | lint, sast | Dart Analyzer, Datadog SAST |

## Linear MCP — Taxonomía Obligatoria de Labels

Cuando se interactúe con Linear vía MCP (crear issues, asignar labels, buscar issues), **siempre** usar la siguiente taxonomía de labels. Esta sección es la fuente de verdad única.

### Grupos Exclusivos (solo uno por grupo por issue)

**Type** (requerido):
| Label | Cuándo usarlo |
|-------|---------------|
| Bug | Algo está roto. Crashes, errores, violaciones de spec. |
| Chore | Mantenimiento sin cambio visible para el usuario. Deps, CI/CD, docs. |
| Feature | Capacidad nueva que no existe. Página, endpoint, evento, campaña. |
| Spike | Investigación con tiempo acotado. Output = conocimiento. ADR, PoC, eval. |
| Improvement | Mejora a funcionalidad existente. UX, perf, refactor, mejor proceso. |
| Design | Trabajo UI/UX o creativo. Mockups, design system, branding. |

**Size** (requerido, mapea a presupuesto de tokens AI):
| Label | Tokens | Tiempo | Alcance |
|-------|--------|--------|---------|
| XS | <50K | ~30 min | Un archivo, cambio obvio |
| S | 50-100K | ~2-4 hrs | 2-3 archivos, bien acotado |
| M | 100-200K | ~1-2 días | Cross-módulo. Front + back + tests |
| L | 200-500K | ~3-5 días | Cross-capa, afecta arquitectura |
| XL | 500K+ | — | Scope de epic. Requiere descomposición |

**Strategy** (opcional para no-engineering):
| Label | Cuándo usarlo |
|-------|---------------|
| Solo | Un agente, end-to-end. Requerimientos claros. |
| Explore | Scope desconocido — investigar ANTES de proponer solución. |
| Team | Múltiples agentes en paralelo. Front + back + tests concurrente. |
| Human | Requiere decisión humana. UX, lógica de negocio, arquitectura. |
| Worktree | Aislamiento git worktree. Cambios riesgosos o experimentales. |
| Review | Solo auditoría/revisión — sin cambios de código. Output es reporte. |

### Labels Combinables (sin grupo, se pueden poner varios)

**Component:** Frontend, Backend, Database, Security, Performance, Infra, Testing, Web Quality

**Impact:** Critical Path, Revenue, Grant

**Flags:** Blocked, Quick Win, Epic

### Reglas al usar Linear MCP

1. **Siempre asignar al menos Type + Size** al crear un issue
2. **XL = descomponer** — nunca crear un issue XL sin sub-issues
3. **Strategy determina la ejecución** — Solo→agente individual, Team→Agent Teams, Human→esperar decisión
4. **Component es combinable** — un issue puede ser Backend + Database + Testing
5. **Labels existentes** — verificar con `list_issue_labels` antes de crear duplicados
6. **Asignar al proyecto correcto** — mapear al proyecto Linear que corresponda (Mobile App, Backend, Agent AI, Infrastructure & DevOps, etc.)

## MCP Servers

Configurados en `mcp.json`:

| Servidor | Uso |
|----------|-----|
| Flutter/Dart | Análisis estático, pub.dev, widgets |
| Figma | Assets, tokens de diseño |
| Apollo GraphQL | Introspección de esquemas |
| Context7 | Documentación técnica |
| Mobile | Gestión de dispositivos |
| Stitch | Generación de UI |
| Linear | Gestión de issues, labels, proyectos (ver taxonomía arriba) |

Ver [docs/MCP_SETUP.md](./docs/MCP_SETUP.md) para configuración.

## Documentación Adicional

- [Plantilla IEEE 830](docs/templates/IEEE_830_TEMPLATE.md) - Para especificaciones de requisitos
- [Mapeo de Mejores Prácticas](skills/flutter/BEST_PRACTICES_MAPPING.md) - Prácticas por skill

---

**Última actualización:** Marzo 2026
