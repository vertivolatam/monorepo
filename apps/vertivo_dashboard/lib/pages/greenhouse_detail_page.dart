import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import '../components/sensor_chart.dart';
import '../components/gauge_chart.dart';

class GreenhouseDetailPage extends StatelessComponent {
  final String greenhouseId;

  const GreenhouseDetailPage({required this.greenhouseId, super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'page', [
      // Breadcrumb
      div(classes: 'breadcrumb', [
        a(href: '/greenhouses', [Component.text('Invernaderos')]),
        span(classes: 'breadcrumb__sep', [Component.text(' / ')]),
        span([Component.text('GH-$greenhouseId')]),
      ]),

      // Header
      div(classes: 'page__header page__header--detail', [
        div([
          h1([Component.text('GH-$greenhouseId')]),
          p(classes: 'page__subtitle', [
            Component.text('Invernadero Central — Indoor Hydroponics'),
          ]),
        ]),
        div(classes: 'page__header-actions', [
          span(classes: 'badge badge--segment-industrial', [
            Component.text('Industrial'),
          ]),
          span(classes: 'status-dot status-dot--online', []),
          span([Component.text('Online')]),
        ]),
      ]),

      // Metadata
      div(classes: 'detail-meta', [
        div(classes: 'detail-meta__item', [
          span(classes: 'detail-meta__label', [Component.text('Modo')]),
          span([Component.text('Indoor')]),
        ]),
        div(classes: 'detail-meta__item', [
          span(classes: 'detail-meta__label', [Component.text('Irrigacion')]),
          span([Component.text('NFT Hidroponico')]),
        ]),
        div(classes: 'detail-meta__item', [
          span(classes: 'detail-meta__label', [Component.text('Bandejas')]),
          span([Component.text('6')]),
        ]),
        div(classes: 'detail-meta__item', [
          span(classes: 'detail-meta__label', [Component.text('Ubicacion')]),
          span([Component.text('Bogota, Colombia')]),
        ]),
      ]),

      // Gauge row — all 8 sensors
      div(classes: 'section', [
        h2(classes: 'section__title', [Component.text('Lecturas Actuales')]),
        div(classes: 'grid grid--4', [
          _gaugePanel('CO2', 537.9, 300, 800, 400, 700, 'ppm'),
          _gaugePanel('Humedad', 62.3, 0, 100, 40, 80, '%'),
          _gaugePanel('Temperatura', 22.1, 10, 40, 18, 28, 'C'),
          _gaugePanel('pH', 6.12, 0, 14, 5.5, 6.5, ''),
          _gaugePanel('EC', 1502.0, 0, 3000, 1200, 1800, 'uS/cm'),
          _gaugePanel('TDS', 1005.0, 0, 2000, 800, 1200, 'mg/L'),
          _gaugePanel('DO', 6.48, 0, 14, 5.0, 8.0, 'mg/L'),
          _gaugePanel('ORP', 398.0, 0, 600, 300, 500, 'mV'),
        ]),
      ]),

      // Time-series charts — 2 columns
      div(classes: 'section', [
        h2(classes: 'section__title', [
          Component.text('Historico — Ultimas 24h'),
        ]),
        div(classes: 'grid grid--2', [
          _chartPanel('CO2', 'co2', 'ppm', 400, 700),
          _chartPanel('Humedad', 'humidity', '%', 40, 80),
          _chartPanel('pH', 'ph', '', 5.5, 6.5),
          _chartPanel('Temperatura', 'temperature', 'C', 18, 28),
          _chartPanel('EC', 'ec', 'uS/cm', 1200, 1800),
          _chartPanel('DO', 'do', 'mg/L', 5.0, 8.0),
          _chartPanel('TDS', 'tds', 'mg/L', 800, 1200),
          _chartPanel('ORP', 'orp', 'mV', 300, 500),
        ]),
      ]),
    ]);
  }

  Component _gaugePanel(
    String label,
    double value,
    double min,
    double max,
    double lowerBound,
    double upperBound,
    String unit,
  ) {
    final id = '$greenhouseId-${label.toLowerCase()}';
    return div(classes: 'panel panel--compact', [
      GaugeChart(
        gaugeId: id,
        value: value,
        min: min,
        max: max,
        lowerBound: lowerBound,
        upperBound: upperBound,
        unit: unit,
        label: label,
      ),
    ]);
  }

  Component _chartPanel(
    String label,
    String sensorType,
    String unit,
    double minBound,
    double maxBound,
  ) {
    return div(classes: 'panel', [
      div(classes: 'panel__header', [
        span(classes: 'panel__title', [Component.text('$label ($unit)')]),
      ]),
      SensorChart(
        chartId: '$greenhouseId-$sensorType',
        sensorType: sensorType,
        unit: unit,
        minBound: minBound,
        maxBound: maxBound,
      ),
    ]);
  }
}
