import 'package:jaspr/jaspr.dart';

class KpiCard extends StatelessComponent {
  final String title;
  final String value;
  final String unit;
  final String trend;
  final String trendDirection; // up, down, stable
  final String sparklineId;

  const KpiCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.trend,
    required this.trendDirection,
    required this.sparklineId,
    super.key,
  });

  @override
  Iterable<Component> build(BuildContext context) sync* {
    final trendClass = switch (trendDirection) {
      'up' => 'kpi__trend--up',
      'down' => 'kpi__trend--down',
      _ => 'kpi__trend--stable',
    };

    yield div(classes: 'kpi', [
      div(classes: 'kpi__header', [
        span(classes: 'kpi__title', [text(title)]),
      ]),
      div(classes: 'kpi__body', [
        span(classes: 'kpi__value', [text(value)]),
        span(classes: 'kpi__unit', [text(unit)]),
      ]),
      div(classes: 'kpi__footer', [
        span(classes: 'kpi__trend $trendClass', [text(trend)]),
        div(classes: 'kpi__sparkline', id: sparklineId, []),
      ]),
    ]);
  }
}
