---
title: Entorno Local
description: Configuracion del entorno de desarrollo local con make bootstrap-dev, Minikube y venv para Raspberry.
---

# Entorno Local

Esta guia detalla paso a paso como configurar el entorno de desarrollo local para trabajar con todos los componentes de Vertivo: backend, app movil, IoT y documentacion.

## Prerequisitos

Asegurate de haber completado la [instalacion](/docs/getting-started/installation) de todas las herramientas necesarias antes de continuar.

## Bootstrap completo

```bash
make bootstrap-dev
```

Este comando automatiza la configuracion inicial. Consulta la pagina de [configuracion inicial](/docs/getting-started/setup) para ver el detalle de cada paso.

## Minikube

Una vez levantado el cluster con `make bootstrap-dev`, puedes interactuar con los servicios:

```bash
# Ver estado del cluster
minikube status

# Ver pods de todos los namespaces
kubectl get pods -A

# Acceder al dashboard de Minikube
minikube dashboard
```

## Entorno virtual Python (Raspberry)

El proyecto del Raspberry Pi utiliza un virtualenv de Python para aislar las dependencias. En desarrollo local (sin hardware real), se puede usar el modo simulacion.

```bash
cd apps/raspberry
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Servidor Serverpod

```bash
cd apps/vertivo_server
dart run bin/main.dart
```

## App Flutter

```bash
cd apps/vertivo_flutter
flutter run
```
