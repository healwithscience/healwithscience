

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:heal_with_science/controller/category_controller.dart';

import '../../controller/dashboard_controller.dart';

class CategoryBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(
          () => CategoryController(parser: Get.find()),
    );
  }



}