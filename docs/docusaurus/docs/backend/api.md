---
title: API Reference
description: Endpoints autogenerados por Serverpod, convenciones y documentacion de la API.
---

# API Reference

Serverpod genera automaticamente los endpoints de la API a partir de las clases Dart anotadas en el directorio `endpoints/`. Cada metodo publico de un endpoint se expone como un RPC callable desde el cliente generado.

## Convenciones de endpoints

Los endpoints siguen la convencion de Serverpod donde cada clase extiende `Endpoint` y sus metodos publicos se convierten en llamadas remotas. Los parametros y tipos de retorno se serializan automaticamente gracias a los modelos generados.

```dart
class GreenhouseEndpoint extends Endpoint {
  Future<Greenhouse> getGreenhouse(Session session, int id) async {
    // Logica de negocio
  }
}
```

## Dominios disponibles

Los endpoints estan organizados por dominio funcional. Cada dominio agrupa las operaciones CRUD y las queries especializadas relacionadas con su area de negocio.

| Dominio | Descripcion |
|---------|-------------|
| `user` | Gestion de usuarios y perfiles |
| `greenhouse` | CRUD de greenhouses y configuracion |
| `sensor` | Lecturas y calibracion de sensores |
| `alert` | Reglas de alerta y notificaciones |
| `crop` | Ciclos de cultivo y seguimiento |
| `device` | Registro y estado de dispositivos IoT |
| `nutrient` | Recetas de soluciones nutritivas |
| `automation` | Reglas de automatizacion y scheduling |
| `report` | Generacion de reportes e historicos |
| `config` | Configuracion global de la plataforma |

## Cliente generado

Serverpod genera automaticamente un paquete cliente Dart (`vertivo_client`) que la app Flutter importa para comunicarse con el backend de forma type-safe, sin necesidad de escribir HTTP requests manualmente.
