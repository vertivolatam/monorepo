import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

import '../../monitoring/presentation/sparkline.dart';
import '../data/telemetry_repository.dart';
import '../domain/greenhouse_payload.dart';
import 'telemetry_providers.dart';

/// Tamaño base de celda del grid Win8 (ancho en dp por celda).
enum TileSize {
  small(110),
  medium(150),
  large(190),
  xlarge(240);

  const TileSize(this.cellWidth);
  final double cellWidth;
}

/// Tamaño seleccionado (default medium). Se cambia desde Settings.
final tileSizeProvider = StateProvider<TileSize>((ref) => TileSize.medium);

/// Dashboard estilo AtlasDesktop: un tile por sensor con valor grande,
/// unidad, sparkline y etiqueta — una mirada = estado del invernadero.
/// La tab Telemetría, en cambio, muestra el stream de mensajes por topic.
enum _Role {
  primary,
  secondary,
  tertiary,
  error,
  primaryContainer,
  secondaryContainer,
  tertiaryContainer,
  primaryFixed,
  inversePrimary,
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  /// Span estilo Win8 por métrica: (columnas, filas) sobre grid denso.
  /// temperature grande (2x2), ph ancho (2x1), resto celdas (1x1).
  static const _spans = {
    'temperature': (2, 2),
    'ph': (2, 1),
  };
  static const _ranges = {
    'temperature': (-10.0, 50.0),
    'nutrient_temperature': (0.0, 40.0),
    'humidity': (0.0, 100.0),
    'co2': (0.0, 2000.0),
    'ph': (0.0, 14.0),
    'ec': (0.0, 5000.0),
    'tds': (0.0, 2000.0),
    'do': (0.0, 20.0),
    'orp': (-1000.0, 1000.0),
  };

  /// Punto medio del rango (aguja en reposo cuando no hay datos).
  static double _rangeMid(String type) {
    final range = DashboardScreen._ranges[type] ?? (0.0, 100.0);
    return (range.$1 + range.$2) / 2;
  }

  /// Unidad por defecto cuando aún no llegó ninguna lectura.
  static String _defaultUnit(String type) {
    return const {
      'temperature': '°C',
      'nutrient_temperature': '°C',
      'humidity': '%',
      'co2': 'ppm',
      'ph': '',
      'ec': 'µS/cm',
      'tds': 'mg/L',
      'do': 'mg/L',
      'orp': 'mV',
    }[type] ??
        '';
  }

