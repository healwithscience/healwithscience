import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import '../backend/helper/app_router.dart';
import '../controller/create_password_controller.dart';
import '../controller/otp_verification_controller.dart';
import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/string.dart';
import '../util/theme.dart';
import '../widgets/commontext.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/submit_button.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<CreatePasswordController>(builder: (value) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.all(screenWidth * .04),
            child: SingleChildScrollView(
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(AssetPath.back_arrow),
                    ),
                  ),

                  SizedBox(height: screenHeight * .04),
                  CommonTextWidget(
                      heading: AppString.create_new_password,
                      fontSize: Dimens.thirty,
                      color: Colors.black,
                      fontFamily: 'bold'),
                  SizedBox(height: screenHeight * .02),
                  CommonTextWidget(
                    heading: AppString.new_password_description,
                    fontSize: Dimens.sixteen,
                    color: ThemeProvider.textColor,
                    fontFamily: 'medium',
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.w500,
                  ),

                  // Password Field
                  SizedBox(height: screenHeight * .01),
                  Obx(() =>  CustomTextField(
                      obscureText:value.isObscured,
                      textInputStyle: TextStyle(
                          color: Colors.black,
                          fontSize: Dimens.sixteen,
                          fontFamily: 'medium'),
                      suffixIcon: InkWell(
                        onTap: (){
                          value.togglePasswordVisibility();
                        },
                        child:   Icon( value.isObscured ? Icons.visibility_off_outlined : Icons.visibility,
                            color: ThemeProvider.textColor, size: 23),
                      ),
                      hintText: AppString.password,
                      hintStyle: TextStyle(
                          fontFamily: 'medium',
                          color: ThemeProvider.textColor,
                          fontSize: Dimens.sixteen))),

                  //Confirm Password field
                  SizedBox(height: screenHeight * .01),
                  Obx(() =>  CustomTextField(
                      obscureText:value.isConfirmObscured,
                      textInputStyle: TextStyle(
                          color: Colors.black,
                          fontSize: Dimens.sixteen,
                          fontFamily: 'medium'),
                      suffixIcon: InkWell(
                        onTap: (){
                          value.toggleConfirmPasswordVisibility();
                        },
                        child:   Icon( value.isConfirmObscured ? Icons.visibility_off_outlined : Icons.visibility,
                            color: ThemeProvider.textColor, size: 23),
                      ),
                      hintText: AppString.confirm_password,
                      hintStyle: TextStyle(
                          fontFamily: 'medium',
                          color: ThemeProvider.textColor,
                          fontSize: Dimens.sixteen))),

                  SizedBox(height: screenHeight * .05),
                  SubmitButton(onPressed: () {

                    Get.offNamed(
                        AppRouter.getPasswordSuccessScreen());
                  }, title: AppString.reset_password),

                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}



