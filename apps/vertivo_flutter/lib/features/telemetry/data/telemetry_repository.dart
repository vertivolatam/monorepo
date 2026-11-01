import 'package:vertivo_client/vertivo_client.dart';

import '../domain/greenhouse_payload.dart';

/// Recibe payloads MQTT de invernadero vía backend Serverpod (REHM Módulo 3).
///
/// El transporte MQTT real (EMQX → ingestión) vive en el backend; la app
/// mobile solo consume las lecturas ya persistidas con los endpoints
/// existentes (`client.greenhouse.getReadings`) y las proyecta al envelope
/// [GreenhouseMqttPayload] con el árbol de tópicos canónico.
class TelemetryRepository {
  final Client client;
  final int greenhouseId;

  /// `+` = wildcard MQTT: el userId no viaja en EnvironmentalReading.
  final String userIdSegment;

  /// Topics reales publicados por el Edge (thread 2026-09-20, reply 10):
  /// 9 metrics cada ~5s en vertivo/1/greenhouse/1/sensor/*.
  static const defaultMeasurementTypes = [
    'temperature',
    'humidity',
    'co2',
    'nutrient_temperature',
    'ph',
    'ec',
    'tds',
    'do',
    'orp',
  ];

  final List<String> measurementTypes;

  const TelemetryRepository(
    this.client, {
    this.greenhouseId = 1,
    this.userIdSegment = '+',
    this.measurementTypes = defaultMeasurementTypes,
  });

  /// Construye el tópico canónico para una lectura.
  String topicFor(String measurementType) =>
      'vertivo/$userIdSegment/greenhouse/$greenhouseId/sensor/$measurementType';

  GreenhouseMqttPayload payloadFromReading(EnvironmentalReading reading) {
    return GreenhouseMqttPayload(
      topic: topicFor(reading.measurementType),
      sender: reading.source ?? 'greenhouse-$greenhouseId',
      timestamp: reading.createdAt,
      body: {
        'value': reading.value,
        'unit': reading.unit,
        'isAnomaly': reading.isAnomaly,
      },
    );
  }

  /// Trae las lecturas recientes de cada tipo y las devuelve como payloads
  /// ordenados de más nuevo a más viejo.
  Future<List<GreenhouseMqttPayload>> fetch({int limit = 20}) async {
    final payloads = <GreenhouseMqttPayload>[];
    for (final type in measurementTypes) {
      final readings =
          await client.greenhouse.getReadings(greenhouseId, type, limit: limit);
      payloads.addAll(readings.map(payloadFromReading));
    }
    payloads.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return payloads;
  }
}
