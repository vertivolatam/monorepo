import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

class AlertItem extends StatelessComponent {
  final String severity; // critical, high, medium, low
  final String title;
  final String message;
  final String greenhouse;
  final String timestamp;
  final bool isResolved;

  const AlertItem({
    required this.severity,
    required this.title,
    required this.message,
    required this.greenhouse,
    required this.timestamp,
    required this.isResolved,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'alert-item alert-item--$severity${isResolved ? ' alert-item--resolved' : ''}',
      [
        div(classes: 'alert-item__indicator', []),
        div(classes: 'alert-item__content', [
          div(classes: 'alert-item__header', [
            span(classes: 'alert-item__title', [Component.text(title)]),
            span(classes: 'badge badge--$severity', [
              Component.text(severity.toUpperCase()),
            ]),
          ]),
          p(classes: 'alert-item__message', [Component.text(message)]),
          div(classes: 'alert-item__meta', [
            span([Component.text(greenhouse)]),
            span(classes: 'alert-item__time', [Component.text(timestamp)]),
          ]),
        ]),
      ],
    );
  }
}
