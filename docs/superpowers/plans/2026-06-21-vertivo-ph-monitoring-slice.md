# pH Monitoring Vertical Slice — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Prove the full monitoring chain end-to-end with one sensor (pH): simulator → EMQX → Serverpod ingestion → PostgreSQL → a Flutter desktop screen showing live pH value, threshold color, sparkline, and an alert banner.

**Architecture:** The Raspberry simulator publishes pH over MQTT to EMQX. A `SensorIngestionService` (already written, currently NOT wired) subscribes, persists `EnvironmentalReading`, and creates `Anomaly`/`Alert` on threshold breach. The Flutter app (`vertivo_flutter`, the canonical app) polls `greenhouse.getReadings(1,"ph")` + `alert.getForGreenhouse(1)` every 5 s via a Riverpod `StreamProvider` and renders `MonitorPhScreen`.

**Tech Stack:** Serverpod 3.4 (Dart backend), `mqtt_client`, EMQX, PostgreSQL; Flutter + `flutter_riverpod` (first use — per the `2026-06-21-canonical-flutter-app` OpenSpec decision); the Python simulator in `apps/raspberry`.

**Spec:** `docs/superpowers/specs/2026-06-21-vertivo-ph-monitoring-slice-design.md`

---

## File Structure

| File | Responsibility | Action |
|------|----------------|--------|
| `Makefile` | `dev-flutter-desktop` / `dev-flutter-mobile` targets + help | Modify |
| `apps/vertivo_server/lib/server.dart` | Wire MQTT ingestion into boot | Modify |
| `apps/vertivo_server/test/mqtt_topics_test.dart` | Lock topic→measurementType parsing contract | Create |
| `apps/vertivo_flutter/pubspec.yaml` | Add `flutter_riverpod` | Modify |
| `apps/vertivo_flutter/lib/main.dart` | `ProviderScope` + login-gated home | Modify |
| `apps/vertivo_flutter/lib/features/monitoring/domain/ph_status.dart` | Pure threshold→status function | Create |
| `apps/vertivo_flutter/lib/features/monitoring/data/ph_monitor_repository.dart` | Wrap client calls into a snapshot | Create |
| `apps/vertivo_flutter/lib/features/monitoring/presentation/ph_providers.dart` | Riverpod polling provider | Create |
| `apps/vertivo_flutter/lib/features/monitoring/presentation/ph_monitor_screen.dart` | The screen (value/color/sparkline/banner) | Create |
| `apps/vertivo_flutter/lib/features/monitoring/presentation/sparkline.dart` | Tiny CustomPainter sparkline (no new dep) | Create |
| `apps/vertivo_flutter/lib/screens/home_menu.dart` | Post-login menu with a button to the monitor | Create |
| `apps/vertivo_flutter/test/ph_status_test.dart` | Unit-test the status function | Create |

---

## Task 1: Makefile targets (desktop + mobile)

**Files:**
- Modify: `Makefile` (the `DEV - Flutter` section, after `dev-flutter-build`)

- [ ] **Step 1: Add the two targets**

In `Makefile`, immediately after the `dev-flutter-build` target, add:

```makefile
dev-flutter-desktop: ## Run Flutter app on Linux desktop (server on localhost:8080)
	@cd apps/vertivo_flutter && flutter run -d linux \
		--dart-define=SERVER_URL=http://localhost:8080/

dev-flutter-mobile: ## Run Flutter app on Android device/emulator (10.0.2.2 = host from emulator)
	@cd apps/vertivo_flutter && flutter run \
		--dart-define=SERVER_URL=http://10.0.2.2:8080/
```

- [ ] **Step 2: Register them in `.PHONY` and help**

Add `dev-flutter-desktop dev-flutter-mobile` to the `.PHONY` line that lists the flutter targets, and under the `DEV - Flutter:` help block add:

```makefile
	@echo "  $(YELLOW)dev-flutter-desktop$(NC)         Run Flutter app on Linux desktop"
	@echo "  $(YELLOW)dev-flutter-mobile$(NC)          Run Flutter app on Android device/emulator"
```

- [ ] **Step 3: Verify the targets parse**

Run: `make -n dev-flutter-desktop`
Expected: prints the `flutter run -d linux --dart-define=SERVER_URL=http://localhost:8080/` command without executing it.

