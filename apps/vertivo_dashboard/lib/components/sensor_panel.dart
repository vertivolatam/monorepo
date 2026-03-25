import 'package:jaspr/jaspr.dart';

class SensorPanel extends StatelessComponent {
  final String sensorType;
  final String label;
  final String currentValue;
  final String unit;
  final String min;
  final String max;
  final String status; // normal, warning, critical, offline
  final String chartId;

  const SensorPanel({
    required this.sensorType,
    required this.label,
    required this.currentValue,
    required this.unit,
    required this.min,
    required this.max,
    required this.status,
    required this.chartId,
    super.key,
  });

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div(classes: 'sensor-panel sensor-panel--$status', [
      div(classes: 'sensor-panel__header', [
        span(classes: 'sensor-panel__type', [text(sensorType)]),
        span(classes: 'sensor-panel__status-dot status-dot status-dot--$status', []),
      ]),
      div(classes: 'sensor-panel__gauge', id: 'gauge-$chartId', []),
      div(classes: 'sensor-panel__reading', [
        span(classes: 'sensor-panel__value', [text(currentValue)]),
        span(classes: 'sensor-panel__unit', [text(unit)]),
      ]),
      div(classes: 'sensor-panel__label', [text(label)]),
      div(classes: 'sensor-panel__range', [
        span([text('Min: $min')]),
        span([text('Max: $max')]),
      ]),
      div(classes: 'sensor-panel__chart', id: 'chart-$chartId', []),
    ]);
  }
}
