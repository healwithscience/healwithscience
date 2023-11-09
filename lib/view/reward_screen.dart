import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:heal_with_science/controller/reward_controller.dart';
import '../controller/splash_controller.dart';
import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/string.dart';
import '../util/theme.dart';
import '../widgets/commontext.dart';

class RewardScreen extends StatefulWidget {
  @override
  State<RewardScreen> createState() => _rewardScreenState();
}

class _rewardScreenState extends State<RewardScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<RewardController>(builder: (value) {
      return SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(screenWidth * .04),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        value.onBackRoutes();
                      },
                      child: Container(
                        width: screenWidth * .1,
                        height: screenWidth * .1,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: ThemeProvider.borderColor,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * .02),
                          child: SvgPicture.asset(AssetPath.back_arrow),
                        ),
                      ),
                    ),
                    CommonTextWidget(
                        lineHeight: 1.3,
                        heading: AppString.earn_points,
                        fontSize: Dimens.twentyFour,
                        color: Colors.black,
                        fontFamily: 'bold'),
                    SizedBox(
                      width: screenWidth * .1,
                      height: screenWidth * .1,
                    )
                  ],
                ),
                SizedBox(height: screenHeight * .1),
                SvgPicture.asset(AssetPath.reward, height: screenHeight * .25),
                SizedBox(height: screenHeight * .05),
                Obx(() => CommonTextWidget(
                    heading: value.rewardPoint.value,
                    fontSize: Dimens.twentyFour,
                    color: Colors.black,
                    fontFamily: 'bold')),
                SizedBox(height: screenHeight * .03),
                Align(
                  alignment: Alignment.center,
                  child: CommonTextWidget(
                      textAlign: TextAlign.center,
                      heading: AppString.total_point,
                      fontSize: Dimens.twentyFour,
                      color: ThemeProvider.textColor,
                      fontFamily: 'medium'),
                ),
                SizedBox(height: screenHeight * .05),
              ],
            ),
          ),
        ),
      );
    });

    //SafeArea(child: Text("Splash Screen"));
  }
}
