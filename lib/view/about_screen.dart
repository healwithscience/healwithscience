import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:heal_with_science/controller/about_controller.dart';
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

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
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

    return GetBuilder<AboutController>(builder: (value) {
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
                              CommonTextWidget(heading: AppString.about, fontSize: Dimens.twentyFour, color: Colors.black, fontFamily: 'bold'),
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
                                  CommonTextWidget(heading: AppString.deletion_guide, fontSize: Dimens.twenty, color: Colors.black, fontFamily: 'regular'),
                                  SizedBox(height: screenHeight * .025),
                                  CommonTextWidget(heading: 'Thank you for using our app! If you wish to delete your account, please follow the instructions below:', fontSize: Dimens.fifteen, color: Colors.black, fontFamily: 'regular'),
                                  SizedBox(height: screenHeight * .01),
                                  CommonTextWidget(heading: '1. Log in to your account.', fontSize: Dimens.fifteen, color: Colors.black, fontFamily: 'regular'),
                                  SizedBox(height: screenHeight * .01),
                                  CommonTextWidget(heading: '2. Go to the account Profile page.', fontSize: Dimens.fifteen, color: Colors.black, fontFamily: 'regular'),
                                  SizedBox(height: screenHeight * .01),
                                  CommonTextWidget(heading: '3. Find the option for account deletion.', fontSize: Dimens.fifteen, color: Colors.black, fontFamily: 'regular'),
                                  SizedBox(height: screenHeight * .01),
                                  CommonTextWidget(heading: '4. Follow the on-screen instructions to confirm and complete the process.', fontSize: Dimens.fifteen, color: Colors.black, fontFamily: 'regular'),
                                  SizedBox(height: screenHeight * .02),
                                  RichText(
                                    text: TextSpan(
                                      text: 'If you encounter any issues or have questions, feel free to contact our support team at ',
                                      style: TextStyle(fontSize: Dimens.fifteen, color: Colors.black, fontFamily: 'bold'),
                                      children: const <TextSpan>[
                                        TextSpan(
                                          text: 'healwithscience.ai@gmail.com',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            // Add other styles as needed
                                          ),
                                        ),
                                      ],
                                    ),
                                    softWrap: true,
                                  ),
                                  SizedBox(height: screenHeight * .025),
                                  CommonTextWidget(heading: 'Additional Information', fontSize: Dimens.twenty, color: Colors.black, fontFamily: 'regular'),
                                  SizedBox(height: screenHeight * .025),
                                  CustomGradientDivider(
                                    height: 1.0,
                                    startColor: ThemeProvider.greyColor,
                                    endColor: Colors.transparent,
                                  ),
                                  SizedBox(height: screenHeight * .02),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Privacy and Security : ',
                                      style: TextStyle(fontSize: Dimens.fifteen, color: Colors.black, fontFamily: 'bold'),
                                      children: const <TextSpan>[
                                        TextSpan(
                                          text: 'We take your privacy seriously. Account deletion ensures that your personal information is handled securely.',
                                          style: TextStyle(color: Colors.black, fontFamily: 'regular'
                                              // Add other styles as needed
                                              ),
                                        ),
                                      ],
                                    ),
                                    softWrap: true,
                                  ),
                                  SizedBox(height: screenHeight * .01),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Consequences : ',
                                      style: TextStyle(fontSize: Dimens.fifteen, color: Colors.black, fontFamily: 'bold'),
                                      children: const <TextSpan>[
                                        TextSpan(
                                          text: 'Be aware that account deletion may result in the loss of data, subscriptions, and other account-related information.',
                                          style: TextStyle(color: Colors.black, fontFamily: 'regular'
                                              // Add other styles as needed
                                              ),
                                        ),
                                      ],
                                    ),
                                    softWrap: true,
                                  ),
                                  SizedBox(height: screenHeight * .025),
                                  CommonTextWidget(heading: 'Contact Us', fontSize: Dimens.twenty, color: Colors.black, fontFamily: 'regular'),
                                  SizedBox(height: screenHeight * .025),
                                  CustomGradientDivider(
                                    height: 1.0,
                                    startColor: ThemeProvider.greyColor,
                                    endColor: Colors.transparent,
                                  ),
                                  SizedBox(height: screenHeight * .02),
                                  RichText(
                                    text: TextSpan(
                                      text: 'For any further assistance, please contact our support team at ',
                                      style: TextStyle(fontSize: Dimens.fifteen, color: Colors.black, fontFamily: 'bold'),
                                      children: const <TextSpan>[
                                        TextSpan(
                                          text: 'healwithscience.ai@gmail.com',
                                          style: TextStyle(
                                            color: Colors.blue,
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
