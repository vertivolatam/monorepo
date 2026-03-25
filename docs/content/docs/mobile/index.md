---
title: App Movil
description: App Flutter con Riverpod + GoRouter para 4 segmentos de usuario.
---

# App Movil — Flutter + Riverpod

La app movil de Vertivo esta construida con Flutter y usa Riverpod como state management. Sirve a **4 segmentos de usuario** con experiencias adaptadas.

## Estado actual

| Dato | Valor |
|------|-------|
| **Framework** | Flutter 3.x |
| **State Management** | Riverpod |
| **Navegacion** | GoRouter |
| **Cliente API** | Serverpod Client (autogenerado) |
| **Pantallas** | 2 (auth + test) |
| **Madurez** | 8% |

!!! info "Prioridad T0"
    VRTV-6 (8 pts): Implementar GoRouter + Riverpod + 5 core screens (home, greenhouse list, greenhouse detail, alerts, profile). VRTV-7 (5 pts): Onboarding wizard con device pairing via QR.

## Segmentos de usuario

| Segmento | Plan | Experiencia |
|----------|------|-------------|
| **Residential** | Basic $29 / Pro $59 | Interfaz simplificada, recomendaciones automaticas, alertas push |
| **Commercial** | Commercial $199 | Dashboards ROI, multi-greenhouse, integracion POS |
| **Industrial** | Industrial $499 | Fleet management, compliance reports, integracion ERP |
| **Expert** | Commercial $199 | Datos crudos, calibracion manual, cross-client analytics |

## Stack tecnologico

| Tecnologia | Rol |
|-----------|-----|
| **Flutter 3.x** | Framework UI multiplataforma (Android + iOS) |
| **Riverpod** | State management reactivo y type-safe |
| **GoRouter** | Navegacion declarativa con deep linking |
| **Serverpod Client** | Cliente autogenerado para comunicacion type-safe con backend |
| **FCM** | Push notifications (pendiente — VRTV-9, T1) |
| **latam_payments** | Integracion de pagos (pendiente — VRTV-5, T0) |

## 5 Core Screens (T0)

| Screen | Funcion | Journey |
|--------|---------|---------|
| **Home** | Dashboard resumen: estado general, alertas recientes, ultima cosecha | J2 |
| **Greenhouse List** | Lista de invernaderos del usuario con estado de cada uno | J2 |
| **Greenhouse Detail** | Lecturas en tiempo real de 8 sensores, graficas, alertas | J2, J3 |
| **Alerts** | Historial de alertas, filtros por tipo y severidad | J3 |
| **Profile** | Datos del usuario, plan activo, configuracion, logout | J1 |

## Onboarding Wizard (T0)

```
Welcome → Scan QR device → Name greenhouse → Choose first crop → See first readings → Done
```

Cada paso mapea a una pantalla del wizard. El flujo completo debe pasar el **Rosa Test** (accesible para una persona de 63 anos con tech baja).

## Siguientes secciones

- [Arquitectura](architecture.md) — Clean Architecture con capas domain/data/presentation
- [Design System](design-system.md) — Widgetbook, tokens y paleta de colores
