import 'dart:async';
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:serverpod/serverpod.dart';
import '../data/data_sources/mqtt_data_source.dart';
import '../data/data_sources/mqtt_topics.dart';
import '../generated/protocol.dart';

/// Processes incoming MQTT sensor messages, persists EnvironmentalReadings,
/// and triggers anomaly detection + alerts.
class SensorIngestionService {
  final Serverpod _pod;
  StreamSubscription<MqttReceivedMessage>? _subscription;

  SensorIngestionService(this._pod);

  /// Start listening to MQTT sensor messages
  void start() {
    _subscription = MqttDataSource.instance.messages.listen(_handleMessage);
  }

  /// Stop listening
  void stop() {
    _subscription?.cancel();
  }

  Future<void> _handleMessage(MqttReceivedMessage msg) async {
    final topic = msg.topic;
    final segments = MqttTopics.parse(topic);
    if (segments == null || segments.category != 'sensor') return;

    final payload = MqttPublishPayload.bytesToStringAsString(
      (msg.payload as MqttPublishMessage).payload.message,
    );

    final data = _parsePayload(payload);
    if (data == null) return;

    final session = await _pod.createSession();
    try {
      // 1. Persist the environmental reading
      final reading = EnvironmentalReading(
        greenhouseId: segments.greenhouseId,
        measurementType: segments.type ?? 'unknown',
        value: data['value'] as double,
        unit: data['unit'] as String? ?? '',
        source: data['sensorId'] as String?,
        isAnomaly: false,
        createdAt: DateTime.now(),
      );

      // 2. Check for anomalies against greenhouse thresholds
      final greenhouse =
          await Greenhouse.db.findById(session, segments.greenhouseId);
      final isAnomaly =
          greenhouse != null ? _checkAnomaly(reading, greenhouse) : false;
      reading.isAnomaly = isAnomaly;

      await EnvironmentalReading.db.insertRow(session, reading);

      // 3. If anomaly, create anomaly record and alert
      if (isAnomaly) {
        await _createAnomaly(session, reading, greenhouse, segments);
      }
    } finally {
      await session.close();
    }
  }

  Map<String, dynamic>? _parsePayload(String payload) {
    try {
      final decoded = jsonDecode(payload) as Map<String, dynamic>;
      if (decoded.containsKey('value')) return decoded;
      return null;
    } catch (_) {
      return null;
    }
  }

  bool _checkAnomaly(EnvironmentalReading reading, Greenhouse greenhouse) {
    final type = reading.measurementType;
    final value = reading.value;

    switch (type) {
      case 'temperature':
        return _outOfRange(
            value, greenhouse.temperatureMin, greenhouse.temperatureMax);
      case 'humidity':
        return _outOfRange(
            value, greenhouse.humidityMin, greenhouse.humidityMax);
      case 'light':
        return _outOfRange(value, greenhouse.lightMin, greenhouse.lightMax);
      case 'co2':
        return _outOfRange(value, greenhouse.co2Min, greenhouse.co2Max);
      case 'ph':
        return _outOfRange(value, greenhouse.phMin, greenhouse.phMax);
      default:
        return false;
    }
  }

  bool _outOfRange(double value, double? min, double? max) {
    if (min != null && value < min) return true;
    if (max != null && value > max) return true;
    return false;
  }

  Future<void> _createAnomaly(
    Session session,
    EnvironmentalReading reading,
    Greenhouse greenhouse,
    MqttTopicSegments segments,
  ) async {
    // Determine severity based on deviation
    final severity = _calculateSeverity(reading, greenhouse);

    final anomaly = Anomaly(
      greenhouseId: segments.greenhouseId,
      anomalyType: reading.measurementType,
      severity: severity,
      detectionMethod: 'sensor',
      measurementType: reading.measurementType,
      actualValue: reading.value,
      description:
          '${reading.measurementType} reading of ${reading.value} ${reading.unit} '
          'is outside configured range',
      isResolved: false,
      createdAt: DateTime.now(),
    );

    await Anomaly.db.insertRow(session, anomaly);

    // Create alert if severity >= high
    if (severity == 'high' || severity == 'critical') {
      final alert = Alert(
        userId: greenhouse.userId,
        greenhouseId: segments.greenhouseId,
        alertType: 'anomaly',
        severity: severity,
        title: '${reading.measurementType} anomaly detected',
        message:
            '${reading.measurementType} reading of ${reading.value} ${reading.unit} '
            'is outside the configured range for greenhouse "${greenhouse.name}".',
        sourceEntityType: 'environmental_reading',
        isRead: false,
        isAcknowledged: false,
        isResolved: false,
        escalationLevel: 0,
        createdAt: DateTime.now(),
      );

      await Alert.db.insertRow(session, alert);
    }
  }

  String _calculateSeverity(
    EnvironmentalReading reading,
    Greenhouse greenhouse,
  ) {
    double? min;
    double? max;

    switch (reading.measurementType) {
      case 'temperature':
        min = greenhouse.temperatureMin;
        max = greenhouse.temperatureMax;
      case 'humidity':
        min = greenhouse.humidityMin;
        max = greenhouse.humidityMax;
      case 'light':
        min = greenhouse.lightMin;
        max = greenhouse.lightMax;
      case 'co2':
        min = greenhouse.co2Min;
        max = greenhouse.co2Max;
      case 'ph':
        min = greenhouse.phMin;
        max = greenhouse.phMax;
    }

    if (min == null && max == null) return 'low';

    final range = (max ?? min!) - (min ?? max!);
    if (range == 0) return 'medium';

    double deviation;
    if (min != null && reading.value < min) {
      deviation = (min - reading.value) / range;
    } else if (max != null && reading.value > max) {
      deviation = (reading.value - max) / range;
    } else {
      return 'low';
    }

    if (deviation > 0.5) return 'critical';
    if (deviation > 0.25) return 'high';
    if (deviation > 0.1) return 'medium';
    return 'low';
  }
}
