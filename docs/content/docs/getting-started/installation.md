---
title: Instalacion
description: Prerequisitos y herramientas necesarias para desarrollar en Vertivo.
---

# Instalacion

Esta guia cubre la instalacion de todas las herramientas necesarias para trabajar con el monorepo de Vertivo.

## Prerequisitos del sistema

- **OS**: Linux (Ubuntu 22.04+) o macOS
- **RAM**: 8 GB minimo (16 GB recomendado para Minikube + todos los servicios)
- **Disco**: 20 GB libres

## Flutter y Dart

Vertivo utiliza Flutter 3.x con Dart 3.x para la app movil y el backend Serverpod.

```bash
# Instalar Flutter (incluye Dart)
# https://docs.flutter.dev/get-started/install

# Verificar
flutter --version
dart --version
```

!!! tip "Serverpod CLI"
    Serverpod requiere su propio CLI para generar codigo:
    ```bash
    dart pub global activate serverpod_cli
    ```

## pnpm

El monorepo usa pnpm 9+ como gestor de paquetes para Turborepo y dependencias Node.js.

```bash
# Instalar via corepack (incluido con Node.js 18+)
corepack enable
corepack prepare pnpm@latest --activate

# Verificar
pnpm --version
```

## Minikube y Kubernetes

Minikube proporciona un cluster Kubernetes local donde se despliegan todos los servicios.

```bash
# Linux (amd64)
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install kubectl /usr/local/bin/kubectl

# Verificar
minikube version
kubectl version --client
```

## Podman

Vertivo usa Podman como runtime de contenedores (rootless, sin daemon).

```bash
# Ubuntu
sudo apt install podman

# macOS
brew install podman

# Verificar
podman --version
```

## Python 3.11+

Requerido para el software del Raspberry Pi (orquestador IoT).

```bash
# Ubuntu
sudo apt install python3.11 python3.11-venv python3-pip

# macOS
brew install python@3.11

# Verificar
python3 --version
```

## Herramientas adicionales

| Herramienta | Uso | Instalacion |
|------------|-----|-------------|
| **helm** | Charts de Kubernetes (EMQX operator) | `curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \| bash` |
| **mosquitto-clients** | Testing MQTT desde terminal | `sudo apt install mosquitto-clients` |
| **make** | Orquestador de comandos del monorepo | Incluido en build-essential |

## Verificacion rapida

```bash
# Verificar todo de una vez
flutter --version && dart --version && pnpm --version && \
minikube version && kubectl version --client && \
podman --version && python3 --version && \
helm version && mosquitto_pub --help > /dev/null && \
echo "✓ Todo instalado correctamente"
```

## Siguiente paso

Una vez instaladas las dependencias, continua con la [configuracion inicial](setup.md).
