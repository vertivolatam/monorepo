import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../main.dart' show client;
import '../data/ph_monitor_repository.dart';

final phMonitorRepositoryProvider = Provider<PhMonitorRepository>((ref) {
  return PhMonitorRepository(client);
});

/// Polls the backend every 5 seconds and emits a fresh [PhSnapshot].
final phSnapshotProvider = StreamProvider.autoDispose<PhSnapshot>((ref) async* {
  final repo = ref.watch(phMonitorRepositoryProvider);
  while (true) {
    yield await repo.fetch();
    await Future<void>.delayed(const Duration(seconds: 5));
  }
});