- [ ] **Step 4: Commit**

```bash
git add Makefile
git commit -m "feat(make): add dev-flutter-desktop and dev-flutter-mobile targets"
```

---

## Task 2: Wire the MQTT ingestion service into the server boot

The service `SensorIngestionService` and `MqttDataSource` exist but `server.dart` never starts them. Without this, no readings ever reach the DB.

**Files:**
- Modify: `apps/vertivo_server/lib/server.dart`
- Create: `apps/vertivo_server/test/mqtt_topics_test.dart`

- [ ] **Step 1: Write a failing test that locks the topic→type contract**

Create `apps/vertivo_server/test/mqtt_topics_test.dart`:

```dart
import 'package:test/test.dart';
import 'package:vertivo_server/src/data/data_sources/mqtt_topics.dart';

void main() {
  test('parses a pH sensor topic into greenhouseId and type', () {
    final seg = MqttTopics.parse('vertivo/1/greenhouse/1/sensor/ph');
    expect(seg, isNotNull);
    expect(seg!.greenhouseId, 1);
    expect(seg.category, 'sensor');
    expect(seg.type, 'ph');
  });

  test('rejects a malformed topic', () {
    expect(MqttTopics.parse('vertivo/1/greenhouse'), isNull);
  });
}
```

- [ ] **Step 2: Run it to confirm the import path is right and it passes/fails predictably**

Run: `cd apps/vertivo_server && dart test test/mqtt_topics_test.dart`
Expected: PASS (parser already exists). If the import path errors, fix it to match the package name `vertivo_server`. This test guards the contract the ingestion relies on.

- [ ] **Step 3: Add the imports to `server.dart`**

At the top of `apps/vertivo_server/lib/server.dart`, with the other `src/...` imports, add:

```dart
import 'src/data/data_sources/mqtt_data_source.dart';
import 'src/greenhouses/sensor_ingestion_service.dart';
```

- [ ] **Step 4: Start ingestion after the pod starts**

In `run()`, replace the final `await pod.start();` line with:

```dart
  // Start the server.
  await pod.start();

  // Connect to the EMQX broker and start ingesting sensor telemetry.
  // In-cluster the broker resolves as 'emqx-listeners:1883' (MqttDataSource default).
  await MqttDataSource.instance.initialize(pod.runMode);
  SensorIngestionService(pod).start();
}
```

- [ ] **Step 5: Verify the server compiles**

Run: `cd apps/vertivo_server && dart analyze lib/server.dart`
Expected: No errors (warnings about unused imports must be gone now that both are used).

- [ ] **Step 6: Commit**

```bash
git add apps/vertivo_server/lib/server.dart apps/vertivo_server/test/mqtt_topics_test.dart
git commit -m "fix(server): start MQTT ingestion (MqttDataSource + SensorIngestionService) on boot"
```

---

## Task 3: Add Riverpod and wrap the app

**Files:**
- Modify: `apps/vertivo_flutter/pubspec.yaml`
- Modify: `apps/vertivo_flutter/lib/main.dart`

- [ ] **Step 1: Add the dependency**

In `apps/vertivo_flutter/pubspec.yaml`, under `dependencies:` (after `google_fonts`), add:

```yaml
  flutter_riverpod: ^2.5.1
```

- [ ] **Step 2: Install**

Run: `cd apps/vertivo_flutter && flutter pub get`
Expected: resolves and downloads `flutter_riverpod`.

- [ ] **Step 3: Wrap `runApp` in a `ProviderScope`**

In `apps/vertivo_flutter/lib/main.dart`, add the import:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
```

and change `runApp(const MyApp());` to:

```dart
  runApp(const ProviderScope(child: MyApp()));
```

- [ ] **Step 4: Verify it still builds**

Run: `cd apps/vertivo_flutter && flutter analyze lib/main.dart`
Expected: No errors.

- [ ] **Step 5: Commit**

```bash
git add apps/vertivo_flutter/pubspec.yaml apps/vertivo_flutter/pubspec.lock apps/vertivo_flutter/lib/main.dart
git commit -m "chore(flutter): add flutter_riverpod and ProviderScope (first use, per canonical-flutter-app)"
```

---

## Task 4: pH status function (pure, tested)

**Files:**
- Create: `apps/vertivo_flutter/lib/features/monitoring/domain/ph_status.dart`
- Create: `apps/vertivo_flutter/test/ph_status_test.dart`

- [ ] **Step 1: Write the failing test**

Create `apps/vertivo_flutter/test/ph_status_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:vertivo_flutter/features/monitoring/domain/ph_status.dart';

