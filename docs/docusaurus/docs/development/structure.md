---
title: Estructura del Monorepo
description: Organizacion del monorepo con Turborepo, pnpm workspaces y estructura de directorios.
---

# Estructura del Monorepo

El codigo de Vertivo vive en un unico monorepo gestionado con **Turborepo** y **pnpm workspaces**. Esta estructura permite compartir codigo, coordinar builds y mantener consistencia entre todos los proyectos.

## Arbol de directorios

```
monorepo/
  apps/
    vertivo_server/       # Backend Serverpod (Dart)
    vertivo_client/       # Cliente generado por Serverpod (Dart)
    vertivo_flutter/      # App movil Flutter
    widgetbook/           # Catalogo de componentes UI
    raspberry/            # Software del Raspberry Pi (Python)
  packages/
    vertivo_models/       # Modelos compartidos
    design_tokens/        # Tokens de diseno (JSON -> Dart)
  docs/                   # Sitio de documentacion (Fumadocs)
  k8s/                    # Manifiestos de Kubernetes
    base/                 # Configuracion base de Kustomize
    overlays/             # Overlays por entorno
    argocd/               # Aplicaciones de ArgoCD
  Makefile                # Scripts de automatizacion
  turbo.json              # Configuracion de Turborepo
  pnpm-workspace.yaml     # Definicion de workspaces
  package.json            # Root package
```

## Turborepo

Turborepo orquesta las tareas del monorepo (build, test, lint, generate) con caching inteligente y ejecucion paralela. La configuracion se define en `turbo.json` en la raiz del proyecto.

## pnpm Workspaces

pnpm gestiona las dependencias de Node.js y define los workspaces en `pnpm-workspace.yaml`. Esto incluye el sitio de documentacion y cualquier tooling basado en Node.js.

## Makefile

El `Makefile` en la raiz expone los comandos de alto nivel mas usados: `bootstrap-dev`, `generate`, `test`, `deploy-dev`, entre otros. Es el punto de entrada principal para interactuar con el monorepo.
