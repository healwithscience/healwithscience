import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../backend/helper/app_router.dart';
import '../backend/parser/reward_parser.dart';
import '../backend/parser/splash_parser.dart';
import '../util/extensions/static_values.dart';
import '../util/utils.dart';

class RewardController extends GetxController {
  final RewardParser parser;

  RewardController({required this.parser});

  String splash_text = "Splash Screen";
  RxString rewardPoint = "".obs;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    StaticValue.rewardPoint = await Utils.getRewardPoints(parser.getUserId());
    rewardPoint.value = StaticValue.rewardPoint.toString();
  }



  void onBackRoutes() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }
}
