import 'package:vertivo_client/vertivo_client.dart';

/// One fetch of the admin cockpit's top-level fleet state.
class FleetSnapshot {
  /// Every active greenhouse across ALL tenants (operator view).
  final List<Greenhouse> greenhouses;

  /// Unread alert count for the current (admin) session.
  final int unreadAlerts;

  const FleetSnapshot({required this.greenhouses, required this.unreadAlerts});

  int get activeGreenhouses => greenhouses.length;
}

/// Reads the cross-tenant fleet from the Serverpod backend for the cockpit.
///
/// Mirrors `vertivo_flutter`'s `PhMonitorRepository`: a thin wrapper over
/// `vertivo_client` that aggregates the endpoints one view needs into a typed
/// snapshot. The admin endpoint (`adminFleet.listAll`) requires a session with
/// `Scope.admin`; a non-admin session is rejected by Serverpod before the call
/// returns (surfaced as an error to the page, never as fake data).
class FleetRepository {
  final Client client;
  const FleetRepository(this.client);

  Future<FleetSnapshot> fetch() async {
    final greenhouses = await client.adminFleet.listAll(limit: 500, offset: 0);
    final unread = await client.alert.getUnreadCount();
    return FleetSnapshot(greenhouses: greenhouses, unreadAlerts: unread);
  }
}
