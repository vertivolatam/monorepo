import 'package:test/test.dart';
import 'package:vertivo_client/vertivo_client.dart';
import 'package:vertivo_dashboard/data/instrument_range.dart';

void main() {
  // Helpers to build minimal Greenhouse / CropModel rows for the tests.
  Greenhouse gh({
    double? phMin,
    double? phMax,
    double? tempMin,
    double? tempMax,
  }) =>
      Greenhouse(
        userId: 'u',
        name: 'gh',
        irrigationType: 'aeroponic',
        totalTrays: 1,
        isActive: true,
        phMin: phMin,
        phMax: phMax,
        temperatureMin: tempMin,
        temperatureMax: tempMax,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  CropModel crop({
    double idealPhMin = 5.5,
    double idealPhMax = 6.5,
  }) =>
      CropModel(
        species: 'lactuca',
        commonName: 'lechuga',
        category: 'vegetable',
        idealTemperatureMin: 15,
        idealTemperatureMax: 24,
        idealHumidityMin: 50,
        idealHumidityMax: 70,
        idealLightHoursMin: 10,
        idealLightHoursMax: 14,
        idealPhMin: idealPhMin,
        idealPhMax: idealPhMax,
        waterRequirement: 'medium',
        growthDurationDays: 45,
        difficulty: 'beginner',
        segments: const ['residential'],
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  group('resolveRange — 3-layer resolution', () {
    test('layer 1: greenhouse setpoint wins when present', () {
      final r = resolveRange(
        Measurement.ph,
        greenhouse: gh(phMin: 5.8, phMax: 6.2),
        crop: crop(idealPhMin: 5.5, idealPhMax: 6.5),
      );
      expect(r.min, 5.8);
      expect(r.max, 6.2);
      expect(r.source, RangeSource.greenhouse);
    });

    test('layer 2: falls back to CropModel ideal when greenhouse is null', () {
      final r = resolveRange(
        Measurement.ph,
        greenhouse: gh(), // no ph setpoint
        crop: crop(idealPhMin: 5.5, idealPhMax: 6.5),
      );
      expect(r.min, 5.5);
      expect(r.max, 6.5);
      expect(r.source, RangeSource.crop);
    });

    test('layer 3: falls back to static default when both are absent', () {
      final r = resolveRange(Measurement.ph, greenhouse: gh(), crop: null);
      expect(r.source, RangeSource.fallback);
      expect(r.min, lessThan(r.max));
    });

    test('partial greenhouse (only min) still falls through to crop', () {
      // Only a complete [min,max] at a layer counts; a half setpoint defers.
      final r = resolveRange(
        Measurement.ph,
        greenhouse: gh(phMin: 5.9), // max missing
        crop: crop(idealPhMin: 5.5, idealPhMax: 6.5),
      );
      expect(r.source, RangeSource.crop);
      expect(r.min, 5.5);
    });
  });

  group('rangeStatus — in/out colouring', () {
    InstrumentRange range(double lo, double hi) =>
        InstrumentRange(lo, hi, RangeSource.greenhouse);

    test('value inside the band (away from edges) is ok', () {
      expect(rangeStatus(6.0, range(5.5, 6.5)), RangeStatus.ok);
    });

    test('value out of range is alert', () {
      expect(rangeStatus(4.2, range(5.5, 6.5)), RangeStatus.alert);
      expect(rangeStatus(7.0, range(5.5, 6.5)), RangeStatus.alert);
    });

    test('value near the edge is warn', () {
      // within 8% of the span from a bound
      expect(rangeStatus(5.55, range(5.5, 6.5)), RangeStatus.warn);
    });

    test('null value or degenerate range is na', () {
      expect(rangeStatus(null, range(5.5, 6.5)), RangeStatus.na);
      expect(rangeStatus(6.0, range(6.0, 6.0)), RangeStatus.na);
    });
  });
}
