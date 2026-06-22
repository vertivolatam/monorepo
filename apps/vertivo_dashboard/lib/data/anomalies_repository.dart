import 'package:vertivo_client/vertivo_client.dart';

/// Aggregates anomalies across the whole fleet for the cockpit anomalies page.
///
/// GAP: there is no `anomaly.getAll` cross-greenhouse endpoint, so we fan out
/// `anomaly.getForGreenhouse` over the admin fleet (`adminFleet.listAll`). This
/// is N+1 by design until a dedicated aggregate endpoint exists — registered as
/// a follow-up backend change (see OpenSpec design §7 gaps). Not faked.
class AnomaliesRepository {
  final Client client;
  const AnomaliesRepository(this.client);

  Future<List<Anomaly>> fetchForFleet({int perGreenhouse = 50}) async {
    final fleet = await client.adminFleet.listAll(limit: 500, offset: 0);
    final all = <Anomaly>[];
    for (final g in fleet) {
      final id = g.id;
      if (id == null) continue;
      all.addAll(
        await client.anomaly.getForGreenhouse(id, limit: perGreenhouse),
      );
    }
    all.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return all;
  }
}
