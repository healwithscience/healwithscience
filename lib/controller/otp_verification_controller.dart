import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../backend/parser/forgot_password_parser.dart';
import '../backend/parser/otp_verification_parser.dart';

class OtpVerificationController extends GetxController {

  final OtpVerificationParser parser;
  late TextEditingController otpValue = TextEditingController();

  final isShowingPassword = false.obs;
  final isShowingConfirmPsd = false.obs;

  var has8Char = false.obs;
  var hasLN = false.obs;
  final formKey = GlobalKey<FormState>();

  String phoneNumber = "";

  OtpVerificationController({required this.parser});

  @override
  void onInit() {
    super.onInit();
  }

  void onBackRoutes() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }


}
