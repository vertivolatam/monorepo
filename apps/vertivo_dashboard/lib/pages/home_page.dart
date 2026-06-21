import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:vertivo_client/vertivo_client.dart';

import '../components/async_states.dart';
import '../components/kpi_card.dart';
import '../data/client.dart';
import '../data/fleet_repository.dart';

/// Dashboard home — fleet overview for the admin/operator cockpit.
///
/// Server-rendered (`AsyncStatelessComponent`): it fetches the cross-tenant
/// fleet from Serverpod and renders real data, or an explicit loading/error/
/// empty state — never a hardcoded number.
class HomePage extends AsyncStatelessComponent {
  const HomePage({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final repo = FleetRepository(backendClient);
    final FleetSnapshot snapshot;
    try {
      snapshot = await repo.fetch();
    } catch (e) {
      return div(classes: 'page', [
        _header(),
        errorState(e, title: 'No se pudo cargar la flota'),
      ]);
    }

    if (snapshot.greenhouses.isEmpty) {
      return div(classes: 'page', [
        _header(),
        emptyState('No hay invernaderos en la flota todavía.'),
      ]);
    }

    return div(classes: 'page', [
      _header(),
      _kpis(snapshot),
      _recentAlerts(snapshot.greenhouses),
      _fleetTable(snapshot.greenhouses),
    ]);
  }

  Component _header() {
    return div(classes: 'page__header', [
      h1([Component.text('Dashboard')]),
      p(classes: 'page__subtitle', [
        Component.text('Monitoreo en tiempo real de toda la flota'),
      ]),
    ]);
  }

  Component _kpis(FleetSnapshot s) {
    return div(classes: 'grid grid--4', [
      KpiCard(
        title: 'Invernaderos Activos',
        value: '${s.activeGreenhouses}',
        unit: '',
        trend: 'flota completa',
        trendDirection: 'stable',
        sparklineId: 'spark-greenhouses',
      ),
      // No aggregate "sensors online" endpoint exists yet → N/D, not invented.
      const KpiCard(
        title: 'Sensores Online',
        value: 'N/D',
        unit: '',
        trend: 'sin endpoint agregado',
        trendDirection: 'stable',
        sparklineId: 'spark-sensors',
      ),
      KpiCard(
        title: 'Alertas Sin Leer',
        value: '${s.unreadAlerts}',
        unit: '',
        trend: 'sesión actual',
        trendDirection: s.unreadAlerts > 0 ? 'up' : 'stable',
        sparklineId: 'spark-alerts',
      ),
      // No aggregate cross-fleet anomaly count endpoint yet → N/D.
      const KpiCard(
        title: 'Anomalías Globales',
        value: 'N/D',
        unit: '',
        trend: 'sin endpoint agregado',
        trendDirection: 'stable',
        sparklineId: 'spark-anomalies',
      ),
    ]);
  }

  Component _recentAlerts(List<Greenhouse> fleet) {
    return div(classes: 'section', [
      div(classes: 'section__header', [
        h2(classes: 'section__title', [Component.text('Alertas Recientes')]),
        a(href: '/alerts', classes: 'section__link', [Component.text('Ver todas')]),
      ]),
      // Recent alerts are wired in alerts_page; the home strip is a future
      // per-fleet aggregate (needs an endpoint). Shown empty, not faked.
      emptyState('El detalle de alertas está en la sección Alertas.'),
    ]);
  }

  Component _fleetTable(List<Greenhouse> fleet) {
    return div(classes: 'section', [
      div(classes: 'section__header', [
        h2(classes: 'section__title', [Component.text('Estado de Invernaderos')]),
        a(href: '/greenhouses', classes: 'section__link', [Component.text('Ver todos')]),
      ]),
      div(classes: 'table-wrapper', [
        table(classes: 'data-table', [
          thead([
            tr([
              th([Component.text('ID')]),
              th([Component.text('Nombre')]),
              th([Component.text('Cliente')]),
              th([Component.text('Irrigación')]),
              th([Component.text('Ubicación')]),
            ]),
          ]),
          tbody([
            for (final g in fleet) _row(g),
          ]),
        ]),
      ]),
    ]);
  }

  Component _row(Greenhouse g) {
    return tr(classes: 'data-table__row', [
      td([
        a(href: '/greenhouses/${g.id}', [Component.text('GH-${g.id}')]),
      ]),
      td([Component.text(g.name)]),
      td([Component.text(g.userId)]),
      td([Component.text(g.irrigationType)]),
      td([Component.text(g.location ?? '—')]),
    ]);
  }
}
