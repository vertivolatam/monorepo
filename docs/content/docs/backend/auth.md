---
title: Autenticacion
description: Autenticacion en Serverpod v3 con session.authenticated y userIdentifier (String UUID).
---

# Autenticacion

Vertivo utiliza el sistema de autenticacion nativo de Serverpod v3, que simplifica significativamente el manejo de sesiones respecto a versiones anteriores.

## session.authenticated

En Serverpod v3, cada endpoint puede acceder al usuario autenticado a traves de `session.authenticated`. Este objeto contiene el `userIdentifier`, que es un **String UUID** que identifica de forma unica a cada usuario en el sistema.

```dart
Future<UserProfile> getProfile(Session session) async {
  final auth = await session.authenticated;
  if (auth == null) throw AuthenticationException();

  final userId = auth.userIdentifier; // String UUID
  return await UserProfile.db.findFirstRow(
    session,
    where: (t) => t.userId.equals(userId),
  );
}
```

## userIdentifier como String UUID

A diferencia de versiones anteriores de Serverpod que usaban un `userId` numerico (int), la v3 utiliza un `userIdentifier` de tipo `String` en formato UUID. Esto permite mayor flexibilidad y compatibilidad con proveedores de identidad externos.

## Proteccion de endpoints

Los endpoints que requieren autenticacion se protegen usando el scope `requireLogin` o scopes personalizados definidos en la configuracion del servidor. Serverpod rechaza automaticamente las peticiones no autenticadas antes de que lleguen al metodo del endpoint.

## Proveedores de autenticacion

La configuracion de los proveedores de autenticacion (email/password, Google, Apple, etc.) se detallara en esta seccion una vez definida la estrategia final de identity providers para Vertivo.
