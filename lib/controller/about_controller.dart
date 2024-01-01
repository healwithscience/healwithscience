import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heal_with_science/backend/parser/about_parser.dart';
import 'package:heal_with_science/backend/parser/profile_parser.dart';
import 'package:path/path.dart';
import '../backend/helper/app_router.dart';
import '../util/all_constants.dart';
import '../util/extensions/static_values.dart';
import '../util/inactivity_manager.dart';
import '../util/theme.dart';
import '../util/utils.dart';

class AboutController extends GetxController {

  final AboutParser parser;

  AboutController({required this.parser});

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