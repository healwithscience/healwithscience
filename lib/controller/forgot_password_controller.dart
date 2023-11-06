import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../backend/parser/forgot_password_parser.dart';
import '../util/theme.dart';
import '../util/toast.dart';

class ForgotPasswordController extends GetxController {
  final ForgotPasswordParser parser;

  final emailController = TextEditingController();

  ForgotPasswordController({required this.parser});

  @override
  void onInit() {
    super.onInit();
  }

  void onBackRoutes() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  //Function used to send verification mail
  Future<void> sendPasswordResetEmail() async {
    if(emailController.value.text.isEmpty){
      showToast('Please enter email address');
      return;
    }
    else if (!isEmailValid(emailController.value.text)) {
      showToast('Invalid email address');
      return;
    }
    Get.dialog(
        SimpleDialog(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 30,
                ),
                CircularProgressIndicator(
                  color: ThemeProvider.primary,
                ),
                const SizedBox(
                  width: 30,
                ),
                SizedBox(
                    child: Text(
                      "Please wait".tr,
                      style: const TextStyle(fontFamily: 'bold'),
                    )),
              ],
            )
          ],
        ),
        barrierDismissible: false);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.value.text.toString(),
      );
      // Password reset email sent successfully
      Get.back();
      emailController.clear();
      Get.snackbar(
        'Password reset email sent',
        'Please check your email to reset your password.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      Get.back();
      // Handle errors here (e.g., email not found)
      Get.snackbar(
        'Error',
        'An error occurred: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  bool isEmailValid(String email) {
    // Regular expression for email validation
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }


}
