
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:heal_with_science/controller/about_controller.dart';
import 'package:heal_with_science/controller/privacy_policy_controller.dart';
import 'package:heal_with_science/controller/profile_controller.dart';

import '../../controller/onboard_controller.dart';

class PrivacyPolicyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => PrivacyPolicyController(parser: Get.find()),
    );
  }
}
