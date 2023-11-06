import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import '../controller/splash_controller.dart';
import '../util/app_assets.dart';
import '../util/theme.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<SplashScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<SplashController>(builder: (value) {
      return Container(
        color: ThemeProvider.primary,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(AssetPath.splash_1, height: screenHeight * .2),
              const SizedBox(height: 100),
              SvgPicture.asset(AssetPath.splash_2, height: screenHeight * .3)

            ]),
      );
    });

    //SafeArea(child: Text("Splash Screen"));
  }
}
