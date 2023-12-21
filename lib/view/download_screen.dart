import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:heal_with_science/controller/download_controller.dart';
import 'package:heal_with_science/widgets/CustomGradientDivider.dart';
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
import '../widgets/custom_text_field.dart';
import '../widgets/round_button.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  double screenHeight = 0, screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<DownloadController>(builder: (value) {
      return GestureDetector(
        onPanDown: (details) {
          if (StaticValue.miniPlayer.value) {
            InactivityManager.resetTimer();
          }
        },
        child: Obx(() => !InactivityManager.showImage.value
            ? SafeArea(
                child: Scaffold(
                    backgroundColor: Colors.white,
                    body: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10.0, left: 10.0, right: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      heading: AppString.download,
                                      fontSize: Dimens.twentyFour,
                                      color: Colors.black,
                                      fontFamily: 'bold'),
                                  InkWell(
                                    onTap: () {},
                                    child: Padding(
                                      padding:
                                          EdgeInsets.all(screenWidth * .01),
                                      child: SvgPicture.asset(
                                        AssetPath.setting,
                                        width: screenWidth * .01,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Focus(
                              onFocusChange: (hasFocus) {
                                value.isFocus.value = hasFocus;
                              },
                              child: CustomTextField(
                                hintText: 'Search Categories',
                                controller: value.searchController,
                                textInputStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: Dimens.sixteen,
                                    fontFamily: 'medium'),
                                hintStyle: TextStyle(
                                    fontSize: Dimens.sixteen,
                                    fontFamily: 'medium'),
                                prefixIcon: Icon(Icons.search,
                                    color: value.isFocus.value
                                        ? ThemeProvider.primary
                                        : ThemeProvider.greyColor,
                                    size: Dimens.twentyFive),
                              ),
                            ),
                            Obx(() {
                              if (value.isLoading.value) {
                                return Expanded(
                                  child: Container(
                                    width: screenWidth,
                                    height: screenHeight,
                                    alignment: Alignment.center,
                                    child: const CircularProgressIndicator(),
                                  ),
                                );
                              } else if (value.categories.isEmpty) {
                                return Expanded(
                                  child: Center(
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: screenWidth,
                                      child: CommonTextWidget(
                                          textOverflow: TextOverflow.ellipsis,
                                          heading: "No Data",
                                          fontSize: Dimens.sixteen,
                                          color: Colors.black,
                                          fontFamily: 'medium'),
                                    ),
                                  ),
                                );
                              } else {
                                return Expanded(
                                  child: Stack(
                                    children: [
                                      ListView.builder(
                                        itemCount: value.categories.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              StaticValue.resetTimer();
                                              value.goToFeatures(
                                                  value.categories[index]
                                                      .frequency,
                                                  index);
                                            },
                                            child: SizedBox(
                                              height: screenHeight * 0.07,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                screenWidth *
                                                                    0.05),
                                                    child: Row(
                                                      children: [
                                                        RoundButton(
                                                          width:
                                                              screenWidth * .05,
                                                          height:
                                                              screenWidth * .05,
                                                          child:
                                                              SvgPicture.asset(
                                                                  AssetPath
                                                                      .play),
                                                          borderColor:
                                                              ThemeProvider
                                                                  .borderColor,
                                                          padding: screenWidth *
                                                              .013,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 15,
                                                                  horizontal:
                                                                      10),
                                                          child: CommonTextWidget(
                                                              textOverflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              heading:
                                                                  "${value.categories[index].frequency} HZ",
                                                              fontSize: Dimens
                                                                  .sixteen,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'medium'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width: screenWidth * .8,
                                                      child:
                                                          CustomGradientDivider(
                                                              height: 1.0,
                                                              startColor:
                                                                  ThemeProvider
                                                                      .greyColor,
                                                              endColor: Colors
                                                                  .transparent))
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }),
                          ],
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
                                          'frequency': StaticValue
                                                  .frequenciesList[
                                              StaticValue.playingIndex.value],
                                          'frequenciesList':
                                              StaticValue.frequenciesList,
                                          'index':
                                              StaticValue.playingIndex.value,
                                          'name':
                                              StaticValue.frequencyName.value,
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
                    )),
              )
            : CommonLoadingWidget(screenHeight: screenHeight, screenWidth: screenWidth)),
      );
    });
  }
}
