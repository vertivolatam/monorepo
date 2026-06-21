import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

class UsersPage extends StatelessComponent {
  const UsersPage({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'page', [
      div(classes: 'page__header', [
        h1([Component.text('Usuarios')]),
        p(classes: 'page__subtitle', [
          Component.text('Gestion de clientes por segmento'),
        ]),
      ]),

      // Segment summary
      div(classes: 'grid grid--4', [
        _segmentCard('Residencial', '156', '\$100-200/mes', '312 invernaderos'),
        _segmentCard('Comercial', '42', '\$200+/mes', '89 invernaderos'),
        _segmentCard('Industrial', '8', '\$15,000+ impl.', '24 invernaderos'),
        _segmentCard('Expertos', '5', '—', 'Catalogo + Anomalias'),
      ]),

      // Users table
      div(classes: 'section', [
        div(classes: 'section__header', [
          h2(classes: 'section__title', [Component.text('Usuarios Activos')]),
        ]),

        // Filters
        div(classes: 'filters', [
          div(classes: 'filter-group', [
            label(
              attributes: {'for': 'user-segment'},
              [Component.text('Segmento')],
            ),
            select(classes: 'filter-select', id: 'user-segment', [
              option(value: 'all', [Component.text('Todos')]),
              option(value: 'residential', [Component.text('Residencial')]),
              option(value: 'commercial', [Component.text('Comercial')]),
              option(value: 'industrial', [Component.text('Industrial')]),
              option(value: 'expert', [Component.text('Experto')]),
            ]),
          ]),
          div(classes: 'filter-group', [
            label(
              attributes: {'for': 'user-search'},
              [Component.text('Buscar')],
            ),
            input(
              classes: 'filter-input',
              id: 'user-search',
              type: InputType.text,
              attributes: {'placeholder': 'Email o nombre...'},
            ),
          ]),
        ]),

        div(classes: 'table-wrapper', [
          table(classes: 'data-table', [
            thead([
              tr([
                th([Component.text('ID')]),
                th([Component.text('Nombre')]),
                th([Component.text('Email')]),
                th([Component.text('Segmento')]),
                th([Component.text('Invernaderos')]),
                th([Component.text('2FA')]),
                th([Component.text('Ultimo Login')]),
                th([Component.text('Estado')]),
              ]),
            ]),
            tbody([
              _userRow(
                '1',
                'Carlos Mendez',
                'carlos@gmail.com',
                'residential',
                '2',
                false,
                'Hace 2h',
                true,
              ),
              _userRow(
                '2',
                'Maria Rodriguez',
                'maria@lacosechafresca.com',
                'commercial',
                '3',
                true,
                'Hace 30min',
                true,
              ),
              _userRow(
                '3',
                'Inversiones Agro SA',
                'ops@invagro.com',
                'industrial',
                '6',
                true,
                'Hace 5min',
                true,
              ),
              _userRow(
                '4',
                'Ana Torres',
                'ana@gmail.com',
                'residential',
                '1',
                false,
                'Hace 3 dias',
                true,
              ),
              _userRow(
                '5',
                'Dr. Felipe Vargas',
                'fvargas@agro.edu',
                'expert',
                '0',
                true,
                'Hace 1h',
                true,
              ),
              _userRow(
                '6',
                'Restaurante Nativo',
                'chef@nativo.co',
                'commercial',
                '2',
                true,
                'Hace 4h',
                true,
              ),
              _userRow(
                '7',
                'Pedro Gonzalez',
                'pedro@hotmail.com',
                'residential',
                '1',
                false,
                'Hace 15 dias',
                false,
              ),
            ]),
          ]),
        ]),
      ]),
    ]);
  }

  Component _segmentCard(
    String segment,
    String count,
    String pricing,
    String detail,
  ) {
    return div(classes: 'segment-card', [
      h3(classes: 'segment-card__title', [Component.text(segment)]),
      span(classes: 'segment-card__count', [Component.text(count)]),
      span(classes: 'segment-card__label', [Component.text('usuarios')]),
      div(classes: 'segment-card__detail', [
        span([Component.text(pricing)]),
        span([Component.text(detail)]),
      ]),
    ]);
  }

  Component _userRow(
    String id,
    String name,
    String email,
    String segment,
    String greenhouses,
    bool twoFa,
    String lastLogin,
    bool active,
  ) {
    return tr(
      classes: 'data-table__row${!active ? ' data-table__row--inactive' : ''}',
      [
        td([Component.text(id)]),
        td([Component.text(name)]),
        td(classes: 'data-table__mono', [Component.text(email)]),
        td([
          span(classes: 'badge badge--segment-$segment', [
            Component.text(segment),
          ]),
        ]),
        td([Component.text(greenhouses)]),
        td([Component.text(twoFa ? 'Si' : 'No')]),
        td(classes: 'data-table__date', [Component.text(lastLogin)]),
        td([
          span(
            classes: 'status-dot status-dot--${active ? 'online' : 'offline'}',
            [],
          ),
          Component.text(active ? ' Activo' : ' Inactivo'),
        ]),
      ],
    );
  }
}
