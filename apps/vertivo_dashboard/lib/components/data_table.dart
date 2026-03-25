import 'package:jaspr/jaspr.dart';

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
  Iterable<Component> build(BuildContext context) sync* {
    yield div(classes: 'table-wrapper', [
      table(classes: 'data-table', [
        thead([
          tr([
            for (final header in headers)
              th([text(header)]),
          ]),
        ]),
        tbody([
          if (rows.isEmpty)
            tr([
              td(
                attributes: {'colspan': '${headers.length}'},
                classes: 'data-table__empty',
                [text(emptyMessage ?? 'Sin datos')],
              ),
            ])
          else
            for (final row in rows)
              tr([
                for (final cell in row)
                  td([cell]),
              ]),
        ]),
      ]),
    ]);
  }
}
