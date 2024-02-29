import 'dart:math';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:heal_with_science/controller/features_controller.dart';
import 'package:heal_with_science/util/all_constants.dart';
import 'package:heal_with_science/util/inactivity_manager.dart';
import 'package:heal_with_science/widgets/common_reward_dialog.dart';
import 'package:heal_with_science/widgets/common_slider.dart';
import 'package:heal_with_science/widgets/harmonicwaves.dart';
import 'package:heal_with_science/widgets/ramwave.dart';
import 'package:heal_with_science/widgets/round_cornor_button.dart';
import 'package:heal_with_science/widgets/sawtoothwave.dart';
import 'package:heal_with_science/widgets/sinwave.dart';
import 'package:heal_with_science/widgets/squarewave.dart';
import 'package:heal_with_science/widgets/triangularwave.dart';
import 'package:heal_with_science/widgets/hsquarewaves.dart';
import '../backend/helper/app_router.dart';
import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/extensions/static_values.dart';
import '../util/string.dart';
import '../util/theme.dart';
import '../widgets/CustomGradientDivider.dart';
import '../widgets/commontext.dart';
import '../widgets/fabonacciwave.dart';
import '../widgets/round_button.dart';

class FeaturesScreen extends StatefulWidget {
  const FeaturesScreen({super.key});

  @override
  State<FeaturesScreen> createState() => _FeaturesScreenState();
}

