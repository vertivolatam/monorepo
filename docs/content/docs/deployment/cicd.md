---
title: CI/CD
description: ArgoCD app-of-apps con GitOps y sincronizacion automatica.
---

# CI/CD — ArgoCD GitOps

Vertivo adopta un modelo **GitOps** para despliegues continuos usando **ArgoCD**. El repositorio Git es la fuente unica de verdad para el estado deseado de la infraestructura, y ArgoCD se encarga de reconciliar el cluster con ese estado automaticamente.

## App-of-Apps Pattern

ArgoCD se configura con el patron **app-of-apps**, donde una aplicacion raiz de ArgoCD gestiona todas las demas aplicaciones del cluster. Esto permite declarar la totalidad del despliegue en un solo punto de entrada.

```yaml
# App raiz que gestiona todas las sub-aplicaciones
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: vertivo-root
  namespace: argocd
spec:
  source:
    repoURL: https://github.com/vertivolatam/monorepo
    path: k8s/argocd/apps
  destination:
    server: https://kubernetes.default.svc
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

## Sincronizacion automatica

ArgoCD monitorea el repositorio Git y, cuando detecta cambios en los manifiestos de Kubernetes, sincroniza automaticamente el cluster. Las opciones `prune` y `selfHeal` aseguran que los recursos eliminados del repo se eliminen del cluster y que cualquier drift manual se corrija.

## Flujo de despliegue

1. El desarrollador hace push de cambios a los manifiestos K8s en el monorepo.
2. ArgoCD detecta el cambio en el repositorio.
3. ArgoCD aplica los manifiestos actualizados al cluster Minikube.
4. El estado del cluster converge con el estado declarado en Git.

## Estado actual

La configuracion de ArgoCD esta en proceso de implementacion. Los detalles de pipelines de CI (build, test, lint) se documentaran una vez integrados con el flujo de ArgoCD.
