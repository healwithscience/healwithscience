import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HarmonicWavePainter extends CustomPainter {
  final double frequency;
  final double amplitude;
  final double dutyCycle;
  final double phase;
  final double offset;
  final int harmonicCount;

  HarmonicWavePainter({
    required this.frequency,
    required this.amplitude,
    required this.dutyCycle,
    required this.phase,
    required this.offset,
    this.harmonicCount = 5, // Default to 1 harmonic if not specified
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
    double prevY = calculateHarmonicWave(prevX, period, midY);

    for (double x = 0; x < width; x++) {
      final double y = calculateHarmonicWave(x, period, midY);

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

  double calculateHarmonicWave(double x, double period, double midY) {
    double result = 0.0;
    for (int i = 1; i <= harmonicCount; i++) {
      result += amplitude / i * sin((2 * pi * i * x / period) + phase);
    }
    return midY + result + offset;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
