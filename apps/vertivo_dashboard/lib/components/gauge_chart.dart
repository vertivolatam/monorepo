import 'package:jaspr/jaspr.dart';

/// Radial gauge component rendered by D3.js client-side.
/// Shows current sensor value as a Grafana-style arc gauge
/// with colored zones for normal/warning/critical ranges.
@client
class GaugeChart extends StatefulComponent {
  final String gaugeId;
  final double value;
  final double min;
  final double max;
  final double lowerBound;
  final double upperBound;
  final String unit;
  final String label;

  const GaugeChart({
    required this.gaugeId,
    required this.value,
    required this.min,
    required this.max,
    required this.lowerBound,
    required this.upperBound,
    required this.unit,
    required this.label,
    super.key,
  });

  @override
  State<GaugeChart> createState() => GaugeChartState();
}

class GaugeChartState extends State<GaugeChart> {
  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div(
      classes: 'gauge-container',
      id: 'gauge-${component.gaugeId}',
      attributes: {
        'data-value': '${component.value}',
        'data-min': '${component.min}',
        'data-max': '${component.max}',
        'data-lower-bound': '${component.lowerBound}',
        'data-upper-bound': '${component.upperBound}',
        'data-unit': component.unit,
        'data-label': component.label,
      },
      [],
    );
  }
}
