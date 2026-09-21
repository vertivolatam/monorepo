import 'package:flutter/material.dart';

/// Minimal sparkline: draws [values] (oldest→newest) as a polyline.
/// Pass [min]/[max] to pin the y-scale (e.g. the metric range); otherwise it
/// auto-scales to the data, which exaggerates tiny noise into big waves.
class Sparkline extends StatelessWidget {
  final List<double> values;
  final Color color;
  final double? min;
  final double? max;
  const Sparkline({
    super.key,
    required this.values,
    required this.color,
    this.min,
    this.max,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: CustomPaint(painter: _SparklinePainter(values, color, min, max)),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> values;
  final Color color;
  final double? minBound;
  final double? maxBound;
  _SparklinePainter(this.values, this.color, this.minBound, this.maxBound);

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final dataMin = values.reduce((a, b) => a < b ? a : b);
    final dataMax = values.reduce((a, b) => a > b ? a : b);
    final min = minBound ?? dataMin;
    final max = maxBound ?? dataMax;
    final span = (max - min).abs() < 1e-6 ? 1.0 : (max - min);
    final dx = size.width / (values.length - 1);
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = dx * i;
      final y = size.height - ((values[i] - min) / span) * size.height;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(_SparklinePainter old) => old.values != values;
}
