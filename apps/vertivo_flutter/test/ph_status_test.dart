import 'package:flutter_test/flutter_test.dart';
import 'package:vertivo_flutter/features/monitoring/domain/ph_status.dart';

void main() {
  // Modelo Fitotécnico: leafy crops pH ideal 6.6, range 6.0–7.4.
  test('in-range pH is ok', () {
    expect(phStatus(6.6), PhStatus.ok);
    expect(phStatus(6.0), PhStatus.ok);
    expect(phStatus(7.4), PhStatus.ok);
  });

  test('just outside range is warning', () {
    expect(phStatus(7.7), PhStatus.warning); // 7.4..7.9
    expect(phStatus(5.7), PhStatus.warning); // 5.5..6.0
  });

  test('far outside range is alert', () {
    expect(phStatus(8.0), PhStatus.alert); // > 7.9
    expect(phStatus(5.2), PhStatus.alert); // < 5.5
  });
}
