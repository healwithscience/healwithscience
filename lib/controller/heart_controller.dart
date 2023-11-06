import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:heal_with_science/backend/parser/dashboard_parser.dart';
import 'package:heal_with_science/backend/parser/heart_parser.dart';
import 'package:heal_with_science/model/ListItem.dart';
import '../backend/helper/app_router.dart';
import '../util/all_constants.dart';

class HeartController extends GetxController {
  final HeartParser parser;

  HeartController({required this.parser});

  @override
  void onInit() {
    super.onInit();

  }

  void onBackRoutes() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }
}
