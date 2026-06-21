import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vertivo_flutter/core/widgets/molecules/result_display.dart';

void main() {
  testWidgets('ResultDisplay muestra placeholder sin datos', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ResultDisplay())),
    );
    expect(find.text('No server response yet.'), findsOneWidget);
  });
}
