import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heal_with_science/util/theme.dart';

class RoundButton extends StatelessWidget {
  final double width;
  final double height;
  final Color borderColor;
  final Widget child;
  final double padding;
  final Color background;

  RoundButton({
    required this.width,
    required this.height,
    this.borderColor = Colors.white,
    this.padding = 5.0,
    required this.child,
    this.background = ThemeProvider.whiteColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: background,
        border: Border.all(
          color: borderColor,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: child,
      ),
    );
  }
}