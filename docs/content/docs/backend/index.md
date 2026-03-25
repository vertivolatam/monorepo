---
title: Backend
description: Overview del backend Serverpod v3.4.1 con 10 dominios, 30 modelos y PostgreSQL.
---

# Backend — Serverpod v3.4.1

El backend de Vertivo esta construido con [Serverpod](https://serverpod.dev) v3.4.1, un framework de servidor Dart que genera automaticamente el cliente, los modelos y la integracion con PostgreSQL.

## Resumen

| Dato | Valor |
|------|-------|
| **Framework** | Serverpod v3.4.1 (Dart) |
| **Base de datos** | PostgreSQL 16 + pgvector |
| **Dominios** | 10 funcionales |
| **Modelos** | ~30 (YAML → clases Dart generadas) |
| **Endpoints** | 13 funcionales |
| **MQTT** | Integrado con EMQX via paho |

## Dominios funcionales

| Dominio | Modelos | Descripcion |
|---------|---------|-------------|
| **Auth** | 3 | Autenticacion JWT, 2FA para comercial/industrial |
| **Users** | 4 | Gestion multi-segmento (residencial, comercial, industrial, experto) |
| **Greenhouses** | 5 | CRUD de invernaderos, lecturas ambientales, rangos de sensores |
| **Phytopathology** | 4 | Deteccion de enfermedades con IA, historial de diagnosticos |
| **Alerts** | 4 | Alertas multi-canal diferenciadas por segmento (7 canales definidos) |
| **Harvest Prediction** | 2 | Predicciones ML, scores de calidad nutricional |
| **Traceability** | 3 | Cadena hash-chain SHA-256, compliance (ISO 22000, SENASA, GlobalGAP) |
| **Anomaly Management** | 1 | Deteccion AI/sensor/manual/rule_based, clasificacion |
| **Crop Catalog** | 2 | Especies, etapas de crecimiento, condiciones ideales |
| **Management** | 1 | KPIs periodicos: yield_rate, health_score, ROI |

## Base de datos

PostgreSQL 16 con extension **pgvector** para busquedas vectoriales (futuro: embeddings de datos de sensores para anomaly detection). Las migraciones se generan automaticamente a partir de los modelos YAML de Serverpod.

## Estructura del proyecto

```
apps/vertivo_server/
  lib/
    src/
      endpoints/       # Endpoints organizados por dominio
      models/          # Modelos YAML -> clases Dart generadas
      services/        # Logica de negocio
      mqtt/            # Integracion con EMQX
        ├── mqtt_data_source.dart
        ├── mqtt_topics.dart
        └── sensor_ingestion_service.dart
  generated/           # Codigo autogenerado por Serverpod
  migrations/          # Migraciones SQL de PostgreSQL
  config/
    └── development.yaml
```

## Gaps actuales (SRD)

!!! warning "Backend-ahead syndrome"
    El backend tiene 13 endpoints funcionales pero 0 pantallas de Flutter los consumen. La prioridad T0 es conectar Flutter (VRTV-6), no crear mas endpoints.

| Gap | Issue | Tier |
|-----|-------|------|
| Billing / latam_payments | VRTV-5 | T0 |
| Marketplace backend | VRTV-8 | T0 |
| Push notifications send | VRTV-9 | T1 |
| Order management | VRTV-16 | T1 |

## Siguientes secciones

- [API Reference](api.md) — Endpoints autogenerados
- [Autenticacion](auth.md) — Session management con Serverpod v3
- [Integracion MQTT](mqtt.md) — Ingesta de datos de sensores
