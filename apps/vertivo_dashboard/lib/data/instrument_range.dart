import 'package:vertivo_client/vertivo_client.dart';

/// The sensor measurements the cockpit gauges show. Maps to the backend's
/// `EnvironmentalReading.measurementType` strings.
enum Measurement { ph, temperature, humidity, co2, light }

/// Where a resolved [InstrumentRange] came from (for badges / debugging).
enum RangeSource { greenhouse, crop, fallback }

/// In/out-of-range colouring status for a gauge value.
enum RangeStatus { ok, warn, alert, na }

/// A resolved operating range for one measurement: `[min, max]` + provenance.
class InstrumentRange {
  final double min;
  final double max;
  final RangeSource source;
  const InstrumentRange(this.min, this.max, this.source);
}

/// Static last-resort bounds per measurement (same numbers the mock pages used).
const Map<Measurement, (double, double)> _fallback = {
  Measurement.ph: (5.5, 6.5),
  Measurement.temperature: (18, 28),
  Measurement.humidity: (40, 80),
  Measurement.co2: (400, 700),
  Measurement.light: (10, 14),
};

/// Fraction of the span near each bound that counts as `warn`.
const double _warnBand = 0.08;

/// Resolve the operating range for [m] by layers (InstrumentCard concept):
///   1. the greenhouse's own setpoint (`phMin/phMax`, `temperatureMin/Max`, …)
///   2. the planted crop's `CropModel` ideal (`idealPhMin/Max`, …)
///   3. a static per-measurement fallback
///
/// A layer only wins when it provides a COMPLETE `[min, max]`; a half setpoint
/// (only min, or only max) defers to the next layer.
InstrumentRange resolveRange(
  Measurement m, {
  Greenhouse? greenhouse,
  CropModel? crop,
}) {
  final gh = _fromGreenhouse(m, greenhouse);
  if (gh != null) return InstrumentRange(gh.$1, gh.$2, RangeSource.greenhouse);

  final c = _fromCrop(m, crop);
  if (c != null) return InstrumentRange(c.$1, c.$2, RangeSource.crop);

  final f = _fallback[m]!;
  return InstrumentRange(f.$1, f.$2, RangeSource.fallback);
}

(double, double)? _fromGreenhouse(Measurement m, Greenhouse? g) {
  if (g == null) return null;
  final (lo, hi) = switch (m) {
    Measurement.ph => (g.phMin, g.phMax),
    Measurement.temperature => (g.temperatureMin, g.temperatureMax),
    Measurement.humidity => (g.humidityMin, g.humidityMax),
    Measurement.co2 => (g.co2Min, g.co2Max),
    Measurement.light => (g.lightMin, g.lightMax),
  };
  return (lo != null && hi != null) ? (lo, hi) : null;
}

(double, double)? _fromCrop(Measurement m, CropModel? c) {
  if (c == null) return null;
  return switch (m) {
    Measurement.ph => (c.idealPhMin, c.idealPhMax),
    Measurement.temperature => (c.idealTemperatureMin, c.idealTemperatureMax),
    Measurement.humidity => (c.idealHumidityMin, c.idealHumidityMax),
    Measurement.light => (c.idealLightHoursMin, c.idealLightHoursMax),
    // co2 ideals are nullable on CropModel — only use a complete pair.
    Measurement.co2 => (c.idealCo2Min != null && c.idealCo2Max != null)
        ? (c.idealCo2Min!, c.idealCo2Max!)
        : null,
  };
}

/// Classify [value] against [range] — pure, mirrors the explorer's
/// `range_status` (ok / warn / alert / n-a).
RangeStatus rangeStatus(double? value, InstrumentRange range) {
  if (value == null) return RangeStatus.na;
  final span = range.max - range.min;
  if (span <= 0) return RangeStatus.na;
  if (value < range.min || value > range.max) return RangeStatus.alert;
  final margin = span * _warnBand;
  if (value <= range.min + margin || value >= range.max - margin) {
    return RangeStatus.warn;
  }
  return RangeStatus.ok;
}
