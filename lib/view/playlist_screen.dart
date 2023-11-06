import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:heal_with_science/controller/playlist_controller.dart';
import 'package:heal_with_science/widgets/CustomGradientDivider.dart';
import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/string.dart';
import '../util/theme.dart';
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
      return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
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
                          heading: AppString.playlist,
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

                //Search Category Field
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
                    onChanged: (searchText) {
                      value.filter(searchText.toLowerCase());
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
                  }
                  else if (value.filteredPlaylist.isEmpty) {
                    // Display a "No Data" message
                    return Expanded(
                      child: Center(
                        child:  CommonTextWidget(
                            heading: AppString.no_data,
                            fontSize: Dimens.sixteen,
                            color: Colors.black,
                            fontFamily: 'light'),
                      ),
                    );
                  }
                  else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: value.filteredPlaylist.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: (){
                              value.fetchFrequencyArray(value.filteredPlaylist[index]);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                  child: CommonTextWidget(
                                      lineHeight: 1.3,
                                      heading: value.filteredPlaylist[index],
                                      fontSize: Dimens.sixteen,
                                      color: Colors.black,
                                      fontFamily: 'medium'),
                                ),
                                SizedBox(
                                    width: screenWidth * .8,
                                    child: CustomGradientDivider(
                                        height: 1.0,
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
            )),
      );
    });
  }
}
