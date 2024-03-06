import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:heal_with_science/controller/heart_controller.dart';
import 'package:heal_with_science/util/theme.dart';
import 'package:heart_bpm/chart.dart';
import 'package:heart_bpm/heart_bpm.dart';
import '../backend/helper/app_router.dart';
import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/extensions/static_values.dart';
import '../util/inactivity_manager.dart';
import '../util/string.dart';
import '../widgets/common_loading.dart';
import '../widgets/common_min_player.dart';
import '../widgets/commontext.dart';

class HeartRateScreen extends StatefulWidget {
  const HeartRateScreen({Key? key}) : super(key: key);

  @override
  State<HeartRateScreen> createState() => _HeartRateScreenState();
}

class _HeartRateScreenState extends State<HeartRateScreen> {
  Widget? dialog;

  double screenHeight = 0, screenWidth = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<HeartController>(builder: (value) {
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
                                padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        value.onBackRoutes();
                                      },
                                      child: Container(
                                        width: kIsWeb ? screenWidth * .07 : screenWidth * .1,
                                        height: kIsWeb ? screenWidth * .07 : screenWidth * .1,
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
                                    CommonTextWidget(lineHeight: 1.3, heading: AppString.heart_rate, fontSize: Dimens.twentyFour, color: Colors.black, fontFamily: 'bold'),
                                    InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: EdgeInsets.all(screenWidth * .01),
                                        child: SvgPicture.asset(
                                          AssetPath.setting,
                                          width: screenWidth * .01,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  height: Get.height * .2,
                                  child: Obx(() => value.isBPMEnabled.value
                                      ? Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            HeartBPMDialog(
                                              context: context,
                                              showTextValues: true,
                                              borderRadius: 10,
                                              onRawData: (newvalue) {
                                                setState(() {
                                                  if (value.data.length >= 100) value.data.removeAt(0);
                                                  value.data.add(newvalue);
                                                });
                                                // chart = BPMChart(data);
                                              },
                                              onBPM: (newValue) => setState(() {
                                                if (value.bpmValues.length >= 100) value.bpmValues.removeAt(0);
                                                value.bpmValues.add(SensorValue(value: newValue.toDouble(), time: DateTime.now()));
                                              }),
                                              sampleDelay: 1000 ~/ 20,
                                            ),
                                            Stack(
                                              children: [
                                                SizedBox(
                                                  width: 100,
                                                  height: 100,
                                                  child: CircularProgressIndicator(
                                                    backgroundColor: Colors.grey,
                                                    valueColor: AlwaysStoppedAnimation(ThemeProvider.primary),
                                                    strokeWidth: 15,
                                                    value: value.progressValue.value,
                                                  ),
                                                ),
                                                Positioned(top:0,left:0,right:0,bottom:0,child:Container(
                                                  alignment: Alignment.center,

                                                  child: CommonTextWidget(textAlign: TextAlign.center,
                                                      heading: (value.progressValue.value * 100).toStringAsFixed(1),
                                                      fontSize: Dimens.twenty,
                                                      color: Colors.black, fontFamily: 'medium') ,
                                                ))
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container(
                                          width: screenWidth,
                                          height: 80,
                                          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                                          child: CommonTextWidget(lineHeight: 1.3, textAlign: TextAlign.center, heading: 'Cover your phone camera with index finger properly and start measure', fontSize: Dimens.twenty, color: Colors.black, fontFamily: 'medium'),
                                        ))),
                              Obx(() => !value.isBPMEnabled.value
                                  ? Center(
                                      child: ElevatedButton.icon(
                                          icon: const Icon(Icons.favorite_rounded),
                                          label: Text("Measure BPM"),
                                          onPressed: () {
                                            value.isBPMEnabled.value = true;
                                            value.startTimer();
                                          }))
                                  : SizedBox()),
                              SizedBox(height: screenHeight * 0.02),

                              // Heart Rate Value
                              Obx(() => value.heartRateValue.value.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          CommonTextWidget(heading: "Heart Rate : ", fontSize: Dimens.twentyFour, color: Colors.black, fontFamily: 'bold'),
                                          CommonTextWidget(heading: value.heartRateValue.value, fontSize: Dimens.twentyFour, color: Colors.black, fontFamily: 'bold'),
                                        ],
                                      ),
                                    )
                                  : const SizedBox()),

                              Expanded(
                                child: Container(
                                    alignment: Alignment.center,
                                    width: Get.width,
                                    child: Obx(
                                      () => value.loading.value == '1'
                                          ? CircularProgressIndicator(color: ThemeProvider.primary)
                                          : value.loading.value == '2'
                                              ? CommonTextWidget(textAlign: TextAlign.center, heading: 'At least two heart rates are required for RMSSD calculation.', fontSize: Dimens.twenty, color: Colors.black, fontFamily: 'regular')
                                              : Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(AssetPath.heart, width: screenWidth * .15, height: screenWidth * .15),
                                                    SizedBox(height: screenHeight * .03),
                                                    InkWell(
                                                        onTap: () {
                                                          value.goToNext(double.parse(value.rmssd.value.toStringAsFixed(2)));
                                                        },
                                                        child: CommonTextWidget(heading: value.rmssd.value.toStringAsFixed(2), fontSize: Dimens.twentyFour, color: Colors.black, fontFamily: 'bold')),
                                                    SizedBox(height: 10),
                                                    CommonTextWidget(heading: 'Heart rate variability (HRV)', fontSize: Dimens.twentyFour, color: Colors.black, fontFamily: 'bold')
                                                  ],
                                                ),
                                    )),
                              )
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
                                        Get.toNamed(AppRouter.getFeaturesScreen(), arguments: {
                                          'frequency': StaticValue.selectedList == 'main' ? StaticValue.frequenciesList[StaticValue.playingIndex.value] : StaticValue.queueFrequenciesList[StaticValue.playingIndex.value],
                                          'frequenciesList': StaticValue.frequenciesList,
                                          'index': StaticValue.playingIndex.value,
                                          'name': StaticValue.frequencyName.value,
                                          'programName': StaticValue.programNameList, // Pass the data you want
                                          'screenName': StaticValue.screenName,
                                          'type': 'mini_player',
                                          'isPlaying': StaticValue.isPlaying.value, // Pass the data you want
                                          'currentTimeInSeconds': StaticValue.currentTimeInSeconds, // Pass the data you want
                                          'selectedList': StaticValue.selectedList
                                        });
                                      },
                                      child: CustomMiniPlayer(screenWidth: screenWidth, screenHeight: screenHeight)),
                                )
                              : Container()),
                        ],
                      )),
                )
              : CommonLoadingWidget(screenHeight: screenHeight, screenWidth: screenWidth)));
    });
  }

