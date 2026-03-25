import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class AlertEndpoint extends Endpoint {
  /// Create an alert
  Future<Alert> create(Session session, Alert alert) async {
    alert.createdAt = DateTime.now();
    alert.isRead = false;
    alert.isAcknowledged = false;
    alert.isResolved = false;
    alert.escalationLevel = 0;
    return await Alert.db.insertRow(session, alert);
  }

  /// Get alerts for the authenticated user
  Future<List<Alert>> getMyAlerts(
    Session session, {
    int limit = 50,
    int offset = 0,
  }) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return [];
    return await Alert.db.find(
      session,
      where: (t) => t.userId.equals(authInfo.userIdentifier),
      limit: limit,
      offset: offset,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Get unread alert count
  Future<int> getUnreadCount(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return 0;
    return await Alert.db.count(
      session,
      where: (t) =>
          t.userId.equals(authInfo.userIdentifier) & t.isRead.equals(false),
    );
  }

  /// Mark alert as read
  Future<bool> markAsRead(Session session, int alertId) async {
    final alert = await Alert.db.findById(session, alertId);
    if (alert == null) return false;
    alert.isRead = true;
    await Alert.db.updateRow(session, alert);
    return true;
  }

  /// Acknowledge an alert
  Future<bool> acknowledge(Session session, int alertId) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return false;
    final alert = await Alert.db.findById(session, alertId);
    if (alert == null) return false;
    alert.isAcknowledged = true;
    alert.acknowledgedAt = DateTime.now();
    alert.acknowledgedBy = authInfo.userIdentifier;
    await Alert.db.updateRow(session, alert);
    return true;
  }

  /// Resolve an alert
  Future<bool> resolve(Session session, int alertId) async {
    final alert = await Alert.db.findById(session, alertId);
    if (alert == null) return false;
    alert.isResolved = true;
    alert.resolvedAt = DateTime.now();
    await Alert.db.updateRow(session, alert);
    return true;
  }

  /// Get alerts for a greenhouse
  Future<List<Alert>> getForGreenhouse(
    Session session,
    int greenhouseId, {
    int limit = 50,
  }) async {
    return await Alert.db.find(
      session,
      where: (t) => t.greenhouseId.equals(greenhouseId),
      limit: limit,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Get active alert templates
  Future<List<AlertTemplate>> getTemplates(Session session) async {
    return await AlertTemplate.db.find(
      session,
      where: (t) => t.isActive.equals(true),
    );
  }
}
