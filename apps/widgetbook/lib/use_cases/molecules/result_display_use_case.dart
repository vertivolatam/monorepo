import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:vertivo_ui/vertivo_ui.dart';

@widgetbook.UseCase(name: 'Default', type: ResultDisplay, path: '[molecules]')
Widget buildResultDisplayUseCase(BuildContext context) {
  final hasResult = context.knobs.boolean(
    label: 'Con resultado',
    initialValue: true,
  );
  final hasError = context.knobs.boolean(
    label: 'Con error',
    initialValue: false,
  );
  return ResultDisplay(
    resultMessage: hasResult
        ? context.knobs.string(
            label: 'Mensaje de resultado',
            initialValue: 'Hola desde el servidor',
          )
        : null,
    errorMessage: hasError
        ? context.knobs.string(
            label: 'Mensaje de error',
            initialValue: 'Connection refused',
          )
        : null,
  );
}
