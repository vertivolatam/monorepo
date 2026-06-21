import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:vertivo_client/vertivo_client.dart';

import '../main.dart';
import '../features/monitoring/presentation/ph_monitor_screen.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  /// Dev-only: ensure a greenhouse with pH thresholds exists so the ingestion
  /// service can raise alerts. On a fresh bootstrap-dev DB this creates id=1.
  /// The server's `greenhouse.create` does NOT assign `userId` from the
  /// session, and `listByUser` filters by the authenticated user's UUID, so we
  /// set `userId` here from the current auth session to keep the greenhouse
  /// owned by (and visible to) the logged-in user.
  Future<void> _seedGreenhouse(BuildContext context) async {
    final existing = await client.greenhouse.listByUser();
    if (existing.isNotEmpty) return;
    final userId =
        client.authSessionManager.authInfoListenable.value?.authUserId.uuid ??
            '';
    await client.greenhouse.create(
      Greenhouse(
        userId: userId,
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
