import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/theme.dart';
import 'commontext.dart';

class CommonCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String heading;
  final String point1;
  final String point2;
  final String point3;
  final String imagePath;

  const CommonCard({
    Key? key,
    required this.heading,

    required this.point1,
    required this.point2,
    required this.point3,
    required this.imagePath,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * 0.25,
      padding: EdgeInsets.symmetric(vertical:screenWidth * 0.05,horizontal:screenWidth * 0.03 ),
      width: screenWidth,
      decoration: BoxDecoration(
        color: ThemeProvider.persianGreen,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: screenWidth * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextWidget(
                  heading: heading,
                  fontSize: Dimens.eighteen,
                  color: ThemeProvider.whiteColor,
                  fontFamily: 'bold',
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                    children: [
                      SvgPicture.asset(AssetPath.dot),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: screenWidth * 0.02,
                            left: screenWidth * 0.02,
                          ),
                          child: CommonTextWidget(
                            heading: point1,
                            fontSize: Dimens.sixteen,
                            color: ThemeProvider.whiteColor,
                            fontFamily: 'medium',
                          ),
                        ),
                      ),
                    ],
                  ),
                Row(
                  children: [
                    point2.toString() != "" ?
                    SvgPicture.asset(AssetPath.dot) : Container(),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: screenWidth * 0.02,
                          left: screenWidth * 0.02,
                        ),
                        child: CommonTextWidget(
                          heading: point2,
                          fontSize: Dimens.sixteen,
                          color: ThemeProvider.whiteColor,
                          fontFamily: 'medium',
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(AssetPath.dot),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: screenWidth * 0.02,
                          left: screenWidth * 0.02,
                        ),
                        child: CommonTextWidget(
                          heading: point3,
                          fontSize: Dimens.sixteen,
                          color: ThemeProvider.whiteColor,
                          fontFamily: 'medium',
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            width: screenWidth * 0.2,
            child: SvgPicture.asset(imagePath),
          ),
        ],
      ),
    );
  }
}
