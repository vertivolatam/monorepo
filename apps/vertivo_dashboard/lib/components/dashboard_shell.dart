import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

class DashboardShell extends StatelessComponent {
  final Component child;

  const DashboardShell({required this.child, super.key});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div(classes: 'dashboard', [
      // Sidebar
      nav(classes: 'sidebar', [
        div(classes: 'sidebar__brand', [
          div(classes: 'sidebar__logo', [text('V')]),
          span([text('Vertivo')]),
        ]),
        div(classes: 'sidebar__nav', [
          _navItem(context, '/', 'Dashboard', 'grid'),
          _navItem(context, '/greenhouses', 'Invernaderos', 'plant'),
          _navItem(context, '/alerts', 'Alertas', 'bell'),
          _navItem(context, '/anomalies', 'Anomalias', 'warning'),
          _navItem(context, '/users', 'Usuarios', 'users'),
        ]),
        div(classes: 'sidebar__footer', [
          div(classes: 'sidebar__status', [
            span(classes: 'status-dot status-dot--online', []),
            span([text('EMQX Conectado')]),
          ]),
          div(classes: 'sidebar__version', [
            text('v0.1.0'),
          ]),
        ]),
      ]),
      // Main content
      div(classes: 'main', [
        // Top bar
        header(classes: 'topbar', [
          div(classes: 'topbar__search', [
            input(classes: 'topbar__input', type: InputType.text, attributes: {'placeholder': 'Buscar invernadero, sensor, alerta...'}, []),
          ]),
          div(classes: 'topbar__actions', [
            div(classes: 'topbar__badge', [
              span(classes: 'badge badge--critical', [text('3')]),
              span([text('Alertas')]),
            ]),
            div(classes: 'topbar__user', [
              span([text('Admin')]),
            ]),
          ]),
        ]),
        // Content area
        main_(classes: 'content', [
          child,
        ]),
      ]),
    ]);
  }

  Component _navItem(BuildContext context, String path, String label, String icon) {
    final currentPath = RouteState.of(context).location;
    final isActive = currentPath == path ||
        (path != '/' && currentPath.startsWith(path));
    return Link(
      to: path,
      classes: 'nav-item${isActive ? ' nav-item--active' : ''}',
      child: div([
        span(classes: 'material-symbols-outlined nav-item__icon${isActive ? ' filled' : ''}', [text(_iconFor(icon))]),
        span(classes: 'nav-item__label', [text(label)]),
      ]),
    );
  }

  /// Material Symbols icon names (M3 Expressive)
  String _iconFor(String icon) {
    return switch (icon) {
      'grid' => 'dashboard',
      'plant' => 'eco',
      'bell' => 'notifications',
      'warning' => 'warning',
      'users' => 'group',
      _ => 'circle',
    };
  }
}
