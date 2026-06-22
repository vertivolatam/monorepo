import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:vertivo_client/vertivo_client.dart';

import '../components/async_states.dart';
import '../data/client.dart';
import '../data/users_repository.dart';

/// Users — admin view of clients across all segments.
class UsersPage extends AsyncStatelessComponent {
  const UsersPage({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final repo = UsersRepository(backendClient);
    final List<User> users;
    try {
      users = await repo.fetchAll();
    } catch (e) {
      return div(classes: 'page', [
        _header(),
        errorState(e, title: 'No se pudieron cargar los usuarios'),
      ]);
    }

    if (users.isEmpty) {
      return div(classes: 'page', [
        _header(),
        emptyState('No hay usuarios registrados.'),
      ]);
    }

    return div(classes: 'page', [
      _header(),
      div(classes: 'section', [
        div(classes: 'table-wrapper', [
          table(classes: 'data-table', [
            thead([
              tr([
                for (final h in const [
                  'ID',
                  'Nombre',
                  'Email',
                  'Segmento',
                  '2FA',
                  'Último Login',
                  'Estado',
                ])
                  th([Component.text(h)]),
              ]),
            ]),
            tbody([for (final u in users) _row(u)]),
          ]),
        ]),
      ]),
    ]);
  }

  Component _header() {
    return div(classes: 'page__header', [
      h1([Component.text('Usuarios')]),
      p(classes: 'page__subtitle', [
        Component.text('Clientes por segmento — vista de operador'),
      ]),
    ]);
  }

  Component _row(User u) {
    return tr(
      classes:
          'data-table__row${!u.isActive ? ' data-table__row--inactive' : ''}',
      [
        td([Component.text('${u.id ?? '—'}')]),
        td([Component.text(u.displayName)]),
        td(classes: 'data-table__mono', [Component.text(u.email)]),
        td([
          span(classes: 'badge badge--segment-${u.segment}', [
            Component.text(u.segment),
          ]),
        ]),
        td([Component.text(u.twoFactorEnabled ? 'Sí' : 'No')]),
        td(classes: 'data-table__date', [
          Component.text(u.lastLoginAt?.toIso8601String() ?? '—'),
        ]),
        td([
          span(
            classes:
                'status-dot status-dot--${u.isActive ? 'online' : 'offline'}',
            [],
          ),
          Component.text(u.isActive ? ' Activo' : ' Inactivo'),
        ]),
      ],
    );
  }
}
