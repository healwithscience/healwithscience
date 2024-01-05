import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../backend/parser/privacy_policy_parser.dart';
import '../util/all_constants.dart';
import '../util/extensions/static_values.dart';
import '../util/inactivity_manager.dart';

class PrivacyPolicyController extends GetxController {

  final PrivacyPolicyParser parser;

  PrivacyPolicyController({required this.parser});

  @override
  void onInit() {
    super.onInit();
  }

  void onBackRoutes() {
    if(StaticValue.miniPlayer.value){
      InactivityManager.resetTimer();
    }
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

}