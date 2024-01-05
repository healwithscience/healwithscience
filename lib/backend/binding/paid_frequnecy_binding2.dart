

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:heal_with_science/controller/category_controller.dart';
import 'package:heal_with_science/controller/paid_frequency_controller.dart';
import 'package:heal_with_science/controller/paid_frequency_controller2.dart';

import '../../controller/dashboard_controller.dart';

class PaidFrequencyBinding2 extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(
          () => PaidFrequencyController2(parser: Get.find()),
    );
  }
}