// @override
// Widget build(BuildContext context) {
//   return GetBuilder<HeartController>(builder: (value) {
//      return SafeArea(
//        child: Scaffold(
//          backgroundColor: Colors.grey.shade100,
//          body: Column(
//            children: [
//
//              Padding(
//                padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: [
//                    InkWell(
//                      onTap: () {
//                        value.onBackRoutes();
//                      },
//                      child: Container(
//                        width: kIsWeb ? screenWidth * .07 :  screenWidth * .1,
//                        height: kIsWeb ? screenWidth * .07 :  screenWidth * .1,
//                        decoration: BoxDecoration(
//                            border: Border.all(
//                              color: ThemeProvider.borderColor,
//                            ),
//                            borderRadius: const BorderRadius.all(
//                                Radius.circular(10))),
//                        child: Padding(
//                          padding: EdgeInsets.all(screenWidth * .02),
//                          child: SvgPicture.asset(AssetPath.back_arrow),
//                        ),
//                      ),
//                    ),
//                    CommonTextWidget(
//                        lineHeight: 1.3,
//                        heading: AppString.frequencies,
//                        fontSize: Dimens.twentyFour,
//                        color: Colors.black,
//                        fontFamily: 'bold'),
//                    InkWell(
//                      onTap: () {},
//                      child: Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: SvgPicture.asset(
//                          AssetPath.setting,
//                          width: screenWidth * .01,
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//
//              isBPMEnabled
//                  ? dialog = HeartBPMDialog(
//                context: context,
//                showTextValues: true,
//                borderRadius: 10,
//                onRawData: (value) {
//                  setState(() {
//                    if (data.length >= 100) data.removeAt(0);
//                    data.add(value);
//                  });
//                  // chart = BPMChart(data);
//                },
//                onBPM: (value) =>
//                    setState(() {
//                      if (bpmValues.length >= 100) bpmValues.removeAt(0);
//                      bpmValues.add(SensorValue(value: value.toDouble(), time: DateTime.now()));
//                    }),
//                sampleDelay: 1000 ~/ 20,
//                child: Container(
//                  height: 50,
//                  width: 100,
//                  child: BPMChart(data),
//                ),
//              )
//                  : SizedBox(),
//
//              Center(
//                child: ElevatedButton.icon(
//                  icon: Icon(Icons.favorite_rounded),
//                  label: Text(isBPMEnabled ? "Stop measurement" : "Measure BPM"),
//                  onPressed: () =>
//                      setState(() {
//                        if (isBPMEnabled) {
//                          isBPMEnabled = false;
//                          // dialog.
//                        } else
//                          isBPMEnabled = true;
//                      }),
//                ),
//              ),
//            ],
//          ),
//        ),
//      );
//   });
// }

