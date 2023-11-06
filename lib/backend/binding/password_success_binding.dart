
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import '../../controller/password_success_controller.dart';

class PasswordSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
          () => PasswordSuccessController(parser: Get.find()),
    );
  }
}
