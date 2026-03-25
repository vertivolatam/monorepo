import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ManagementEndpoint extends Endpoint {
  /// Get KPI metrics for a greenhouse
  Future<List<KpiMetric>> getMetrics(
    Session session,
    int greenhouseId, {
    String? metricType,
    String periodType = 'monthly',
    int limit = 50,
  }) async {
    return await KpiMetric.db.find(
      session,
      where: metricType != null
          ? (t) =>
              t.greenhouseId.equals(greenhouseId) &
              t.metricType.equals(metricType) &
              t.periodType.equals(periodType)
          : (t) =>
              t.greenhouseId.equals(greenhouseId) &
              t.periodType.equals(periodType),
      limit: limit,
      orderBy: (t) => t.periodEnd,
      orderDescending: true,
    );
  }

  /// Record a KPI metric
  Future<KpiMetric> record(Session session, KpiMetric metric) async {
    metric.createdAt = DateTime.now();

    // Calculate change percent if previous value provided
    if (metric.previousValue != null && metric.previousValue != 0) {
      metric.changePercent =
          ((metric.value - metric.previousValue!) / metric.previousValue!) *
              100;
    }

    return await KpiMetric.db.insertRow(session, metric);
  }

  /// Get dashboard summary: latest metric of each type for a user
  Future<List<KpiMetric>> getDashboardSummary(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return [];

    // Get the latest metric of each type for the user
    return await KpiMetric.db.find(
      session,
      where: (t) => t.userId.equals(authInfo.userIdentifier),
      orderBy: (t) => t.periodEnd,
      orderDescending: true,
      limit: 100,
    );
  }

  /// Get metrics for a user across all greenhouses
  Future<List<KpiMetric>> getMetricsByUser(
    Session session,
    String metricType, {
    String periodType = 'monthly',
    int limit = 50,
  }) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return [];
    return await KpiMetric.db.find(
      session,
      where: (t) =>
          t.userId.equals(authInfo.userIdentifier) &
          t.metricType.equals(metricType) &
          t.periodType.equals(periodType),
      limit: limit,
      orderBy: (t) => t.periodEnd,
      orderDescending: true,
    );
  }
}
