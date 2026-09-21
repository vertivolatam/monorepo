---
title: Configuracion inicial
description: Configuracion del monorepo con make bootstrap-dev para levantar el entorno de desarrollo.
---

# Configuracion inicial

Una vez instaladas todas las dependencias, el monorepo se configura con un solo comando.

## Bootstrap del entorno

```bash
make bootstrap-dev
```

## Que hace bootstrap-dev

| Paso | Comando | Descripcion |
|------|---------|-------------|
| 1 | `pnpm install` | Instala dependencias Node.js de todos los workspaces |
| 2 | `minikube start --driver=podman` | Levanta cluster Kubernetes local |
| 3 | `kubectl apply -k k8s/overlays/dev` | Despliega PostgreSQL + EMQX en Minikube |
| 4 | `serverpod generate` | Genera modelos, endpoints y cliente Dart |
| 5 | `python -m venv .venv` | Crea virtualenv para el proyecto Raspberry Pi |
| 6 | `pip install -r requirements.txt` | Instala dependencias Python del orquestador |

## Verificacion

```bash
# Estado del cluster
minikube status

# Pods corriendo
kubectl get pods -A

# Deberian verse:
# - postgresql (namespace vertivo)
# - emqx (namespace emqx)
```

## Levantar todo

```bash
# Infraestructura completa
make dev-all-deploy

# O paso a paso:
make dev-minikube-deploy      # Cluster Minikube
make dev-postgres-deploy      # PostgreSQL 16 + pgvector
make dev-emqx-deploy          # EMQX operator + cluster
make dev-backend-deploy       # Serverpod en Kubernetes
```

## Acceder a servicios

| Servicio | Comando | URL |
|----------|---------|-----|
| EMQX Dashboard | `make dev-emqx-dashboard` | `localhost:18083` (admin/public) |
| PostgreSQL | `make dev-postgres-port-forward` | `localhost:5432` |
| MQTT Broker | `make dev-mqtt-forward` | `localhost:1883` |
| Documentacion | `make dev-docs-serve` | `localhost:8000` |

## Ejecutar componentes

```bash
# App Flutter
make dev-flutter-start

# Backend Serverpod (modo local con docker-compose DB)
make dev-backend-start

# Simulacion IoT (sin hardware)
make dev-raspberry-i2c-sim

# Con escenario especifico
SCENARIO=heat_wave make dev-raspberry-i2c-sim
```
