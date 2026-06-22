import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

/// Shared loading / error / empty states for data-backed pages.
///
/// These exist so a page NEVER silently shows a hardcoded value when the
/// backend is unavailable: a failed fetch renders [errorState] (with the real
/// message), an empty fleet renders [emptyState] — not `'24'`.

Component loadingState([String label = 'Cargando datos…']) {
  return div(classes: 'state state--loading', [
    div(classes: 'state__spinner', []),
    p(classes: 'state__label', [Component.text(label)]),
  ]);
}

Component errorState(Object error, {String? title}) {
  return div(classes: 'state state--error', [
    h3(classes: 'state__title', [Component.text(title ?? 'Sin conexión al backend')]),
    p(classes: 'state__label', [Component.text('$error')]),
    // Server-rendered retry: a plain link reload, no client JS needed.
    a(href: '', classes: 'state__retry', [Component.text('Reintentar')]),
  ]);
}

Component emptyState(String message) {
  return div(classes: 'state state--empty', [
    p(classes: 'state__label', [Component.text(message)]),
  ]);
}
