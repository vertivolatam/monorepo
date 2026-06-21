import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/ph_status.dart';
import 'ph_providers.dart';
import 'sparkline.dart';

class MonitorPhScreen extends ConsumerWidget {
  const MonitorPhScreen({super.key});

  static const _colors = {
    PhStatus.ok: Color(0xFF2E7D32),
    PhStatus.warning: Color(0xFFF9A825),
    PhStatus.alert: Color(0xFFC62828),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(phSnapshotProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Monitoreo de pH')),
      body: snapshot.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (snap) {
          final latest = snap.latest;
          if (latest == null) {
            return const Center(child: Text('Esperando datos del sensor…'));
          }
          final status = phStatus(latest.value);
          final color = _colors[status]!;
          final series =
              snap.readings.reversed.map((r) => r.value).toList(); // oldest→newest
          final hasAlert = snap.activeAlerts.isNotEmpty;
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (hasAlert)
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: _colors[PhStatus.alert],
                    child: Text(
                      '⚠ ${snap.activeAlerts.first.title}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    latest.value.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 96,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                Center(
                  child: Text('pH',
                      style: TextStyle(fontSize: 24, color: color)),
                ),
                const SizedBox(height: 24),
                Sparkline(values: series, color: color),
                const SizedBox(height: 8),
                Text('Última lectura: ${latest.createdAt.toLocal()}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
