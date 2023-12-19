import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:heal_with_science/controller/features_controller.dart';
import 'package:heal_with_science/util/extensions/static_values.dart';
import 'package:heal_with_science/util/theme.dart';
import '../backend/helper/app_router.dart';
import '../controller/dashboard_controller.dart';
import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/inactivity_manager.dart';
import '../util/string.dart';
import '../widgets/common_card.dart';
import '../widgets/common_loading.dart';
import '../widgets/common_min_player.dart';
import '../widgets/commontext.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double screenHeight = 0, screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<DashboardController>(builder: (value) {
      return Obx(() => value.currentPlan.value == "null" ? SafeArea(

        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                    onTap: (){
                      value.setSubscriptionType("basic");
                    },
                    child: CommonCard(screenWidth: screenWidth, screenHeight: screenHeight, heading: AppString.free_plan, point1: AppString.free_plan_point1, point2: AppString.free_plan_point2, point3: AppString.free_plan_point3, imagePath: AssetPath.free_plan)),
                GestureDetector(
                    onTap: (){

                    },
                    child: CommonCard(screenWidth: screenWidth, screenHeight: screenHeight, heading: AppString.paid_plan, point1: AppString.paid_plan_point1, point2: "", point3: AppString.paid_plan_point2, imagePath: AssetPath.pain_plan)),
                GestureDetector(
                    onTap: (){

                    },
                    child: CommonCard(screenWidth: screenWidth, screenHeight: screenHeight, heading: AppString.featured_plan, point1: AppString.featured_plan_point1, point2: AppString.featured_plan_point2, point3: AppString.featured_plan_point3, imagePath: AssetPath.featured_plan))],
            ),
          ),
        ),
      ) : GestureDetector(
        onPanDown: (details) {
          if (StaticValue.miniPlayer.value) {
            InactivityManager.resetTimer();
          }
        },
        child:Obx(() => !InactivityManager.showImage.value
            ? SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(screenWidth * .04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
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
                          CommonTextWidget(lineHeight: 1.3, heading: AppString.dashboard, fontSize: Dimens.twentyFour, color: Colors.black, fontFamily: 'bold'),
                          InkWell(
                            onTap: () {
                              Get.toNamed(AppRouter.getProfileScreen());
                              // value.logout();
                            },
                            child: Padding(
                              padding: EdgeInsets.all(screenWidth * .02),
                              child: SvgPicture.asset(AssetPath.user_icon, width: screenWidth * .06, color: ThemeProvider.blackColor),
                            ),

                            /* Container(
                          alignment: Alignment.center,
                          width: screenWidth * .2,
                          height: screenWidth * .1,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: ThemeProvider.borderColor,
                              ),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CommonTextWidget(
                                lineHeight:1.3,
                                heading: "logout",
                                fontSize: Dimens.sixteen,
                                color: Colors.black,
                                fontFamily: 'bold'),
                          ),
                        ),*/
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Container(
                          width: screenWidth,
                          height: screenHeight,
                          alignment: Alignment.center,
                          child: StaggeredGridView.countBuilder(
                            crossAxisCount: 4,
                            // Number of columns
                            itemCount: value.listItem.length,
                            // Total number of items
                            itemBuilder: (BuildContext context, int index) => Container(
                              child: InkWell(
                                onTap: () {
                                  if (index == 0) {
                                    Get.toNamed(AppRouter.getCategoryScreen());
                                  } else if (index == 2) {
                                    Get.toNamed(AppRouter.getFrequencyScreen());
                                  } else if (index == 4) {
                                    Get.toNamed(AppRouter.getPlaylistScreen());
                                  } else if (index == 3) {
                                    Get.toNamed(AppRouter.getHeartScreen());
                                  } else if (index == 1) {
                                    Get.toNamed(AppRouter.getCustomFrequencyScreen());
                                  }
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    //<-- SEE HERE
                                      borderRadius: BorderRadius.circular(10.0)),
                                  color: ThemeProvider.iceberg,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CommonTextWidget(lineHeight: 1.3, heading: value.itemList[index].name, fontSize: Dimens.eighteen, color: Colors.black, fontFamily: 'bold'),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(20.0),
                                            child: Center(
                                              child: SvgPicture.asset(value.listItem[index].imagePath),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            staggeredTileBuilder: (int index) => StaggeredTile.count(index == 0 ? 4 : 2, index.isOdd ? 3 : 2),
                            mainAxisSpacing: screenHeight * .015,
                            // Spacing between rows
                            crossAxisSpacing: screenWidth * .01, // Spacing between columns
                          ),
                        ),
                      )
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
                      Get.toNamed(AppRouter.getFeaturesScreen(), arguments: {
                        'frequency': StaticValue.frequenciesList[StaticValue.playingIndex.value],
                        'frequenciesList': StaticValue.frequenciesList,
                        'index': StaticValue.playingIndex.value,
                        'name': StaticValue.frequencyName.value,
                        'programName': StaticValue.programNameList,
                        // Pass the data you want
                        'screenName': StaticValue.screenName,
                        'type': 'mini_player',
                        'isPlaying': StaticValue.isPlaying.value,
                        // Pass the data you want
                        'currentTimeInSeconds': StaticValue.currentTimeInSeconds
                        // Pass the data you want
                      });
                    },
                    child: CustomMiniPlayer(screenWidth: screenWidth, screenHeight: screenHeight),
                  ),
                )
                    : Container()),
              ],
            ),
          ),
        )
            : CommonLoadingWidget(screenHeight: screenHeight, screenWidth: screenWidth)),
      ));
    });
  }
}
