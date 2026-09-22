---
title: Orchestrator
description: IndoorUrbanVerticalFarmingOrchestrator, modos de operacion, MonitorMQTTIntegration y threading.
---

# Orchestrator

El **orchestrator** es el proceso principal que corre en el Raspberry Pi y coordina la lectura de sensores, la publicacion MQTT y la ejecucion de modos de operacion. Es el cerebro del dispositivo IoT de Vertivo.

## IndoorUrbanVerticalFarmingOrchestrator

La clase principal `IndoorUrbanVerticalFarmingOrchestrator` gestiona el ciclo de vida completo del dispositivo: inicializa los sensores, establece la conexion MQTT con EMQX y ejecuta el loop principal de lectura y publicacion.

```python
class IndoorUrbanVerticalFarmingOrchestrator:
    """Orquestador principal para vertical farming indoor."""
    def __init__(self, config: OrchestratorConfig):
        # Inicializa sensores, MQTT y modos
        pass

    def run(self):
        # Loop principal
        pass
```

## Modos de operacion

El orchestrator soporta diferentes modos de operacion que determinan que sensores se leen, con que frecuencia y que acciones se toman. Los modos pueden cambiarse dinamicamente via comandos MQTT desde el backend.

## MonitorMQTTIntegration

`MonitorMQTTIntegration` es el componente que gestiona la conexion bidireccional con el broker EMQX. Publica las lecturas de sensores y escucha comandos de configuracion y control provenientes del backend Serverpod.

## Threading

El orchestrator utiliza **threading** de Python para ejecutar las lecturas de sensores en paralelo sin bloquear el loop principal. Cada grupo de sensores (ambiental y solucion nutritiva) se lee en su propio thread con intervalos configurables.
