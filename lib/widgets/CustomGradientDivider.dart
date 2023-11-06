import 'package:flutter/material.dart';

class CustomGradientDivider extends StatelessWidget {
  final double height;
  final Color startColor;
  final Color endColor;

  CustomGradientDivider({
    required this.height,
    required this.startColor,
    required this.endColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [startColor, startColor, endColor],
          stops: [0.0, 0.5, 1.0],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}