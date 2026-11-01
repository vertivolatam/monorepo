---
title: Integracion MQTT
description: Integracion MQTT en el backend con mqtt_data_source.dart, mqtt_topics.dart y sensor_ingestion_service.dart.
---

# Integracion MQTT

El backend de Serverpod se conecta al broker EMQX via MQTT para recibir las lecturas de sensores en tiempo real desde los dispositivos Raspberry Pi. Esta integracion es el puente entre el mundo IoT y la persistencia en PostgreSQL.

## Componentes principales

### mqtt_data_source.dart

Gestiona la conexion MQTT con el broker EMQX. Maneja la suscripcion a topics, reconexion automatica y deserializacion de los mensajes entrantes. Se inicializa al arrancar el servidor Serverpod.

### mqtt_topics.dart

Define las constantes y funciones helper para construir y parsear los topics MQTT. Sigue la estructura estandar de Vertivo: `vertivo/{userId}/greenhouse/{ghId}/sensor/{type}`.

### sensor_ingestion_service.dart

Servicio que procesa cada mensaje MQTT recibido: valida el payload, lo transforma al modelo de Serverpod correspondiente, lo persiste en PostgreSQL y dispara las reglas de alerta si algun valor excede los umbrales configurados.

## Flujo de datos

```
Raspberry Pi -> EMQX Broker -> mqtt_data_source.dart -> sensor_ingestion_service.dart -> PostgreSQL
                                                                    |
                                                                    v
                                                              Alert Engine
```

## Configuracion

La conexion al broker EMQX se configura mediante variables de entorno en el despliegue de Kubernetes. En desarrollo local, Minikube expone EMQX en el NodePort 31883.
