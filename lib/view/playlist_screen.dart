import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:heal_with_science/controller/playlist_controller.dart';
import 'package:heal_with_science/util/extensions/static_values.dart';
import 'package:heal_with_science/widgets/CustomGradientDivider.dart';
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

class PlayListScreen extends StatefulWidget {
  const PlayListScreen({super.key});

  @override
  State<PlayListScreen> createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  double screenHeight = 0, screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<PlaylistController>(builder: (value) {
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
                                        width: kIsWeb ? screenWidth * .07 :  screenWidth * .1,
                                        height: kIsWeb ? screenWidth * .07 :  screenWidth * .1,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: ThemeProvider.borderColor,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
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
                                        heading: AppString.playlist,
                                        fontSize: Dimens.twentyFour,
                                        color: Colors.black,
                                        fontFamily: 'bold'),
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

                              //Search Category Field
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
                                  onChanged: (searchText) {
                                    value.filter(searchText.toLowerCase());
                                  },
                                ),
                              ),

                              InkWell(
                                onTap: (){
                                   if(value.completePackage1.value){
                                     Get.toNamed(AppRouter.getPaidFrequencyScreen(), arguments: {'purchased':value.completePackage1.value,});
                                   }else{
                                     _showDialog(context,value,'complete_package1');
                                   }
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(   kIsWeb ? screenWidth * .015  : screenWidth * .04 ),
                                      child: CommonTextWidget(
                                          heading:AppString.biophotonic1,
                                          fontSize: Dimens.sixteen,
                                          color: Colors.black,
                                          fontFamily: 'bold'),
                                    ),
                                    Obx(() => !value.completePackage1.value ? SizedBox(
                                      height: kIsWeb ? screenHeight * .04 : screenHeight * .025,
                                      child: SvgPicture.asset(AssetPath.lock),
                                    ) : SizedBox( height: kIsWeb ? screenHeight * .04 : screenHeight * .025))

                                  ],
                                ),
                              ),
                              SizedBox(
                                  width: screenWidth * .8,
                                  child: CustomGradientDivider(
                                      height: 1.0,
                                      startColor: ThemeProvider.greyColor,
                                      endColor:
                                      Colors.transparent)),

                              InkWell(
                                onTap: (){
                                  if(value.completePackage2.value){
                                    Get.toNamed(AppRouter.getPaidFrequencyScreen2(), arguments: {'purchased':value.completePackage2.value,});
                                  }else{
                                    _showDialog(context,value,'complete_package2');
                                  }
                                  // Get.toNamed(AppRouter.getPaidFrequencyScreen2());
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(   kIsWeb ? screenWidth * .015  : screenWidth * .04 ),
                                      child: CommonTextWidget(
                                          heading:AppString.biophotonic2,
                                          fontSize: Dimens.sixteen,
                                          color: Colors.black,
                                          fontFamily: 'bold'),
                                    ),
                                    Obx(() => !value.completePackage2.value ? SizedBox(
                                      height:  kIsWeb ? screenHeight * .04 : screenHeight * .025,
                                      child: SvgPicture.asset(AssetPath.lock),
                                    ) : SizedBox(height : kIsWeb ? screenHeight * .04 : screenHeight * .025,))
                                  ],
                                ),
                              ),
                              SizedBox(
                                  width: screenWidth * .8,
                                  child: CustomGradientDivider(
                                      height: 1.0,
                                      startColor: ThemeProvider.greyColor,
                                      endColor:
                                      Colors.transparent)),

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
                                } else if (value.filteredPlaylist.isEmpty) {
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
                                      itemCount: value.filteredPlaylist.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            if (StaticValue.rewardPoint > 0) {
                                              StaticValue.resetTimer();
                                              value.fetchFrequencyArray(value
                                                  .filteredPlaylist[index]);
                                            } else {
                                              showCommonRewardDialog(
                                                  context,
                                                  screenHeight,
                                                  screenWidth, () {
                                                Future.delayed(
                                                    const Duration(seconds: 1),
                                                    () {
                                                  value.showRewardedAd();
                                                });
                                              });
                                            }
                                          },
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(   kIsWeb ? screenWidth * .01  : screenWidth * .04 ),
                                                    child: CommonTextWidget(lineHeight: 1.3,
                                                        heading: value.filteredPlaylist[index],
                                                        fontSize: Dimens.sixteen,
                                                        color: Colors.black,
                                                        fontFamily: 'medium'),
                                                  ),

                                                   value.parser.getPlan() == "advance" ? PopupMenuButton<String>(
                                                      offset: const Offset(00, 40),
                                                      itemBuilder: (context) => [
                                                        buildPopupMenuItem("Add To Queue", AssetPath.add_queue),
                                                        // Add more options as needed
                                                      ],
                                                      onSelected: (selectedValue) {
                                                        if (selectedValue == "Add To Queue") {
                                                          value.addToQueue(value.filteredPlaylist[index]);
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric( vertical: screenWidth * .04,horizontal: screenWidth * .07 ),
                                                        child: SvgPicture.asset(
                                                            AssetPath.setting,
                                                            width: screenWidth * .008,
                                                            color: ThemeProvider
                                                                .greyColor),
                                                      ),
                                                    ) : Container(),
                                                ],
                                              ),
                                              SizedBox(
                                                  width: screenWidth * .8,
                                                  child: CustomGradientDivider(height: 1.0,
                                                      startColor: ThemeProvider.greyColor,
                                                      endColor: Colors.transparent))
                                            ],
                                          ),
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
                                      Get.toNamed(AppRouter.getFeaturesScreen(),
                                          arguments: {
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
                                    child: CustomMiniPlayer(
                                        screenWidth: screenWidth,
                                        screenHeight: screenHeight),
                                  ),
                                )
                              : Container())
                        ],
                      )),
                )
              : CommonLoadingWidget(screenHeight: screenHeight, screenWidth: screenWidth)));
    });
  }


  void _showDialog(BuildContext context, PlaylistController value,String package) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Center(
            child: CommonTextWidget(
              heading: 'Complete Package',
              fontSize: Dimens.twenty,
              color: ThemeProvider.blackColor,
              fontFamily: 'bold',
            ),
          ),
          content: Container(
            margin: const EdgeInsets.only(top: 5), // Adjust the top margin as needed
            child: const Text('Unlock the full potential of our premium package and enjoy exclusive features and benefits. By choosing the complete package, you gain access to a wealth of resources designed to enhance your experience.',textAlign: TextAlign.center,),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                    if(package == 'complete_package1'){
                      Get.toNamed(AppRouter.getPaidFrequencyScreen(), arguments: {'purchased':value.completePackage1.value,});
                    }else{
                      Get.toNamed(AppRouter.getPaidFrequencyScreen2(), arguments: {'purchased':value.completePackage2.value,});
                    }


                  },
                  child: Container(
                    width: screenWidth * .25,
                    padding: const EdgeInsets.all(12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(screenWidth * .02),
                        border: Border.all(width: 1.0, color: ThemeProvider.persianGreen)),
                    child: CommonTextWidget(
                        heading: 'Buy One',
                        fontSize: Dimens.sixteen,
                        color: Colors.black,
                        fontFamily: 'bold'),
                  ),
                ),
                const SizedBox(width: 20), // Add some spacing between buttons
                InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                    value.purchaseProduct(package);
                  },
                  child: Container(
                    width: screenWidth * .2,
                    padding: const EdgeInsets.all(12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(screenWidth * .02),
                        border: Border.all(width: 1.0, color: ThemeProvider.persianGreen)),
                    child: CommonTextWidget(
                        heading: 'Buy All',
                        fontSize: Dimens.sixteen,
                        color: Colors.black,
                        fontFamily: 'bold'),
                  ),
                ),

              ],
            ),
          ],
        );
      },
    );
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

}


