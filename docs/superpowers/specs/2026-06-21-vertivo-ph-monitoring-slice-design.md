# Diseño: Vertical Slice de Monitoreo de pH (Raspberry → EMQX → Serverpod → Flutter)

- **Fecha:** 2026-06-21
- **Estado:** Aprobado para planificación
- **Rama base:** `fix/backend-db-wiring-dev`
- **App objetivo:** `apps/vertivo_flutter` (NO `apps/mobile`, que es un stub vacío)

## 1. Contexto y problema

El monorepo Vertivo tiene los tres extremos de la cadena de monitoreo construidos por
separado, pero **nunca se han conectado punta a punta**:

- `apps/raspberry` (Python) ya monitorea sensores y publica por MQTT; tiene simuladores
  para generar datos sin hardware (`simulation/`).
- `apps/vertivo_server` (Serverpod) ya tiene 14 endpoints, el modelo `EnvironmentalReading`
  y un `SensorIngestionService` que se suscribe al broker, persiste lecturas y auto-genera
  `Alert`/`Anomaly` por umbral.
- `apps/vertivo_flutter` (Flutter) solo tiene `sign_in_screen` y `greetings_screen`.
  **Cero pantallas de monitoreo.** Los 14 endpoints están sin consumir.

Regla del proyecto (`CLAUDE.md`): *"Connect before create — 13 Serverpod endpoints exist
with 0 Flutter screens. Build UI first."*

Este diseño **no intenta construir toda la UI**. Construye el **vertical slice más pequeño
que prueba la cadena completa** con un solo sensor (**pH**), para de-riesgar el pipeline y
dejar un patrón replicable a los demás sensores.

### Por qué pH

- Es el corazón de la nebuponía (regla del proyecto: aeropónico/nebuponía, nunca "hidropónico").
- Tiene umbrales claros → ejercita la rama de `Alert`/`Anomaly` del ingestor.
- Pasa el "Rosa test": un número con color verde/ámbar/rojo se entiende sin entrenamiento.

## 2. Arquitectura del slice

```
make dev-raspberry-i2c-sim (escenario pH)
  → publish topic: vertivo/1/greenhouse/1/sensor/ph
    → EMQX broker (:1883)
      → SensorIngestionService.start()  [VERIFICAR que arranca en el boot del server]
        → insert EnvironmentalReading(greenhouseId:1, measurementType:"ph", value, unit)
        → si fuera de rango: insert Alert + Anomaly
          → PostgreSQL (environmental_readings)
            → vertivo_client (cliente Dart generado)
              → Flutter MonitorPhScreen: poll getReadings(1, "ph") cada 5 s
                → gauge + color por estado + sparkline + banner de Alert
```

## 3. Contrato de datos (referencia, ya existente)

- **Topic MQTT** (`apps/raspberry/config/current/mqtt_dev.json`):
  `vertivo/{user_id}/greenhouse/{greenhouse_id}/sensor/ph` → dev usa `user_id=1`, `greenhouse_id=1`.
- **Broker dev:** EMQX en `localhost:1883` (vía port-forward de minikube).
- **Modelo** (`environmental_reading.spy.yaml`):
  `EnvironmentalReading { greenhouseId:int, measurementType:String, value:double, unit:String, source:String?, isAnomaly:bool, createdAt:DateTime }`
- **Endpoint de lectura** (`greenhouse_endpoint.dart`):
  `Future<List<EnvironmentalReading>> getReadings(Session, int greenhouseId, String measurementType, {...})`
  → para el slice: `getReadings(1, "ph")`. **Requiere `session.authenticated`.**

## 4. Decisiones de diseño (confirmadas)

| Decisión | Elección | Razón |
|----------|----------|-------|
| Sensor del slice | **pH** | núcleo nebuponía + umbrales + Rosa test |
| Mecanismo "en vivo" | **Polling** cada 5 s | el server no tiene métodos streaming (`yield`/`Stream`) |
| Autenticación | **Login real + usuario semilla** (`dev`, `greenhouse_id=1`) | respeta "connect before create"; prueba el camino real; sin deuda técnica |
| Alcance pantalla | **Valor + estado + sparkline + banner de Alert** | prueba lectura *y* alertas en una sola pantalla |

## 5. Entregables (unidades con propósito único)

### 5.1 Targets de Makefile (desktop + mobile)

Añadir al `Makefile` del monorepo, en la sección `DEV - Flutter`:

```makefile
dev-flutter-desktop: ## Run Flutter app on Linux desktop
	@cd apps/vertivo_flutter && flutter run -d linux \
		--dart-define=SERVER_URL=http://localhost:8080/

dev-flutter-mobile: ## Run Flutter app on Android device/emulator
	@cd apps/vertivo_flutter && flutter run \
		--dart-define=SERVER_URL=http://10.0.2.2:8080/
```

