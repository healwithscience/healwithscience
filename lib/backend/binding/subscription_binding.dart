

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:heal_with_science/controller/category_controller.dart';
import 'package:heal_with_science/controller/download_controller.dart';
import 'package:heal_with_science/controller/heart_controller.dart';
import 'package:heal_with_science/controller/subscription_controller.dart';

import '../../controller/dashboard_controller.dart';

class SubscriptionBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(
          () => SubscriptionController(parser: Get.find()),
    );
  }
}