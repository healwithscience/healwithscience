import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import '../controller/otp_verification_controller.dart';
import '../controller/password_success_controller.dart';
import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/string.dart';
import '../util/theme.dart';
import '../widgets/commontext.dart';
import '../widgets/submit_button.dart';

class PasswordSuccessScreen extends StatefulWidget {
  const PasswordSuccessScreen({super.key});

  @override
  State<PasswordSuccessScreen> createState() => _PasswordSuccessScreenState();
}

class _PasswordSuccessScreenState extends State<PasswordSuccessScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<PasswordSuccessController>(builder: (value) {
      return SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(screenWidth * .04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: screenWidth * .1,
                  height: screenWidth * .1,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ThemeProvider.borderColor,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(AssetPath.back_arrow),
                  ),
                ),
                SizedBox(height: screenHeight * .04),
                Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(AssetPath.success,
                        height: screenHeight * .25)),
                SizedBox(height: screenHeight * .05),
                Align(
                  alignment: Alignment.center,
                  child: CommonTextWidget(
                      heading: AppString.password_changed,
                      fontSize: Dimens.thirty,
                      color: Colors.black,
                      fontFamily: 'bold'),
                ),
                SizedBox(height: screenHeight * .03),
                Align(
                  alignment: Alignment.center,
                  child: CommonTextWidget(
                    textAlign: TextAlign.center,
                      heading: AppString.successfully_changed,
                      fontSize: Dimens.sixteen,
                      color: ThemeProvider.textColor,
                      fontFamily: 'medium'),
                ),
                SizedBox(height: screenHeight * .05),
                SubmitButton(onPressed: () {}, title: AppString.back_to_login),
              ],
            ),
          ),
        ),
      );
    });
  }
}
