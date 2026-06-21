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
