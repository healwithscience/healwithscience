
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:heal_with_science/util/theme.dart';

class Utils {
  static void filedFocusChange(BuildContext context, FocusNode current,
      FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static void showProgressbar(){
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
  }


}