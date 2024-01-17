import 'dart:async';

import 'package:get/get.dart';

class InactivityManager {
  static Timer? timer;
  static RxBool showImage = false.obs;

  static void startTime() {
    int startTimeValue = 0;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      startTimeValue = startTimeValue + 1;
      if(startTimeValue < 90){
        // print("HelloTimer====> " + startTimeValue.toString());
      }else{
        // print("HelloTimerCancel====> ");
        showImage.value = true;
        timer.cancel();
      }

    });
  }

  static void doNotStart() {
    timer?.cancel();
    showImage.value = false;
  }

  static void resetTimer() {
    timer?.cancel();
    showImage.value = false;
    startTime();
  }
}
