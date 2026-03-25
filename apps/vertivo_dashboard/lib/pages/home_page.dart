import 'package:jaspr/jaspr.dart';

import '../components/kpi_card.dart';
import '../components/alert_item.dart';
import '../components/sensor_chart.dart';

class HomePage extends StatelessComponent {
  const HomePage({super.key});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div(classes: 'page', [
      // Page header
      div(classes: 'page__header', [
        h1([text('Dashboard')]),
        p(classes: 'page__subtitle', [text('Monitoreo en tiempo real de todos los invernaderos')]),
      ]),

      // KPI cards row
      div(classes: 'grid grid--4', [
        KpiCard(
          title: 'Invernaderos Activos',
          value: '24',
          unit: '',
          trend: '+2 este mes',
          trendDirection: 'up',
          sparklineId: 'spark-greenhouses',
        ),
        KpiCard(
          title: 'Sensores Online',
          value: '186',
          unit: '/ 192',
          trend: '96.8% uptime',
          trendDirection: 'stable',
          sparklineId: 'spark-sensors',
        ),
        KpiCard(
          title: 'Alertas Activas',
          value: '3',
          unit: '',
          trend: '-5 vs ayer',
          trendDirection: 'down',
          sparklineId: 'spark-alerts',
        ),
        KpiCard(
          title: 'Anomalias Sin Resolver',
          value: '7',
          unit: '',
          trend: '+1 hoy',
          trendDirection: 'up',
          sparklineId: 'spark-anomalies',
        ),
      ]),

      // Sensor overview charts
      div(classes: 'section', [
        h2(classes: 'section__title', [text('Lecturas Globales — Ultimas 24h')]),
        div(classes: 'grid grid--2', [
          div(classes: 'panel', [
            div(classes: 'panel__header', [
              span(classes: 'panel__title', [text('CO2 (ppm)')]),
              span(classes: 'panel__badge badge badge--normal', [text('Normal')]),
            ]),
            SensorChart(
              chartId: 'global-co2',
              sensorType: 'co2',
              unit: 'ppm',
              minBound: 300,
              maxBound: 800,
            ),
          ]),
          div(classes: 'panel', [
            div(classes: 'panel__header', [
              span(classes: 'panel__title', [text('Humedad (%)')]),
              span(classes: 'panel__badge badge badge--normal', [text('Normal')]),
            ]),
            SensorChart(
              chartId: 'global-humidity',
              sensorType: 'humidity',
              unit: '%',
              minBound: 40,
              maxBound: 80,
            ),
          ]),
          div(classes: 'panel', [
            div(classes: 'panel__header', [
              span(classes: 'panel__title', [text('pH')]),
              span(classes: 'panel__badge badge badge--warning', [text('Atencion')]),
            ]),
            SensorChart(
              chartId: 'global-ph',
              sensorType: 'ph',
              unit: '',
              minBound: 5.5,
              maxBound: 6.5,
            ),
          ]),
          div(classes: 'panel', [
            div(classes: 'panel__header', [
              span(classes: 'panel__title', [text('Temperatura (C)')]),
              span(classes: 'panel__badge badge badge--normal', [text('Normal')]),
            ]),
            SensorChart(
              chartId: 'global-temp',
              sensorType: 'temperature',
              unit: 'C',
              minBound: 18,
              maxBound: 28,
            ),
          ]),
        ]),
      ]),

      // Recent alerts
      div(classes: 'section', [
        div(classes: 'section__header', [
          h2(classes: 'section__title', [text('Alertas Recientes')]),
          a(href: '/alerts', classes: 'section__link', [text('Ver todas')]),
        ]),
        div(classes: 'alert-list', [
          AlertItem(
            severity: 'critical',
            title: 'pH fuera de rango critico',
            message: 'pH 4.2 — Limite inferior 5.5. Invernadero #12, Bandeja A3.',
            greenhouse: 'GH-012 (Residencial)',
            timestamp: 'Hace 12 min',
            isResolved: false,
          ),
          AlertItem(
            severity: 'high',
            title: 'Sensor DO desconectado',
            message: 'Sin lectura en 15 min. Ultimo valor: 6.1 mg/L.',
            greenhouse: 'GH-007 (Comercial)',
            timestamp: 'Hace 34 min',
            isResolved: false,
          ),
          AlertItem(
            severity: 'medium',
            title: 'EC elevada',
            message: 'EC 2100 uS/cm — Limite superior 1800. Tendencia ascendente.',
            greenhouse: 'GH-019 (Industrial)',
            timestamp: 'Hace 1h 12min',
            isResolved: false,
          ),
        ]),
      ]),

      // Greenhouse status table
      div(classes: 'section', [
        div(classes: 'section__header', [
          h2(classes: 'section__title', [text('Estado de Invernaderos')]),
          a(href: '/greenhouses', classes: 'section__link', [text('Ver todos')]),
        ]),
        div(classes: 'table-wrapper', [
          table(classes: 'data-table', [
            thead([
              tr([
                th([text('ID')]),
                th([text('Nombre')]),
                th([text('Segmento')]),
                th([text('Sensores')]),
                th([text('Alertas')]),
                th([text('Estado')]),
              ]),
            ]),
            tbody([
              _ghRow('GH-001', 'Invernadero Central', 'industrial', '8/8', '0', 'online'),
              _ghRow('GH-007', 'La Cosecha Fresca', 'commercial', '7/8', '1', 'warning'),
              _ghRow('GH-012', 'Mi Huerta', 'residential', '8/8', '1', 'critical'),
              _ghRow('GH-015', 'Granja Norte', 'industrial', '8/8', '0', 'online'),
              _ghRow('GH-019', 'Hidroponicos Sur', 'industrial', '8/8', '1', 'warning'),
            ]),
          ]),
        ]),
      ]),
    ]);
  }

  Component _ghRow(String id, String name, String segment, String sensors, String alerts, String status) {
    return tr(classes: 'data-table__row data-table__row--$status', [
      td([a(href: '/greenhouses/${id.replaceAll('GH-', '')}', [text(id)])]),
      td([text(name)]),
      td([span(classes: 'badge badge--segment-$segment', [text(segment)])]),
      td([text(sensors)]),
      td([text(alerts)]),
      td([span(classes: 'status-dot status-dot--$status', []), text(' ${status.toUpperCase()}')]),
    ]);
  }
}
