import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:heal_with_science/backend/parser/share_parser.dart';

import '../backend/helper/app_router.dart';
import '../backend/parser/reward_parser.dart';
import '../backend/parser/splash_parser.dart';
import '../util/extensions/static_values.dart';
import '../util/inactivity_manager.dart';
import '../util/utils.dart';

class ShareController extends GetxController {
  final ShareParser parser;

  ShareController({required this.parser});

  RxString dynamicUrlShare = "".obs;


  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    createDynamicLink(parser.getUserId());
    if(StaticValue.miniPlayer.value){
      InactivityManager.resetTimer();
    }
  }


  Future<void> createDynamicLink(String userId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://healwithscience.page.link',
      link: Uri.parse('https://healwithscience.page.link?userId=$userId'),
      androidParameters: const AndroidParameters(
        packageName: 'com.healwithscience',
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.example.yourapp',
        minimumVersion: '1.0.0',
        appStoreId: 'your_app_store_id',
      ),
    );

    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    Uri dynamicUrl = await dynamicLinks.buildLink(parameters);
    dynamicUrlShare.value = dynamicUrl.toString();

    print("Hello Dynamic Link===>  $dynamicUrl");
  }


  void onBackRoutes() {
    if(StaticValue.miniPlayer.value){
      InactivityManager.resetTimer();
    }
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }
}