/*  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<HeartController>(builder: (value) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
              padding: EdgeInsets.all(screenWidth * .04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          value.onBackRoutes();
                        },
                        child: Container(
                          width: kIsWeb ? screenWidth * .07 : screenWidth * .1,
                          height: kIsWeb ? screenWidth * .07 : screenWidth * .1,
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
                      CommonTextWidget(lineHeight: 1.3,
                          heading: AppString.heart_rate,
                          fontSize: Dimens.twentyFour,
                          color: Colors.black,
                          fontFamily: 'bold'),
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * .02),
                          child: SvgPicture.asset(AssetPath.setting, width: screenWidth * .012, color: ThemeProvider.blackColor),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: screenHeight * .7,
                    alignment: Alignment.center,
                    child: Center(
                      child: CommonTextWidget(
                          heading: AppString.comingSoon,
                          fontSize: Dimens.sixteen,
                          color: Colors.black,
                          fontFamily: 'regular'),
                    ),
                  )

                ],
              )),
        ),
      );
    });
  }*/
}

/*
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:heal_with_science/controller/heart_controller.dart';
import 'package:heal_with_science/util/theme.dart';
import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/string.dart';
import '../widgets/commontext.dart';
import 'package:heart_bpm/heart_bpm.dart';

class HeartRateScreen extends StatefulWidget {
  const HeartRateScreen({Key? key}) : super(key: key);

  @override
  State<HeartRateScreen> createState() => _HeartRateScreenState();
}

class _HeartRateScreenState extends State<HeartRateScreen> {
  double screenHeight = 0, screenWidth = 0;
  List<SensorValue> data = [];
  List<SensorValue> bpmValues = [];

  //  Widget chart = BPMChart(data);

  bool isBPMEnabled = false;
  Widget? dialog;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<HeartController>(builder: (value) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
              padding: EdgeInsets.all(screenWidth * .04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          value.onBackRoutes();
                        },
                        child: Container(
                          width: kIsWeb ? screenWidth * .07 : screenWidth * .1,
                          height: kIsWeb ? screenWidth * .07 : screenWidth * .1,
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
                      CommonTextWidget(lineHeight: 1.3, heading: AppString.heart_rate, fontSize: Dimens.twentyFour, color: Colors.black, fontFamily: 'bold'),
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * .02),
                          child: SvgPicture.asset(AssetPath.setting, width: screenWidth * .012, color: ThemeProvider.blackColor),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: screenWidth,
                    height: screenHeight * .7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => value.loading.value == '1'
                              ? CircularProgressIndicator(color: ThemeProvider.primary)
                              : value.loading.value == '2'
                                  ? CommonTextWidget(textAlign: TextAlign.center, heading: 'Your should wear smart watch and it should be connect with google fit account for results.', fontSize: Dimens.twenty, color: Colors.black, fontFamily: 'regular')
                                  : Column(
                                      children: [
                                        SvgPicture.asset(AssetPath.heart,width: screenWidth * .3,height: screenWidth * .3),
                                        SizedBox(height: screenHeight * .03),
                                        InkWell(
                                            onTap: (){
                                              value.goToNext(double.parse(value.rmssd.value.toStringAsFixed(2)));
                                            },
                                            child: CommonTextWidget(heading: value.rmssd.value.toStringAsFixed(2), fontSize: Dimens.twentyFour, color: Colors.black, fontFamily: 'bold')),
                                        SizedBox(height: 10),
                                        CommonTextWidget(heading: 'Heart rate variability (HRV)', fontSize: Dimens.twentyFour, color: Colors.black, fontFamily: 'bold')
                                      ],
                                    ),
                        )

                        // Obx(() => Expanded(child: healthCard(title: "Heart rate", image: AssetPath.user, data: value.heartRate.value != "null" ? "${value.heartRate.value} bpm" : "", color: const Color(0xFF8d7ffa)))),
                        // const SizedBox(
                        //   width: 10,
                        // ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      );
    });
  }

  Widget healthCard({String title = "", String data = "", Color color = Colors.blue, required String image}) {
    return Container(
      height: 240,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Image.asset(image, width: 70),
          Text(data),
        ],
      ),
    );
  }
}
*/
