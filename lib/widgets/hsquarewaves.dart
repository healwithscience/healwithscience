import 'dart:math';
import 'package:flutter/material.dart';

class HSquareWavePainter extends CustomPainter {
  final double frequency;
  final double amplitude;
  final double dutyCycle;
  final double phase;
  final double offset;

  HSquareWavePainter({
    required this.frequency,
    required this.amplitude,
    required this.dutyCycle,
    required this.phase,
    required this.offset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    final double midY = size.height / 2;
    final double width = size.width;
    final double period = width / frequency;

    double prevX = 0.0;
    double prevY = midY +
        amplitude *
            sin((2 * pi * prevX / period) + phase) +
        offset;

    for (double x = 0; x < width; x++) {
      final double y = midY +
          amplitude *
              sin((2 * pi * x / period) + phase) +
          offset;

      // Apply duty cycle by multiplying y by the duty cycle
      if ((x / period) % 1.0 > dutyCycle) {
        prevY = y;
        continue;
      }

      // Add spikes to the leading and trailing edges
      final double spikeWidthFraction = 0.1; // Adjust as needed
      final double spikeWidth = dutyCycle * spikeWidthFraction;
      final double spikeHeightFraction = 0.2; // Adjust as needed
      final double spikeHeight = amplitude * spikeHeightFraction;

      if (x < spikeWidth * period || x > (dutyCycle - spikeWidth) * period) {
        prevY += spikeHeight;
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