- `localhost:8080` desde desktop; `10.0.2.2:8080` es el host visto desde el emulador Android.
- También actualizar el bloque de help del Makefile con ambos targets.
- Mantener `dev-flutter-start` existente (no romper compatibilidad).

### 5.2 Verificación/cableado del ingestor MQTT

- Confirmar que `SensorIngestionService.start()` se invoca en el arranque del server
  (`server.dart` o un boot hook de Serverpod).
- **Si es el cabo suelto sospechado**, cablearlo aquí. Sin esto, nada fluye.
- Criterio de éxito: con el simulador corriendo, aparecen filas en `environmental_readings`
  con `measurement_type = 'ph'`.

### 5.3 Usuario y greenhouse semilla (dev)

- Seed de un usuario dev (vía emailIdp) y un `Greenhouse` con `id=1` para `user_id=1`,
  alineado con `mqtt_dev.json`.
- Documentar credenciales dev en el spec de implementación (no en código productivo).

### 5.4 Pantalla Flutter `MonitorPhScreen`

- Estado con **Riverpod** (patrón del proyecto): un provider que hace polling de
  `getReadings(1, "ph")` cada 5 s y expone la última lectura + historial corto.
- UI:
  - Valor grande de pH (1 decimal).
  - Color por estado: 🟢 en rango / 🟡 advertencia / 🔴 fuera de rango
    (umbrales tomados del backend, no recalculados en el front).
  - Sparkline de las últimas ~20 lecturas.
  - Banner si existe `Alert` activa para el greenhouse (vía `alert.getMyAlerts` /
    `alert.getForGreenhouse`).
- Navegación: accesible tras el login desde `greetings_screen` (enlace temporal del slice).

### 5.5 Verificación E2E

Secuencia manual reproducible (irá al plan de implementación):
1. `make bootstrap-dev` (o pasos equivalentes ya levantados).
2. `make dev-all-port-forward` (expone EMQX :1883 y Serverpod :8080).
3. `make dev-raspberry-i2c-sim` con escenario que mueva pH.
4. Confirmar filas en `environmental_readings` (PostgreSQL).
5. `make dev-flutter-desktop` → login → `MonitorPhScreen` → ver el número moverse y el
   color cambiar; provocar un valor fuera de rango y ver el banner de Alert.

## 6. Manejo de errores

- **Sin sesión / sesión expirada:** la pantalla redirige a `sign_in_screen`.
- **Backend caído / timeout de polling:** mostrar último valor con marca "desactualizado"
  (timestamp) en vez de pantalla en blanco; reintentar en el siguiente ciclo.
- **Sin lecturas aún:** estado vacío explícito ("esperando datos del sensor…").
- **Ingestor no arrancado:** se detecta en el paso 4 de la verificación E2E (no hay filas);
  es el riesgo principal (ver §8).

## 7. Pruebas

- **Flutter:** test de widget de `MonitorPhScreen` con un provider mock que emite lecturas
  en rango y fuera de rango → verifica color/banner. Test de la lógica de polling/estado.
- **Server:** test del parseo de topic→`measurementType` en `SensorIngestionService` y de
  la creación de `Alert` cuando el valor cruza umbral (si no existe ya).
- **Pipeline:** la verificación E2E de §5.5 es la prueba de integración manual del slice.

## 8. Riesgos y supuestos

- **Riesgo principal:** `SensorIngestionService` podría no estar arrancado en el boot del
  server. Es lo primero a verificar; si es así, su cableado entra en el alcance (§5.2).
- **Supuesto:** los umbrales de pH ya están definidos en el backend (el ingestor crea
  `Alert`/`Anomaly`). Si no, se define un umbral dev mínimo en §5.2.
- **Supuesto:** `getReadings` ordena/permite limitar por fecha para el sparkline; si no,
  se añade un parámetro de límite en el plan de implementación.

## 9. Fuera de alcance (futuro)

- Streaming real (push) en lugar de polling — requiere endpoint streaming en Serverpod.
- Los demás sensores (EC, TDS, DO, ORP, CO₂, temperatura, humedad…) — se replican con el
  mismo patrón una vez probado el slice.
- Pantallas de plantas/bandejas, predicción de cosecha, fitopatología, trazabilidad.
- ~~Eliminar/renombrar el stub `apps/mobile` (`vertivo_mobile`)~~ — **RESUELTO** en
  `openspec/changes/2026-06-21-canonical-flutter-app/` (stub eliminado, `vertivo_flutter`
  canonizado, `STRUCTURE.md` corregido).
- Pulido de la app móvil (target `dev-flutter-mobile` queda funcional pero sin device-setup
  tipo `launch_flutter_debug.sh` de altrupets; eso es una mejora de ergonomía futura).
