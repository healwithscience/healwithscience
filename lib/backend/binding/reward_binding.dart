
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:heal_with_science/controller/reward_controller.dart';

import '../../controller/splash_controller.dart';

class RewardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => RewardController(parser: Get.find()),
    );
  }
}
