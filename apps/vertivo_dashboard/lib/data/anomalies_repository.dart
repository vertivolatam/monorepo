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

  /// Concurrencia acotada del fan-out: hasta [_poolSize] llamadas
  /// `getForGreenhouse` en paralelo. Serial sobre 500 greenhouses provoca
  /// timeout en el SSR; 500 en paralelo reventaría el backend. El pool acotado
  /// es el punto medio.
  static const _poolSize = 8;

  Future<List<Anomaly>> fetchForFleet({int perGreenhouse = 50}) async {
    final fleet = await client.adminFleet.listAll(limit: 500, offset: 0);
    final ids = [for (final g in fleet) g.id].whereType<int>().toList();

    final all = <Anomaly>[];
    // Procesa en lotes de [_poolSize]: cada lote corre en paralelo con
    // `Future.wait`, y un fallo por-greenhouse (try/catch) no tumba la página.
    for (var i = 0; i < ids.length; i += _poolSize) {
      final batch = ids.sublist(
        i,
        i + _poolSize > ids.length ? ids.length : i + _poolSize,
      );
      final results = await Future.wait(
        batch.map((id) async {
          try {
            return await client.anomaly
                .getForGreenhouse(id, limit: perGreenhouse);
          } catch (_) {
            // Un greenhouse caído no debe tumbar la agregación de toda la flota.
            return const <Anomaly>[];
          }
        }),
      );
      for (final r in results) {
        all.addAll(r);
      }
    }

    all.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return all;
  }
}
