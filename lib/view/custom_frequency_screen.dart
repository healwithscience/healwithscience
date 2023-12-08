import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:heal_with_science/controller/custom_frequency_controller.dart';
import 'package:heal_with_science/util/theme.dart';
import '../backend/helper/app_router.dart';
import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/extensions/static_values.dart';
import '../util/inactivity_manager.dart';
import '../util/string.dart';
import '../widgets/CustomGradientDivider.dart';
import '../widgets/common_loading.dart';
import '../widgets/common_min_player.dart';
import '../widgets/commontext.dart';

class CustomFrequencyScreen extends StatefulWidget {
  const CustomFrequencyScreen({Key? key}) : super(key: key);

  @override
  State<CustomFrequencyScreen> createState() => _CustomFrequencyScreenState();
}

class _CustomFrequencyScreenState extends State<CustomFrequencyScreen> {
  double screenHeight = 0, screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<CustomFrequencyController>(builder: (value) {
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
                      Padding(
                          padding: EdgeInsets.all(screenWidth * .04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      heading: AppString.custom_frequency,
                                      fontSize: Dimens.twentyFour,
                                      color: Colors.black,
                                      fontFamily: 'bold'),
                                  InkWell(
                                    onTap: () {},
                                    child: Padding(
                                      padding:
                                          EdgeInsets.all(screenWidth * .02),
                                      child: SvgPicture.asset(AssetPath.setting,
                                          width: screenWidth * .012,
                                          color: ThemeProvider.blackColor),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              const SizedBox(height: 10),
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
                                } else if (value.customProgram.isEmpty) {
                                  // Display a "No Data" message
                                  return Expanded(
                                    child: Center(
                                      child: CommonTextWidget(
                                          heading: AppString.no_data,
                                          fontSize: Dimens.sixteen,
                                          color: Colors.black,
                                          fontFamily: 'light'),
                                    ),
                                  );
                                } else {
                                  return Expanded(
                                    child: ListView.builder(
                                      controller: value.scrollController,
                                      itemCount: value.customProgram.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            StaticValue.resetTimer();
                                            value.goToFeatures(
                                                value.customProgram[index].frequency,
                                                value.customProgram[index].name);
                                          },
                                          child: SizedBox(
                                            height: screenHeight * 0.07,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 15,
                                                          horizontal: 10),
                                                      child: CommonTextWidget(
                                                          textOverflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                          heading: value
                                                              .customProgram[
                                                                  index]
                                                              .name,
                                                          fontSize:
                                                              Dimens.sixteen,
                                                          color: Colors.black,
                                                          fontFamily: 'medium'),
                                                    ),
                                                    PopupMenuButton<String>(
                                                      offset:
                                                          const Offset(00, 40),
                                                      itemBuilder: (context) =>
                                                          [
                                                        buildPopupMenuItem(
                                                            "Add Frequency",
                                                            AssetPath
                                                                .add_playlist),
                                                        buildPopupMenuItem(
                                                            "Remove Program",
                                                            AssetPath.add_queue),
                                                        // Add more options as needed
                                                      ],
                                                      onSelected:
                                                          (selectedValue) {
                                                        if (selectedValue ==
                                                            "Add Frequency") {
                                                          showFrequencyDialog(
                                                              context,
                                                              value,
                                                              value
                                                                  .customProgram[
                                                                      index]
                                                                  .name);
                                                          // value.addToFrequencyArray()
                                                        } else if (selectedValue ==
                                                            "Remove Program") {
                                                          value.removeProgram(
                                                              value
                                                                  .customProgram[
                                                                      index]
                                                                  .name);
                                                        } else {}
                                                      },
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            screenWidth * .04),
                                                        child: SvgPicture.asset(
                                                            AssetPath.setting,
                                                            width: screenWidth *
                                                                .008,
                                                            color: ThemeProvider
                                                                .greyColor),
                                                      ),
                                                    )
                                                  ],
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
                                  );
                                }
                              }),
                            ],
                          )),
                      Obx(() => Positioned(
                          bottom: StaticValue.miniPlayer.value
                              ? screenHeight * .09
                              : screenHeight * .02,
                          right: 10,
                          child: FloatingActionButton.extended(
                            backgroundColor: ThemeProvider.persianGreen,
                            onPressed: () {
                              showAddProgramDialog(context, value);
                            },
                            label: CommonTextWidget(
                                lineHeight: 1.3,
                                heading: AppString.add_frequency,
                                fontSize: Dimens.thrteen,
                                color: Colors.white,
                                fontFamily: 'bold'),
                          ))),
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
  }

  PopupMenuItem<String> buildPopupMenuItem(String text, String path) {
    return PopupMenuItem<String>(
      value: text,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.04),
            child: SvgPicture.asset(
              path,
              width: screenWidth * .05,
            ),
          ),
          CommonTextWidget(
              heading: text,
              fontSize: Dimens.thrteen,
              color: Colors.black,
              fontFamily: 'light')
        ],
      ),
    );
  }

  void showFrequencyDialog(BuildContext context,
      CustomFrequencyController value, String programName) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: screenWidth * .1, // Set the width to 200
            height: screenHeight * .3, // Set the height to 200
            child: Column(
              children: [
                Center(
                    child: CommonTextWidget(
                        lineHeight: 1.3,
                        heading: AppString.add_frequency,
                        fontSize: Dimens.twenty,
                        color: Colors.black,
                        fontFamily: 'bold')),
                SizedBox(height: screenHeight * .02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * .03),
                  child: TextField(
                    controller: value.newFrequencyController,
                    style: TextStyle(
                        fontSize: Dimens.seventeen,
                        color: Colors.black,
                        fontFamily: 'medium'),
                    keyboardType: TextInputType.number,
                    cursorColor: ThemeProvider.persianGreen,
                    decoration: InputDecoration(
                      hintText: AppString.frequencies,
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: ThemeProvider.persianGreen)),
                    ),
                    maxLength: 7,
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                  ),
                ),
                SizedBox(height: screenHeight * .02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: SizedBox(
                        width: screenWidth * .2, // Adjust the width as needed
                        height: 40,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            // Adjust the border radius as needed
                            border: Border.all(
                              width: 1.0,
                              color: ThemeProvider.persianGreen,
                            ),
                          ),
                          child: CommonTextWidget(
                            heading: AppString.cancel,
                            fontSize: Dimens.forteen,
                            color: Colors.black,
                            fontFamily: 'bold',
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        value.addToFrequencyArray(programName);
                      },
                      child: SizedBox(
                        width: screenWidth * .2, // Adjust the width as needed
                        height: 40,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            // Adjust the border radius as needed
                            border: Border.all(
                              width: 1.0,
                              color: ThemeProvider.persianGreen,
                            ),
                          ),
                          child: CommonTextWidget(
                            heading: AppString.ok,
                            fontSize: Dimens.forteen,
                            color: Colors.black,
                            fontFamily: 'bold',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showAddProgramDialog(
      BuildContext context, CustomFrequencyController value) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: screenWidth * .1, // Set the width to 200
            height: screenHeight * .3, // Set the height to 200
            child: Column(
              children: [
                Center(
                    child: CommonTextWidget(
                        lineHeight: 1.3,
                        heading: AppString.add_frequency,
                        fontSize: Dimens.twenty,
                        color: Colors.black,
                        fontFamily: 'bold')),
                SizedBox(height: screenHeight * .02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * .03),
                  child: TextField(
                    controller: value.nameController,
                    style: TextStyle(
                        fontSize: Dimens.seventeen,
                        color: Colors.black,
                        fontFamily: 'medium'),
                    keyboardType: TextInputType.text,
                    cursorColor: ThemeProvider.persianGreen,
                    decoration: const InputDecoration(
                      hintText: "Program Name",
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: ThemeProvider.persianGreen)),
                    ),
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * .03),
                  child: TextField(
                    controller: value.frequencyController,
                    style: TextStyle(
                        fontSize: Dimens.seventeen,
                        color: Colors.black,
                        fontFamily: 'medium'),
                    keyboardType: TextInputType.number,
                    cursorColor: ThemeProvider.persianGreen,
                    decoration: InputDecoration(
                      hintText: AppString.frequencies,
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: ThemeProvider.persianGreen)),
                    ),
                    maxLength: 5,
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                  ),
                ),
                SizedBox(height: screenHeight * .02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        value.nameController.clear();
                        value.frequencyController.clear();
                        Get.back();
                      },
                      child: SizedBox(
                        width: screenWidth * .2, // Adjust the width as needed
                        height: 40,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            // Adjust the border radius as needed
                            border: Border.all(
                              width: 1.0,
                              color: ThemeProvider.persianGreen,
                            ),
                          ),
                          child: CommonTextWidget(
                            heading: AppString.cancel,
                            fontSize: Dimens.forteen,
                            color: Colors.black,
                            fontFamily: 'bold',
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        value.createCustomProgram();
                      },
                      child: SizedBox(
                        width: screenWidth * .2, // Adjust the width as needed
                        height: 40,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            // Adjust the border radius as needed
                            border: Border.all(
                              width: 1.0,
                              color: ThemeProvider.persianGreen,
                            ),
                          ),
                          child: CommonTextWidget(
                            heading: AppString.ok,
                            fontSize: Dimens.forteen,
                            color: Colors.black,
                            fontFamily: 'bold',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
