import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:vertivo_client/vertivo_client.dart';

import '../components/async_states.dart';
import '../components/gauge_chart.dart';
import '../data/client.dart';
import '../data/greenhouse_detail_repository.dart';
import '../data/instrument_range.dart';

/// Greenhouse detail — live gauges + history, ranges from InstrumentCard.
class GreenhouseDetailPage extends AsyncStatelessComponent {
  final String greenhouseId;

  const GreenhouseDetailPage({required this.greenhouseId, super.key});

  static const _labels = {
    Measurement.ph: ('pH', ''),
    Measurement.temperature: ('Temperatura', 'C'),
    Measurement.humidity: ('Humedad', '%'),
    Measurement.co2: ('CO2', 'ppm'),
    Measurement.light: ('Luz', 'h'),
  };

  // Display axis bounds per measurement (the gauge dial range, distinct from
  // the in/out-of-range setpoints resolved by instrument_range).
  static const _axis = {
    Measurement.ph: (0.0, 14.0),
    Measurement.temperature: (0.0, 50.0),
    Measurement.humidity: (0.0, 100.0),
    Measurement.co2: (0.0, 2000.0),
    Measurement.light: (0.0, 24.0),
  };

  @override
  Future<Component> build(BuildContext context) async {
    final id = int.tryParse(greenhouseId);
    if (id == null) {
      return div(classes: 'page', [errorState('ID inválido: $greenhouseId')]);
    }

    final repo = GreenhouseDetailRepository(backendClient);
    final GreenhouseDetail? detail;
    try {
      detail = await repo.fetch(id);
    } catch (e) {
      return div(classes: 'page', [
        _breadcrumb(),
        errorState(e, title: 'No se pudo cargar el invernadero'),
      ]);
    }

    if (detail == null) {
      return div(classes: 'page', [
        _breadcrumb(),
        emptyState('Invernadero GH-$greenhouseId no encontrado.'),
      ]);
    }

    final gh = detail.greenhouse;
    return div(classes: 'page', [
      _breadcrumb(),
      div(classes: 'page__header page__header--detail', [
        div([
          h1([Component.text('GH-$greenhouseId')]),
          p(classes: 'page__subtitle', [
            Component.text('${gh.name} — ${gh.irrigationType}'),
          ]),
        ]),
      ]),
      _meta(gh),
      _gauges(detail),
    ]);
  }

  Component _breadcrumb() {
    return div(classes: 'breadcrumb', [
      a(href: '/greenhouses', [Component.text('Invernaderos')]),
      span(classes: 'breadcrumb__sep', [Component.text(' / ')]),
      span([Component.text('GH-$greenhouseId')]),
    ]);
  }

  Component _meta(Greenhouse gh) {
    return div(classes: 'detail-meta', [
      _metaItem('Cliente', gh.userId),
      _metaItem('Irrigación', gh.irrigationType),
      _metaItem('Bandejas', '${gh.totalTrays}'),
      _metaItem('Ubicación', gh.location ?? '—'),
    ]);
  }

  Component _metaItem(String label, String value) {
    return div(classes: 'detail-meta__item', [
      span(classes: 'detail-meta__label', [Component.text(label)]),
      span([Component.text(value)]),
    ]);
  }

  Component _gauges(GreenhouseDetail detail) {
    return div(classes: 'section', [
      h2(classes: 'section__title', [Component.text('Lecturas Actuales')]),
      div(classes: 'grid grid--4', [
        for (final m in _labels.keys) _gauge(m, detail),
      ]),
    ]);
  }

  Component _gauge(Measurement m, GreenhouseDetail detail) {
    final (label, unit) = _labels[m]!;
    final reading = detail.latest[m];
    if (reading == null) {
      // No data for this sensor → explicit N/D, not a fake needle.
      return div(classes: 'panel panel--compact', [
        div(classes: 'panel__header', [
          span(classes: 'panel__title', [Component.text(label)]),
        ]),
        emptyState('N/D'),
      ]);
    }
    // Range from the greenhouse setpoint (→ crop ideal → static fallback).
    final range = resolveRange(m, greenhouse: detail.greenhouse);
    final (axisMin, axisMax) = _axis[m]!;
    return div(classes: 'panel panel--compact', [
      GaugeChart(
        gaugeId: '$greenhouseId-${m.name}',
        value: reading.value,
        min: axisMin,
        max: axisMax,
        lowerBound: range.min,
        upperBound: range.max,
        unit: unit,
        label: label,
      ),
    ]);
  }
}
