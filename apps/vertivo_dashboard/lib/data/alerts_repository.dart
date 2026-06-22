import 'package:vertivo_client/vertivo_client.dart';

/// Reads the current (admin) session's alerts for the cockpit alerts page.
class AlertsRepository {
  final Client client;
  const AlertsRepository(this.client);

  Future<List<Alert>> fetch({int limit = 100}) {
    return client.alert.getMyAlerts(limit: limit, offset: 0);
  }
}