void main() {
  test('in-range pH is ok', () {
    expect(phStatus(6.0), PhStatus.ok);
    expect(phStatus(5.5), PhStatus.ok);
    expect(phStatus(6.5), PhStatus.ok);
  });

  test('just outside range is warning', () {
    expect(phStatus(6.8), PhStatus.warning);
    expect(phStatus(5.2), PhStatus.warning);
  });

  test('far outside range is alert', () {
    expect(phStatus(7.2), PhStatus.alert);
    expect(phStatus(4.5), PhStatus.alert);
  });
}
```

- [ ] **Step 2: Run it to verify it fails**

Run: `cd apps/vertivo_flutter && flutter test test/ph_status_test.dart`
Expected: FAIL — `ph_status.dart` does not exist yet.

- [ ] **Step 3: Implement**

Create `apps/vertivo_flutter/lib/features/monitoring/domain/ph_status.dart`:

```dart
/// Health status of a pH reading against the greenhouse's configured range.
enum PhStatus { ok, warning, alert }

/// Pure mapping from a pH value to a status. Defaults match the seed greenhouse
/// thresholds (phMin 5.5 / phMax 6.5). `warnBand` is how far outside the range
/// still counts as "warning" before escalating to "alert".
PhStatus phStatus(
  double value, {
  double min = 5.5,
  double max = 6.5,
  double warnBand = 0.5,
}) {
  if (value >= min && value <= max) return PhStatus.ok;
  if (value >= min - warnBand && value <= max + warnBand) return PhStatus.warning;
  return PhStatus.alert;
}
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `cd apps/vertivo_flutter && flutter test test/ph_status_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add apps/vertivo_flutter/lib/features/monitoring/domain/ph_status.dart apps/vertivo_flutter/test/ph_status_test.dart
git commit -m "feat(monitoring): pure pH status thresholds with tests"
```

---

## Task 5: Repository + polling provider

**Files:**
- Create: `apps/vertivo_flutter/lib/features/monitoring/data/ph_monitor_repository.dart`
- Create: `apps/vertivo_flutter/lib/features/monitoring/presentation/ph_providers.dart`

- [ ] **Step 1: Write the repository**

Create `apps/vertivo_flutter/lib/features/monitoring/data/ph_monitor_repository.dart`:

```dart
import 'package:vertivo_client/vertivo_client.dart';

/// One fetch of pH state: recent readings (newest first) + active alerts.
class PhSnapshot {
  final List<EnvironmentalReading> readings;
  final List<Alert> activeAlerts;
  const PhSnapshot({required this.readings, required this.activeAlerts});

  EnvironmentalReading? get latest => readings.isEmpty ? null : readings.first;
}

/// Reads pH data from the Serverpod backend for one greenhouse.
class PhMonitorRepository {
  final Client client;
  final int greenhouseId;
  const PhMonitorRepository(this.client, {this.greenhouseId = 1});

  Future<PhSnapshot> fetch() async {
    final readings =
        await client.greenhouse.getReadings(greenhouseId, 'ph', limit: 20);
    final alerts = await client.alert.getForGreenhouse(greenhouseId, limit: 50);
    final active = alerts.where((a) => !a.isResolved).toList();
    return PhSnapshot(readings: readings, activeAlerts: active);
  }
}
```

- [ ] **Step 2: Write the provider (5 s polling)**

Create `apps/vertivo_flutter/lib/features/monitoring/presentation/ph_providers.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../main.dart' show client;
import '../data/ph_monitor_repository.dart';

final phMonitorRepositoryProvider = Provider<PhMonitorRepository>((ref) {
  return PhMonitorRepository(client);
});

/// Polls the backend every 5 seconds and emits a fresh [PhSnapshot].
final phSnapshotProvider = StreamProvider.autoDispose<PhSnapshot>((ref) async* {
  final repo = ref.watch(phMonitorRepositoryProvider);
  while (true) {
    yield await repo.fetch();
    await Future<void>.delayed(const Duration(seconds: 5));
  }
});
```

