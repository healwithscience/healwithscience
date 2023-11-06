import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import '../backend/helper/app_router.dart';
import '../controller/forgot_password_controller.dart';
import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/string.dart';
import '../util/theme.dart';
import '../widgets/commontext.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/submit_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _FogrgotPasswordScreenState();
}

class _FogrgotPasswordScreenState extends State<ForgotPasswordScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<ForgotPasswordController>(builder: (value) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.all(screenWidth * .04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
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
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(AssetPath.back_arrow),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * .04),
                CommonTextWidget(
                    heading: AppString.forgot_password,
                    fontSize: Dimens.thirty,
                    color: Colors.black,
                    fontFamily: 'bold'),
                SizedBox(height: screenHeight * .02),
                CommonTextWidget(
                  lineHeight: 1.3,
                  heading: AppString.forgot_subtitle,
                  fontSize: Dimens.sixteen,
                  color: ThemeProvider.textColor,
                  fontFamily: 'medium',
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w500,
                ),

                SizedBox(height: screenHeight * .02),
                CustomTextField(
                  controller: value.emailController,
                  textInputStyle: TextStyle(
                      color: Colors.black,
                      fontSize: Dimens.sixteen,
                      fontFamily: 'medium'),
                  prefixIcon:  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: SvgPicture.asset(
                      AssetPath.email, // Replace with your SVG file path
                      width: 20, // Adjust the width as needed
                      height: 20, // Adjust the height as needed
                    ),
                  ),
                  hintText: AppString.enter_your_email,
                  hintStyle: TextStyle(
                      fontFamily: 'medium',
                      color: ThemeProvider.textColor,
                      fontSize: Dimens.sixteen),
                ),


                SizedBox(height: screenHeight * .05),
                SubmitButton(onPressed: () {
                  value.sendPasswordResetEmail();
                  // Get.toNamed(
                  //     AppRouter.getOtpVerificationScreen());
                }, title: AppString.send_code),

              ],
            ),
          ),
        ),
      );
    });
  }
}
