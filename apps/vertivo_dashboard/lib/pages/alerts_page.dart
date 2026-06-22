import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:vertivo_client/vertivo_client.dart';

import '../components/alert_item.dart';
import '../components/async_states.dart';
import '../data/alerts_repository.dart';
import '../data/client.dart';

/// Alerts center — the current admin session's alerts, real data.
class AlertsPage extends AsyncStatelessComponent {
  const AlertsPage({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final repo = AlertsRepository(backendClient);
    final List<Alert> alerts;
    try {
      alerts = await repo.fetch();
    } catch (e) {
      return div(classes: 'page', [
        _header(),
        errorState(e, title: 'No se pudieron cargar las alertas'),
      ]);
    }

    if (alerts.isEmpty) {
      return div(classes: 'page', [
        _header(),
        emptyState('No hay alertas para esta sesión.'),
      ]);
    }

    return div(classes: 'page', [
      _header(),
      _summary(alerts),
      div(classes: 'alert-list', [for (final a in alerts) _item(a)]),
    ]);
  }

  Component _header() {
    return div(classes: 'page__header', [
      h1([Component.text('Alertas')]),
      p(classes: 'page__subtitle', [
        Component.text('Centro de alertas de la sesión'),
      ]),
    ]);
  }

  Component _summary(List<Alert> alerts) {
    int count(String s) => alerts.where((al) => al.severity == s).length;
    final resolved = alerts.where((al) => al.isResolved).length;
    return div(classes: 'alert-summary', [
      _badge('critical', count('critical'), 'Crítica'),
      _badge('high', count('high'), 'Alta'),
      _badge('medium', count('medium'), 'Media'),
      _badge('low', count('low'), 'Baja'),
      _badge('resolved', resolved, 'Resueltas'),
    ]);
  }

  Component _badge(String variant, int n, String label) {
    return div(classes: 'alert-summary__item alert-summary__item--$variant', [
      span(classes: 'alert-summary__count', [Component.text('$n')]),
      span([Component.text(label)]),
    ]);
  }

  Component _item(Alert a) {
    return AlertItem(
      severity: a.severity,
      title: a.title,
      message: a.message,
      greenhouse: a.greenhouseId != null ? 'GH-${a.greenhouseId}' : '—',
      timestamp: a.createdAt.toIso8601String(),
      isResolved: a.isResolved,
    );
  }
}
