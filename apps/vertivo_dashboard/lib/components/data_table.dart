import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

class DataTable extends StatelessComponent {
  final List<String> headers;
  final List<List<Component>> rows;
  final String? emptyMessage;

  const DataTable({
    required this.headers,
    required this.rows,
    this.emptyMessage,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return div(classes: 'table-wrapper', [
      table(classes: 'data-table', [
        thead([
          tr([
            for (final header in headers) th([Component.text(header)]),
          ]),
        ]),
        tbody([
          if (rows.isEmpty)
            tr([
              td(
                attributes: {'colspan': '${headers.length}'},
                classes: 'data-table__empty',
                [Component.text(emptyMessage ?? 'Sin datos')],
              ),
            ])
          else
            for (final row in rows)
              tr([
                for (final cell in row) td([cell]),
              ]),
        ]),
      ]),
    ]);
  }
}
