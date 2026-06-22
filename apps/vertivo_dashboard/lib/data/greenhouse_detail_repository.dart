import 'package:vertivo_client/vertivo_client.dart';

import 'instrument_range.dart';

/// One greenhouse's detail: metadata + latest reading per measurement.
class GreenhouseDetail {
  final Greenhouse greenhouse;

  /// Most-recent reading per measurement (null if no data for that sensor).
  final Map<Measurement, EnvironmentalReading?> latest;

  /// Recent history per measurement (newest first), for the time-series charts.
  final Map<Measurement, List<EnvironmentalReading>> history;

  const GreenhouseDetail({
    required this.greenhouse,
    required this.latest,
    required this.history,
  });
}

/// Reads a single greenhouse's metadata and sensor readings.
class GreenhouseDetailRepository {
  final Client client;
  const GreenhouseDetailRepository(this.client);

  /// Backend `measurementType` string for each [Measurement].
  static const _typeOf = {
    Measurement.ph: 'ph',
    Measurement.temperature: 'temperature',
    Measurement.humidity: 'humidity',
    Measurement.co2: 'co2',
    Measurement.light: 'light',
  };

  Future<GreenhouseDetail?> fetch(int greenhouseId, {int limit = 50}) async {
    final gh = await client.greenhouse.get(greenhouseId);
    if (gh == null) return null;

    final latest = <Measurement, EnvironmentalReading?>{};
    final history = <Measurement, List<EnvironmentalReading>>{};
    // Las 5 lecturas (una por measurement) son independientes: las pedimos en
    // paralelo con `Future.wait` en vez de seriales, para no acumular 5 RTT.
    final entries = _typeOf.entries.toList();
    final results = await Future.wait(
      entries.map((entry) =>
          client.greenhouse.getReadings(greenhouseId, entry.value, limit: limit)),
    );
    for (var i = 0; i < entries.length; i++) {
      final readings = results[i];
      history[entries[i].key] = readings;
      latest[entries[i].key] = readings.isEmpty ? null : readings.first;
    }
    return GreenhouseDetail(greenhouse: gh, latest: latest, history: history);
  }
}
