import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import '../backend/helper/app_router.dart';
import '../controller/login_controller.dart';
import '../util/app_assets.dart';
import '../util/dimens.dart';
import '../util/string.dart';
import '../util/theme.dart';
import '../util/utils.dart';
import '../widgets/commontext.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/social_login_button.dart';
import '../widgets/submit_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return GetBuilder<LoginController>(builder: (value) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.all(screenWidth * .04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*Container(
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
                ),*/
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Heading Text or Tittle Text
                        SizedBox(height: screenHeight * .04),
                        CommonTextWidget(
                            lineHeight:1.3,
                            heading: AppString.welcome,
                            fontSize: Dimens.thirty,
                            color: Colors.black,
                            fontFamily: 'bold'),

                        //E-mail Address field
                        SizedBox(height: screenHeight * .02),
                        CustomTextField(
                          focusNode: emailFocusNode,
                          controller: value.emailController,
                          textInputStyle: TextStyle(
                              color: Colors.black,
                              fontSize: Dimens.sixteen,
                              fontFamily: 'medium'),
                          prefixIcon: Padding(
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
                          onFieldSubmitted: (value) {
                            Utils.filedFocusChange(
                                context, emailFocusNode, passwordFocusNode);
                          },
                        ),
                        // Password Field
                        SizedBox(height: screenHeight * .01),

                        Obx(() => CustomTextField(
                            focusNode: passwordFocusNode,
                            controller: value.passwordController,
                            obscureText: value.isObscured,
                            textInputStyle: TextStyle(
                                color: Colors.black,
                                fontSize: Dimens.sixteen,
                                fontFamily: 'medium'),
                            suffixIcon: InkWell(
                              onTap: () {
                                value.togglePasswordVisibility();
                              },
                              child: Icon(
                                  value.isObscured
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility,
                                  color: ThemeProvider.textColor,
                                  size: 23),
                            ),
                            hintText: AppString.enter_your_password,
                            hintStyle: TextStyle(
                                fontFamily: 'medium',
                                color: ThemeProvider.textColor,
                                fontSize: Dimens.sixteen))),


                        //Login Button
                        SizedBox(height: screenHeight * .05),
                        SubmitButton(
                            onPressed: () {
                              value.onSubmit();
                            },
                            title: AppString.login),

                        //Forgot Password
                        SizedBox(height: screenHeight * .03),
                        InkWell(
                          onTap: () {
                            Get.toNamed(AppRouter.getforgotPasswordScreen());
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: CommonTextWidget(
                              heading: AppString.forgot_your_password,
                              fontSize: Dimens.sixteen,
                              color: ThemeProvider.textColor,
                              fontFamily: 'medium',
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),

                        //Text With divider on both side
                        SizedBox(height: screenHeight * .05),
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                color: ThemeProvider.borderColor,
                                thickness: 1.0,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                AppString.login_with,
                                style: TextStyle(
                                  fontFamily: 'bold',
                                  color: ThemeProvider.greyColor,
                                  fontSize: Dimens.forteen,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                color: ThemeProvider.borderColor,
                                thickness: 1.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * .05),
                        SocialLoginButton(
                            onPressed: () {
                              value.handleFacebookLogin();
                            },
                            title: AppString.facebook_login,
                            style: TextStyle(
                                fontSize: 16,
                                color: ThemeProvider.whiteColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'bold'),
                            backgroundColor: ThemeProvider.blue,
                            iconPath: AssetPath.facebook),

                        //Apple Login Butotn
                        isIOS
                            ? SizedBox(height: screenHeight * .05)
                            : SizedBox(
                                height: 0,
                              ),
                        isIOS
                            ? SocialLoginButton(
                                onPressed: () {
                                  value.signInWithApple();
                                },
                                title: AppString.apple_login,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: ThemeProvider.whiteColor,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'bold'),
                                backgroundColor: ThemeProvider.blackColor,
                                iconPath: AssetPath.apple)
                            : SizedBox(
                                height: 0,
                              ),

                        //Google Login Button
                        SizedBox(height: screenHeight * .05),
                        SocialLoginButton(
                          onPressed: () {
                            value.signInWithGoogle();
                          },
                          title: AppString.google_login,
                          style: TextStyle(
                              fontSize: 16,
                              color: ThemeProvider.whiteColor,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'bold'),
                          backgroundColor: ThemeProvider.redColor,
                          iconPath: AssetPath.google,
                        ),

                        SizedBox(height: screenHeight * .05),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                                fontFamily: 'bold', fontSize: Dimens.fifteen),
                            children: <TextSpan>[
                              TextSpan(
                                text: AppString.no_account,
                                style: TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                  text: AppString.register_now,
                                  style: TextStyle(
                                      color: ThemeProvider.persianGreen),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      //Navigate to Register Screen
                                      Get.toNamed(AppRouter.getRegisterRoute());
                                    }),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * .02),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
