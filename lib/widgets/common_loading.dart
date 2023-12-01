import 'package:flutter/material.dart';

import '../util/app_assets.dart';
import '../util/theme.dart';

class CommonLoadingWidget extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;

  const CommonLoadingWidget({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: ThemeProvider.whiteColor,
        height: screenHeight,
        width: screenWidth,
        child: Image.asset(
          AssetPath.background,
          height: screenHeight,
          width: screenWidth,
          fit: BoxFit.cover,
        ),
      );

  }
}
