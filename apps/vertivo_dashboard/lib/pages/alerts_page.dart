import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import '../components/alert_item.dart';

class AlertsPage extends StatelessComponent {
  const AlertsPage({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'page', [
      div(classes: 'page__header', [
        h1([Component.text('Alertas')]),
        p(classes: 'page__subtitle', [
          Component.text('Centro de alertas de todos los invernaderos'),
        ]),
      ]),

      // Summary badges
      div(classes: 'alert-summary', [
        div(classes: 'alert-summary__item alert-summary__item--critical', [
          span(classes: 'alert-summary__count', [Component.text('1')]),
          span([Component.text('Critica')]),
        ]),
        div(classes: 'alert-summary__item alert-summary__item--high', [
          span(classes: 'alert-summary__count', [Component.text('1')]),
          span([Component.text('Alta')]),
        ]),
        div(classes: 'alert-summary__item alert-summary__item--medium', [
          span(classes: 'alert-summary__count', [Component.text('1')]),
          span([Component.text('Media')]),
        ]),
        div(classes: 'alert-summary__item alert-summary__item--low', [
          span(classes: 'alert-summary__count', [Component.text('4')]),
          span([Component.text('Baja')]),
        ]),
        div(classes: 'alert-summary__item alert-summary__item--resolved', [
          span(classes: 'alert-summary__count', [Component.text('23')]),
          span([Component.text('Resueltas hoy')]),
        ]),
      ]),

      // Filters
      div(classes: 'filters', [
        div(classes: 'filter-group', [
          label(
            attributes: {'for': 'severity-filter'},
            [Component.text('Severidad')],
          ),
          select(classes: 'filter-select', id: 'severity-filter', [
            option(value: 'all', [Component.text('Todas')]),
            option(value: 'critical', [Component.text('Critica')]),
            option(value: 'high', [Component.text('Alta')]),
            option(value: 'medium', [Component.text('Media')]),
            option(value: 'low', [Component.text('Baja')]),
          ]),
        ]),
        div(classes: 'filter-group', [
          label(
            attributes: {'for': 'alert-status-filter'},
            [Component.text('Estado')],
          ),
          select(classes: 'filter-select', id: 'alert-status-filter', [
            option(value: 'active', [Component.text('Activas')]),
            option(value: 'acknowledged', [Component.text('Reconocidas')]),
            option(value: 'resolved', [Component.text('Resueltas')]),
            option(value: 'all', [Component.text('Todas')]),
          ]),
        ]),
      ]),

      // Alert list
      div(classes: 'alert-list', [
        AlertItem(
          severity: 'critical',
          title: 'pH fuera de rango critico',
          message:
              'pH 4.2 — Limite inferior 5.5. Invernadero GH-012, Bandeja A3. Posible falla en dosificador de solucion nutritiva.',
          greenhouse: 'GH-012 — Mi Huerta (Residencial)',
          timestamp: 'Hace 12 min',
          isResolved: false,
        ),
        AlertItem(
          severity: 'high',
          title: 'Sensor DO desconectado',
          message:
              'Sin lectura de oxigeno disuelto en 15 min. Ultimo valor: 6.1 mg/L. Verificar conexion I2C (0x61).',
          greenhouse: 'GH-007 — La Cosecha Fresca (Comercial)',
          timestamp: 'Hace 34 min',
          isResolved: false,
        ),
        AlertItem(
          severity: 'medium',
          title: 'EC elevada persistente',
          message:
              'EC 2100 uS/cm — Limite superior 1800. Tendencia ascendente por 2h. Considerar flush del sistema.',
          greenhouse: 'GH-019 — Hidroponicos Sur (Industrial)',
          timestamp: 'Hace 1h 12min',
          isResolved: false,
        ),
        AlertItem(
          severity: 'low',
          title: 'Humedad por debajo del optimo',
          message:
              'Humedad 38% — Limite inferior 40%. Variacion menor, monitorear.',
          greenhouse: 'GH-003 — Cultivo Express (Comercial)',
          timestamp: 'Hace 2h 45min',
          isResolved: false,
        ),
        AlertItem(
          severity: 'medium',
          title: 'Temperatura nocturna alta',
          message:
              'Temperatura 29.1 C a las 02:00. Ciclo nocturno esperaba < 24 C. Verificar ventilacion.',
          greenhouse: 'GH-015 — Granja Norte (Industrial)',
          timestamp: 'Hace 6h',
          isResolved: true,
        ),
      ]),
    ]);
  }
}
