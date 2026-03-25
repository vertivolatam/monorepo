---
title: Inicio
description: Documentacion tecnica de Vertivo — micro-invernaderos autonomos aeroponicos con robot agronomo embebido.
---

# Vertivo — Micro-Invernaderos Autonomos Aeroponicos

Plataforma cloud-native de **agricultura vertical autonoma por nebuponia** (aeroponia por nebulizacion) para Latinoamerica. Cada micro-invernadero incluye un **robot agronomo embebido** (Raspberry Pi + 8 sensores Atlas Scientific EZO) que controla pH, nutrientes, temperatura, humedad y CO2 automaticamente.

> **"Una Huerta Pensada para Vos"** — Tu robot agronomo personal: cultiva tus alimentos en casa sin saber nada de agronomia, sin luz solar, sin plagas, y con insumos en tu puerta cada mes.

---

## Navegacion Rapida

| Seccion | Descripcion |
|---------|-------------|
| [Producto](docs/producto/propuesta-de-valor.md) | Propuesta de valor, segmentos, verticales, roadmap |
| [Empezar](docs/getting-started/installation.md) | Instalacion y configuracion del entorno de desarrollo |
| [Backend](docs/backend/index.md) | Serverpod v3.4.1, 10 dominios, 30 modelos, PostgreSQL |
| [Mobile](docs/mobile/index.md) | Flutter + Riverpod + GoRouter, 4 segmentos de usuario |
| [IoT](docs/iot/index.md) | Raspberry Pi, 8 sensores Atlas Scientific, simulacion |
| [Pagos](docs/pagos/latam-payments.md) | latam_payments SDK — OnvoPay, Tilopay, Wompi |
| [Arquitectura](docs/architecture/overview.md) | Diagrama del sistema, flujo de datos, tecnologias |
| [Despliegue](docs/deployment/kubernetes.md) | Kubernetes, EMQX, ArgoCD, Balena |
| [Desarrollo](docs/development/local-setup.md) | Entorno local, estructura del monorepo, testing |
| [Estrategia](docs/estrategia/srd.md) | SRD framework, Linear, ciclos y roadmap |

---

## Estado Actual

> **Madurez general: ~15%** — Infraestructura y sensores IoT funcionales; las funcionalidades de negocio y la app movil estan en desarrollo temprano.

| Componente | Madurez | Lo que funciona | Gaps principales |
|------------|---------|----------------|-----------------|
| **Serverpod backend** | 40% | 13 endpoints, 30 modelos, MQTT ingestion | Billing, marketplace, notifications |
| **Flutter app** | 8% | 2 screens (auth + test), M3 theme | Todas las screens core, GoRouter, Riverpod |
| **Jaspr dashboard** | 35% | 6 paginas, D3.js charts | 100% hardcoded, 0% API |
| **Raspberry Pi IoT** | 60% | 8 sensores, 4 orquestadores, MQTT publish | 0 actuadores, 0 robot decision engine |
| **Billing / Pagos** | 0% | — | latam_payments no integrado |
| **Marketplace** | 0% | — | Catalogo, carrito, Caja Vertivo |
| **Infraestructura K8s** | 80% | Minikube, EMQX, PostgreSQL, ArgoCD | Produccion multi-nodo |

### Construyendo ahora (T0 — v0.2.0)

1. **VRTV-5**: Billing — integrar latam_payments (OnvoPay/Tilopay/Wompi)
2. **VRTV-6**: Flutter — GoRouter + Riverpod + 5 core screens
3. **VRTV-7**: Flutter — onboarding wizard (device pairing via QR)
4. **VRTV-8**: Marketplace MVP — Caja Vertivo tiers, subscribe, checkout

---

## Stack Tecnologico

| Capa | Tecnologia |
|------|-----------|
| **Mobile** | Flutter + Riverpod + GoRouter + Serverpod client |
| **Backend** | Dart / Serverpod + PostgreSQL 16 (pgvector) |
| **Dashboard** | Jaspr (Dart SSR) + D3.js + Material Web Components |
| **Broker MQTT** | EMQX Open Source 5.8.6 |
| **IoT** | Raspberry Pi + Python + Atlas Scientific EZO (I2C) + Balena |
| **Pagos** | latam_payments SDK (OnvoPay, Tilopay, Wompi, SPEI, PIX, OXXO) |
| **Infraestructura** | Kubernetes (Minikube) + ArgoCD + Terraform + Podman |
| **Monorepo** | Turborepo v2 + pnpm |

