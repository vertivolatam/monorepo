import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class AnomalyEndpoint extends Endpoint {
  /// Record a new anomaly
  Future<Anomaly> record(Session session, Anomaly anomaly) async {
    anomaly.createdAt = DateTime.now();
    anomaly.isResolved = false;
    return await Anomaly.db.insertRow(session, anomaly);
  }

  /// Get anomalies for a greenhouse
  Future<List<Anomaly>> getForGreenhouse(
    Session session,
    int greenhouseId, {
    int limit = 50,
  }) async {
    return await Anomaly.db.find(
      session,
      where: (t) => t.greenhouseId.equals(greenhouseId),
      limit: limit,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Get unresolved anomalies for a greenhouse
  Future<List<Anomaly>> getUnresolved(
    Session session,
    int greenhouseId,
  ) async {
    return await Anomaly.db.find(
      session,
      where: (t) =>
          t.greenhouseId.equals(greenhouseId) & t.isResolved.equals(false),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Classify an anomaly (update type and severity)
  Future<Anomaly?> classify(
    Session session,
    int anomalyId,
    String anomalyType,
    String severity,
  ) async {
    final anomaly = await Anomaly.db.findById(session, anomalyId);
    if (anomaly == null) return null;
    anomaly.anomalyType = anomalyType;
    anomaly.severity = severity;
    return await Anomaly.db.updateRow(session, anomaly);
  }

  /// Resolve an anomaly
  Future<Anomaly?> resolve(
    Session session,
    int anomalyId,
    String resolutionNotes,
  ) async {
    final authInfo = session.authenticated;
    final anomaly = await Anomaly.db.findById(session, anomalyId);
    if (anomaly == null) return null;
    anomaly.isResolved = true;
    anomaly.resolvedAt = DateTime.now();
    anomaly.resolvedBy = authInfo?.userIdentifier;
    anomaly.resolutionNotes = resolutionNotes;
    return await Anomaly.db.updateRow(session, anomaly);
  }
}