  /// Color por métrica, derivado de los tokens (colorScheme del tema activo).
  static Color _tileColor(BuildContext context, String type) {
    final scheme = Theme.of(context).colorScheme;
    const order = [
      'temperature',
      'humidity',
      'co2',
      'nutrient_temperature',
      'ph',
      'ec',
      'tds',
      'do',
      'orp',
    ];
    const roles = [
      _Role.primary,
      _Role.secondary,
      _Role.tertiary,
      _Role.primaryContainer,
      _Role.error,
      _Role.secondaryContainer,
      _Role.tertiaryContainer,
      _Role.primaryFixed,
      _Role.inversePrimary,
    ];
    final role = roles[order.indexOf(type) % roles.length];
    return switch (role) {
      _Role.primary => scheme.primary,
      _Role.secondary => scheme.secondary,
      _Role.tertiary => scheme.tertiary,
      _Role.error => scheme.error,
      _Role.primaryContainer => scheme.primaryContainer,
      _Role.secondaryContainer => scheme.secondaryContainer,
      _Role.tertiaryContainer => scheme.tertiaryContainer,
      _Role.primaryFixed => scheme.primaryFixed,
      _Role.inversePrimary => scheme.inversePrimary,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payloads = ref.watch(telemetryPayloadsProvider);
    // El grid SIEMPRE se pinta: sin datos (loading/error/vacío) los tiles
    // muestran placeholders; el error va en un banner, nunca a pantalla
    // completa.
    final items = payloads.valueOrNull ?? const <GreenhouseMqttPayload>[];
    final error = payloads.hasError ? '${payloads.error}' : null;
    final latest = <String, GreenhouseMqttPayload>{};
    for (final p in items) {
      final type = p.measurementType;
      if (type == null) continue;
      latest.putIfAbsent(type, () => p);
    }
    // Series por tipo (más viejo → más nuevo) para los sparklines.
    final series = <String, List<double>>{};
    for (final p in items.reversed) {
      final type = p.measurementType;
      if (type == null) continue;
      final v = (p.body['value'] as num?)?.toDouble();
      if (v == null) continue;
      series.putIfAbsent(type, () => []).add(v);
    }
    final types = TelemetryRepository.defaultMeasurementTypes.toList();
    // Densidad Win8: columnas según tamaño de celda elegido (S/M/L/XL).
    final width = MediaQuery.sizeOf(context).width;
    final cellWidth = ref.watch(tileSizeProvider).cellWidth;
    final columns = (width / cellWidth).floor().clamp(2, 10);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (error != null)
          MaterialBanner(
            content: Text(
              'Sin conexión con la API — mostrando últimos valores conocidos.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            leading: const Icon(Icons.cloud_off_outlined, size: 18),
            actions: const [SizedBox.shrink()],
          ),
        if (payloads.isLoading && items.isEmpty)
          const LinearProgressIndicator(minHeight: 2),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: StaggeredGrid.count(
              crossAxisCount: columns,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                for (final type in types)
                  StaggeredGridTile.count(
                    crossAxisCellCount:
                        (_spans[type]?.$1 ?? 1).clamp(1, columns),
                    mainAxisCellCount: _spans[type]?.$2 ?? 1,
                    child: _SensorTile(
                      type: type,
                      payload: latest[type],
                      series: series[type] ?? const [],
                    ),
                  ),
              ],
            ),
          ),
          ),
        ],
      );
  }

  static String _formatTime(DateTime t) {
    final local = t.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(local.hour)}:${two(local.minute)}:${two(local.second)}';
  }
}

/// Tile individual estilo Win8: header + gauge radial + sparkline + hora.
/// Sin datos muestra placeholders (nunca pantalla de error).
class _SensorTile extends StatelessWidget {
  final String type;
  final GreenhouseMqttPayload? payload;
  final List<double> series;

  const _SensorTile({
    required this.type,
    required this.payload,
    required this.series,
  });

  @override
  Widget build(BuildContext context) {
    final p = payload;
    final isAnomaly = p?.body['isAnomaly'] as bool? ?? false;
    final tileColor = DashboardScreen._tileColor(context, type);
    final range = DashboardScreen._ranges[type] ?? (0.0, 100.0);
    final value =
        (p?.body['value'] as num?)?.toDouble() ?? DashboardScreen._rangeMid(type);
    final unit = '${p?.body['unit'] ?? DashboardScreen._defaultUnit(type)}';
    return Card(
      color: isAnomaly
          ? Theme.of(context).colorScheme.errorContainer
          : tileColor.withValues(alpha: 0.15),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isAnomaly
                      ? Icons.warning_amber_rounded
                      : Icons.sensors_rounded,
                  size: 18,
                  color: isAnomaly
                      ? Theme.of(context).colorScheme.error
                      : tileColor,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    type.replaceAll('_', ' ').toUpperCase(),
                    style: Theme.of(context).textTheme.labelMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Center(
                child: AnimatedRadialGauge(
                  duration: const Duration(milliseconds: 600),
                  value: value.clamp(range.$1, range.$2),
                  radius: 44,
                  axis: GaugeAxis(
                    min: range.$1,
                    max: range.$2,
                    progressBar: GaugeProgressBar.basic(color: tileColor),
                  ),
                  builder: (context, _, value) => Text(
                    p == null
                        ? '— $unit'.trim()
                        : '${p.body['value']} $unit'.trim(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Sparkline(values: series, color: tileColor),
            const SizedBox(height: 2),
            Text(
              p == null ? 'Sin datos' : DashboardScreen._formatTime(p.timestamp),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
