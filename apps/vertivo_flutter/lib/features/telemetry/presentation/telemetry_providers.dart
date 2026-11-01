import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../main.dart' show client;
import '../data/telemetry_repository.dart';
import '../domain/greenhouse_payload.dart';

final telemetryRepositoryProvider = Provider<TelemetryRepository>((ref) {
  return TelemetryRepository(client);
});

/// RF-3.2: patrón de tópico activo para filtrar canales.
/// Wildcards MQTT: `+` un nivel, `#` el resto.
final telemetryFilterProvider = StateProvider<String>((ref) {
  return 'vertivo/+/greenhouse/+/sensor/#';
});

/// Polls the backend every 5 seconds and emits fresh payloads
/// filtered by [telemetryFilterProvider].
final telemetryPayloadsProvider =
    StreamProvider.autoDispose<List<GreenhouseMqttPayload>>((ref) async* {
  final repo = ref.watch(telemetryRepositoryProvider);
  final filter = ref.watch(telemetryFilterProvider);
  while (true) {
    final payloads = await repo.fetch();
    yield payloads.where((p) => p.matches(filter)).toList();
    await Future<void>.delayed(const Duration(seconds: 5));
  }
});