- [ ] **Step 3: Verify it analyzes**

Run: `cd apps/vertivo_flutter && flutter analyze lib/features/monitoring`
Expected: No errors (confirms `client.greenhouse.getReadings` / `client.alert.getForGreenhouse` signatures match the generated client).

- [ ] **Step 4: Commit**

```bash
git add apps/vertivo_flutter/lib/features/monitoring/data apps/vertivo_flutter/lib/features/monitoring/presentation/ph_providers.dart
git commit -m "feat(monitoring): pH repository + 5s polling Riverpod provider"
```

---

## Task 6: Sparkline painter + the screen

**Files:**
- Create: `apps/vertivo_flutter/lib/features/monitoring/presentation/sparkline.dart`
- Create: `apps/vertivo_flutter/lib/features/monitoring/presentation/ph_monitor_screen.dart`

- [ ] **Step 1: Sparkline (no new dependency)**

Create `apps/vertivo_flutter/lib/features/monitoring/presentation/sparkline.dart`:

```dart
import 'package:flutter/material.dart';

/// Minimal sparkline: draws [values] (oldest→newest) as a polyline.
class Sparkline extends StatelessWidget {
  final List<double> values;
  final Color color;
  const Sparkline({super.key, required this.values, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: CustomPaint(painter: _SparklinePainter(values, color)),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> values;
  final Color color;
  _SparklinePainter(this.values, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    final span = (max - min).abs() < 1e-6 ? 1.0 : (max - min);
    final dx = size.width / (values.length - 1);
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = dx * i;
      final y = size.height - ((values[i] - min) / span) * size.height;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(_SparklinePainter old) => old.values != values;
}
```

- [ ] **Step 2: The screen**

Create `apps/vertivo_flutter/lib/features/monitoring/presentation/ph_monitor_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/ph_status.dart';
import 'ph_providers.dart';
import 'sparkline.dart';

class MonitorPhScreen extends ConsumerWidget {
  const MonitorPhScreen({super.key});

  static const _colors = {
    PhStatus.ok: Color(0xFF2E7D32),
    PhStatus.warning: Color(0xFFF9A825),
    PhStatus.alert: Color(0xFFC62828),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(phSnapshotProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Monitoreo de pH')),
      body: snapshot.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (snap) {
          final latest = snap.latest;
          if (latest == null) {
            return const Center(child: Text('Esperando datos del sensor…'));
          }
          final status = phStatus(latest.value);
          final color = _colors[status]!;
          final series =
              snap.readings.reversed.map((r) => r.value).toList(); // oldest→newest
          final hasAlert = snap.activeAlerts.isNotEmpty;
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (hasAlert)
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: _colors[PhStatus.alert],
                    child: Text(
                      '⚠ ${snap.activeAlerts.first.title}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    latest.value.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 96,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                Center(
                  child: Text('pH',
                      style: TextStyle(fontSize: 24, color: color)),
                ),
                const SizedBox(height: 24),
                Sparkline(values: series, color: color),
                const SizedBox(height: 8),
                Text('Última lectura: ${latest.createdAt.toLocal()}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

- [ ] **Step 3: Analyze**

Run: `cd apps/vertivo_flutter && flutter analyze lib/features/monitoring`
Expected: No errors.

- [ ] **Step 4: Commit**

```bash
git add apps/vertivo_flutter/lib/features/monitoring/presentation/sparkline.dart apps/vertivo_flutter/lib/features/monitoring/presentation/ph_monitor_screen.dart
git commit -m "feat(monitoring): MonitorPhScreen (value, color, sparkline, alert banner)"
```

---

## Task 7: Login-gated navigation + greenhouse seed + E2E

**Files:**
- Create: `apps/vertivo_flutter/lib/screens/home_menu.dart`
- Modify: `apps/vertivo_flutter/lib/main.dart`

- [ ] **Step 1: Post-login menu with a dev seed action**

Create `apps/vertivo_flutter/lib/screens/home_menu.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:vertivo_client/vertivo_client.dart';

