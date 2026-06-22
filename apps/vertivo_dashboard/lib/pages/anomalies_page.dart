import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

class AnomaliesPage extends StatelessComponent {
  const AnomaliesPage({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'page', [
      div(classes: 'page__header', [
        h1([Component.text('Anomalias')]),
        p(classes: 'page__subtitle', [
          Component.text('Deteccion y clasificacion de anomalias en sensores'),
        ]),
      ]),

      // Summary
      div(classes: 'grid grid--4', [
        _statCard('Sin Resolver', '7', 'critical'),
        _statCard('En Investigacion', '3', 'warning'),
        _statCard('Resueltas Hoy', '12', 'normal'),
        _statCard('Deteccion IA', '68%', 'info'),
      ]),

      // Anomaly table
      div(classes: 'section', [
        h2(classes: 'section__title', [Component.text('Anomalias Activas')]),
        div(classes: 'table-wrapper', [
          table(classes: 'data-table', [
            thead([
              tr([
                th([Component.text('ID')]),
                th([Component.text('Invernadero')]),
                th([Component.text('Tipo')]),
                th([Component.text('Severidad')]),
                th([Component.text('Deteccion')]),
                th([Component.text('Sensor')]),
                th([Component.text('Esperado')]),
                th([Component.text('Actual')]),
                th([Component.text('Desviacion')]),
                th([Component.text('Fecha')]),
              ]),
            ]),
            tbody([
              _anomalyRow(
                'A-042',
                'GH-012',
                'out_of_range',
                'critical',
                'sensor',
                'pH',
                '5.5-6.5',
                '4.2',
                '-23.6%',
                '09 Mar 14:23',
              ),
              _anomalyRow(
                'A-041',
                'GH-007',
                'sensor_failure',
                'high',
                'rule_based',
                'DO',
                '5.0-8.0',
                'NaN',
                '—',
                '09 Mar 14:01',
              ),
              _anomalyRow(
                'A-040',
                'GH-019',
                'drift',
                'medium',
                'ai',
                'EC',
                '1200-1800',
                '2100',
                '+16.7%',
                '09 Mar 13:15',
              ),
              _anomalyRow(
                'A-039',
                'GH-003',
                'out_of_range',
                'low',
                'sensor',
                'Humedad',
                '40-80',
                '38',
                '-5.0%',
                '09 Mar 11:42',
              ),
              _anomalyRow(
                'A-038',
                'GH-015',
                'spike',
                'medium',
                'ai',
                'Temp',
                '18-28',
                '34.2',
                '+22.1%',
                '09 Mar 08:30',
              ),
              _anomalyRow(
                'A-037',
                'GH-001',
                'drift',
                'low',
                'ai',
                'ORP',
                '300-500',
                '285',
                '-5.0%',
                '09 Mar 07:15',
              ),
              _anomalyRow(
                'A-036',
                'GH-024',
                'calibration',
                'medium',
                'manual',
                'pH',
                '5.5-6.5',
                '7.8',
                '+20.0%',
                '08 Mar 22:00',
              ),
            ]),
          ]),
        ]),
      ]),

      // Detection methods breakdown
      div(classes: 'section', [
        h2(classes: 'section__title', [
          Component.text('Metodos de Deteccion — Ultimo Mes'),
        ]),
        div(classes: 'grid grid--4', [
          _methodCard(
            'IA / ML',
            '68%',
            '142 detecciones',
            'Ornstein-Uhlenbeck + bounds',
          ),
          _methodCard(
            'Reglas',
            '18%',
            '38 detecciones',
            'Threshold + rate-of-change',
          ),
          _methodCard(
            'Sensor',
            '10%',
            '21 detecciones',
            'NaN / timeout / desconexion',
          ),
          _methodCard('Manual', '4%', '8 detecciones', 'Reporte de operador'),
        ]),
      ]),
    ]);
  }

  Component _statCard(String label, String value, String variant) {
    return div(classes: 'stat-card stat-card--$variant', [
      span(classes: 'stat-card__value', [Component.text(value)]),
      span(classes: 'stat-card__label', [Component.text(label)]),
    ]);
  }

  Component _anomalyRow(
    String id,
    String gh,
    String type,
    String severity,
    String detection,
    String sensor,
    String expected,
    String actual,
    String deviation,
    String date,
  ) {
    return tr(classes: 'data-table__row', [
      td([Component.text(id)]),
      td([
        a(href: '/greenhouses/${gh.replaceAll('GH-', '')}', [
          Component.text(gh),
        ]),
      ]),
      td([
        span(classes: 'tag tag--anomaly-$type', [Component.text(type)]),
      ]),
      td([
        span(classes: 'badge badge--$severity', [Component.text(severity)]),
      ]),
      td([
        span(classes: 'tag tag--detection-$detection', [
          Component.text(detection),
        ]),
      ]),
      td([Component.text(sensor)]),
      td(classes: 'data-table__mono', [Component.text(expected)]),
      td(classes: 'data-table__mono data-table__mono--$severity', [
        Component.text(actual),
      ]),
      td(classes: 'data-table__mono', [Component.text(deviation)]),
      td(classes: 'data-table__date', [Component.text(date)]),
    ]);
  }

  Component _methodCard(
    String title,
    String percentage,
    String count,
    String desc,
  ) {
    return div(classes: 'method-card', [
      div(classes: 'method-card__header', [
        span(classes: 'method-card__pct', [Component.text(percentage)]),
        span(classes: 'method-card__title', [Component.text(title)]),
      ]),
      span(classes: 'method-card__count', [Component.text(count)]),
      p(classes: 'method-card__desc', [Component.text(desc)]),
    ]);
  }
}
