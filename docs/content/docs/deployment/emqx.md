---
title: EMQX
description: Despliegue de EMQX Open Source 5.8.6 via K8s Operator CRD con NodePort 31883.
---

# EMQX — Broker MQTT

Vertivo utiliza **EMQX Open Source 5.8.6** como broker MQTT para la comunicacion entre los dispositivos Raspberry Pi y el backend Serverpod. Se despliega dentro del cluster Minikube usando el **EMQX Kubernetes Operator**.

## Despliegue via K8s Operator

El operador de EMQX para Kubernetes permite gestionar el broker como un recurso nativo de Kubernetes mediante un Custom Resource Definition (CRD). Esto simplifica el lifecycle management, scaling y actualizaciones.

```yaml
apiVersion: apps.emqx.io/v2beta1
kind: EMQX
metadata:
  name: emqx
  namespace: emqx
spec:
  image: emqx:5.8.6
  coreTemplate:
    spec:
      replicas: 1
```

## Acceso al broker

En desarrollo local, EMQX se expone mediante un **NodePort** en el puerto **31883**. Esto permite que tanto el backend Serverpod (dentro del cluster) como los dispositivos Raspberry Pi (fuera del cluster) se conecten al broker.

```bash
# Obtener la IP de Minikube para conectarse
minikube ip
# Conexion: <minikube-ip>:31883
```

## Puertos

| Puerto | Protocolo | Uso |
|--------|-----------|-----|
| 1883 | MQTT | Conexion interna del cluster |
| 31883 | MQTT (NodePort) | Conexion externa desde Raspberry Pi |
| 8083 | WebSocket | Conexion WebSocket (si se habilita) |
| 18083 | HTTP | Dashboard de administracion de EMQX |

## Configuracion

La configuracion de autenticacion, ACLs y reglas de EMQX se gestionara via el dashboard de administracion o mediante ConfigMaps de Kubernetes. Los detalles se documentaran una vez estabilizada la configuracion de produccion.