import '../main.dart';
import '../features/monitoring/presentation/ph_monitor_screen.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  /// Dev-only: ensure a greenhouse with pH thresholds exists so the ingestion
  /// service can raise alerts. On a fresh bootstrap-dev DB this creates id=1.
  /// NOTE: verify `greenhouse.create` assigns `userId` from the session; if it
  /// requires it on the object, set it from `client.auth` before calling.
  Future<void> _seedGreenhouse(BuildContext context) async {
    final existing = await client.greenhouse.listByUser();
    if (existing.isNotEmpty) return;
    await client.greenhouse.create(
      Greenhouse(
        userId: '', // assigned server-side from the authenticated session
        name: 'Invernadero de prueba',
        irrigationType: 'aeroponic',
        totalTrays: 1,
        isActive: true,
        phMin: 5.5,
        phMax: 6.5,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Greenhouse de prueba creado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MonitorPhScreen()),
            ),
            child: const Text('Monitoreo de pH'),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => _seedGreenhouse(context),
            child: const Text('Crear greenhouse de prueba (dev)'),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Gate the home behind login**

In `apps/vertivo_flutter/lib/main.dart`, add the imports:

```dart
import 'screens/home_menu.dart';
import 'screens/sign_in_screen.dart';
```

and replace the `MyHomePage.build` `body:` with the login-gated menu:

```dart
      body: SignInScreen(child: const HomeMenu()),
```

- [ ] **Step 3: Analyze the whole app**

Run: `cd apps/vertivo_flutter && flutter analyze`
Expected: No errors.

- [ ] **Step 4: Commit**

```bash
git add apps/vertivo_flutter/lib/screens/home_menu.dart apps/vertivo_flutter/lib/main.dart
git commit -m "feat(flutter): login-gated home menu with pH monitor nav + dev greenhouse seed"
```

- [ ] **Step 5: End-to-end verification (manual)**

```bash
# 1. Full dev environment (minikube + postgres + emqx + serverpod, ingestion now wired)
make bootstrap-dev
make dev-all-port-forward          # EMQX :1883 + Serverpod :8080

# 2. Happy path — green banner
make dev-raspberry-i2c-sim SCENARIO=normal INTERVAL=30   # pH ~6.0

# 3. Confirm rows land in PostgreSQL
make dev-postgres-port-forward &
psql -h localhost -U postgres -d vertivo \
  -c "select measurement_type, value, created_at from environmental_readings where measurement_type='ph' order by created_at desc limit 5;"
# Expected: pH rows ~6.0 appearing every ~30s

# 4. Launch the app, log in (register dev@vertivo.local once), seed greenhouse, open monitor
make dev-flutter-desktop
#   → SignInWidget → register/login → "Crear greenhouse de prueba (dev)" → "Monitoreo de pH"
#   → pH ~6.0, GREEN, sparkline filling every 5s

# 5. Alert path — red banner
make dev-raspberry-i2c-sim SCENARIO=nutrient_imbalance INTERVAL=30   # pH drifts to ~7.2
#   → ingestion: deviation (7.2-6.5)/1.0 = 0.7 > 0.5 → severity 'critical' → Alert created
#   → screen flips to RED and shows the alert banner within ~5s
```

Expected final state: green→red transition observed on `MonitorPhScreen` driven purely by the simulator scenario. The chain is proven end-to-end.

---

## Self-Review notes

- **Spec coverage:** Makefile targets (§5.1) → Task 1; ingestor wiring (§5.2) → Task 2; seed greenhouse/user (§5.3) → Task 7; `MonitorPhScreen` Riverpod polling (§5.4) → Tasks 3–6; E2E (§5.5) → Task 7 Step 5. Auth decision (login real) → Task 7 Step 2 (`SignInScreen`), with the caveat that the read endpoints don't enforce auth server-side (documented).
- **Open verification points (not placeholders — real "confirm against generated code" steps):**
  1. `greenhouse.create` userId handling (Task 7 Step 1 comment). If it does not assign from session, set `userId` from `client.auth` before the call.
  2. `MqttDataSource` default host `emqx-listeners` assumes the server runs in-cluster (it does under `bootstrap-dev`). Running the server locally would need `localhost:1883` config.
  3. Severity tuning: `phMin 5.5 / phMax 6.5` + `nutrient_imbalance` (7.2) → critical. If you change thresholds, re-check the deviation crosses 0.5 to guarantee an Alert.
