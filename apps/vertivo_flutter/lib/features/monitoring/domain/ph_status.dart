/// Health status of a pH reading against the greenhouse's configured range.
enum PhStatus { ok, warning, alert }

/// Pure mapping from a pH value to a status. Defaults match the Modelo
/// Fitotécnico setpoints for leafy crops (pH ideal 6.6, range 6.0–7.4).
/// `warnBand` is how far outside the range still counts as "warning" before
/// escalating to "alert".
PhStatus phStatus(
  double value, {
  double min = 6.0,
  double max = 7.4,
  double warnBand = 0.5,
}) {
  if (value >= min && value <= max) return PhStatus.ok;
  if (value >= min - warnBand && value <= max + warnBand) return PhStatus.warning;
  return PhStatus.alert;
}
