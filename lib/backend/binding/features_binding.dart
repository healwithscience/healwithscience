import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import '../../controller/features_controller.dart';

class FeaturesBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(
          () => FeaturesController(parser: Get.find()),
    );
  }



}