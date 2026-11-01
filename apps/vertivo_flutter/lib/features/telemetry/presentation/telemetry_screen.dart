import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/telemetry_repository.dart';
import 'telemetry_providers.dart';

/// RF-3.2: UI estilo canales (Slack/Discord) que categoriza y filtra los
/// mensajes recibidos según el árbol de tópicos MQTT.
class TelemetryScreen extends ConsumerWidget {
  const TelemetryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payloads = ref.watch(telemetryPayloadsProvider);
    final filter = ref.watch(telemetryFilterProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
          _ChannelBar(
            active: filter,
            onSelect: (pattern) =>
                ref.read(telemetryFilterProvider.notifier).state = pattern,
          ),
          const Divider(height: 1),
          Expanded(
            child: payloads.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (items) {
                if (items.isEmpty) {
                  return const Center(
                    child: Text('Sin mensajes en este canal…'),
                  );
                }
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final p = items[i];
                    final value = p.body['value'];
                    final unit = p.body['unit'] ?? '';
                    final isAnomaly =
                        p.body['isAnomaly'] as bool? ?? false;
                    return ListTile(
                      leading: Icon(
                        isAnomaly
                            ? Icons.warning_amber_rounded
                            : Icons.sensors_rounded,
                        color: isAnomaly ? Colors.red : null,
                      ),
                      title: Text('$value $unit'.trim()),
                      subtitle: Text(
                        '${p.topic}\n${p.sender} · ${_formatTime(p.timestamp)}',
                      ),
                      isThreeLine: true,
                    );
                  },
                );
              },
            ),
          ),
        ],
      );
  }

  static String _formatTime(DateTime t) {
    final local = t.toLocal();
    final hh = local.hour.toString().padLeft(2, '0');
    final mm = local.minute.toString().padLeft(2, '0');
    final ss = local.second.toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }
}

class _ChannelBar extends StatelessWidget {
  final String active;
  final ValueChanged<String> onSelect;

  const _ChannelBar({required this.active, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final channels = <String, String>{
      'Todos': 'vertivo/+/greenhouse/+/sensor/#',
      for (final type in TelemetryRepository.defaultMeasurementTypes)
        type: 'vertivo/+/greenhouse/+/sensor/$type',
    };
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          for (final entry in channels.entries)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text('# ${entry.key}'),
                selected: active == entry.value,
                onSelected: (_) => onSelect(entry.value),
              ),
            ),
        ],
      ),
    );
  }
}
