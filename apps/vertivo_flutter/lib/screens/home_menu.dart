import 'package:flutter/material.dart';
import 'package:vertivo_client/vertivo_client.dart';

import '../main.dart';
import '../features/monitoring/presentation/ph_monitor_screen.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  /// Dev-only: ensure a greenhouse with pH thresholds exists so the ingestion
  /// service can raise alerts. On a fresh bootstrap-dev DB this creates id=1.
  /// `greenhouse.create` assigns `userId` from the authenticated session
  /// server-side, so the value sent here is ignored.
  Future<void> _seedGreenhouse(BuildContext context) async {
    final existing = await client.greenhouse.listByUser();
    if (existing.isNotEmpty) return;
    await client.greenhouse.create(
      Greenhouse(
        userId: '',
        name: 'Invernadero de prueba',
        irrigationType: 'aeroponic',
        totalTrays: 1,
        isActive: true,
        phMin: 5.5,
        phMax: 6.5,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Greenhouse de prueba creado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MonitorPhScreen()),
            ),
            child: const Text('Monitoreo de pH'),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => _seedGreenhouse(context),
            child: const Text('Crear greenhouse de prueba (dev)'),
          ),
        ],
      ),
    );
  }
}
