import 'dart:async';
import 'dart:ffi';

import 'package:get/get.dart';

import '../all_constants.dart';

class StaticValue {
  static int rewardPoint = 100;
  static RxBool miniPlayer = false.obs;
  static double dutyCycle = 0.50;
  static double amplitude = 45.0;
  static double offset = 0.0;
  static double phaseControl = 0.0;
  static int waveType = 1;
  static RxString frequencyName = "".obs;
  static RxDouble frequencyValue = 0.0.obs;
  static int totalTimeInSeconds = 0;
  static int currentTimeInSeconds = 0;
  static RxBool isPlaying = false.obs;
  static int restartTimeInSeconds = 0;
  static Timer? timer;

  static RxList<double?> frequenciesList = <double?>[].obs;
  static List<String> programNameList = <String>[];

  static RxInt playingIndex = 0.obs;
  static String screenName = "";


  static void startTime() {
    restartTimeInSeconds = totalTimeInSeconds - currentTimeInSeconds;
    if (timer == null) {
      startTimer(); // Start a new timer
    }
  }

  static void startTimer() async {
    print("HelloTimer====>" + restartTimeInSeconds.toString());
    print("HelloTimer====>" + totalTimeInSeconds.toString());
    print("HelloTimer====>" + currentTimeInSeconds.toString());

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (currentTimeInSeconds < restartTimeInSeconds) {
        currentTimeInSeconds++;
        // print(currentTimeInSeconds.toString());
      } else {
        playNext();
      }
    });
  }

  //This function is used to generate sound according to particular frequency value (Native Approach)
  static Future<void> playFrequency() async {
    isPlaying.value = true;
    Map<String, dynamic> data = {
      'frequency': frequencyValue.value,
      'duty_cycle': dutyCycle,
      'amplitude': amplitude,
      'offset': offset,
      'phase': phaseControl,
      'wavetype': waveType
    };

    var channelName = const MethodChannel("nativeBridge");
    try {
      await channelName.invokeMethod<String>("playMusic", data);
    } catch (e) {
      print("Error getting string: $e");
    }
  }

  //used to reset timer
  static void resetTimer() {
    StaticValue.currentTimeInSeconds = 0;
    pauseTimer();
    stopFrequency();
  }

  static void pauseTimer() {
    if (timer != null) {
      timer?.cancel();
      timer = null; // Reset the timer
    }
  }

  //Used to stop generated frequency sound
  static Future<void> stopFrequency() async {
    if (isPlaying.value == true) {
      isPlaying.value = false;
      var channelName = const MethodChannel("nativeBridge");
      try {
        await channelName.invokeMethod<String>("stopMusic");
      } catch (e) {
        print("Error getting string: $e");
      }
    }
  }

  //This function is used to play next frequency in the list
  static Future<void> playNext() async {
    resetTimer();
    isPlaying.value == false;
    if (playingIndex.value + 1 < frequenciesList.length) {
      playingIndex.value = playingIndex.value + 1;
      frequencyValue.value = frequenciesList[playingIndex.value] as double;
    } else {
      frequencyValue.value = frequenciesList[0]!;
      playingIndex.value = 0;
    }
    changeProgramName();
    Future.delayed(Duration(seconds: 3), () {
      playFrequency();
      startTime();
      isPlaying.value = true;
    });
  }

  static void changeProgramName(){
    if(screenName == "playlist" || screenName == "download" ){
      frequencyName.value = programNameList[playingIndex.value] != 'No Name' ?  programNameList[playingIndex.value] : "";
    }

  }
}
