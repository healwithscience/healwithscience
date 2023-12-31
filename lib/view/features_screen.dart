import 'dart:math';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:heal_with_science/controller/features_controller.dart';
import 'package:heal_with_science/widgets/common_slider.dart';
import 'package:heal_with_science/widgets/ramwave.dart';
import 'package:heal_with_science/widgets/round_cornor_button.dart';
import 'package:heal_with_science/widgets/sawtoothwave.dart';
import 'package:heal_with_science/widgets/sinwave.dart';
import 'package:heal_with_science/widgets/squarewave.dart';
import 'package:heal_with_science/widgets/triangularwave.dart';
import '../backend/helper/app_router.dart';
import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/string.dart';
import '../util/theme.dart';
import '../widgets/CustomGradientDivider.dart';
import '../widgets/commontext.dart';
import '../widgets/round_button.dart';

class FeaturesScreen extends StatefulWidget {
  const FeaturesScreen({super.key});

  @override
  State<FeaturesScreen> createState() => _FeaturesScreenState();
}

class _FeaturesScreenState extends State<FeaturesScreen> {
  double screenHeight = 0, screenWidth = 0;
  double currenValue = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<FeaturesController>(builder: (value) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: ThemeProvider.light_white,
          // Set the scaffold's background to transparent
          body: WillPopScope(
            onWillPop: () async {
             value.onBackRoutes(); // Call your function
              return true; // Return true to allow back navigation, or false to prevent it.
            },
            child: Stack(
              children: [
                // Background Image
                Obx(() => value.currentTheme.value == 2
                    ? Positioned.fill(
                  child: Image.asset(
                    AssetPath
                        .dark_background, // Replace with your image path
                    fit: BoxFit.cover, // Adjust the fit as needed
                  ),
                )
                    : Container()),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
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
                              lineHeight: 1.3,
                              heading: AppString.features,
                              fontSize: Dimens.twentyFour,
                              color: value.currentTheme.value == 1
                                  ? ThemeProvider.blackColor
                                  : ThemeProvider.whiteColor,
                              fontFamily: 'bold')),
                          InkWell(
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
                                    PopupMenuItem(
                                      value: 3,
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 5),
                                          SvgPicture.asset(
                                            AssetPath.create_playlist,
                                            width: 20,
                                            color: ThemeProvider.persianGreen,
                                          ),
                                          const SizedBox(width: 12),
                                          CommonTextWidget(
                                            heading: AppString.create_playlist,
                                            fontSize: Dimens.forteen,
                                            color: ThemeProvider.blackColor,
                                            fontFamily: 'light',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  elevation: 3,
                                ).then((newValue) {
                                  if (newValue == 1 || newValue == 2) {
                                    value.setTheme(newValue!);
                                  } else if (newValue == 3) {
                                    value.fetchUserPlaylists();
                                    _showBottomSheet(
                                        context,
                                        value,
                                        value.frequencyValue.toString(),
                                        value.programName.value.toString());
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
                    SizedBox(height: screenHeight * .05),

                    Center(
                        child: Container(
                          width: screenWidth * .6,
                          height: screenWidth * .6,
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
                                )
                                    : value.selectedOption.value == 2
                                    ? SquareWavePainter(
                                  frequency: value.frequencyValue.value,
                                  amplitude: value.amplitude.value,
                                  dutyCycle: value.dutyCycle.value,
                                  phase: value.phaseControl.value,
                                  offset: value.offset.value,
                                )
                                    : value.selectedOption.value == 3
                                    ? RamWavePainter(
                                  frequency: value.frequencyValue.value,
                                  amplitude: value.amplitude.value,
                                  dutyCycle: value.dutyCycle.value,
                                  phase: value.phaseControl.value,
                                  offset: value.offset.value,
                                )
                                    : value.selectedOption.value == 4
                                    ? SawToothWavePainter(
                                  frequency: value.frequencyValue.value,
                                  amplitude: value.amplitude.value,
                                  dutyCycle: value.dutyCycle.value,
                                  phase: value.phaseControl.value,
                                  offset: value.offset.value,
                                )
                                    : TriangularWavePainter(
                                  frequency: value.frequencyValue.value,
                                  amplitude: value.amplitude.value,
                                  dutyCycle: value.dutyCycle.value,
                                  phase: value.phaseControl.value,
                                  offset: value.offset.value,
                                ),
                              )),
                            ),
                          ),
                        )),
                    SizedBox(height: screenHeight * .02),
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
                    //Slider View (Swipe here to slide)
                    Expanded(
                      child: PageView(
                        onPageChanged: (index) {
                          value.currentIndex.value = index.toDouble();
                        },
                        children: <Widget>[
                          //Slider One
                          Align(
                            alignment: Alignment.center,
                            child: SingleChildScrollView(
                              child: Align(
                                alignment: Alignment.bottomCenter,
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
                                    //display time remaining
                                    SizedBox(height: screenHeight * .025),
                                    Stack(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            //backward button
                                            InkWell(
                                              onTap: () {
                                                value.playPrevious();
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
                                                onTap: () {
                                                  Future.delayed(Duration(seconds: 1),
                                                          () {
                                                        if (value.isPlaying.value == false) {
                                                          value.playFrequency();
                                                          value.startTime();
                                                        } else {
                                                          value.stopFrequency();
                                                          value.pauseTimer();
                                                        }
                                                      });
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
                                              onTap: () {
                                                value.playNext();
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
                                                                  onTap: () {
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                  child: SvgPicture.asset(AssetPath.close, width: 15, height: 15)),
                                                            ),
                                                          ),
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
                                                                    value.selectedOption(newValue);
                                                                  },
                                                                )),
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          //Square wave radio button
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
                                                                  onChanged: (int?newValue) {value.selectedOption(newValue);
                                                                  },
                                                                )),
                                                          ),
                                                          const SizedBox(height: 10),
                                                          //Ram wave radio button
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
                                                                    onChanged: (int?newValue) {value.selectedOption(newValue);
                                                                    })),
                                                          ),
                                                          //Saw wave radio button
                                                          const SizedBox(
                                                              height: 10),
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
                                                                    value.selectedOption(newValue);
                                                                  },
                                                                )),
                                                          ),
                                                          //Triangular wave radio button
                                                          const SizedBox(
                                                              height: 10),
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
                                                                    value.selectedOption(newValue);
                                                                  },
                                                                )),
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
                                                                    value.playingIndex.value = index;
                                                                    value.isProcessing.value = true;
                                                                    value.frequencyValue.value = value.frequenciesList[index]!;
                                                                    value.resetTimer();
                                                                    Future.delayed(const Duration(seconds: 4), ()
                                                                    {
                                                                      value.isProcessing.value = false;
                                                                      value.playFrequency();
                                                                      value.startTime();
                                                                    });
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
                                                                                  lineHeight: 1.3,
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
                                                                            ):Container() : Container(),
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
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: SingleChildScrollView(
                              child: Column(
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
                            ),
                          )

                          //Slider two
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _showBottomSheet(BuildContext context, FeaturesController value,
      String frequency, String programName) {
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
                  Get.back();
                  Get.toNamed(
                    AppRouter.getcreatePlaylistScreen(),
                    arguments: {'frequency': frequency, 'name': programName},
                  );
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

  void showTextDialog(BuildContext context, FeaturesController value) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: screenWidth * .1, // Set the width to 200
            height: screenHeight * .22, // Set the height to 200
            child: Column(
              children: [
                const Center(
                    child: Text('Personalize the timing',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontFamily: 'bold'))),
                SizedBox(height: screenHeight * .02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * .03),
                  child: TextField(
                    controller: value.timeController,
                    style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontFamily: 'medium'),
                    keyboardType: TextInputType.number,
                    cursorColor: ThemeProvider.persianGreen,
                    decoration: const InputDecoration(
                      hintText: "Enter Time in min",
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: ThemeProvider.persianGreen)),
                    ),
                    maxLength: 1,
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
                        Navigator.pop(context);
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
