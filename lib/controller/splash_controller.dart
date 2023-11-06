import 'dart:async';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../backend/helper/app_router.dart';
import '../backend/parser/splash_parser.dart';

class SplashController extends GetxController {
  final SplashParser parser;

  SplashController({required this.parser});

  String splash_text = "Splash Screen";

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Timer(
        const Duration(seconds: 3),
        () => {
              if (parser.haveLoggedIn())
                {Get.offNamed(AppRouter.addDashboardScreenRoute())}
              else
                {Get.back(), Get.offNamed(AppRouter.getLoginRoute())}
            });
  }
}
