
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../../controller/create_password_controller.dart';

class CreatePasswordBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(
          () => CreatePasswordController(parser: Get.find()),
    );
  }



}