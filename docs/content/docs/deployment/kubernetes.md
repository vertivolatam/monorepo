---
title: Kubernetes
description: Configuracion de Minikube con Kustomize base+overlay y namespaces del cluster.
---

# Kubernetes — Minikube

Vertivo utiliza **Minikube** como cluster Kubernetes local para desarrollo. Los manifiestos se organizan con **Kustomize** usando un patron de base + overlays que permite adaptar la configuracion a diferentes entornos.

## Setup de Minikube

Minikube se configura con el driver de Podman para evitar dependencias en Docker. El cluster se inicia con recursos suficientes para correr todos los servicios de la plataforma.

```bash
minikube start --driver=podman --cpus=4 --memory=8192
```

## Estructura de Kustomize

```
k8s/
  base/
    serverpod/          # Deployment y Service del backend
    postgresql/         # StatefulSet de PostgreSQL
    emqx/               # CRD del operador EMQX
    kustomization.yaml
  overlays/
    dev/                # Configuracion para desarrollo local
      kustomization.yaml
      patches/
    staging/            # Configuracion para staging
      kustomization.yaml
```

La **base** contiene los manifiestos comunes a todos los entornos. Los **overlays** aplican patches especificos (replicas, recursos, variables de entorno) segun el entorno de destino.

## Namespaces

| Namespace | Contenido |
|-----------|-----------|
| `vertivo` | Backend Serverpod y PostgreSQL |
| `emqx` | Broker EMQX y sus recursos |
| `argocd` | ArgoCD y sus componentes |

## Aplicar manifiestos

```bash
kubectl apply -k k8s/overlays/dev
```
