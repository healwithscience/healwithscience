import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:heal_with_science/controller/about_controller.dart';
import 'package:heal_with_science/controller/privacy_policy_controller.dart';
import 'package:heal_with_science/controller/profile_controller.dart';
import 'package:heal_with_science/widgets/common_menu.dart';

import '../backend/helper/app_router.dart';
import '../controller/frequency_controller.dart';
import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/extensions/static_values.dart';
import '../util/inactivity_manager.dart';
import '../util/string.dart';
import '../util/theme.dart';
import '../widgets/CustomGradientDivider.dart';
import '../widgets/common_loading.dart';
import '../widgets/common_min_player.dart';
import '../widgets/commontext.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  double screenHeight = 0, screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      screenHeight = MediaQuery.of(context).size.height / 3;
      screenWidth = MediaQuery.of(context).size.width / 3;
    } else {
      screenHeight = MediaQuery.of(context).size.height;
      screenWidth = MediaQuery.of(context).size.width;
    }

    return GetBuilder<PrivacyPolicyController>(builder: (value) {
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
                              CommonTextWidget(heading: AppString.privacy_policy, fontSize: Dimens.twentyFour, color: Colors.black, fontFamily: 'bold'),
                              SizedBox(
                                width: screenWidth * .1,
                                height: screenWidth * .1,
                              )
                            ],
                          ),
                          SizedBox(height: screenHeight * .025),
                          CustomGradientDivider(
                            height: 1.0,
                            startColor: ThemeProvider.greyColor,
                            endColor: Colors.transparent,
                          ),
                          SizedBox(height: screenHeight * .025),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonTextWidget(heading: AppString.privacy_policy_heading1, fontSize: Dimens.sixteen, color: Colors.black, fontFamily: 'medium'),
                                  SizedBox(height: screenHeight * .01),
                                  CommonTextWidget(heading: 'What data do we collect?', fontSize: Dimens.seventeen, color: Colors.black, fontFamily: 'regular'),
                                  SizedBox(height: screenHeight * .01),
                                  CommonTextWidget(heading: 'We collect the following data from you when you use the app:', fontSize: Dimens.fifteen, color: Colors.black, fontFamily: 'regular'),

                                  SizedBox(height: screenHeight * .01),
                                  CommonTextWidget(heading: AppString.decleration1, fontSize: Dimens.fifteen, color: Colors.black, fontFamily: 'medium'),

                                  SizedBox(height: screenHeight * .01),
                                  CommonTextWidget(heading: AppString.decleration2, fontSize: Dimens.fifteen, color: Colors.black, fontFamily: 'regular'),

                                  SizedBox(height: screenHeight * .01),
                                  CommonTextWidget(heading: 'How do we use the data we collect?', fontSize: Dimens.seventeen, color: Colors.black, fontFamily: 'regular'),
                                  SizedBox(height: screenHeight * .01),
                                  CommonTextWidget(heading: 'We use the data we collect for the following purposes :', fontSize: Dimens.fifteen, color: Colors.black, fontFamily: 'regular'),

                                  SizedBox(height: screenHeight * .01),
                                  CommonTextWidget(heading: AppString.required, fontSize: Dimens.fifteen, color: Colors.black, fontFamily: 'medium'),

                                  SizedBox(height: screenHeight * .01),
                                  CommonTextWidget(heading: 'How do we store the data we collect?', fontSize: Dimens.seventeen, color: Colors.black, fontFamily: 'regular'),
                                  SizedBox(height: screenHeight * .01),
                                  CommonTextWidget(heading: AppString.decleration3, fontSize: Dimens.fifteen, color: Colors.black, fontFamily: 'regular'),



                                  SizedBox(height: screenHeight * .01),
                                  CommonTextWidget(heading: 'How do we share the data we collect?', fontSize: Dimens.seventeen, color: Colors.black, fontFamily: 'regular'),
                                  SizedBox(height: screenHeight * .01),
                                  CommonTextWidget(heading: AppString.decleration4, fontSize: Dimens.fifteen, color: Colors.black, fontFamily: 'regular'),
                                  SizedBox(height: screenHeight * .01),
                                  CommonTextWidget(heading: AppString.required2, fontSize: Dimens.fifteen, color: Colors.black, fontFamily: 'medium'),



                                  SizedBox(height: screenHeight * .01),
                                  CommonTextWidget(heading: 'How do we protect the data we collect?', fontSize: Dimens.seventeen, color: Colors.black, fontFamily: 'regular'),
                                  SizedBox(height: screenHeight * .01),
                                  CommonTextWidget(heading: AppString.decleration5, fontSize: Dimens.fifteen, color: Colors.black, fontFamily: 'regular'),


                                  SizedBox(height: screenHeight * .01),
                                  CommonTextWidget(heading: 'What are your rights regarding the data we collect?', fontSize: Dimens.seventeen, color: Colors.black, fontFamily: 'regular'),
                                  SizedBox(height: screenHeight * .01),
                                  CommonTextWidget(heading: AppString.decleration6, fontSize: Dimens.fifteen, color: Colors.black, fontFamily: 'regular'),
                                  SizedBox(height: screenHeight * .01),
                                  CommonTextWidget(heading: AppString.required3, fontSize: Dimens.fifteen, color: Colors.black, fontFamily: 'medium'),

                                  SizedBox(height: screenHeight * .01),
                                  CommonTextWidget(heading: 'How can you contact us?', fontSize: Dimens.seventeen, color: Colors.black, fontFamily: 'regular'),
                                  SizedBox(height: screenHeight * .01),
                                  RichText(
                                    text: TextSpan(
                                      text: 'If you have any questions, requests, or concerns about this privacy policy or our data practices, you can contact us at',
                                      style: TextStyle(fontSize: Dimens.fifteen, color: Colors.black, fontFamily: 'bold'),
                                      children: const <TextSpan>[
                                        TextSpan(
                                          text: ' healwithscience.ai@gmail.com. ',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            // Add other styles as needed
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'We will respond to your inquiry as soon as possible.',
                                          style: TextStyle(
                                            color: Colors.black,
                                            // Add other styles as needed
                                          ),
                                        ),
                                      ],
                                    ),
                                    softWrap: true,
                                  ),

                                ],
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
                                  'frequency':StaticValue.frequenciesList[StaticValue.playingIndex.value],
                                  'frequenciesList':StaticValue.frequenciesList,
                                  'index':StaticValue.playingIndex.value,
                                  'name': StaticValue.frequencyName.value,
                                  'programName':StaticValue.programNameList,// Pass the data you want
                                  'screenName': StaticValue.screenName,
                                  'type':'mini_player',
                                  'isPlaying':StaticValue.isPlaying.value,// Pass the data you want
                                  'currentTimeInSeconds':StaticValue.currentTimeInSeconds,// Pass the data you want
                                  'playingType' : StaticValue.playingType.value,
                                  'playingQueueIndex' : StaticValue.playingQueueIndex.value,
                                });
                              },
                              child: CustomMiniPlayer(screenWidth: screenWidth, screenHeight: screenHeight),
                            ),
                          )
                        : Container())
                  ],
                ),
              ))
            : CommonLoadingWidget(screenHeight: screenHeight, screenWidth: screenWidth)),
      );
    });
  }
}
