import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:heal_with_science/controller/reward_controller.dart';
import 'package:heal_with_science/controller/share_controller.dart';
import 'package:share_plus/share_plus.dart';
import '../backend/helper/app_router.dart';
import '../controller/splash_controller.dart';
import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/extensions/static_values.dart';
import '../util/inactivity_manager.dart';
import '../util/string.dart';
import '../util/theme.dart';
import '../widgets/common_loading.dart';
import '../widgets/common_min_player.dart';
import '../widgets/commontext.dart';
import '../widgets/submit_button.dart';

class ShareScreen extends StatefulWidget {
  @override
  State<ShareScreen> createState() => _shareScreenState();
}

class _shareScreenState extends State<ShareScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<ShareController>(builder: (value) {
      return GestureDetector(
        onPanDown: (details) {
          if (StaticValue.miniPlayer.value) {
            InactivityManager.resetTimer();
          }
        },
        child: Obx(() => !InactivityManager.showImage.value
            ? SafeArea(
                child: Scaffold(
                  body: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(screenWidth * .04),
                        child: SizedBox(
                          width: screenWidth,
                          height: screenHeight,
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
                                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                                      child: Padding(
                                        padding: EdgeInsets.all(screenWidth * .02),
                                        child: SvgPicture.asset(AssetPath.back_arrow),
                                      ),
                                    ),
                                  ),
                                  CommonTextWidget(lineHeight: 1.3, heading: AppString.share, fontSize: Dimens.twentyFour, color: Colors.black, fontFamily: 'bold'),
                                  SizedBox(
                                    width: screenWidth * .1,
                                    height: screenWidth * .1,
                                  )
                                ],
                              ),
                              SizedBox(height: screenHeight * .3),


                              SizedBox(
                                width: screenWidth * .8,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(screenWidth * .02),
                                      border: Border.all(width: 1.0, color: ThemeProvider.persianGreen)),
                                  child: CommonTextWidget(
                                      lineHeight: 1.1,
                                      heading: value.dynamicUrlShare.value,
                                      fontSize: Dimens.eighteen,
                                      color: Colors.black,
                                      fontFamily: 'medium'),
                                ),
                              ),
                              SizedBox(height: screenHeight * .03),
                              InkWell(
                                  child: SizedBox(width: screenWidth * .3, height: 50, child: SubmitButton(onPressed: () {
                                    Share.share(value.dynamicUrlShare.value);
                                  }, title: AppString.invite))),
                            ],
                          ),
                        ),
                      ),
                      Obx(() => StaticValue.miniPlayer.value
                          ? Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  StaticValue.pauseTimer();
                                  Get.toNamed(AppRouter.getFeaturesScreen(), arguments: {
                                    'frequency': StaticValue.frequenciesList[StaticValue.playingIndex.value],
                                    'frequenciesList': StaticValue.frequenciesList,
                                    'index': StaticValue.playingIndex.value,
                                    'name': StaticValue.frequencyName.value,
                                    'programName': StaticValue.programNameList,
                                    'screenName': StaticValue.screenName,
                                    'type': 'mini_player',
                                    'isPlaying': StaticValue.isPlaying.value,
                                    'currentTimeInSeconds': StaticValue.currentTimeInSeconds
                                    // Pass the data you want
                                  });
                                },
                                child: CustomMiniPlayer(screenWidth: screenWidth, screenHeight: screenHeight),
                              ),
                            )
                          : Container())
                    ],
                  ),
                ),
              )
            : CommonLoadingWidget(screenHeight: screenHeight, screenWidth: screenWidth)),
      );
    });

    //SafeArea(child: Text("Splash Screen"));
  }
}