---

## Estructura del Monorepo

```
monorepo/
  apps/
    vertivo_server/      # Backend Serverpod (Dart)
    vertivo_client/      # Client stubs generados
    vertivo_flutter/     # App Flutter (Riverpod + GoRouter)
    raspberry/           # Robot agronomo (Python)
    dashboard/           # Jaspr SSR dashboard (D3.js)
    widgetbook/          # Widgetbook design system
  k8s/
    base/                # Manifiestos K8s base
    overlays/dev/        # Overlay desarrollo (Kustomize)
    argocd/              # GitOps applications
  infrastructure/
    scripts/             # bootstrap-raspberry.sh, setup-emqx-operator.sh
    terraform/           # IaC
  srd/                   # SRD framework (estrategia de producto)
  skills/                # Agent Skills para desarrollo asistido
  docs/                  # Esta documentacion (Zensical/MkDocs)
```

---

## Robot Agronomo — 8 Parametros en Tiempo Real

El orquestador Python (`apps/raspberry/`) lee 8 sensores Atlas Scientific EZO via I2C y publica a EMQX via MQTT:

- **Ambientales**: CO2 (ppm), Humedad (%), Temperatura (°C)
- **Solucion nutritiva**: pH, EC (uS/cm), TDS (mg/L), DO (mg/L), ORP (mV)

| Sensor | Parametro | Unidad | I2C |
|--------|-----------|--------|-----|
| EZO CO2 | Dioxido de carbono | ppm | 0x69 |
| EZO HUM | Humedad relativa | % | 0x6F |
| EZO RTD | Temperatura solucion | °C | 0x66 |
| EZO pH | Potencial de hidrogeno | — | 0x63 |
| EZO EC | Conductividad electrica | uS/cm | 0x64 |
| EZO TDS | Solidos disueltos totales | mg/L | — |
| EZO DO | Oxigeno disuelto | mg/L | 0x61 |
| EZO ORP | Potencial redox | mV | 0x62 |

4 modos de orquestacion: `indoor` (8 sensores), `outdoor` (CO2, humedad), `soil` (EC, pH, temp), `environmental` (CO2, humedad). Simulacion completa sin hardware via proceso estocastico Ornstein-Uhlenbeck con 7 escenarios.

[Ver documentacion IoT completa →](docs/iot/index.md)

---

## Inicio Rapido

```bash
# Clonar y bootstrap
git clone https://github.com/vertivolatam/monorepo.git
cd monorepo
make bootstrap-dev

# Levantar todo: Minikube + PostgreSQL + EMQX + Backend
make dev-all-deploy

# Simulacion IoT (sin hardware)
make dev-raspberry-i2c-sim

# App Flutter
make dev-flutter-start

# Documentacion
make dev-docs-serve    # localhost:8000
```

---

## Identidad de Marca

| | |
|---|---|
| **Razon Social** | Vertivo Horticultura Urbana Vertical S.R.L. |
| **Slogan** | "Una Huerta Pensada para Vos" |
| **Proposito** | Solventar la falta de acceso a alimentos libres de pesticidas mediante aeroponia automatizada |
| **ODS** | 12 (Produccion Responsable), 11 (Ciudades Sostenibles), 13 (Accion Climatica), 2 (Hambre Cero) |
| **Geo** | CR → PA → CO → MX → BR |
| **Target** | [MRR target] a 18 meses |

---

## Referencias

- [SRD Framework](docs/estrategia/srd.md) — Estrategia de producto completa
- [Linear Project](https://linear.app/vertivolatam/project/vertivo-dollar500k-mrr-9b6ce5d7223c) — 28 issues, 8 ciclos
- [AGENTS.md](https://github.com/vertivolatam/monorepo/blob/main/AGENTS.md) — Instrucciones para agentes AI
