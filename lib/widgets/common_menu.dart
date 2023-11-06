import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heal_with_science/util/all_constants.dart';
import 'package:heal_with_science/widgets/round_button.dart';

import '../util/dimens.dart';
import '../util/theme.dart';
import 'commontext.dart';

class CommonMenuWidget extends StatelessWidget {
  final double screenWidth;
  final String userIconAssetPath;
  final String accountText;

  CommonMenuWidget({
    required this.screenWidth,
    required this.userIconAssetPath,
    required this.accountText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              RoundButton(
                width: screenWidth * 0.15,
                height: screenWidth * 0.15,
                borderColor: ThemeProvider.borderColor,
                padding: screenWidth * 0.013,
                background: ThemeProvider.iceberg,
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  child: SvgPicture.asset(userIconAssetPath,
                      color: ThemeProvider.primary),
                ),
              ),
              SizedBox(width: screenWidth * 0.09),
              CommonTextWidget(
                lineHeight: 1.3,
                heading: accountText,
                fontSize: Dimens.twenty,
                color: ThemeProvider.blackColor,
                fontFamily: 'medium',
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child:
                SvgPicture.asset(AssetPath.next, width: screenWidth * 0.03),
          ),
        ],
      ),
    );
  }
}
