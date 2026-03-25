import 'package:jaspr/jaspr.dart';

import '../components/alert_item.dart';

class AlertsPage extends StatelessComponent {
  const AlertsPage({super.key});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div(classes: 'page', [
      div(classes: 'page__header', [
        h1([text('Alertas')]),
        p(classes: 'page__subtitle', [text('Centro de alertas de todos los invernaderos')]),
      ]),

      // Summary badges
      div(classes: 'alert-summary', [
        div(classes: 'alert-summary__item alert-summary__item--critical', [
          span(classes: 'alert-summary__count', [text('1')]),
          span([text('Critica')]),
        ]),
        div(classes: 'alert-summary__item alert-summary__item--high', [
          span(classes: 'alert-summary__count', [text('1')]),
          span([text('Alta')]),
        ]),
        div(classes: 'alert-summary__item alert-summary__item--medium', [
          span(classes: 'alert-summary__count', [text('1')]),
          span([text('Media')]),
        ]),
        div(classes: 'alert-summary__item alert-summary__item--low', [
          span(classes: 'alert-summary__count', [text('4')]),
          span([text('Baja')]),
        ]),
        div(classes: 'alert-summary__item alert-summary__item--resolved', [
          span(classes: 'alert-summary__count', [text('23')]),
          span([text('Resueltas hoy')]),
        ]),
      ]),

      // Filters
      div(classes: 'filters', [
        div(classes: 'filter-group', [
          label(attributes: {'for': 'severity-filter'}, [text('Severidad')]),
          select(classes: 'filter-select', id: 'severity-filter', [
            option(value: 'all', [text('Todas')]),
            option(value: 'critical', [text('Critica')]),
            option(value: 'high', [text('Alta')]),
            option(value: 'medium', [text('Media')]),
            option(value: 'low', [text('Baja')]),
          ]),
        ]),
        div(classes: 'filter-group', [
          label(attributes: {'for': 'alert-status-filter'}, [text('Estado')]),
          select(classes: 'filter-select', id: 'alert-status-filter', [
            option(value: 'active', [text('Activas')]),
            option(value: 'acknowledged', [text('Reconocidas')]),
            option(value: 'resolved', [text('Resueltas')]),
            option(value: 'all', [text('Todas')]),
          ]),
        ]),
      ]),

      // Alert list
      div(classes: 'alert-list', [
        AlertItem(
          severity: 'critical',
          title: 'pH fuera de rango critico',
          message: 'pH 4.2 — Limite inferior 5.5. Invernadero GH-012, Bandeja A3. Posible falla en dosificador de solucion nutritiva.',
          greenhouse: 'GH-012 — Mi Huerta (Residencial)',
          timestamp: 'Hace 12 min',
          isResolved: false,
        ),
        AlertItem(
          severity: 'high',
          title: 'Sensor DO desconectado',
          message: 'Sin lectura de oxigeno disuelto en 15 min. Ultimo valor: 6.1 mg/L. Verificar conexion I2C (0x61).',
          greenhouse: 'GH-007 — La Cosecha Fresca (Comercial)',
          timestamp: 'Hace 34 min',
          isResolved: false,
        ),
        AlertItem(
          severity: 'medium',
          title: 'EC elevada persistente',
          message: 'EC 2100 uS/cm — Limite superior 1800. Tendencia ascendente por 2h. Considerar flush del sistema.',
          greenhouse: 'GH-019 — Hidroponicos Sur (Industrial)',
          timestamp: 'Hace 1h 12min',
          isResolved: false,
        ),
        AlertItem(
          severity: 'low',
          title: 'Humedad por debajo del optimo',
          message: 'Humedad 38% — Limite inferior 40%. Variacion menor, monitorear.',
          greenhouse: 'GH-003 — Cultivo Express (Comercial)',
          timestamp: 'Hace 2h 45min',
          isResolved: false,
        ),
        AlertItem(
          severity: 'medium',
          title: 'Temperatura nocturna alta',
          message: 'Temperatura 29.1 C a las 02:00. Ciclo nocturno esperaba < 24 C. Verificar ventilacion.',
          greenhouse: 'GH-015 — Granja Norte (Industrial)',
          timestamp: 'Hace 6h',
          isResolved: true,
        ),
      ]),
    ]);
  }
}
