import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../all_constants.dart';
// import 'dart:js' as js;

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

  static RxInt playingQueueIndex = 0.obs;
  static RxBool playingType = false.obs;


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

    if(kIsWeb){
      //Commented because dart:js not working  only in web . You have to uncomment it if you have to run application in web
      // js.context.callMethod('generateAudio', [amplitude,frequencyValue.value,phaseControl,waveType]);
    }else{
      if(Platform.isAndroid){
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
      }else{

      }
    }
  }


  static Future<void> stopFrequency() async {
    if (isPlaying.value == true) {
      isPlaying.value = false;

      if(kIsWeb){
        //Commented because dart:js not working  only in web . You have to uncomment it if you have to run application in web
        // js.context.callMethod('stopAudio');
      }else{
        if(Platform.isAndroid){
          var channelName = const MethodChannel("nativeBridge");
          try {
            await channelName.invokeMethod<String>("stopMusic");
          } catch (e) {
            print("Error getting string: $e");
          }
        }else{

        }
      }
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


  //This function is used to play next frequency in the list
  static Future<void> playNext() async {
    resetTimer();
    isPlaying.value == false;

    if(playingType.value){
      playingQueueIndex.value = playingQueueIndex.value + 1;
    }

    if(StaticValue.queueFrequenciesList.isNotEmpty && playingQueueIndex.value != StaticValue.queueFrequenciesList.length ){
      playingType.value = true;
      frequencyValue.value = StaticValue.queueFrequenciesList[playingQueueIndex.value] as double;
      frequencyName.value = StaticValue.queueProgramNameList[playingQueueIndex.value] != 'No Name' ?  StaticValue.queueProgramNameList[playingQueueIndex.value] : "";
      // frequencyName.value = programNameList[playingIndex.value] != 'No Name' ?  programNameList[playingIndex.value] : "";
    }else{
      playingType.value = false;
      if (playingIndex.value + 1 < frequenciesList.length) {
        playingIndex.value = playingIndex.value + 1;
        frequencyValue.value = frequenciesList[playingIndex.value] as double;
      } else {
        frequencyValue.value = frequenciesList[0]!;
        playingIndex.value = 0;
      }
      changeProgramName();
    }



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


  static Future<void> startBackgroundService() async {
    // if (isPlaying.value == true) {
      isPlaying.value = false;
      var channelName = const MethodChannel("nativeBridge");
      try {
        await channelName.invokeMethod<String>("startBackgroundService");
      } catch (e) {
        print("Error getting string: $e");
      }
    // }
  }

  static RxList<double?> queueFrequenciesList = <double?>[].obs;
  static List<String> queueProgramNameList = <String>[];

  static Future<void> addSongToQueue(double freq, String name) async {

    if (!queueFrequenciesList.contains(freq)) {
      queueFrequenciesList.add(freq);
      if(name == ""){
        queueProgramNameList.add('No Name');
      }else{
        queueProgramNameList.add(name);
      }

    } else {
      showToast("Program with frequency $freq already exists in the queue.");
    }
     print("HelloQueueList===>"+queueFrequenciesList.toString());
  }

  static Future<void> removeFromQueue(double freq,) async {
    int index = queueFrequenciesList.indexOf(freq);

    if (index != -1) {
      queueFrequenciesList.removeAt(index);
      queueProgramNameList.removeAt(index);
      showToast("Program with frequency $freq removed from the queue.");
    } else {
      showToast("Program with frequency $freq not found in the queue.");
    }

    print("HelloQueueList===>" + queueFrequenciesList.toString());
  }

  static Future<void> addListToQueue(List<double> frequencies, String name) async {
    for (int i = 0; i < frequencies.length; i++) {
      double freq = frequencies[i];

      int existingIndex = queueFrequenciesList.indexOf(freq);

      if (existingIndex == -1) {
        // Frequency does not exist, add it to the queue
        queueFrequenciesList.add(freq);
        queueProgramNameList.add(name);
      } else {
        // Frequency already exists, replace the program name
        queueProgramNameList[existingIndex] = name;
      }
    }
    successToast("Program added in the queue successfully.");

  }

  static Future<void> removeAllWithName(String name) async {
    List<double> removedFrequencies = [];

    for (int i = queueProgramNameList.length - 1; i >= 0; i--) {
      if (queueProgramNameList[i] == name) {
        removedFrequencies.add(queueFrequenciesList.removeAt(i)!);
        queueProgramNameList.removeAt(i);
      }
    }

    if (removedFrequencies.isNotEmpty) {
      successToast("Programs with name '$name' removed from the queue.");
      print("Removed Frequencies: $removedFrequencies");
    } else {
      showToast("No programs with name '$name' found in the queue.");
    }

    print("HelloQueueList===>$queueFrequenciesList");
  }
}
