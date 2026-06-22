# Estructura del Proyecto — Vertivo Monorepo

> Documento de **referencia** del layout real del monorepo. Las **decisiones** de
> arquitectura se registran en `openspec/` (ver
> [`2026-06-21-canonical-flutter-app`](../openspec/changes/2026-06-21-canonical-flutter-app/)).
>
> App Flutter canónica: **`apps/vertivo_flutter`** (mobile + desktop + web). Arquitectura
> móvil: **Clean Architecture** + **Atomic Design** + **Riverpod**.

## Arbol de Directorios

```
monorepo/
├── AGENTS.md                          # Contexto de producto, prioridades, skills, taxonomia Linear
├── CLAUDE.md                          # Entry point auto-cargado (Critical Rules + Quick Nav)
├── Makefile                           # Automatizacion (env-recurso-verbo): bootstrap-dev, dev-*
├── README.md                          # Guia de inicio
├── mcp.json                           # Configuracion MCP servers
├── turbo.json · package.json · pnpm-workspace.yaml · pubspec.lock
│
├── apps/
│   ├── raspberry/                     # Orquestador de monitoreo (Python) — sensores I2C + MQTT
│   │   ├── src/
│   │   │   ├── monitors/             # Ambientales + Atlas Scientific (pH, EC, CO2, DO, ORP…)
│   │   │   ├── orchestrators/        # Coordinacion de monitores
│   │   │   ├── networking/           # MQTT (mqtt.py) + integracion monitor→MQTT
│   │   │   ├── simulation/           # Simuladores de sensores (sin hardware)
│   │   │   ├── cloud_sdk_libs/       # AWS IoT Core / paho-mqtt
│   │   │   └── visualization/        # Dashboards Grafana-as-code (grafanalib) — ops, NO producto
│   │   ├── config/                   # defaults/ + current/ (mqtt_dev.json, indoor/outdoor/…)
│   │   ├── tests/ · Dockerfile.template · .balena/
│   │
│   ├── vertivo_server/               # Backend Serverpod (Dart) — :8080 API, :8081 Insights
│   │   └── lib/src/
│   │       ├── <dominio>/            # endpoints: greenhouse, alert, anomaly, management,
│   │       │                         #   harvest_prediction, phytopathology, traceability, users…
│   │       ├── greenhouses/          # EnvironmentalReading (spy.yaml) + SensorIngestionService
│   │       ├── data/data_sources/    # mqtt_data_source · mqtt_topics
│   │       └── generated/            # protocol.yaml + endpoints.dart (Serverpod codegen)
│   │
│   ├── vertivo_client/               # Cliente Dart generado por Serverpod (consumido por Flutter)
│   ├── vertivo_dashboard/            # Dashboard web (Jaspr + D3.js) — :8080
│   ├── vertivo_flutter/              # ★ App Flutter canonica (android/ios/linux/web/windows)
│   │   └── lib/                      # Ver "Arquitectura de la App" abajo
│   └── widgetbook/                   # Catalogo de widgets (Widgetbook)
│
├── infrastructure/
│   ├── terraform/                    # environments/ (dev/qa/staging/prod) + modules/
│   ├── scripts/                      # bootstrap-dev.sh, bootstrap-raspberry.sh, start-minikube.sh…
│   └── helm-charts/ · docker/ · kms/
│
├── k8s/                              # Manifiestos K8s de aplicacion (base/ + overlays/ + argocd/)
│
├── openspec/                         # Decision records (PDR/ADR/tasks) — changes/
├── srd/                              # Synthetic Reality Development (directivas, gap-audit, journeys)
├── specs/                            # Especificaciones de requisitos (IEEE 830)
├── business/                         # Modelo de negocio
├── skills/                           # Agent Skills (Flutter, CI/CD, SRE, backend, figma…)
├── style-dictionary/                # Design tokens
├── docs/                             # content/ (Zensical) + templates/ + monitoring/ + security/
├── libs/ · scripts/ · logs/ · linear-todo-templates/
│
└── .github/workflows/               # CI/CD pipelines
```

## Descripcion de Directorios

| Directorio | Descripcion |
|------------|-------------|
| `apps/raspberry/` | Orquestador de monitoreo en Python: monitores de sensores, MQTT, simuladores, AWS IoT |
| `apps/vertivo_server/` | Backend Serverpod (Dart): 14 endpoints, modelos, ingestor MQTT→PostgreSQL |
| `apps/vertivo_client/` | Cliente Dart generado por Serverpod; lo consume `vertivo_flutter` |
| `apps/vertivo_dashboard/` | Dashboard web con Jaspr + D3.js |
| `apps/vertivo_flutter/` | App Flutter canonica (mobile/desktop/web) — front del producto |
| `apps/widgetbook/` | Catalogo de widgets para la UI Flutter |
| `infrastructure/` | IaC: Terraform, Helm, Docker, KMS, scripts de bootstrap/minikube |
| `k8s/` | Manifiestos Kubernetes de aplicacion (Kustomize overlays + ArgoCD GitOps) |
| `openspec/` | Decision records (PDR=`proposal.md`, ADR=`design.md`, `tasks.md`) |
| `srd/` | Directivas de producto (Synthetic Reality Development): prioridades, gap-audit, journeys |
| `skills/` | Agent Skills para asistentes IA |
| `docs/` | Documentacion, plantillas, monitoreo y seguridad |

## Arquitectura de la App (`apps/vertivo_flutter/lib/`)

Sigue **Clean Architecture** organizada por features, con **Atomic Design** para
componentes UI compartidos. State management: **Riverpod**.

> Migracion **incremental**: las features nuevas (empezando por el monitoreo de pH) se
> escriben en este layout; las pantallas existentes (`screens/`) migran oportunamente.
> No hay refactor big-bang. Detalle en el OpenSpec change citado arriba.

### Clean Architecture (por feature)

| Capa | Contenido | Depende de |
|------|-----------|------------|
| `domain/` | Entities, use cases, repository interfaces | Nada (capa mas interna) |
| `data/` | Datasources, models, repository impl (envuelven `vertivo_client`) | `domain/` |
| `presentation/` | Pages, providers Riverpod, widgets | `domain/` |

Las dependencias son **unidireccionales**: `presentation/` y `data/` dependen de `domain/`,
nunca al reves.

### Atomic Design (UI compartida en `lib/shared/ui/`)

| Nivel | Descripcion | Ejemplo |
|-------|-------------|---------|
| `atoms/` | Componentes indivisibles | Boton, TextField, Icono |
| `molecules/` | Combinacion de 2-3 atoms | Input con label, IconButton con tooltip |
| `organisms/` | Secciones funcionales completas | AppBar, Form, Card con acciones |
| `templates/` | Layouts de pagina (sin datos) | Scaffold con slots, grid layout |

### State Management

| Framework | Cuando usarlo | Paquete |
|-----------|---------------|---------|
| **Riverpod** (adoptado) | Default del proyecto. Providers reactivos, compile-safe. | [`riverpod`](https://pub.dev/packages/riverpod) |
| Air Framework (opcion futura) | Escala enterprise; no adoptado aun (YAGNI). | [`air_framework`](https://pub.dev/packages/air_framework) |
