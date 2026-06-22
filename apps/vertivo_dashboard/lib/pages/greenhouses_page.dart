import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:vertivo_client/vertivo_client.dart';

import '../components/async_states.dart';
import '../data/client.dart';
import '../data/fleet_repository.dart';

/// Fleet listing — every greenhouse across all tenants (admin/operator view).
///
/// Server-rendered: fetches the cross-tenant fleet, renders real cards or an
/// explicit loading/error/empty state. No hardcoded GH-NNN / "Hydroponics"
/// literals (regla #6 aeroponic-only): names + irrigationType come from the DB.
class GreenhousesPage extends AsyncStatelessComponent {
  const GreenhousesPage({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final repo = FleetRepository(backendClient);
    final List<Greenhouse> fleet;
    try {
      fleet = (await repo.fetch()).greenhouses;
    } catch (e) {
      return div(classes: 'page', [
        _header(),
        errorState(e, title: 'No se pudo cargar la flota'),
      ]);
    }

    if (fleet.isEmpty) {
      return div(classes: 'page', [
        _header(),
        emptyState('No hay invernaderos en la flota todavía.'),
      ]);
    }

    return div(classes: 'page', [
      _header(),
      div(classes: 'grid grid--3', [for (final g in fleet) _card(g)]),
    ]);
  }

  Component _header() {
    return div(classes: 'page__header', [
      h1([Component.text('Invernaderos')]),
      p(classes: 'page__subtitle', [
        Component.text('Toda la flota — todos los clientes'),
      ]),
    ]);
  }

  Component _card(Greenhouse g) {
    return a(href: '/greenhouses/${g.id}', classes: 'gh-card', [
      div(classes: 'gh-card__header', [
        span(classes: 'gh-card__id', [Component.text('GH-${g.id}')]),
      ]),
      h3(classes: 'gh-card__name', [Component.text(g.name)]),
      div(classes: 'gh-card__tags', [
        span(classes: 'tag tag--mode', [Component.text(g.irrigationType)]),
        if (g.climateType != null)
          span(classes: 'tag', [Component.text(g.climateType!)]),
      ]),
      div(classes: 'gh-card__stats', [
        div([
          span(classes: 'gh-card__stat-label', [Component.text('Cliente')]),
          Component.text(g.userId),
        ]),
        div([
          span(classes: 'gh-card__stat-label', [Component.text('Bandejas')]),
          Component.text('${g.totalTrays}'),
        ]),
      ]),
      div(classes: 'gh-card__location', [Component.text(g.location ?? '—')]),
    ]);
  }
}
