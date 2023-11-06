import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:heal_with_science/controller/create_playlist_controller.dart';
import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/string.dart';
import '../util/theme.dart';
import '../widgets/commontext.dart';
import '../widgets/submit_button.dart';

class CreatePlaylistScreen extends StatefulWidget {
  const CreatePlaylistScreen({super.key});

  @override
  State<CreatePlaylistScreen> createState() => _CreatePlaylistScreenState();
}

class _CreatePlaylistScreenState extends State<CreatePlaylistScreen> {
  double screenHeight = 0, screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return GetBuilder<CreatePlaylistController>(builder: (value) {
      return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
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
                              borderRadius: const BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: EdgeInsets.all(screenWidth * .02),
                            child: SvgPicture.asset(AssetPath.back_arrow),
                          ),
                        ),
                      ),
                      CommonTextWidget(
                          heading: AppString.create_playlist,
                          fontSize: Dimens.twentyFour,
                          color: Colors.black,
                          fontFamily: 'bold'),
                      InkWell(
                        onTap: () {
                          value.onBackRoutes();
                        },
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
                SizedBox(
                  height: screenHeight * .06,
                ),
                Align(
                  child: CommonTextWidget(
                      heading: AppString.give_name,
                      fontSize: Dimens.twentyTwo,
                      color: Colors.black,
                      fontFamily: 'bold'),
                ),
                SizedBox(height: screenHeight * .07),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * .2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidth * .03),
                    boxShadow: [
                      BoxShadow(
                        color: ThemeProvider.persianGreen.withOpacity(0.9),
                        // Shadow color and opacity
                        spreadRadius: 3,
                        // Spread of the shadow
                        blurRadius: 2,
                        // Blurring of the shadow
                        offset: const Offset(
                            5, 5), // Offset for the bottom-right corner shadow
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: value.nameController,
                    cursorColor: Colors.white,
                    style: TextStyle(
                        color: ThemeProvider.whiteColor,
                        fontSize: Dimens.twentyFour,
                        fontFamily: 'medium'),
                    decoration: const InputDecoration(
                      border: InputBorder.none, // Remove the default border
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * .08),
                    child: Divider(
                        color: ThemeProvider.persianGreen.withOpacity(0.2))),
                SizedBox(height: screenHeight * .1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(onTap: (){
                      value.onBackRoutes();
                    },
                    child:  SizedBox(
                      width: screenWidth * .3,
                      height: 50,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(screenWidth * .02),
                            border: Border.all(width: 1.0, color: ThemeProvider.persianGreen)),
                        child: CommonTextWidget(
                            heading: AppString.cancel,
                            fontSize: Dimens.eighteen,
                            color: Colors.black,
                            fontFamily: 'bold'),
                      ),
                    )),
                    SizedBox(
                      width: screenWidth * .3,
                      child: SubmitButton(
                          onPressed: () {
                            value.createUserPlaylist();
                          }, title: AppString.create),
                    ),
                  ],
                ),
               /* GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    shrinkWrap: true,
                    children: List.generate(value.selectedWords.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child:  Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(screenWidth * .02),border: Border.all(width: 1.0, color: ThemeProvider.persianGreen)),
                          child: CommonTextWidget(
                              heading: value.selectedWords[index],
                              fontSize: Dimens.eighteen,
                              color: Colors.black,
                              fontFamily: 'bold'),
                        ),
                      );
                    },),
                  ),*/
              ],
            )),
      );
    });
  }
}
