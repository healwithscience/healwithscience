import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import '../../controller/otp_verification_controller.dart';

class OtpVerificationBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(
          () => OtpVerificationController(parser: Get.find()),
    );
  }
}