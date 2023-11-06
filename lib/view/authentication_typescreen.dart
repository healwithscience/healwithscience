import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../backend/helper/app_router.dart';
import '../controller/authentication_type_controller.dart';
import '../util/all_constants.dart';
import '../util/dimens.dart';
import '../widgets/commontext.dart';

class AuthenticationTypeScreen extends StatefulWidget {
  const AuthenticationTypeScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationTypeScreen> createState() => _AuthenticationTypeScreenState();
}

class _AuthenticationTypeScreenState extends State<AuthenticationTypeScreen> {
  double screenHeight = 0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return GetBuilder<AuthenticationTypeController>(builder: (value) {
      return Scaffold(
          body: SafeArea(
              child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: WillPopScope(
          onWillPop: () {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            return Future.value(false);
          },
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenHeight * 0.04,
                  ),
                  SvgPicture.asset(AssetPath.app_logo),
                  CommonTextWidget(
                    heading: AppString.paymeback,
                    fontSize: Dimens.thirty,
                    color: Colors.black,
                    fontFamily: 'bold',
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  CommonTextWidget(
                    heading: AppString.bill_payment_service,
                    fontSize: Dimens.forteen,
                    color: Colors.black,
                    fontFamily: 'bold',
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  SubmitButton(
                    onPressed: () => {Get.toNamed(AppRouter.getLoginRoute())},
                    title: AppString.login,
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  SubmitButton(
                    onPressed: () => {
                      {Get.toNamed(AppRouter.getLoginRoute())},

                      ///  if (value.formKey.currentState!.validate()) {value.onLoginClicked()}
                    },
                    title: AppString.create_an_account,
                  )
                ],
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 100,
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    CommonTextWidget(
                      heading: AppString.help,
                      fontSize: Dimens.sixteen,
                      color: Colors.black,
                      fontFamily: 'bold',
                      fontWeight: FontWeight.w500,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: Dimens.forteen, right: Dimens.forteen),
                      child: Container(
                        height: Dimens.twenty,
                        width: 1,
                        color: Colors.black,
                      ),
                    ),
                    CommonTextWidget(
                      heading: AppString.terms,
                      fontSize: Dimens.sixteen,
                      color: Colors.black,
                      fontFamily: 'bold',
                      fontWeight: FontWeight.w500,
                    ),
                  ])),
            ],
          ),
        ),
      )));
    });
  }
}
