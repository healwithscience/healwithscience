
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:heal_with_science/controller/reward_controller.dart';
import '../backend/helper/app_router.dart';
import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/extensions/static_values.dart';
import '../util/inactivity_manager.dart';
import '../util/string.dart';
import '../util/theme.dart';
import '../widgets/common_loading.dart';
import '../widgets/common_min_player.dart';
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
                                    width: kIsWeb ? screenWidth * .07 :  screenWidth * .1,
                                    height: kIsWeb ? screenWidth * .07 :  screenWidth * .1,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: ThemeProvider.borderColor,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.all(screenWidth * .02),
                                      child: SvgPicture.asset(
                                          AssetPath.back_arrow),
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
                            SvgPicture.asset(AssetPath.reward,
                                height: screenHeight * .25),
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
                      Obx(() => StaticValue.miniPlayer.value
                          ? Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  StaticValue.pauseTimer();
                                  Get.toNamed(AppRouter.getFeaturesScreen(),
                                      arguments: {
                                        'frequency':
                                            StaticValue.frequenciesList[
                                                StaticValue.playingIndex.value],
                                        'frequenciesList':
                                            StaticValue.frequenciesList,
                                        'index': StaticValue.playingIndex.value,
                                        'name': StaticValue.frequencyName.value,
                                        'programName':
                                            StaticValue.programNameList,
                                        // Pass the data you want
                                        'screenName': StaticValue.screenName,
                                        'type': 'mini_player',
                                        'isPlaying':
                                            StaticValue.isPlaying.value,
                                        // Pass the data you want
                                        'currentTimeInSeconds':
                                            StaticValue.currentTimeInSeconds
                                        // Pass the data you want
                                      });
                                },
                                child: CustomMiniPlayer(
                                    screenWidth: screenWidth,
                                    screenHeight: screenHeight),
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
