import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:heal_with_science/controller/category_controller.dart';
import 'package:heal_with_science/widgets/CustomGradientDivider.dart';
import '../controller/features_controller.dart';
import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/extensions/static_values.dart';
import '../util/string.dart';
import '../util/theme.dart';
import '../widgets/common_reward_dialog.dart';
import '../widgets/commontext.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/round_button.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  double screenHeight = 0, screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<CategoryController>(builder: (value) {
      return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
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
                            heading: AppString.category,
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

                    ),
                  ),

                  // Category Item listing
                  const SizedBox(height: 10),
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
                            child: Stack(
                              children: [
                                ListView.builder(
                                  controller: value.scrollController,
                                  itemCount: value.categories.length,
                                  itemBuilder: (context, index) {
                                    return  InkWell(
                                      onTap: (){
                                        if(StaticValue.rewardPoint > 0){
                                          value.goToFeatures(value.categories[index].frequency,value.categories[index].name);
                                        }else{
                                          showCommonRewardDialog(context ,screenHeight ,screenWidth ,() {
                                            Future.delayed(const Duration(seconds: 1), () {
                                              value.showRewardedAd();
                                            });
                                          });
                                        }
                                      },
                                      child: SizedBox(
                                        height: screenHeight * 0.07,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                              child: CommonTextWidget(
                                                  textOverflow: TextOverflow.ellipsis,
                                                  heading: value.categories[index].name,
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
                                      ),
                                    );
                                  },
                                ),


                                Positioned(
                                  right: 0,
                                  child:SingleChildScrollView(
                                    child: Container(
                                      width: 50,
                                      alignment: Alignment.bottomCenter,
                                      height: screenHeight * .75,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: value.alphabets.map((alphabet) =>
                                            InkWell(
                                              onTap: () {
                                                value.visibility.value = true;
                                                value.scrollToCategoryByAlphabet(alphabet,screenHeight);
                                                value.alphabet.value = alphabet;
                                                Future.delayed(const Duration(seconds: 1), () {
                                                  value.visibility.value = false;
                                                });

                                              },
                                              child: CommonTextWidget(
                                              heading: alphabet,
                                              fontSize: Dimens.thrteen,
                                              color: ThemeProvider.alphabatic_gray,
                                              fontFamily: 'bold'),
                                        )).toList(),
                                      ),
                                    ),
                                  ),
                                ),

                                Positioned(
                                    child: Obx(() => value.visibility.value ? Center(
                                      child: Material(
                                        elevation: 10, // Adjust the elevation to control the shadow
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.0), // Adjust the value for the desired corner radius
                                        ),
                                        child:Padding(
                                          padding: EdgeInsets.all(screenWidth * 0.07),
                                          child: CommonTextWidget(
                                              heading: value.alphabet.value,
                                              fontSize: Dimens.thirty,
                                              color: Colors.black,
                                              fontFamily: 'bold'),
                                        ),
                                      ),
                                    ) : const SizedBox()) ),

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
                    height: screenHeight * .08, // Adjust the height as needed
                    color: ThemeProvider.blackColor, // Set the color as needed
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(AssetPath.mini_player),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * .06),
                            width: screenWidth * .6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() => CommonTextWidget(
                                    heading: StaticValue.frequencyName.value,
                                    fontSize: Dimens.thrteen,
                                    color: Colors.white,
                                    fontFamily: 'light'),
                                ),
                                SizedBox(height: 8),
                                Obx(() => CommonTextWidget(
                                    heading: StaticValue.frequencyValue.value,
                                    fontSize: Dimens.thrteen,
                                    color: Colors.white,
                                    fontFamily: 'regular')),
                              ],
                            ),
                          ),

                          RoundButton(
                            width: screenWidth * .1,
                            height: screenWidth * .1,
                            borderColor: ThemeProvider.borderColor,
                            padding: screenWidth * 0.03,
                            background: ThemeProvider.bright_gray,
                            child: SvgPicture.asset(AssetPath.play2),
                          ),

                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              print("HelloHere");
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
                    : Container()),
              ],

            )),
      );
    });
  }
}
