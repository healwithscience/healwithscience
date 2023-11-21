import 'dart:math';
import 'package:flutter/material.dart';

class BubbleWavePainter extends CustomPainter {
  final double frequency;
  final double amplitude;
  final double dutyCycle; // Added dutyCycle property
  final double phase;
  final double offset;

  BubbleWavePainter({
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

    for (double x = 0; x < width; x++) {
      final double y = midY + amplitude * sin((2 * pi * x / period) + phase) + offset;

      // Apply duty cycle by multiplying y by the duty cycle
      if ((x / period) % 1.0 > dutyCycle) {
        continue;
      }

      // Draw a circle at each point along the sine wave
      canvas.drawCircle(Offset(x, y), 2.0, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}

