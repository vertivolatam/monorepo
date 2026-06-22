import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:vertivo_client/vertivo_client.dart';

import '../components/async_states.dart';
import '../data/anomalies_repository.dart';
import '../data/client.dart';

/// Anomalies — fleet-wide table, aggregated per-greenhouse (no bulk endpoint).
class AnomaliesPage extends AsyncStatelessComponent {
  const AnomaliesPage({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final repo = AnomaliesRepository(backendClient);
    final List<Anomaly> anomalies;
    try {
      anomalies = await repo.fetchForFleet();
    } catch (e) {
      return div(classes: 'page', [
        _header(),
        errorState(e, title: 'No se pudieron cargar las anomalías'),
      ]);
    }

    if (anomalies.isEmpty) {
      return div(classes: 'page', [
        _header(),
        emptyState('No hay anomalías registradas en la flota.'),
      ]);
    }

    return div(classes: 'page', [
      _header(),
      div(classes: 'section', [
        h2(classes: 'section__title', [Component.text('Anomalías de la Flota')]),
        div(classes: 'table-wrapper', [
          table(classes: 'data-table', [
            thead([
              tr([
                for (final h in const [
                  'Invernadero',
                  'Tipo',
                  'Severidad',
                  'Detección',
                  'Sensor',
                  'Esperado',
                  'Actual',
                  'Desviación',
                  'Fecha',
                ])
                  th([Component.text(h)]),
              ]),
            ]),
            tbody([for (final a in anomalies) _row(a)]),
          ]),
        ]),
      ]),
    ]);
  }

  Component _header() {
    return div(classes: 'page__header', [
      h1([Component.text('Anomalías')]),
      p(classes: 'page__subtitle', [
        Component.text('Detección de anomalías en toda la flota'),
      ]),
    ]);
  }

  Component _row(Anomaly an) {
    String num(double? v) => v?.toStringAsFixed(1) ?? '—';
    return tr(classes: 'data-table__row', [
      td([
        a(href: '/greenhouses/${an.greenhouseId}', [
          Component.text('GH-${an.greenhouseId}'),
        ]),
      ]),
      td([
        span(classes: 'tag tag--anomaly-${an.anomalyType}', [
          Component.text(an.anomalyType),
        ]),
      ]),
      td([
        span(classes: 'badge badge--${an.severity}', [
          Component.text(an.severity),
        ]),
      ]),
      td([Component.text(an.detectionMethod)]),
      td([Component.text(an.measurementType ?? '—')]),
      td(classes: 'data-table__mono', [Component.text(num(an.expectedValue))]),
      td(classes: 'data-table__mono', [Component.text(num(an.actualValue))]),
      td(classes: 'data-table__mono', [
        Component.text(an.deviationPercent != null
            ? '${an.deviationPercent!.toStringAsFixed(1)}%'
            : '—'),
      ]),
      td(classes: 'data-table__date', [
        Component.text(an.createdAt.toIso8601String()),
      ]),
    ]);
  }
}
