import 'package:flutter_test/flutter_test.dart';
import 'package:vertivo_client/vertivo_client.dart';
import 'package:vertivo_flutter/features/telemetry/data/telemetry_repository.dart';
import 'package:vertivo_flutter/features/telemetry/domain/greenhouse_payload.dart';

void main() {
  group('GreenhouseMqttPayload', () {
    final payload = GreenhouseMqttPayload(
      topic: 'vertivo/7/greenhouse/2/sensor/temperature',
      sender: 'sim-temperature',
      timestamp: DateTime.utc(2026, 9, 20, 12, 0, 0),
      body: const {'value': 24.5, 'unit': 'C', 'isAnomaly': false},
    );

    test('expone measurementType y greenhouseId del tópico', () {
      expect(payload.measurementType, 'temperature');
      expect(payload.greenhouseId, 2);
    });

    test('matches con wildcards + y #', () {
      expect(payload.matches('vertivo/+/greenhouse/+/sensor/#'), isTrue);
      expect(
          payload.matches('vertivo/+/greenhouse/+/sensor/temperature'), isTrue);
      expect(payload.matches('vertivo/+/greenhouse/+/sensor/ph'), isFalse);
      expect(payload.matches('vertivo/7/greenhouse/2/sensor/#'), isTrue);
      expect(payload.matches('otro/+/greenhouse/+/sensor/#'), isFalse);
    });

    test('round-trip JSON del envelope RF-3.1', () {
      final restored = GreenhouseMqttPayload.fromJson(payload.toJson());
      expect(restored.topic, payload.topic);
      expect(restored.sender, payload.sender);
      expect(restored.timestamp, payload.timestamp);
      expect(restored.body['value'], 24.5);
    });

    test('tópico malformado no rompe los getters', () {
      final bad = GreenhouseMqttPayload(
        topic: 'corto',
        sender: 'x',
        timestamp: DateTime.utc(2026, 9, 20),
        body: const {},
      );
      expect(bad.measurementType, isNull);
      expect(bad.greenhouseId, isNull);
      expect(bad.matches('vertivo/#'), isFalse);
    });
  });

  group('TelemetryRepository.topicFor', () {
    // Client real sin conexión: estos tests no tocan red.
    Client newClient() => Client('http://localhost:8080/');

    test('construye el árbol canónico de MqttTopics', () {
      final repo = TelemetryRepository(
        newClient(),
        greenhouseId: 2,
        userIdSegment: '7',
      );
      expect(repo.topicFor('temperature'),
          'vertivo/7/greenhouse/2/sensor/temperature');
    });

    test('payloadFromReading mapea sender/body/timestamp', () {
      final repo = TelemetryRepository(newClient(), greenhouseId: 2);
      final reading = EnvironmentalReading(
        greenhouseId: 2,
        measurementType: 'ph',
        value: 6.8,
        unit: '',
        source: 'sim-ph',
        isAnomaly: true,
        createdAt: DateTime.utc(2026, 9, 20),
      );
      final p = repo.payloadFromReading(reading);
      expect(p.topic, 'vertivo/+/greenhouse/2/sensor/ph');
      expect(p.sender, 'sim-ph');
      expect(p.body['value'], 6.8);
      expect(p.body['isAnomaly'], isTrue);
    });
  });
}
