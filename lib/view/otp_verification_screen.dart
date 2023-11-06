import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../backend/helper/app_router.dart';
import '../controller/otp_verification_controller.dart';
import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/string.dart';
import '../util/theme.dart';
import '../widgets/commontext.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/submit_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<OtpVerificationController>(builder: (value) {
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
                CommonTextWidget(
                  heading: AppString.otp_verification,
                  fontSize: Dimens.thirty,
                  color: Colors.black,
                  fontFamily: 'bold',
                ),
                SizedBox(height: screenHeight * .02),
                CommonTextWidget(
                  heading: AppString.otp_description,
                  fontSize: Dimens.sixteen,
                  color: ThemeProvider.textColor,
                  fontFamily: 'medium',
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: screenHeight * .02),
                pinArea1(context, value),
                SizedBox(height: screenHeight * .05),
                SubmitButton(onPressed: () {
                  Get.toNamed(AppRouter.getCreatePasswordScreen());
                }, title: AppString.verify),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'bold',
                            fontSize: Dimens.fifteen,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: AppString.notgot_otp,
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(text: " "),
                            TextSpan(
                              text: AppString.resend,
                              style: TextStyle(color: ThemeProvider.persianGreen),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {

                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }


  Widget pinArea1(BuildContext context1, OtpVerificationController value) {
    return Container(
      height: 100.0,
      margin: EdgeInsets.only(top: Dimens.twenty),
      padding: EdgeInsets.symmetric(vertical: Dimens.ten),
      child: GestureDetector(
        onLongPress: () {
          print("LONG");
        },
        child: PinCodeTextField(
          cursorColor: Colors.black,
          length: 4,
          obscureText: false,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          textStyle: TextStyle(fontSize: Dimens.twenty, fontWeight: FontWeight.w500),
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: Dimens.sixty,
            fieldWidth: Dimens.sixty,
            selectedColor: ThemeProvider.transparent,
            selectedFillColor: ThemeProvider.text_background,
            inactiveColor: ThemeProvider.text_background,
            activeColor: ThemeProvider.persianGreen,
            inactiveFillColor: ThemeProvider.text_background,
            activeFillColor: ThemeProvider.whiteColor,
          ),
          animationDuration: Duration(milliseconds: 300),
          enableActiveFill: true,
          keyboardType: TextInputType.number,
          onCompleted: (v) {
            print("Completed");
            // _allFilled = true;
            // _newPin = v;
            value.otpValue.text = v;
          },
          onChanged: (value1) {
            print("value is $value and lengtbn is ${value1.length}");
            setState(() {
              if (value1.length == 6) {
                value.otpValue.text = value1;
                //   _allFilled = true;
                //   _showDarkButton = true;
                // } else if (value.length < 4) {
                //   _allFilled = false;
                // }
                //   setState(() {});
              }
            });
          },
          beforeTextPaste: (text) {
            print("Allowing to paste $text");
            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
            //but you can show anything you want here, like your pop up saying wrong paste format or etc
            return true;
          },
          appContext: context1,
        ),
      ),
    );
  }
}



