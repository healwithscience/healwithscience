import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
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
import '../widgets/common_loading.dart';
import '../widgets/common_min_player.dart';
import '../widgets/commontext.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double screenHeight = 0, screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    if(kIsWeb){
      screenHeight = MediaQuery.of(context).size.height/3;
      screenWidth = MediaQuery.of(context).size.width/3;
    }else{
      screenHeight = MediaQuery.of(context).size.height;
      screenWidth = MediaQuery.of(context).size.width;
    }


    return GetBuilder<ProfileController>(builder: (value) {
      return GestureDetector(
        onPanDown: (details){
          if (StaticValue.miniPlayer.value) {
            InactivityManager.resetTimer();
          }
        },
        child: Obx(() =>  !InactivityManager.showImage.value
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
                                heading: AppString.profile,
                                fontSize: Dimens.twentyFour,
                                color: Colors.black,
                                fontFamily: 'bold'),
                            SizedBox(
                              width: screenWidth * .1,
                              height: screenWidth * .1,
                            )
                          ],
                        ),
                        SizedBox(height: screenHeight * .03),
                        // Profile Image
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: screenWidth * .3,
                              height: screenWidth * .3,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: screenWidth * .008,
                                  color: ThemeProvider
                                      .persianGreen, // Change 'Colors.red' to your desired border color
                                ),
                                borderRadius: BorderRadius.circular(
                                    screenWidth), // Half of width and height to make it circular
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(screenWidth),
                                child: Obx(() => Image.network(
                                  value.profileImage.value,
                                  width: screenWidth * .3,
                                  height: screenWidth * .3,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      AssetPath.user,
                                      fit: BoxFit.cover,
                                      width: screenWidth * .3,
                                      height: screenWidth * .3,
                                    );
                                  },
                                )),
                              ),
                            ),
                            Positioned(
                              bottom: screenWidth * .01,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  _showDialog(value);
                                },
                                child: Container(
                                  width: screenWidth * .1,
                                  height: screenWidth * .1,

                                  decoration: const BoxDecoration(
                                    color: ThemeProvider.persianGreen,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white, // Change 'Colors.white' to your desired icon color
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: screenHeight * .03),

                        //Name Field
                        CommonTextWidget(
                            heading: value.username,
                            fontSize: Dimens.twentyTwo,
                            color: Colors.black,
                            fontFamily: 'bold'),

                        //Email Field
                        CommonTextWidget(
                            lineHeight: 1.3,
                            heading: value.email,
                            fontSize: Dimens.sixteen,
                            color: ThemeProvider.greyColor,
                            fontFamily: 'medium'),

                        SizedBox(height: screenHeight * .03),

                        const Divider(
                          color: ThemeProvider.borderColor,
                        ),

                        // SizedBox(height: screenHeight * .01),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                CommonMenuWidget(
                                    screenWidth: screenWidth,
                                    userIconAssetPath: AssetPath.user_icon,
                                    accountText: AppString.account),
                                CommonMenuWidget(
                                    screenWidth: screenWidth,
                                    userIconAssetPath: AssetPath.change_password,
                                    accountText: AppString.change_password),
                                InkWell(
                                  onTap: (){
                                    Get.toNamed(AppRouter.getRewardScreen());
                                  },
                                  child: CommonMenuWidget(
                                      screenWidth: screenWidth,
                                      userIconAssetPath: AssetPath.earn_point,
                                      accountText: AppString.earn_point),
                                ),
                                InkWell(
                                    onTap: () { Get.toNamed(AppRouter.getDownloadScreen());},
                                    child: CommonMenuWidget(
                                        screenWidth: screenWidth,
                                        userIconAssetPath: AssetPath.new_download,
                                        accountText: AppString.download)),
                                InkWell(
                                  onTap: (){
                                    Get.toNamed(AppRouter.getPrivacyPolicyScreen());
                                  },
                                  child: CommonMenuWidget(
                                      screenWidth: screenWidth,
                                      userIconAssetPath: AssetPath.policy,
                                      accountText: AppString.privacy_policy),
                                ),


                                CommonMenuWidget(
                                    screenWidth: screenWidth,
                                    userIconAssetPath: AssetPath.notification,
                                    accountText: AppString.notification),

                                InkWell(
                                    onTap: () {
                                      Get.toNamed(AppRouter.getSubscriptionScreen());
                                    },
                                    child: CommonMenuWidget(
                                        screenWidth: screenWidth,
                                        userIconAssetPath: AssetPath.sign_out,
                                        accountText: AppString.subscription)),

                                InkWell(
                                    onTap: () {
                                      Get.toNamed(AppRouter.getShareScreen());
                                    },
                                    child: CommonMenuWidget(
                                        screenWidth: screenWidth,
                                        userIconAssetPath: AssetPath.sign_out,
                                        accountText: AppString.share)),

                                InkWell(
                                  onTap: (){
                                    Get.toNamed(AppRouter.getAboutScreen());
                                  },
                                  child: CommonMenuWidget(
                                      screenWidth: screenWidth,
                                      userIconAssetPath: AssetPath.policy,
                                      accountText: AppString.about),
                                ),

                                InkWell(
                                    onTap: () {
                                      _showDeleteDialog(context,value);
                                    },
                                    child: CommonMenuWidget(
                                        screenWidth: screenWidth,
                                        userIconAssetPath: AssetPath.sign_out,
                                        accountText: AppString.delete)),

                                InkWell(
                                    onTap: () {
                                      value.signOut();
                                    },
                                    child: CommonMenuWidget(
                                        screenWidth: screenWidth,
                                        userIconAssetPath: AssetPath.sign_out,
                                        accountText: AppString.sign_out)),

                                Obx(() => StaticValue.miniPlayer.value ? SizedBox(height: screenHeight * .05) : Container()),
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
                      onTap: (){
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
                      child:  CustomMiniPlayer(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight),
                    ),
                  )
                      : Container())
                ],
              ),
            ))
            : CommonLoadingWidget(screenHeight: screenHeight,screenWidth: screenWidth)),
      );
    });
  }

  Future<void> _showDialog(ProfileController value) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          alignment: Alignment.center,
          title: const Text('Choose an option'),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Flexible(
                  child: SimpleDialogOption(
                    onPressed: () {
                      // Handle the gallery button press here
                      Navigator.pop(context, 'camera');
                    },
                    child: Column(
                      children: [
                        const Icon(Icons.camera),
                        const SizedBox(height: 15),
                        CommonTextWidget(
                            heading: AppString.camera,
                            fontSize: Dimens.sixteen,
                            color: Colors.black,
                            fontFamily: 'medium'),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: SimpleDialogOption(
                    onPressed: () {
                      // Handle the camera button press here
                      Navigator.pop(context, 'gallery');
                    },
                    child: Column(
                      children: [
                        const Icon(Icons.photo_library),
                        const SizedBox(height: 15),
                        CommonTextWidget(
                            heading: AppString.gallery,
                            fontSize: Dimens.sixteen,
                            color: Colors.black,
                            fontFamily: 'medium')
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ).then((newValue) {
      // Handle the result here (value is either 'gallery' or 'camera')
      value.selectFromGallery(newValue);
      // Handle camera option
    });
  }


  void _showDeleteDialog(BuildContext context, ProfileController value) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete this accounts?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // User clicked on "No" button
                Navigator.of(context).pop();
              },
              child: CommonTextWidget(
                  heading: 'No',
                  fontSize: Dimens.sixteen,
                  color: ThemeProvider.blackColor,
                  fontFamily: 'light'),
            ),
            TextButton(
              onPressed: () {
               value.deleteAccount();
              },
              child: CommonTextWidget(
                  heading: 'Yes',
                  fontSize: Dimens.sixteen,
                  color: ThemeProvider.persianGreen,
                  fontFamily: 'light'),
            ),
          ],
        );
      },
    );
  }


}
