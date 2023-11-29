import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:heal_with_science/controller/download_controller.dart';
import 'package:heal_with_science/widgets/CustomGradientDivider.dart';
import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/extensions/static_values.dart';
import '../util/string.dart';
import '../util/theme.dart';
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
      return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
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
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                              child: Padding(
                                padding: EdgeInsets.all(screenWidth * .02),
                                child: SvgPicture.asset(AssetPath.back_arrow),
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
                              padding:  EdgeInsets.all(screenWidth * .01),
                              child: SvgPicture.asset(AssetPath.setting, width:screenWidth *.01,),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Focus(
                      onFocusChange: (hasFocus){
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
                            fontFamily: 'medium'
                        ),
                        prefixIcon: Icon(Icons.search,color: value.isFocus.value ?  ThemeProvider.primary : ThemeProvider.greyColor, size: Dimens.twentyFive),
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
                      }
                      else if(value.categories.isEmpty){
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
                      }
                      else {
                        return Expanded(
                          child: Stack(
                            children: [
                              ListView.builder(
                                itemCount: value.categories.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: (){
                                      StaticValue.resetTimer();
                                      value.goToFeatures(value.categories[index].frequency,index);
                                    },
                                    child: SizedBox(
                                      height: screenHeight * 0.07,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:  EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                                            child: Row(
                                              children: [
                                                RoundButton(
                                                  width: screenWidth * .05,
                                                  height: screenWidth * .05,
                                                  child: SvgPicture.asset(
                                                      AssetPath.play),
                                                  borderColor:
                                                  ThemeProvider.borderColor,
                                                  padding: screenWidth * .013,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      vertical: 15, horizontal: 10),
                                                  child: CommonTextWidget(
                                                      textOverflow: TextOverflow.ellipsis,
                                                      heading: "${value.categories[index].frequency} HZ",
                                                      fontSize: Dimens.sixteen,
                                                      color: Colors.black,
                                                      fontFamily: 'medium'),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              width: screenWidth * .8,
                                              child: CustomGradientDivider(
                                                  height: 1.0,
                                                  startColor: ThemeProvider.greyColor,
                                                  endColor: Colors.transparent))
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
                  child: Container(
                    width: screenWidth,
                    height:
                    screenHeight * .08, // Adjust the height as needed
                    color: ThemeProvider
                        .blackColor, // Set the color as needed
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(AssetPath.mini_player),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * .06),
                            width: screenWidth * .6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Obx(
                                      () => CommonTextWidget(
                                      heading:
                                      StaticValue.frequencyName.value,
                                      fontSize: Dimens.thrteen,
                                      color: Colors.white,
                                      fontFamily: 'light'),
                                ),
                                SizedBox(height: 8),
                                Obx(() => CommonTextWidget(
                                    heading: StaticValue
                                        .frequencyValue.value
                                        .toString(),
                                    fontSize: Dimens.thrteen,
                                    color: Colors.white,
                                    fontFamily: 'regular')),
                              ],
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              if (StaticValue.isPlaying.value == false) {
                                StaticValue.startTime();
                                StaticValue.playFrequency();
                              } else {
                                StaticValue.pauseTimer();
                                StaticValue.stopFrequency();
                              }
                            },
                            child: RoundButton(
                              width: screenWidth * .1,
                              height: screenWidth * .1,
                              borderColor: ThemeProvider.borderColor,
                              padding: screenWidth * 0.03,
                              background: ThemeProvider.bright_gray,
                              child: StaticValue.isPlaying.value
                                  ? SvgPicture.asset(AssetPath.play2)
                                  : SvgPicture.asset(AssetPath.play),
                            ),
                          ),

                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              print("HelloHereTimer" + StaticValue.frequenciesList.length.toString());
                              StaticValue.miniPlayer.value = false;
                              StaticValue.resetTimer();
                              // final FeaturesController featuresController = Get.put(FeaturesController(parser: Get.find()));
                              // featuresController.resetTimer();
                              // StaticValue.miniPlayer.value = false;
                            },
                          ),

                          // You can add more widgets here as needed
                        ],
                      ),
                    ),
                  ),
                )
                    : Container())
              ],
            )),
      );
    });
  }
}
