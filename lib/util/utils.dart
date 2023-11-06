
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:heal_with_science/util/theme.dart';
import 'package:heal_with_science/util/toast.dart';

import 'constants.dart';

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

  //Function used to get reward points
  static Future<int> getRewardPoints(String userId) async {
    final firestoreInstance = FirebaseFirestore.instance;

    // Create a reference to the document for the specified user
    final userPoint = firestoreInstance.collection('reward').doc(userId);

    // Get the document snapshot
    final docSnapshot = await userPoint.get();

    if (docSnapshot.exists) {
      // The document exists, so you can access the "points" field
      String points = docSnapshot.data()?['points'] ;
      return int.parse(points);
    }
    return  0;
  }

  //Function Used to update Reward Point
  static Future<void> updateRewardPoints(int newPoints,String userId) async {
    final firestoreInstance = FirebaseFirestore.instance;

    // Create a reference to the document for the specified user
    final userPoint = firestoreInstance.collection('reward').doc(userId);

    // Update the "points" field with the new value
    await userPoint.update({
      "points": newPoints.toString(),
    });
  }

}