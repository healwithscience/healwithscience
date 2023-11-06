import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heal_with_science/util/theme.dart';

import 'commontext.dart';

class RoundConorButton extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Widget child;
  final double padding;
  final String heading;
  final double fontSize;
  final Color color;

  RoundConorButton({
    required this.width,
    required this.height,
    this.borderRadius = 30,
    this.padding = 8.0,
    required this.child,
    required this.heading,
    required this.fontSize,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color:color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(padding),
            child: child,
          ),
          CommonTextWidget(
              lineHeight: 1.3,
              heading: heading,
              fontSize: fontSize,
              color: ThemeProvider.whiteColor,
              fontFamily: 'medium')
        ],
      ),
    );
  }
}