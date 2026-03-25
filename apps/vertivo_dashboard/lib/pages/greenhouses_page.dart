import 'package:jaspr/jaspr.dart';

class GreenhousesPage extends StatelessComponent {
  const GreenhousesPage({super.key});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div(classes: 'page', [
      div(classes: 'page__header', [
        h1([text('Invernaderos')]),
        p(classes: 'page__subtitle', [text('Todos los invernaderos de todos los clientes')]),
      ]),

      // Filters
      div(classes: 'filters', [
        div(classes: 'filter-group', [
          label(attributes: {'for': 'segment-filter'}, [text('Segmento')]),
          select(classes: 'filter-select', id: 'segment-filter', [
            option(value: 'all', [text('Todos')]),
            option(value: 'residential', [text('Residencial')]),
            option(value: 'commercial', [text('Comercial')]),
            option(value: 'industrial', [text('Industrial')]),
          ]),
        ]),
        div(classes: 'filter-group', [
          label(attributes: {'for': 'status-filter'}, [text('Estado')]),
          select(classes: 'filter-select', id: 'status-filter', [
            option(value: 'all', [text('Todos')]),
            option(value: 'online', [text('Online')]),
            option(value: 'warning', [text('Warning')]),
            option(value: 'critical', [text('Critical')]),
            option(value: 'offline', [text('Offline')]),
          ]),
        ]),
        div(classes: 'filter-group', [
          label(attributes: {'for': 'search-gh'}, [text('Buscar')]),
          input(
            classes: 'filter-input',
            id: 'search-gh',
            type: InputType.text,
            attributes: {'placeholder': 'Nombre o ID...'},
            [],
          ),
        ]),
      ]),

      // Greenhouse cards grid
      div(classes: 'grid grid--3', [
        _ghCard('GH-001', 'Invernadero Central', 'industrial', 'online', 'indoor',
            '8/8 sensores', '0 alertas', 'Bogota, Colombia'),
        _ghCard('GH-003', 'Cultivo Express', 'commercial', 'online', 'indoor',
            '8/8 sensores', '0 alertas', 'Lima, Peru'),
        _ghCard('GH-007', 'La Cosecha Fresca', 'commercial', 'warning', 'indoor',
            '7/8 sensores', '1 alerta', 'CDMX, Mexico'),
        _ghCard('GH-012', 'Mi Huerta', 'residential', 'critical', 'indoor',
            '8/8 sensores', '1 alerta', 'Santiago, Chile'),
        _ghCard('GH-015', 'Granja Norte', 'industrial', 'online', 'indoor',
            '8/8 sensores', '0 alertas', 'Medellin, Colombia'),
        _ghCard('GH-019', 'Hidroponicos Sur', 'industrial', 'warning', 'indoor',
            '8/8 sensores', '1 alerta', 'BA, Argentina'),
        _ghCard('GH-021', 'Terraza Verde', 'residential', 'online', 'outdoor',
            '2/2 sensores', '0 alertas', 'Quito, Ecuador'),
        _ghCard('GH-024', 'Agro Lab', 'commercial', 'online', 'soil',
            '3/3 sensores', '0 alertas', 'SP, Brasil'),
      ]),
    ]);
  }

  Component _ghCard(String id, String name, String segment, String status,
      String mode, String sensors, String alerts, String location) {
    return a(href: '/greenhouses/${id.replaceAll('GH-', '')}', classes: 'gh-card gh-card--$status', [
      div(classes: 'gh-card__header', [
        span(classes: 'gh-card__id', [text(id)]),
        span(classes: 'status-dot status-dot--$status', []),
      ]),
      h3(classes: 'gh-card__name', [text(name)]),
      div(classes: 'gh-card__tags', [
        span(classes: 'tag tag--$segment', [text(segment)]),
        span(classes: 'tag tag--mode', [text(mode)]),
      ]),
      div(classes: 'gh-card__stats', [
        div([span(classes: 'gh-card__stat-label', [text('Sensores')]), text(sensors)]),
        div([span(classes: 'gh-card__stat-label', [text('Alertas')]), text(alerts)]),
      ]),
      div(classes: 'gh-card__location', [text(location)]),
    ]);
  }
}
