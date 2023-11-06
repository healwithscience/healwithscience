import 'dart:async';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../backend/helper/app_router.dart';
import '../backend/parser/password_success_parser.dart';
import '../backend/parser/splash_parser.dart';

class PasswordSuccessController extends GetxController {
  final PasswordSuccessParser parser;
  PasswordSuccessController({required this.parser});


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }
}
