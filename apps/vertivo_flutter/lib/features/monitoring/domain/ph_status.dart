/// Health status of a pH reading against the greenhouse's configured range.
enum PhStatus { ok, warning, alert }

/// Pure mapping from a pH value to a status. Defaults match the seed greenhouse
/// thresholds (phMin 5.5 / phMax 6.5). `warnBand` is how far outside the range
/// still counts as "warning" before escalating to "alert".
PhStatus phStatus(
  double value, {
  double min = 5.5,
  double max = 6.5,
  double warnBand = 0.5,
}) {
  if (value >= min && value <= max) return PhStatus.ok;
  if (value >= min - warnBand && value <= max + warnBand) return PhStatus.warning;
  return PhStatus.alert;
}
