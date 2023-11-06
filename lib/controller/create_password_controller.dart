import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../backend/parser/create_password_parser.dart';
import '../backend/parser/forgot_password_parser.dart';
import '../backend/parser/otp_verification_parser.dart';

class CreatePasswordController extends GetxController {

  final CreatePasswordParser parser;
  CreatePasswordController({required this.parser});

  var _isObscured = true.obs; // Use RxBool for reactivity
  bool get isObscured => _isObscured.value;

  var _isConfirmObscured = true.obs; // Use RxBool for reactivity
  bool get isConfirmObscured => _isConfirmObscured.value;

  @override
  void onInit() {
    super.onInit();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmObscured.value = !isConfirmObscured;
  }

  void togglePasswordVisibility() {
    _isObscured.value = !isObscured;
  }
  void onBackRoutes() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }


}
