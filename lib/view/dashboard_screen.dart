import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:heal_with_science/util/extensions/static_values.dart';
import 'package:heal_with_science/util/theme.dart';
import '../backend/helper/app_router.dart';
import '../controller/dashboard_controller.dart';
import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/string.dart';
import '../widgets/commontext.dart';
import '../widgets/round_button.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double screenHeight = 0, screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<DashboardController>(builder: (value) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
              padding: EdgeInsets.all(screenWidth * .04),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
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
                              child: SvgPicture.asset(AssetPath.back_arrow),
                            ),
                          ),
                          CommonTextWidget(
                              lineHeight: 1.3,
                              heading: AppString.dashboard,
                              fontSize: Dimens.twentyFour,
                              color: Colors.black,
                              fontFamily: 'bold'),
                          InkWell(
                            onTap: () {
                              Get.toNamed(AppRouter.getProfileScreen());
                              // value.logout();
                            },
                            child: Padding(
                              padding: EdgeInsets.all(screenWidth * .02),
                              child: SvgPicture.asset(AssetPath.user_icon,
                                  width: screenWidth * .06,
                                  color: ThemeProvider.blackColor),
                            ),

                            /* Container(
                        alignment: Alignment.center,
                        width: screenWidth * .2,
                        height: screenWidth * .1,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: ThemeProvider.borderColor,
                            ),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CommonTextWidget(
                              lineHeight:1.3,
                              heading: "logout",
                              fontSize: Dimens.sixteen,
                              color: Colors.black,
                              fontFamily: 'bold'),
                        ),
                      ),*/
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Container(
                          width: screenWidth,
                          height: screenHeight,
                          alignment: Alignment.center,
                          child: StaggeredGridView.countBuilder(
                            crossAxisCount: 4,
                            // Number of columns
                            itemCount: value.listItem.length,
                            // Total number of items
                            itemBuilder: (BuildContext context, int index) =>
                                Container(
                              child: InkWell(
                                onTap: () {
                                  if (index == 0) {
                                    Get.toNamed(AppRouter.getCategoryScreen());
                                  } else if (index == 2) {
                                    Get.toNamed(AppRouter.getFrequencyScreen());
                                  } else if (index == 4) {
                                    Get.toNamed(AppRouter.getPlaylistScreen());
                                  } else if (index == 3) {
                                    Get.toNamed(AppRouter.getHeartScreen());
                                  } else if (index == 1) {
                                    Get.toNamed(
                                        AppRouter.getCustomFrequencyScreen());
                                  }
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      //<-- SEE HERE
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  color: ThemeProvider.iceberg,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonTextWidget(
                                            lineHeight: 1.3,
                                            heading: value.itemList[index].name,
                                            fontSize: Dimens.eighteen,
                                            color: Colors.black,
                                            fontFamily: 'bold'),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(20.0),
                                            child: Center(
                                              child: SvgPicture.asset(value
                                                  .listItem[index].imagePath),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            staggeredTileBuilder: (int index) =>
                                StaggeredTile.count(
                                    index == 0 ? 4 : 2, index.isOdd ? 3 : 2),
                            mainAxisSpacing: screenHeight * .015,
                            // Spacing between rows
                            crossAxisSpacing:
                                screenWidth * .01, // Spacing between columns
                          ),
                        ),
                      )
                    ],
                  ),
                  Obx(() => StaticValue.miniPlayer.value ? Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: screenHeight * .1, // Adjust the height as needed
                      color: ThemeProvider.blackColor, // Set the color as needed
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Center(
                            child: Text(
                              'Your Mini Player',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          RoundButton(
                            width: screenWidth * .1,
                            height: screenWidth * .1,
                            borderColor: ThemeProvider.borderColor,
                            padding: screenWidth * 0.03,
                            background: ThemeProvider.bright_gray,
                            child: SvgPicture.asset(AssetPath.play),
                          ),

                          Padding(
                            padding:  EdgeInsets.all(screenWidth * .01),
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                 StaticValue.miniPlayer.value = false;
                              },
                            ),
                          ),
                          // You can add more widgets here as needed
                        ],
                      ),
                    ),
                  ) : Container() )
                  ,
                ],
              )),
        ),
      );
    });
  }
}
