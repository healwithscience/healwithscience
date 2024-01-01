import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:heal_with_science/controller/frequency_controller.dart';
import 'package:heal_with_science/util/extensions/static_values.dart';
import 'package:heal_with_science/widgets/CustomGradientDivider.dart';
import 'package:heal_with_science/widgets/round_button.dart';
import '../backend/helper/app_router.dart';
import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/inactivity_manager.dart';
import '../util/string.dart';
import '../util/theme.dart';
import '../widgets/common_loading.dart';
import '../widgets/common_min_player.dart';
import '../widgets/common_reward_dialog.dart';
import '../widgets/commontext.dart';
import '../widgets/custom_text_field.dart';

class FrequencyScreen extends StatefulWidget {
  const FrequencyScreen({super.key});

  @override
  State<FrequencyScreen> createState() => _FrequencyScreenState();
}

class _FrequencyScreenState extends State<FrequencyScreen> {
  double screenHeight = 0, screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return GetBuilder<FrequencyController>(builder: (value) {
      return GestureDetector(
        onPanDown: (details){
          if (StaticValue.miniPlayer.value) {
            InactivityManager.resetTimer();
          }
        },
        child: Obx(() => !InactivityManager.showImage.value ?  SafeArea(
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
                                width: kIsWeb ? screenWidth * .07 :  screenWidth * .1,
                                height: kIsWeb ? screenWidth * .07 :  screenWidth * .1,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ThemeProvider.borderColor,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: Padding(
                                  padding: EdgeInsets.all(screenWidth * .02),
                                  child: SvgPicture.asset(AssetPath.back_arrow),
                                ),
                              ),
                            ),
                            CommonTextWidget(
                                lineHeight: 1.3,
                                heading: AppString.frequencies,
                                fontSize: Dimens.twentyFour,
                                color: Colors.black,
                                fontFamily: 'bold'),
                            InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
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
                          hintText: 'Search Frequencies',
                          controller: value.searchController,
                          textInputStyle: TextStyle(
                              color: Colors.black,
                              fontSize: Dimens.sixteen,
                              fontFamily: 'medium'),
                          hintStyle: TextStyle(
                              fontSize: Dimens.sixteen, fontFamily: 'medium'),
                          prefixIcon: Icon(Icons.search,
                              color: value.isFocus.value
                                  ? ThemeProvider.primary
                                  : ThemeProvider.greyColor,
                              size: Dimens.twentyFive),
                          onChanged: (searchText) {
                            value.filterFrequencies(searchText.toLowerCase());
                          },
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
                        } else if (value.filteredfrequencies.length == 0) {
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
                            //List of Frequqncies
                            child: ListView.builder(
                              itemCount: value.filteredfrequencies.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if(value.parser.getPlan() == "intermediate" || value.parser.getPlan() == "advance"){
                                         value.goToNext(value.filteredfrequencies,index);
                                        }else{
                                          if (StaticValue.rewardPoint > 0) {
                                            value.goToNext(value.filteredfrequencies,index);
                                          }
                                          else {
                                            showCommonRewardDialog(
                                                context, screenHeight, screenWidth,
                                                    () {
                                                  Future.delayed(const Duration(seconds: 1), ()
                                                  {
                                                    value.showRewardedAd();
                                                  });
                                                });
                                          }
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 15),
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                RoundButton(
                                                  width: screenWidth * .05,
                                                  height: screenWidth * .05,
                                                  child: SvgPicture.asset(AssetPath.play),
                                                  borderColor: ThemeProvider.borderColor,
                                                  padding: screenWidth * .013,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                                  child: CommonTextWidget(
                                                      lineHeight: 1.3,
                                                      heading: "${value.filteredfrequencies[index]} HZ",
                                                      fontSize: Dimens.sixteen,
                                                      color: Colors.black,
                                                      fontFamily: 'medium'),
                                                )
                                              ],
                                            ),
                                            //
                                            Row(
                                              children: [
                                                value.parser.getPlan() == "advance" ? !value.checkStatus(value.filteredfrequencies[index].toString())
                                                    ? InkWell(
                                                  onTap: () {
                                                    value.downloadButtonClickedList[index] = 2;
                                                    Future.delayed(const Duration(seconds: 1), () {
                                                      value.downloadButtonClickedList[
                                                      index] = 3;
                                                    });
                                                    value.parser.updateList("No Name", value.filteredfrequencies[index].toString());
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.all(screenWidth * .05),
                                                    child: Obx(() => value.downloadButtonClickedList[index] == 1
                                                        ? SvgPicture.asset(
                                                        AssetPath.download, width: screenWidth * 0.05)
                                                        : value.downloadButtonClickedList[index] == 2
                                                        ? Image.asset(
                                                      AssetPath.loading,
                                                      height: screenWidth * .05,
                                                      width: 25.0,
                                                    )
                                                        : Container()),
                                                  ),
                                                )
                                                    : Container() : Container(),

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
                                                      _showBottomSheet(context, value, value.filteredfrequencies[index].toString());

                                                      // value.createUserPlaylist("Test1");// Handle Option 1 action
                                                    } else if (selectedValue == "Add To Queue") {
                                                      // Handle Option 2 action
                                                    } else {}
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
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        width: screenWidth * .8,
                                        child: CustomGradientDivider(
                                            height: 1.0,
                                            startColor: ThemeProvider.greyColor,
                                            endColor: Colors.transparent))
                                  ],
                                );
                              },
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

                        Get.toNamed(AppRouter.getFeaturesScreen(), arguments: {
                          'frequency':StaticValue.frequenciesList[StaticValue.playingIndex.value],
                          'frequenciesList':StaticValue.frequenciesList,
                          'index':StaticValue.playingIndex.value,
                          'name': StaticValue.frequencyName.value,
                          'programName':StaticValue.programNameList,// Pass the data you want
                          'screenName': StaticValue.screenName,
                          'type':'mini_player',
                          'isPlaying':StaticValue.isPlaying.value,// Pass the data you want
                          'currentTimeInSeconds':StaticValue.currentTimeInSeconds// Pass the data you want
                        });

                      },
                      child: CustomMiniPlayer(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight),
                    ),
                  )
                      : Container()),
                ],
              )),
        ) : CommonLoadingWidget(screenHeight: screenHeight,screenWidth: screenWidth))

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

  void _showBottomSheet(
      BuildContext context, FrequencyController value, String frequency) {
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
                    arguments: {'frequency': frequency, 'name': ''},
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
                                value.updatePlaylist(
                                    value.playlistNames[index], frequency);
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
}


/*Container(
width: screenWidth,
height: screenHeight * .08,
// Adjust the height as needed
color: ThemeProvider.blackColor,
// Set the color as needed
child: Padding(
padding: const EdgeInsets.all(8.0),
child: Row(
mainAxisAlignment:
MainAxisAlignment.spaceBetween,
children: [
SvgPicture.asset(AssetPath.mini_player),
Container(
padding: EdgeInsets.symmetric(
horizontal: screenWidth * .06),
width: screenWidth * .6,
child: Column(
mainAxisAlignment:
MainAxisAlignment.center,
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Obx(
() => CommonTextWidget(
heading: StaticValue
    .frequencyName.value,
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
if (StaticValue.isPlaying.value ==
false) {
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
print("HelloHereTimer" +
StaticValue.frequenciesList.length
    .toString());
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
)*/
