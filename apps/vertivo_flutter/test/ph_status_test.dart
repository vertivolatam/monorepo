import 'package:flutter_test/flutter_test.dart';
import 'package:vertivo_flutter/features/monitoring/domain/ph_status.dart';

void main() {
  test('in-range pH is ok', () {
    expect(phStatus(6.0), PhStatus.ok);
    expect(phStatus(5.5), PhStatus.ok);
    expect(phStatus(6.5), PhStatus.ok);
  });

  test('just outside range is warning', () {
    expect(phStatus(6.8), PhStatus.warning);
    expect(phStatus(5.2), PhStatus.warning);
  });

  test('far outside range is alert', () {
    expect(phStatus(7.2), PhStatus.alert);
    expect(phStatus(4.5), PhStatus.alert);
  });
}
