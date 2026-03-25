import 'package:jaspr/jaspr.dart';

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
  Iterable<Component> build(BuildContext context) sync* {
    yield div(classes: 'alert-item alert-item--$severity${isResolved ? ' alert-item--resolved' : ''}', [
      div(classes: 'alert-item__indicator', []),
      div(classes: 'alert-item__content', [
        div(classes: 'alert-item__header', [
          span(classes: 'alert-item__title', [text(title)]),
          span(classes: 'badge badge--$severity', [text(severity.toUpperCase())]),
        ]),
        p(classes: 'alert-item__message', [text(message)]),
        div(classes: 'alert-item__meta', [
          span([text(greenhouse)]),
          span(classes: 'alert-item__time', [text(timestamp)]),
        ]),
      ]),
    ]);
  }
}
