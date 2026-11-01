---
title: Testing
description: Estrategia de testing — pytest para Raspberry, dart test para backend, simulacion de sensores.
---

# Testing

Vertivo mantiene una estrategia de testing que cubre los tres pilares de la plataforma: IoT (Python), backend (Dart) y simulacion de integracion.

## Raspberry Pi — pytest

El software del Raspberry Pi se testea con **pytest**. Los tests cubren la logica de parsing de sensores, la construccion de payloads MQTT y el comportamiento del orchestrator.

```bash
cd apps/raspberry
source .venv/bin/activate
pytest tests/ -v
```

Los tests usan mocks para simular las lecturas I2C de los sensores Atlas Scientific, permitiendo correr la suite completa sin hardware real.

## Backend — dart test

El backend Serverpod se testea con `dart test`. Los tests cubren la logica de los endpoints, los servicios de negocio y la ingesta de datos MQTT.

```bash
cd apps/vertivo_server
dart test
```

Los tests de integracion con PostgreSQL utilizan una base de datos de testing que se levanta automaticamente dentro del cluster Minikube o como un contenedor Podman standalone.

## Simulacion de sensores

Para testing de integracion end-to-end, el proyecto incluye un modo de simulacion que genera lecturas de sensores ficticias y las publica al broker EMQX. Esto permite probar el flujo completo (sensor -> MQTT -> backend -> DB -> app) sin necesidad de hardware fisico.

```bash
cd apps/raspberry
python -m vertivo.simulation --greenhouse-id test-gh-001
```

## Cobertura

El objetivo de cobertura para cada componente se definira una vez estabilizados los primeros tests de cada capa. Se integrara reporting de cobertura en el pipeline de CI.
