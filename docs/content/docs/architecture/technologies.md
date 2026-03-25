---
title: Stack Tecnologico
description: Detalle del stack — Dart/Serverpod, Flutter, Python, EMQX, PostgreSQL, Kubernetes, Podman, Turborepo.
---

# Stack Tecnologico

Vertivo integra multiples tecnologias especializadas en cada capa de la plataforma. Esta pagina documenta cada herramienta, su version y su rol en el ecosistema.

## Backend

| Tecnologia | Version | Rol |
|------------|---------|-----|
| **Dart** | 3.x | Lenguaje del backend y del cliente generado |
| **Serverpod** | 3.4.1 | Framework de backend que genera API, modelos y migraciones |
| **PostgreSQL** | 16.x | Base de datos relacional principal |

## Mobile

| Tecnologia | Version | Rol |
|------------|---------|-----|
| **Flutter** | 3.x | Framework de UI multiplataforma |
| **Riverpod** | 2.x | State management reactivo |
| **Go Router** | — | Navegacion declarativa |
| **Widgetbook** | — | Catalogo de componentes de UI |

## IoT

| Tecnologia | Version | Rol |
|------------|---------|-----|
| **Python** | 3.11+ | Lenguaje del software del Raspberry Pi |
| **Raspberry Pi** | 4/5 | Hardware del dispositivo IoT |
| **Atlas Scientific EZO** | — | Sensores de grado cientifico (8 tipos) |

## Mensajeria

| Tecnologia | Version | Rol |
|------------|---------|-----|
| **EMQX** | 5.8.6 Open Source | Broker MQTT de alto rendimiento |
| **MQTT** | v5 | Protocolo de comunicacion IoT |

## Infraestructura

| Tecnologia | Version | Rol |
|------------|---------|-----|
| **Minikube** | — | Cluster Kubernetes local para desarrollo |
| **Kubernetes** | — | Orquestacion de contenedores |
| **Podman** | — | Runtime de contenedores (reemplazo de Docker) |
| **Kustomize** | — | Gestion de manifiestos K8s con base + overlays |
| **ArgoCD** | — | GitOps y despliegue continuo |

## Monorepo

| Tecnologia | Version | Rol |
|------------|---------|-----|
| **Turborepo** | — | Orquestacion de builds y tareas del monorepo |
| **pnpm** | — | Gestor de paquetes con workspaces |
| **Make** | — | Scripts de automatizacion (`make bootstrap-dev`, etc.) |
