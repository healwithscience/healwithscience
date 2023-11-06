import 'package:flutter/cupertino.dart';
import 'package:heal_with_science/util/theme.dart';

class TriangularWavePainter extends CustomPainter {
  final double frequency;
  final double amplitude;
  final double dutyCycle;
  final double phase;
  final double offset;

  TriangularWavePainter({
    required this.frequency,
    required this.amplitude,
    required this.dutyCycle,
    required this.phase,
    required this.offset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ThemeProvider.whiteColor
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    final double midY = size.height / 2;
    final double width = size.width;
    final double period = width / frequency;

    double prevX = 0.0;
    double prevY = midY +
        (2 * amplitude) *
            (1.0 - (2.0 * ((prevX / period) % 1.0 - 0.5).abs())) +
        offset;

    for (double x = 0; x < width; x++) {
      final double y = midY +
          (2 * amplitude) *
              (1.0 - (2.0 * ((x / period) % 1.0 - 0.5).abs())) +
          offset;

      // Apply duty cycle by multiplying y by the duty cycle
      if ((x / period) % 1.0 > dutyCycle) {
        prevY = y;
        continue;
      }

      canvas.drawLine(Offset(prevX, prevY), Offset(x, y), paint);
      prevX = x;
      prevY = y;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