class _FeaturesScreenState extends State<FeaturesScreen> {
  double screenHeight = 0, screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return GetBuilder<FeaturesController>(builder: (value) {
        return GestureDetector(
            onPanDown: (details){
              InactivityManager.resetTimer();
            },
            onPanUpdate: (details) {
              if (details.delta.dy < -40) {
                // User is swiping up
                queueBottomSheet(value);
              }},
          child: SafeArea(
            child:  Scaffold(
              backgroundColor: ThemeProvider.light_white,
              // Set the scaffold's background to transparent
              body: WillPopScope(
                onWillPop: () async {
                  value.onBackRoutes(); // Call your function
                  return false; // Return true to allow back navigation, or false to prevent it.
                },
                child:  Obx(() =>  !InactivityManager.showImage.value ? Stack(
                  children: [
                    // Background Image
                    Obx(() => value.currentTheme.value == 2
                        ? Positioned.fill(
                      child: Image.asset(
                        AssetPath.dark_background, // Replace with your image path
                        fit: BoxFit.cover, // Adjust the fit as needed
                      ),
                    )
                        : Container()),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                          child: Row(
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
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Padding(
                                      padding: EdgeInsets.all(screenWidth * .02),
                                      child: Obx(() => SvgPicture.asset(
                                          AssetPath.white_back_arrow,
                                          color: value.currentTheme.value == 1
                                              ? ThemeProvider.blackColor
                                              : ThemeProvider.whiteColor))),
                                ),
                              ),
                              Obx(() => CommonTextWidget(
                                  heading: AppString.features,
                                  fontSize: Dimens.twentyFour,
                                  color: value.currentTheme.value == 1
                                      ? ThemeProvider.blackColor
                                      : ThemeProvider.whiteColor,
                                  fontFamily: 'bold')),
                              InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    showMenu(
                                      context: context,
                                      position: RelativeRect.fromLTRB(20, 80, 19, 0),
                                      // Adjust position as needed
                                      items: [
                                        PopupMenuItem(
                                          value: 1,
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(AssetPath.light,
                                                  width: 30),
                                              const SizedBox(width: 10),
                                              CommonTextWidget(
                                                heading: AppString.light_mode,
                                                fontSize: Dimens.forteen,
                                                color: ThemeProvider.blackColor,
                                                fontFamily: 'light',
                                              ),
                                              // Adjust spacing as needed
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 2,
                                          child: Row(
                                            children: [
                                              const SizedBox(width: 5),
                                              SvgPicture.asset(AssetPath.dark,
                                                  width: 20),
                                              const SizedBox(width: 13),
                                              CommonTextWidget(
                                                heading: AppString.dark_mode,
                                                fontSize: Dimens.forteen,
                                                color: ThemeProvider.blackColor,
                                                fontFamily: 'light',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                      elevation: 2,
                                    ).then((newValue) {
                                      if (newValue == 1 || newValue == 2) {
                                        value.setTheme(newValue!);
                                      }
                                    });
                                  },
                                  child: Obx(
                                        () => Padding(
                                      padding: EdgeInsets.all(screenWidth * .03),
                                      child: SvgPicture.asset(
                                        AssetPath.setting,
                                        color: value.currentTheme.value == 1
                                            ? ThemeProvider.blackColor
                                            : ThemeProvider.whiteColor,
                                        width: screenWidth * .01,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),

                        kIsWeb ? const SizedBox() :  SizedBox(height: screenHeight * .05)  ,

                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                            children: [
                              Center(child: Container(
                                width: screenWidth * .6,
                                height:  screenWidth * .6,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.all(Radius.circular(25))),
                                child: Opacity(
                                  opacity: 0.7,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          center: Alignment.center,
                                          radius: 1.1,
                                          stops: [0.2, 0.5, 0.8],
                                          colors: [
                                            ThemeProvider.primary,
                                            Colors.transparent,
                                            ThemeProvider.primary
                                          ],
                                        ),
                                        image: DecorationImage(
                                            image: AssetImage(AssetPath.person),
                                            fit: BoxFit.fitHeight,
                                            alignment: Alignment.center)),
                                    child: Obx(() => CustomPaint(
                                        painter: value.selectedOption.value == 1
                                            ? SinWavePainter(
                                          frequency: value.frequencyValue.value,
                                          amplitude: value.amplitude.value,
                                          dutyCycle: value.dutyCycle.value,
                                          phase: value.phaseControl.value,
                                          offset: value.offset.value,
                                        ) : value.selectedOption.value == 2
                                            ? SquareWavePainter(
                                          frequency: value.frequencyValue.value,
                                          amplitude: value.amplitude.value,
                                          dutyCycle: value.dutyCycle.value,
                                          phase: value.phaseControl.value,
                                          offset: value.offset.value,
                                        ) : value.selectedOption.value == 3
                                            ? RamWavePainter(
                                          frequency: value.frequencyValue.value,
                                          amplitude: value.amplitude.value,
                                          dutyCycle: value.dutyCycle.value,
                                          phase: value.phaseControl.value,
                                          offset: value.offset.value,
                                        ) : value.selectedOption.value == 4
                                            ? SawToothWavePainter(
                                          frequency: value.frequencyValue.value,
                                          amplitude: value.amplitude.value,
                                          dutyCycle: value.dutyCycle.value,
                                          phase: value.phaseControl.value,
                                          offset: value.offset.value,
                                        ) : value.selectedOption.value == 5
                                            ? TriangularWavePainter(
                                          frequency: value.frequencyValue.value,
                                          amplitude: value.amplitude.value,
                                          dutyCycle: value.dutyCycle.value,
                                          phase: value.phaseControl.value,
                                          offset: value.offset.value,
                                        ) : value.selectedOption.value == 6
                                            ? FibonacciWavesPainter(
                                          frequency: value.frequencyValue.value,
                                          amplitude: value.amplitude.value,
                                          dutyCycle: value.dutyCycle.value,
                                          phase: value.phaseControl.value,
                                          offset: value.offset.value,
                                        ): value.selectedOption.value == 7
                                            ? HarmonicWavePainter(
                                          frequency: value.frequencyValue.value,
                                          amplitude: value.amplitude.value,
                                          dutyCycle: value.dutyCycle.value,
                                          phase: value.phaseControl.value,
                                          offset: value.offset.value,
                                        ) : HSquareWavePainter(
                                          frequency: value.frequencyValue.value,
                                          amplitude: value.amplitude.value,
                                          dutyCycle: value.dutyCycle.value,
                                          phase: value.phaseControl.value,
                                          offset: value.offset.value,
                                        )
                                    )),
                                  ),
                                ),
                              )),
                          
                              kIsWeb ? const SizedBox() :  SizedBox(height: screenHeight * .02),
                          
                              //Indicator
                              Obx(() => Container(
                                margin: const EdgeInsets.all(10),
                                alignment: Alignment.center,
                                child: DotsIndicator(
                                  dotsCount: 2, // Replace with the number of slides
                                  position: value.currentIndex.value.toDouble(),
                                  decorator: const DotsDecorator(
                                    activeColor: ThemeProvider.persianGreen,
                                    activeSize: Size(10, 10),
                                    spacing: EdgeInsets.all(4),
                                  ),
                                ),
                              )),
                          
                              SizedBox(
                                height:kIsWeb ? screenHeight * .7   : screenHeight * .4,
                                child: PageView(
                                  onPageChanged: (index) {
                                    value.currentIndex.value = index.toDouble();
                                  },
                                  children: <Widget>[
                                    //Slider One
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Obx(() => CommonTextWidget(
                                              textAlign: TextAlign.center,
                                              heading: value.programName.value.toString(),
                                              fontSize: Dimens.twenty,
                                              color: value.currentTheme.value == 1 ? ThemeProvider.blackColor : ThemeProvider.light_white,
                                              fontFamily: 'bold')),
                                          //display frequency currently playing
                                          SizedBox(height: screenHeight * .01),
                                          Obx(() => CommonTextWidget(
                                              lineHeight: 1.3,
                                              heading: "${value.frequencyValue} HZ",
                                              fontSize: Dimens.eighteen,
                                              color: value.currentTheme.value == 1 ? ThemeProvider.lightBlack : ThemeProvider.light_white,
                                              fontFamily: 'light')),

                                          SizedBox(height: screenHeight * .01),

                                          Stack(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  //backward button
                                                  InkWell(
                                                    splashColor: Colors.transparent,
                                                    highlightColor: Colors.transparent,
                                                    onTap: () {
                                                      if(StaticValue.rewardPoint > 0){
                                                        value.playPrevious();
                                                      }else{
                                                        showCommonRewardDialog(context ,screenHeight ,screenWidth ,() {
                                                          value.stopFrequency();
                                                          value.pauseTimer();
                                                          Future.delayed(const Duration(seconds: 1), () {
                                                            value.showRewardedAd();
                                                          });
                                                        });
                                                      }
                                                    },
                                                    child: RoundButton(
                                                      width: screenWidth * .12,
                                                      height: screenWidth * .12,
                                                      child: SvgPicture.asset(AssetPath.backword),
                                                      borderColor: ThemeProvider.borderColor,
                                                      padding: screenWidth * 0.04,
                                                      background: ThemeProvider.bright_gray,
                                                    ),
                                                  ),
                                                  // Button to handle play or pause
                                                  SizedBox(width: screenWidth * 0.05),
                                                  Obx(() => InkWell(
                                                      splashColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      onTap: () {
                                                        if(!value.isButtonPressed.value){
                                                          if (value.isPlaying.value == false) {
                                                            value.playFrequency();
                                                            value.startTime();
                                                          } else {
                                                            value.stopFrequency();
                                                            value.pauseTimer();
                                                          }
                                                          // Future.delayed(const Duration(seconds: 1),() {});
                                                        }
                                                      },
                                                      child: RoundButton(
                                                        width: screenWidth * .15,
                                                        height: screenWidth * .15,
                                                        borderColor: ThemeProvider.borderColor,
                                                        padding: screenWidth * 0.04,
                                                        background: ThemeProvider.bright_gray,
                                                        child: SvgPicture.asset(
                                                            value.isPlaying.value == true ? AssetPath.play2 : AssetPath.play),
                                                      ))),
                                                  //forward button
                                                  SizedBox(width: screenWidth * 0.05),
                                                  InkWell(
                                                    splashColor: Colors.transparent,
                                                    highlightColor: Colors.transparent,
                                                    onTap: () {
                                                      if(value.parser.getPlan() == "intermediate" || value.parser.getPlan() == "advance"){
                                                        value.playNext();
                                                      }else{
                                                        if(StaticValue.rewardPoint > 0){
                                                          value.playNext();
                                                        }
                                                        else{
                                                          showCommonRewardDialog(context ,screenHeight ,screenWidth ,() {
                                                            value.stopFrequency();
                                                            value.pauseTimer();
                                                            Future.delayed(const Duration(seconds: 2), () {
                                                              value.showRewardedAd();
                                                            });
                                                          });
                                                        }
                                                      }

                                                    },
                                                    child: RoundButton(
                                                      width: screenWidth * .12,
                                                      height: screenWidth * .12,
                                                      borderColor: ThemeProvider.borderColor,
                                                      padding: screenWidth * 0.04,
                                                      background: ThemeProvider.bright_gray,
                                                      child: SvgPicture.asset(
                                                          AssetPath.forword),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Positioned(
                                                top: 0,
                                                bottom: 0,
                                                left:screenWidth * .13,
                                                child:Obx(() => InkWell(
                                                  splashColor: Colors.transparent,
                                                  highlightColor: Colors.transparent,
                                                  onTap: (){
                                                    value.playType.value == 1 ? value.playType.value = 0 : value.playType.value = 1;
                                                  },
                                                  child: SizedBox(
                                                    width: screenWidth * .06,
                                                    child: value.playType.value == 0 ? SvgPicture.asset(AssetPath.repeat) : SvgPicture.asset(AssetPath.repeat_again),
                                                  ),
                                                )),
                                              )

                                            ],
                                          ),
                                          SizedBox(height: screenHeight * .04),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                            child: Row(
                                              children: [
                                                Obx(() => RoundButton(
                                                    width: screenWidth * .05,
                                                    height: screenWidth * .05,
                                                    borderColor: ThemeProvider.borderColor,
                                                    background: ThemeProvider.bright_gray,
                                                    padding: screenWidth * .014,
                                                    child: SvgPicture.asset(value.isPlaying.value == true ? AssetPath.play2 : AssetPath.play))),
                                                // use to represent playing fequency progress
                                                Expanded(
                                                  child: Obx(() => Slider(
                                                    value: value.sliderProgress.value,
                                                    // Change the color of the active part of the slider
                                                    activeColor: ThemeProvider.persianGreen,
                                                    inactiveColor: ThemeProvider.borderColor,
                                                    onChanged: (newValue) {},
                                                    min: 0.0,
                                                    max: double.parse(value.totalTimeInSeconds.toString()),
                                                  )),
                                                ),

                                                Obx(() => CommonTextWidget(
                                                    heading: "${value.totalTime.value}",
                                                    fontSize: Dimens.sixteen,
                                                    color: value.currentTheme.value == 1 ? ThemeProvider.lightBlack : ThemeProvider.light_white,
                                                    fontFamily: 'light')),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              // Use to select type of wave (Open BottomSheep to select type of wave)
                                              GestureDetector(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                    backgroundColor: Colors.transparent,
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return Container(
                                                        decoration: const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(20.0),
                                                            topRight: Radius.circular(20.0),
                                                          ),
                                                        ),
                                                        child: Theme(
                                                            data: Theme.of(context).copyWith(
                                                              unselectedWidgetColor: ThemeProvider.primary,
                                                              disabledColor: ThemeProvider.primary,
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                Align(
                                                                  alignment: Alignment.centerRight,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(top: 20.0, right: 20.0),
                                                                    child: InkWell(
                                                                        splashColor: Colors.transparent,
                                                                        highlightColor: Colors.transparent,
                                                                        onTap: () {
                                                                          Navigator.of(context).pop();
                                                                        },
                                                                        child: SvgPicture.asset(AssetPath.close, width: 15, height: 15)),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: SingleChildScrollView(
                                                                    child: Column(
                                                                      children: [
                                                                        //Sin wave radio button
                                                                        ListTile(
                                                                          title: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              CommonTextWidget(
                                                                                heading: AppString.sin_wave,
                                                                                fontSize: Dimens.forteen,
                                                                                color: ThemeProvider.blackColor,
                                                                                fontFamily: 'light',
                                                                              ),
                                                                              const SizedBox(height: 10),
                                                                              // Adjust spacing as needed
                                                                              SvgPicture.asset(AssetPath.sin),
                                                                            ],
                                                                          ),
                                                                          leading: Obx(
                                                                                  () => Radio<int>(
                                                                                value: 1,
                                                                                activeColor: ThemeProvider.primary,
                                                                                groupValue: value.selectedOption.value,
                                                                                onChanged: (int?newValue) {
                                                                                  value.selectRadioButton(newValue);
                                                                                },
                                                                              )),
                                                                        ),
                                                                        //Square wave radio button
                                                                        const SizedBox(height: 10),
                                                                        ListTile(
                                                                          title: Column(mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              CommonTextWidget(
                                                                                heading: AppString.square_wave,
                                                                                fontSize: Dimens.forteen,
                                                                                color: ThemeProvider.blackColor,
                                                                                fontFamily: 'light',
                                                                              ),
                                                                              const SizedBox(height: 10),
                                                                              SvgPicture.asset(AssetPath.square,)
                                                                            ],
                                                                          ),
                                                                          leading: Obx(
                                                                                  () => Radio<int>(
                                                                                value: 2,
                                                                                activeColor: ThemeProvider.primary,
                                                                                groupValue: value.selectedOption.value,
                                                                                onChanged: (int?newValue) {
                                                                                  value.selectRadioButton(newValue);
                                                                                },
                                                                              )),
                                                                        ),
                                                                        //Ram wave radio button
                                                                        const SizedBox(height: 10),
                                                                        ListTile(
                                                                          title: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              CommonTextWidget(
                                                                                heading: AppString.ram_wave,
                                                                                fontSize: Dimens.forteen,
                                                                                color: ThemeProvider.blackColor,
                                                                                fontFamily: 'light',
                                                                              ),
                                                                              const SizedBox(height: 10),
                                                                              SvgPicture.asset(AssetPath.ram,)
                                                                            ],
                                                                          ),
                                                                          leading: Obx(
                                                                                  () => Radio<int>(
                                                                                  value: 3,
                                                                                  activeColor: ThemeProvider.primary,
                                                                                  groupValue: value.selectedOption.value,
                                                                                  onChanged: (int?newValue) {
                                                                                    value.selectRadioButton(newValue);
                                                                                  })),
                                                                        ),
                                                                        //Saw wave radio button
                                                                        const SizedBox(height: 10),
                                                                        ListTile(
                                                                          title: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              CommonTextWidget(heading: AppString.saw_wave,
                                                                                fontSize: Dimens.forteen,
                                                                                color: ThemeProvider.blackColor,
                                                                                fontFamily: 'light',
                                                                              ),
                                                                              const SizedBox(height: 10),
                                                                              SvgPicture.asset(AssetPath.saw,)
                                                                            ],
                                                                          ),
                                                                          leading: Obx(
                                                                                  () => Radio<int>(
                                                                                value: 4,
                                                                                activeColor: ThemeProvider.primary,
                                                                                groupValue: value.selectedOption.value,
                                                                                onChanged: (int?newValue) {
                                                                                  value.selectRadioButton(newValue);
                                                                                },
                                                                              )),
                                                                        ),
                                                                        //Triangular wave radio button
                                                                        const SizedBox(height: 10),
                                                                        ListTile(
                                                                          title: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              CommonTextWidget(
                                                                                heading: AppString.triangular_wave,
                                                                                fontSize: Dimens.forteen,
                                                                                color: ThemeProvider.blackColor,
                                                                                fontFamily: 'light',
                                                                              ),
                                                                              const SizedBox(height: 10),
                                                                              SvgPicture.asset(AssetPath.triangular,
                                                                              )
                                                                            ],
                                                                          ),
                                                                          leading: Obx(
                                                                                  () => Radio<int>(
                                                                                value: 5,
                                                                                activeColor: ThemeProvider.primary,
                                                                                groupValue: value.selectedOption.value,
                                                                                onChanged: (int?newValue) {
                                                                                  value.selectRadioButton(newValue);
                                                                                },
                                                                              )),
                                                                        ),
                                                                        //Fabonnaci wave radio button
                                                                        const SizedBox(height: 10),
                                                                        ListTile(
                                                                          title: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              CommonTextWidget(
                                                                                heading: AppString.fabonnaci_wave,
                                                                                fontSize: Dimens.forteen,
                                                                                color: ThemeProvider.blackColor,
                                                                                fontFamily: 'light',
                                                                              ),
                                                                              const SizedBox(height: 10),
                                                                              SvgPicture.asset(AssetPath.triangular,
                                                                              )
                                                                            ],
                                                                          ),
                                                                          leading: Obx(
                                                                                  () => Radio<int>(
                                                                                value: 6,
                                                                                activeColor: ThemeProvider.primary,
                                                                                groupValue: value.selectedOption.value,
                                                                                onChanged: (int?newValue) {
                                                                                  value.selectRadioButton(newValue);
                                                                                },
                                                                              )),
                                                                        ),
                                                                        //Harmonic wave radio button
                                                                        const SizedBox(height: 10),
                                                                        ListTile(
                                                                          title: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              CommonTextWidget(
                                                                                heading: AppString.harmonic_wave,
                                                                                fontSize: Dimens.forteen,
                                                                                color: ThemeProvider.blackColor,
                                                                                fontFamily: 'light',
                                                                              ),
                                                                              const SizedBox(height: 10),
                                                                              SvgPicture.asset(AssetPath.triangular,
                                                                              )
                                                                            ],
                                                                          ),
                                                                          leading: Obx(
                                                                                  () => Radio<int>(
                                                                                value: 7,
                                                                                activeColor: ThemeProvider.primary,
                                                                                groupValue: value.selectedOption.value,
                                                                                onChanged: (int?newValue) {
                                                                                  value.selectRadioButton(newValue);
                                                                                },
                                                                              )),
                                                                        ),

                                                                        const SizedBox(height: 10),
                                                                        ListTile(
                                                                          title: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              CommonTextWidget(
                                                                                heading: AppString.hsquare_wave,
                                                                                fontSize: Dimens.forteen,
                                                                                color: ThemeProvider.blackColor,
                                                                                fontFamily: 'light',
                                                                              ),
                                                                              const SizedBox(height: 10),
                                                                              SvgPicture.asset(AssetPath.triangular,
                                                                              )
                                                                            ],
                                                                          ),
                                                                          leading: Obx(
                                                                                  () => Radio<int>(
                                                                                value: 8,
                                                                                activeColor: ThemeProvider.primary,
                                                                                groupValue: value.selectedOption.value,
                                                                                onChanged: (int?newValue) {
                                                                                  value.selectRadioButton(newValue);
                                                                                },
                                                                              )),
                                                                        ),

                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                      );

                                                    },
                                                  );
                                                },
                                                child: RoundConorButton(
                                                  width: screenWidth * .25,
                                                  height: screenHeight * .05,
                                                  heading: AppString.wave,
                                                  fontSize: Dimens.fifteen,
                                                  color: ThemeProvider.persianGreen,
                                                  child: SvgPicture.asset(AssetPath.wave),
                                                ),
                                              ),
                                              SizedBox(width: screenWidth * .05),
                                              //Use to select frequency
                                              GestureDetector(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                    backgroundColor: Colors.transparent,
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return Container(
                                                        decoration: const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(20.0),
                                                            topRight: Radius.circular(20.0),
                                                          ),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            // Add your row above the list title here
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 15),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Expanded(
                                                                      child: Align(
                                                                        alignment: Alignment.center,
                                                                        child: Padding(
                                                                            padding: EdgeInsets.only(
                                                                                top: screenHeight * .02,
                                                                                bottom: screenHeight * .02,
                                                                                right: 20.0),
                                                                            child: CommonTextWidget(
                                                                              lineHeight: 1.3,
                                                                              heading: AppString.frequencies,
                                                                              fontSize: Dimens.twentyFour,
                                                                              color: Colors.black,
                                                                              fontFamily: 'bold',
                                                                            )
                                                                        ),
                                                                      )),
                                                                  Align(
                                                                    alignment: Alignment.topRight,
                                                                    // Adjusted alignment here
                                                                    child: Padding(
                                                                      padding: EdgeInsets.only(
                                                                          top: screenHeight * .02,
                                                                          bottom: screenHeight * .02,
                                                                          right: 20.0),
                                                                      child: InkWell(
                                                                        onTap: () {
                                                                          Navigator.of(context).pop();
                                                                        },
                                                                        child: SvgPicture.asset(AssetPath.close, width: 15, height: 15),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            // List title "Frequency" and items
                                                            Expanded(
                                                              child: ListView.builder(
                                                                itemCount: value.frequenciesList.length,
                                                                itemBuilder: (context, index) {
                                                                  return Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [

                                                                      InkWell(
                                                                        onTap: () {
                                                                          print("HelloIamPressed");
                                                                          if(StaticValue.rewardPoint > 0){
                                                                            value.selectedList.value = 'main';
                                                                            value.isButtonPressed.value = true;
                                                                            value.playingIndex.value = index;
                                                                            value.isProcessing.value = true;
                                                                            value.frequencyValue.value = value.frequenciesList[index]!;
                                                                            value.resetTimer();
                                                                            Future.delayed(const Duration(seconds: 3),()
                                                                            {
                                                                              value.isProcessing.value = false;
                                                                              value.playFrequency();
                                                                              value.startTime();
                                                                              value.isButtonPressed.value = false;
                                                                            });
                                                                          }else{
                                                                            showCommonRewardDialog(context ,screenHeight ,screenWidth ,() {
                                                                              value.stopFrequency();
                                                                              value.pauseTimer();
                                                                              Future.delayed(const Duration(seconds: 2), () {
                                                                                value.showRewardedAd();
                                                                              });
                                                                            });
                                                                          }
                                                                          // Navigator.of(context).pop();
                                                                        },
                                                                        child: Padding(
                                                                          padding: EdgeInsets.symmetric(horizontal: 15),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  RoundButton(
                                                                                    width: screenWidth * .05,
                                                                                    height: screenWidth * .05,
                                                                                    borderColor: ThemeProvider.borderColor,
                                                                                    padding: screenWidth * .013,
                                                                                    child: SvgPicture.asset(AssetPath.play),
                                                                                  ),
                                                                                  Padding(
                                                                                      padding: EdgeInsets.all(screenWidth * .05),
                                                                                      child: CommonTextWidget(
                                                                                        heading: "${value.frequenciesList[index]} HZ",
                                                                                        fontSize: Dimens.sixteen,
                                                                                        color: Colors.black,
                                                                                        fontFamily: 'medium',
                                                                                      )
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  //loading gif
                                                                                  Obx(() => value.playingIndex.value == index && value.isProcessing.value == true
                                                                                      ? Padding(
                                                                                    padding: EdgeInsets.all(screenWidth * .05),
                                                                                    child: Image.asset(
                                                                                      AssetPath.loading,
                                                                                      height: screenWidth * .05,
                                                                                      width: 25.0,
                                                                                    ),
                                                                                  )
                                                                                      : Container()),

                                                                                  //Handle Download based on subscription type
                                                                                  value.parser.getPlan() == "advance"?
                                                                                  (value.screenName == "category" || value.screenName == "frequency") ?
                                                                                  !value.checkStatus(value.frequenciesList[index].toString()) ?
                                                                                  InkWell(
                                                                                    onTap: (){
                                                                                      value.downloadButtonClickedList[index] = 2;
                                                                                      Future.delayed(const Duration(seconds: 1), (){
                                                                                        value.downloadButtonClickedList[index] = 3;
                                                                                      });
                                                                                      value.parser.updateList(value.programName.value.toString(), value.frequenciesList[index].toString());
                                                                                    },
                                                                                    child: Padding(padding: EdgeInsets.all(screenWidth * .01),
                                                                                        child: Obx(() =>  value.downloadButtonClickedList[index] == 1 ?  SvgPicture.asset(AssetPath.download,width: screenWidth * 0.06) :  value.downloadButtonClickedList[index] == 2 ? Image.asset(
                                                                                          AssetPath.loading,
                                                                                          height: screenWidth * .05,
                                                                                          width: 25.0,
                                                                                        ) : Container() )),
                                                                                  ):Container() : Container() : Container(),

                                                                                  (value.screenName == "category" || value.screenName == "frequency") ?
                                                                                  PopupMenuButton<String>(
                                                                                    offset: const Offset(00, 40),
                                                                                    itemBuilder: (context) => [
                                                                                      buildPopupMenuItem("Add To Playlist", AssetPath.add_playlist),
                                                                                      buildPopupMenuItem("Add To Queue", AssetPath.add_queue),
                                                                                      buildPopupMenuItem("Forgot Present Queue", AssetPath.forgot_queue),
                                                                                      // Add more options as needed
                                                                                    ],
                                                                                    onSelected: (selectedValue) {
                                                                                      if (selectedValue == "Add To Playlist") {
                                                                                        value.fetchUserPlaylists();
                                                                                        _showBottomSheet(context, value, value.frequenciesList[index].toString(), value.programName.value.toString());
                                                                                      } else if (selectedValue == "Add To Queue") {
                                                                                        if (value.parser.getPlan() == "advance"){
                                                                                          StaticValue.addSongToQueue(double.parse(value.frequenciesList[index].toString()),value.programName.value.toString());
                                                                                        }else{
                                                                                          showToast('Please upgrade plan to advance to use this feature');
                                                                                        }
                                                                                      } else if(selectedValue == "Forgot Present Queue") {
                                                                                        if (value.parser.getPlan() == "advance"){
                                                                                          StaticValue.removeFromQueue(double.parse(value.frequenciesList[index].toString()));
                                                                                        }else{
                                                                                          showToast('Please upgrade plan to advance to use this feature');
                                                                                        }
                                                                                      }
                                                                                    },
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.all(
                                                                                          screenWidth * .04),
                                                                                      child: SvgPicture.asset(
                                                                                          AssetPath.setting,
                                                                                          width: screenWidth * .008,
                                                                                          color: ThemeProvider
                                                                                              .greyColor),
                                                                                    ),
                                                                                  ) : Container()
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width: screenWidth * .8,
                                                                        child: CustomGradientDivider(
                                                                          height: 1.0,
                                                                          startColor: ThemeProvider.greyColor,
                                                                          endColor: Colors.transparent,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: RoundConorButton(
                                                  width: screenWidth * .35,
                                                  height: screenHeight * .05,
                                                  heading: AppString.frequencies,
                                                  fontSize: Dimens.fifteen,
                                                  color: ThemeProvider.persianGreen,
                                                  child: SvgPicture.asset(AssetPath.frequency),
                                                ),
                                              ),
                                              SizedBox(width: screenWidth * .05),
                                              Container(
                                                height: screenHeight * 0.05,
                                                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                                                decoration: BoxDecoration(
                                                  color: ThemeProvider.persianGreen,
                                                  borderRadius: BorderRadius.circular(screenWidth),
                                                ),
                                                child: Obx(() =>  DropdownButton<String>(
                                                  value: value.selectedTimeObserver.value,
                                                  onChanged: (newValue) {
                                                    value.customTime(newValue.toString());
                                                  },
                                                  items: value.options.map<DropdownMenuItem<String>>((String value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value,
                                                      child: CommonTextWidget(
                                                        heading: '$value min',
                                                        fontSize: Dimens.forteen,
                                                        color: Colors.black, // Set the text color of dropdown items to black
                                                        fontFamily: 'medium',
                                                      ),
                                                    );
                                                  }).toList(),
                                                  underline: Container(),
                                                  icon: const Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Colors.white,
                                                  ),
                                                  selectedItemBuilder: (BuildContext context) {
                                                    return value.options.map<Widget>((String item) {
                                                      return  Center(
                                                        child:  CommonTextWidget(
                                                          heading: '$item min',
                                                          fontSize: Dimens.forteen,
                                                          color: Colors.white, // Set the text color of the selected item to white
                                                          fontFamily: 'medium',
                                                        ),
                                                      );
                                                    }).toList();
                                                  },
                                                )),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                      ),
                                    ),

                                    Align(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // Obx(() => CommonSliderWidget(
                                          //       sliderValue: value.frequency.value
                                          //           .toStringAsFixed(2)
                                          //           .toString(),
                                          //       value: value.frequency.value,
                                          //       onChanged: (newValue) {
                                          //         value.frequency.value = newValue;
                                          //       },
                                          //       buttonSize: screenWidth * .045,
                                          //       title: AppString.frequencies,
                                          //       onPlus: () {},
                                          //       onMinus: () {},
                                          //       minSliderValue: 0,
                                          //       maxSliderValue: 19964.61,
                                          //     )),
                                          Obx(() => CommonSliderWidget(
                                            textColor: value.currentTheme.value == 1 ? ThemeProvider.blackColor : ThemeProvider.whiteColor,
                                            buttonColor: value.currentTheme.value == 1 ? ThemeProvider.blackColor : Colors.transparent,
                                            sliderValue: value.dutyCycle.value.toStringAsFixed(2).toString(),
                                            value: value.dutyCycle.value,
                                            onChanged: (newValue) {
                                              value.dutyCycle.value = newValue;
                                              value.resetTimer();
                                            },
                                            buttonSize: screenWidth * .045,
                                            title: AppString.duty_cycle,
                                            onPlus: () {
                                              value.resetTimer();
                                              value.onIncreaseDutyCycle();
                                            },
                                            onMinus: () {
                                              value.resetTimer();
                                              value.onDecreaseDutyCycle();
                                            },
                                            minSliderValue: value.minDutyCycle,
                                            maxSliderValue: value.maxDutyCycle,
                                          )),
                                          SizedBox(height: screenHeight * .02),
                                          Obx(() => CommonSliderWidget(
                                            textColor: value.currentTheme.value == 1 ? ThemeProvider.blackColor : ThemeProvider.whiteColor,
                                            buttonColor: value.currentTheme.value == 1 ? ThemeProvider.blackColor : Colors.transparent,
                                            sliderValue: value.amplitude.value.toStringAsFixed(2).toString(),
                                            value: value.amplitude.value,
                                            onChanged: (newValue) {
                                              value.amplitude.value = newValue;
                                              value.resetTimer();
                                            },
                                            buttonSize: screenWidth * .045,
                                            title: AppString.amplitude,
                                            onPlus: () {
                                              value.resetTimer();
                                              value.onIncreaseAmplitude();
                                            },
                                            onMinus: () {
                                              value.resetTimer();
                                              value.onDecreaseAmplitude();
                                            },
                                            minSliderValue: value.minAmplitude,
                                            maxSliderValue: value.maxAmplitude,
                                          )),
                                          SizedBox(height: screenHeight * .02),
                                          //Slider use to control offset
                                          Obx(() => CommonSliderWidget(
                                            textColor: value.currentTheme.value == 1 ? ThemeProvider.blackColor : ThemeProvider.whiteColor,
                                            buttonColor: value.currentTheme.value == 1 ? ThemeProvider.blackColor : Colors.transparent,
                                            sliderValue: value.offset.value.toStringAsFixed(2).toString(),
                                            value: value.offset.value,
                                            onChanged: (newValue) {
                                              value.offset.value = newValue;
                                              value.resetTimer();
                                            },
                                            buttonSize: screenWidth * .045,
                                            title: AppString.offset,
                                            onPlus: () {
                                              value.resetTimer();
                                              value.onIncreaseOffset();
                                            },
                                            onMinus: () {
                                              value.resetTimer();
                                              value.onDecreaseOffset();
                                            },
                                            minSliderValue: value.minOffset,
                                            maxSliderValue: value.maxOffset,
                                          )),
                                          SizedBox(height: screenHeight * .02),
                                          //Use to control phase value
                                          Obx(() => CommonSliderWidget(
                                            textColor: value.currentTheme.value == 1 ? ThemeProvider.blackColor : ThemeProvider.whiteColor,
                                            buttonColor: value.currentTheme.value == 1 ? ThemeProvider.blackColor : Colors.transparent,
                                            sliderValue: value.phaseControl.value.toStringAsFixed(2).toString(),
                                            value: value.phaseControl.value,
                                            onChanged: (newValue) {
                                              value.phaseControl.value = newValue;
                                              value.resetTimer();
                                            },
                                            buttonSize: screenWidth * .045,
                                            title: AppString.phase_control,
                                            onPlus: () {
                                              value.resetTimer();
                                              value.onIncreasePhaseControl();
                                            },
                                            onMinus: () {
                                              value.resetTimer();
                                              value.onDecreasePhaseControl();
                                            },
                                            minSliderValue: 0.0,
                                            maxSliderValue: 2 * pi,
                                          ))
                                        ],
                                      ),
                                    )
                                    //Slider two
                                  ],
                                ),
                              )
                            ],
                          ),
                          ),
                        ),

