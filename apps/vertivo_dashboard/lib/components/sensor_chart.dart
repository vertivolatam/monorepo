import 'package:jaspr/jaspr.dart';

/// Real-time sensor time-series chart powered by D3.js.
/// This component renders an SVG container that D3 populates client-side.
/// The actual D3 initialization is in web/dashboard.js.
@client
class SensorChart extends StatefulComponent {
  final String chartId;
  final String sensorType;
  final String unit;
  final double minBound;
  final double maxBound;

  const SensorChart({
    required this.chartId,
    required this.sensorType,
    required this.unit,
    required this.minBound,
    required this.maxBound,
    super.key,
  });

  @override
  State<SensorChart> createState() => SensorChartState();
}

class SensorChartState extends State<SensorChart> {
  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div(
      classes: 'chart-container',
      id: 'chart-container-${component.chartId}',
      attributes: {
        'data-sensor-type': component.sensorType,
        'data-unit': component.unit,
        'data-min-bound': '${component.minBound}',
        'data-max-bound': '${component.maxBound}',
      },
      [],
    );
  }
}
