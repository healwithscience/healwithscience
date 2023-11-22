import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class FibonacciWavesPainter extends CustomPainter {
  final double frequency;
  final double amplitude;
  final double dutyCycle;
  final double phase;
  final double offset;

  FibonacciWavesPainter({
    required this.frequency,
    required this.amplitude,
    required this.dutyCycle,
    required this.phase,
    required this.offset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    final double period = size.width / dutyCycle;

    double x = -size.width / 2; // Start from the left side
    double y = amplitude * sin(frequency * x / period + phase);

    final Path path = Path()..moveTo(x + centerX, centerY - y);

    for (x = -size.width / 2; x <= size.width / 2; x += 1.0) {
      y = amplitude * sin(frequency * (x + offset) / period + phase);
      path.lineTo(x + centerX, centerY - y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