                        //Slider View (Swipe here to slide)

                      ],
                    ),
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [

                          Icon(
                            Icons.arrow_drop_up,
                            size: 32,
                            color: ThemeProvider.primary, // Adjust color as needed
                          ),
                          CommonTextWidget(
                              heading: AppString.swipeUp,
                              fontSize: Dimens.sixteen,
                              color: ThemeProvider.persianGreen,
                              fontFamily: 'bold'),
                        ],
                      ),
                    ),
                  ],
                ) : Image.asset(
                  AssetPath.background,
                  height: screenHeight,
                  width: screenWidth,
                  fit: BoxFit.cover,
                )),
              ),
            ),
          )
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
            child: SvgPicture.asset(path, width: screenWidth * .05,),
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

  void queueBottomSheet(FeaturesController value) {
    Get.bottomSheet(
      StaticValue.queueFrequenciesList.isNotEmpty ?
      Container(
        width: screenWidth,
        color: Colors.white,
          child : Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: CommonTextWidget(
                    heading: AppString.queue,
                  fontSize: Dimens.twentyFour,
                  color: Colors.black,
                  fontFamily: 'bold',),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: StaticValue.queueFrequenciesList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: (){
                              print("HelloIamPressed Queue");
                              value.selectedList.value = 'queue';

                              value.isButtonPressed.value = true;
                              value.playingIndex.value = index;
                              value.isProcessing.value = true;
                              value.frequencyValue.value = StaticValue.queueFrequenciesList[index]!;
                              value.resetTimer();
                              Future.delayed(const Duration(seconds: 3),()
                              {
                                value.isProcessing.value = false;
                                value.playFrequency();
                                value.startTime();
                                value.isButtonPressed.value = false;
                              });
                            },
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    RoundButton(
                                      width: screenWidth * .05,
                                      height: screenWidth * .05,
                                      borderColor: ThemeProvider.borderColor,
                                      padding: screenWidth * .013,
                                      child: SvgPicture.asset(AssetPath.play),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(screenWidth * .05),
                                      child: CommonTextWidget(
                                          heading: "${StaticValue.queueFrequenciesList[index]} HZ",
                                          fontSize: Dimens.sixteen,
                                          color: Colors.black,
                                          fontFamily: 'medium'),
                                    )
                                  ],
                                ),
                                Obx(() => value.playingIndex.value == index && value.isProcessing.value == true
                                    ? Padding(
                                  padding: EdgeInsets.all(screenWidth * .05),
                                  child: Image.asset(
                                    AssetPath.loading,
                                    height: screenWidth * .05,
                                    width: 25.0,
                                  ),
                                )
                                    : Container())
                              ],
                            ),
                          ),
                          SizedBox(
                              width: screenWidth * .8,
                              child: CustomGradientDivider(
                                  height: 1.0,
                                  startColor: ThemeProvider.greyColor,
                                  endColor: Colors.transparent
                              )
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),


      ) :
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Center(
          child:  CommonTextWidget(
              lineHeight: 1.3,
              heading: "No Program Added in the queue",
              fontSize: Dimens.sixteen,
              color: Colors.black,
              fontFamily: 'medium'),
        ),
      )
    );
  }

  void _showBottomSheet(BuildContext context, FeaturesController value, String frequency, String programName) {

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: ThemeProvider.persianGreen,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add your row above the list title here
              Container(
                padding: EdgeInsets.all(screenWidth * .05),
                alignment: Alignment.center,
                child: CommonTextWidget(
                  heading: AppString.custom_playList,
                  fontSize: Dimens.sixteen,
                  color: ThemeProvider.whiteColor,
                  fontFamily: 'bold',
                ),
              ),
              const Divider(
                color: ThemeProvider.borderColor,
                thickness: 1.0,
              ),
              InkWell(
                onTap: () {
                  if(value.parser.getPlan() == "advance"){
                    Get.back();
                    Get.toNamed(AppRouter.getcreatePlaylistScreen(),
                      arguments: {'frequency': frequency, 'name': programName},
                    );
                  }else{
                    successToast("To Use this feature subscribe our advanced plan");
                  }

                },
                child: Row(children: [
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    child: SvgPicture.asset(
                      AssetPath.create_playlist,
                      width: screenWidth * .05,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CommonTextWidget(
                        heading: AppString.custom_playList,
                        fontSize: Dimens.sixteen,
                        color: ThemeProvider.whiteColor,
                        fontFamily: 'bold',
                      ),
                      SizedBox(height: screenHeight * .01),
                      CommonTextWidget(
                        heading: AppString.build_playlist,
                        fontSize: Dimens.forteen,
                        color: ThemeProvider.whiteColor,
                        fontFamily: 'medium',
                      )
                    ],
                  ),
                ]),
              ),

              const Divider(
                color: ThemeProvider.borderColor,
                thickness: 1.0,
              ),
              // List title "Frequency" and items
              Expanded(
                child: Obx(() => ListView.builder(
                      itemCount: value.playlistNames.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                // print("Hello Program=====>"+frequency.toString());
                                value.updatePlaylist(value.playlistNames[index],
                                    frequency, programName);
                              },
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(screenWidth * 0.03),
                                    child: SvgPicture.asset(
                                      AssetPath.create_playlist,
                                      width: screenWidth * .05,
                                    ),
                                  ),
                                  CommonTextWidget(
                                    heading: value.playlistNames[index],
                                    fontSize: Dimens.sixteen,
                                    color: ThemeProvider.whiteColor,
                                    fontFamily: 'bold',
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              color: ThemeProvider.borderColor,
                              thickness: 1.0,
                            ),
                          ],
                        );
                      },
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  // void rewardPointDialog(BuildContext context, FeaturesController value) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         content: SizedBox(
  //           width: screenWidth * .1, // Set the width to 200
  //           height: screenHeight * .2, // Set the height to 200
  //           child: Column(
  //             children: [
  //               CommonTextWidget(
  //                 heading: AppString.reward_Point,
  //                 fontSize: Dimens.twentyFour,
  //                 color: Colors.black,
  //                 fontFamily: 'bold',
  //               ),
  //               SizedBox(height: screenHeight * .02),
  //               CommonTextWidget(
  //                 heading: AppString.no_points,
  //                 fontSize: Dimens.forteen,
  //                 color: Colors.black,
  //                 fontFamily: 'medium',
  //               ),
  //               SizedBox(height: screenHeight * .01),
  //               CommonTextWidget(
  //                 heading: AppString.earn_more,
  //                 fontSize: Dimens.forteen,
  //                 color: Colors.black,
  //                 fontFamily: 'medium',
  //               ),
  //               SizedBox(height: screenHeight * .04),
  //
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                 children: [
  //                   InkWell(
  //                     onTap: () {
  //                       Navigator.pop(context);
  //                     },
  //                     child: SizedBox(
  //                       width: screenWidth * .2, // Adjust the width as needed
  //                       height: 40,
  //                       child: Container(
  //                         alignment: Alignment.center,
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(10),
  //                           // Adjust the border radius as needed
  //                           border: Border.all(
  //                             width: 1.0,
  //                             color: ThemeProvider.persianGreen,
  //                           ),
  //                         ),
  //                         child: CommonTextWidget(
  //                           heading: AppString.cancel,
  //                           fontSize: Dimens.forteen,
  //                           color: Colors.black,
  //                           fontFamily: 'bold',
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   InkWell(
  //                     onTap: () {
  //                       // value.isPlaying.value = false;
  //                       value.stopFrequency();
  //                       value.pauseTimer();
  //                       Future.delayed(const Duration(seconds: 2), (){
  //                         value.showRewardedAd();
  //                       });
  //                     },
  //                     child: SizedBox(
  //                       width: screenWidth * .2, // Adjust the width as needed
  //                       height: 40,
  //                       child: Container(
  //                         alignment: Alignment.center,
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(10),
  //                           // Adjust the border radius as needed
  //                           border: Border.all(
  //                             width: 1.0,
  //                             color: ThemeProvider.persianGreen,
  //                           ),
  //                         ),
  //                         child: CommonTextWidget(
  //                           heading: AppString.warch_ad,
  //                           fontSize: Dimens.forteen,
  //                           color: Colors.black,
  //                           fontFamily: 'bold',
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
