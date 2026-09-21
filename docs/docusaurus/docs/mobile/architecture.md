---
title: Arquitectura Mobile
description: Clean Architecture con capas de dominio, data y presentacion en la app Flutter.
---

# Arquitectura Mobile

La app Flutter de Vertivo sigue los principios de **Clean Architecture**, separando el codigo en tres capas bien definidas que permiten testabilidad, mantenibilidad y separacion de responsabilidades.

## Capas de la arquitectura

### Dominio (Domain Layer)

Contiene las entidades de negocio, los casos de uso (use cases) y las interfaces de repositorio. Esta capa es pura Dart, sin dependencias de Flutter ni de paquetes externos. Define *que* hace la aplicacion.

### Datos (Data Layer)

Implementa los repositorios definidos en el dominio. Se conecta con el cliente Serverpod generado, maneja el cache local y transforma los modelos del servidor a entidades del dominio. Define *como* se obtienen los datos.

### Presentacion (Presentation Layer)

Contiene los widgets, las paginas y los providers de Riverpod. Los providers exponen el estado de la UI consumiendo los casos de uso del dominio. Define *como se muestra* la informacion.

## Diagrama de dependencias

```
Presentation  -->  Domain  <--  Data
(Widgets,         (Entities,    (Repositories,
 Providers)        Use Cases)    Serverpod Client)
```

La regla de dependencia fluye siempre hacia el dominio: la capa de presentacion y la capa de datos dependen del dominio, pero el dominio no depende de ninguna de las otras dos.

## Estructura de directorios

```
lib/
  src/
    features/
      greenhouse/
        domain/        # Entidades, use cases, repo interfaces
        data/          # Implementacion de repositorios
        presentation/  # Widgets, pages, providers
      sensor/
        domain/
        data/
        presentation/
    core/              # Utilidades compartidas, theme, routing
```
