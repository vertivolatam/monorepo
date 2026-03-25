import 'package:jaspr/jaspr.dart';

class UsersPage extends StatelessComponent {
  const UsersPage({super.key});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div(classes: 'page', [
      div(classes: 'page__header', [
        h1([text('Usuarios')]),
        p(classes: 'page__subtitle', [text('Gestion de clientes por segmento')]),
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
          h2(classes: 'section__title', [text('Usuarios Activos')]),
        ]),

        // Filters
        div(classes: 'filters', [
          div(classes: 'filter-group', [
            label(attributes: {'for': 'user-segment'}, [text('Segmento')]),
            select(classes: 'filter-select', id: 'user-segment', [
              option(value: 'all', [text('Todos')]),
              option(value: 'residential', [text('Residencial')]),
              option(value: 'commercial', [text('Comercial')]),
              option(value: 'industrial', [text('Industrial')]),
              option(value: 'expert', [text('Experto')]),
            ]),
          ]),
          div(classes: 'filter-group', [
            label(attributes: {'for': 'user-search'}, [text('Buscar')]),
            input(
              classes: 'filter-input',
              id: 'user-search',
              type: InputType.text,
              attributes: {'placeholder': 'Email o nombre...'},
              [],
            ),
          ]),
        ]),

        div(classes: 'table-wrapper', [
          table(classes: 'data-table', [
            thead([
              tr([
                th([text('ID')]),
                th([text('Nombre')]),
                th([text('Email')]),
                th([text('Segmento')]),
                th([text('Invernaderos')]),
                th([text('2FA')]),
                th([text('Ultimo Login')]),
                th([text('Estado')]),
              ]),
            ]),
            tbody([
              _userRow('1', 'Carlos Mendez', 'carlos@gmail.com', 'residential', '2', false, 'Hace 2h', true),
              _userRow('2', 'Maria Rodriguez', 'maria@lacosechafresca.com', 'commercial', '3', true, 'Hace 30min', true),
              _userRow('3', 'Inversiones Agro SA', 'ops@invagro.com', 'industrial', '6', true, 'Hace 5min', true),
              _userRow('4', 'Ana Torres', 'ana@gmail.com', 'residential', '1', false, 'Hace 3 dias', true),
              _userRow('5', 'Dr. Felipe Vargas', 'fvargas@agro.edu', 'expert', '0', true, 'Hace 1h', true),
              _userRow('6', 'Restaurante Nativo', 'chef@nativo.co', 'commercial', '2', true, 'Hace 4h', true),
              _userRow('7', 'Pedro Gonzalez', 'pedro@hotmail.com', 'residential', '1', false, 'Hace 15 dias', false),
            ]),
          ]),
        ]),
      ]),
    ]);
  }

  Component _segmentCard(String segment, String count, String pricing, String detail) {
    return div(classes: 'segment-card', [
      h3(classes: 'segment-card__title', [text(segment)]),
      span(classes: 'segment-card__count', [text(count)]),
      span(classes: 'segment-card__label', [text('usuarios')]),
      div(classes: 'segment-card__detail', [
        span([text(pricing)]),
        span([text(detail)]),
      ]),
    ]);
  }

  Component _userRow(String id, String name, String email, String segment,
      String greenhouses, bool twoFa, String lastLogin, bool active) {
    return tr(classes: 'data-table__row${!active ? ' data-table__row--inactive' : ''}', [
      td([text(id)]),
      td([text(name)]),
      td(classes: 'data-table__mono', [text(email)]),
      td([span(classes: 'badge badge--segment-$segment', [text(segment)])]),
      td([text(greenhouses)]),
      td([text(twoFa ? 'Si' : 'No')]),
      td(classes: 'data-table__date', [text(lastLogin)]),
      td([
        span(classes: 'status-dot status-dot--${active ? 'online' : 'offline'}', []),
        text(active ? ' Activo' : ' Inactivo'),
      ]),
    ]);
  }
}
