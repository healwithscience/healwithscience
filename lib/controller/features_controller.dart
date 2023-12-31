import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heal_with_science/backend/parser/features_parser.dart';
import '../model/Category.dart';
import '../util/all_constants.dart';

class FeaturesController extends GetxController {
  final FeaturesParser parser;

  FeaturesController({required this.parser});

  final RxDouble currentIndex = 0.0.obs;

  // final RxDouble frequency = 0.0.obs;
  final RxInt selectedOption = 1.obs;

  final RxDouble dutyCycle = 1.0.obs;
  final double minDutyCycle = 0.0;
  final double maxDutyCycle = 1.0;

  final RxDouble amplitude = 30.0.obs;
  final double maxAmplitude = 70.0;
  final double minAmplitude = 30.0;

  final RxDouble offset = 0.0.obs;
  final double maxOffset = 50.0;
  final double minOffset = -50.0;

  final RxDouble phaseControl = 0.0.obs;
  final double maxPhaseControl = 2 * pi;
  final double minPhaseControl = 0.0;


  final RxInt currentTheme = 0.obs;

  var sliderProgress = 0.0.obs;
  Timer? timer;
  int currentTimeInSeconds = 0;
  int totalTimeInSeconds = 300;
  int restartTimeInSeconds = 0;
  var timeRemaining = "3:00".obs;
  var totalTime = "0:00".obs;

  RxBool isPlaying = false.obs;
  RxBool isProcessing = false.obs;

  RxDouble frequencyValue = 0.0.obs;
  final RxList<double?> frequenciesList = <double?>[].obs;
  RxInt playingIndex = 0.obs;
  RxString programName = "".obs;
  String screenName = "";
  RxList playlistNames = <String>[].obs;

  List<String> programNameList = <String>[];

  TextEditingController timeController  = TextEditingController();

  List<String> options = ['1','2','3','4','5'];
  String selectedTime = '5';
  RxString selectedTimeObserver = '5'.obs;

  RxInt playType = 0.obs;

  RxList<int> downloadButtonClickedList = <int>[].obs;
  List<Category>? categoriesList = [];


  @override
  void onInit() {
    super.onInit();
    
    final data = Get.arguments;
    frequencyValue.value = data['frequency'];
    frequenciesList.value = data['frequenciesList'];
    playingIndex.value = data['index'];
    screenName = data['screenName'];

    downloadButtonClickedList.value =  List.filled(frequenciesList.length, 1);

    if(screenName == "category"||screenName == "custom_program"){
      programName.value = data['name'];
    }else if(screenName == "playlist" || screenName == "download" ){
      programNameList = data['programName'];
      programName.value = programNameList[playingIndex.value] != 'No Name' ?  programNameList[playingIndex.value] : "";
    }

    currentTheme.value = parser.getTheme();
    playFrequency();
    fetchDownloadlist();
    startTime();
  }

  Future<void> fetchDownloadlist() async {
    categoriesList =  await parser.fetchList();
  }

  bool checkStatus(String frequency)  {
    if(categoriesList != null){
      for (Category category in categoriesList!) {
        if(frequency.toString() == category.frequency.toString()){
          return true;
        }
      }
    }
    return false;
  }

  void startTime() {
    restartTimeInSeconds = totalTimeInSeconds - currentTimeInSeconds;
    if (timer == null) {
      startTimer(); // Start a new timer
    }
  }

  void pauseTimer() {
    if (timer != null) {
      timer?.cancel();
      timer = null; // Reset the timer
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (currentTimeInSeconds < restartTimeInSeconds) {
        sliderProgress.value = currentTimeInSeconds.toDouble();
        currentTimeInSeconds++;
        timeCalculation();
        print(currentTimeInSeconds.toString());
      } else {
        if(playType.value == 0){
          playNext();
          // resetTimer();
        }else{
          resetTimer();
          Future.delayed(Duration(seconds: 3), (){
            playFrequency();
            startTime();
            isPlaying.value = true;
          });
        }
      }
    });
  }

  //used to reset timer
  void resetTimer() {
    pauseTimer();
    currentTimeInSeconds = 0;
    totalTime.value = "0:00";
    sliderProgress.value = 0.0;
    stopFrequency();
  }

  // Used to calculate remaining time
  void timeCalculation() {
    var minuteTotal = ((currentTimeInSeconds) / 60).toInt();
    var secondTotal = ((currentTimeInSeconds) % 60);

    if (secondTotal < 10) {
      totalTime.value = "$minuteTotal:0$secondTotal";
    } else {
      totalTime.value = "$minuteTotal:$secondTotal";
    }
  }

  //Set wave type
  void changeOption(int newOption) {
    selectedOption.value = newOption;
  }

  //Increase Duty Cycle
  void onIncreaseDutyCycle() {
    if (dutyCycle.value < maxDutyCycle) {
      dutyCycle.value = (dutyCycle.value + 0.1).clamp(0.0, 1.0);
    }
  }

  //Decrease Duty Cycle
  void onDecreaseDutyCycle() {
    if (dutyCycle.value > minDutyCycle) {
      dutyCycle.value = (dutyCycle.value - 0.1).clamp(0.0, 1.0);
    }
  }

  //Increase Amplitude
  void onIncreaseAmplitude() {
    if (amplitude.value < maxAmplitude) {
      amplitude.value = (amplitude.value + 5.0).clamp(30.0, 70.0);
    }
  }

  //Decrease Duty Cycle
  void onDecreaseAmplitude() {
    if (amplitude.value > minAmplitude) {
      amplitude.value = (amplitude.value - 5.0).clamp(30.0, 70.0);
    }
  }

  //Increase Amplitude
  void onIncreaseOffset() {
    if (offset.value < maxOffset) {
      offset.value = (offset.value + 5.0).clamp(-50.0, 50.0);
    }
  }

  //Decrease Duty Cycle
  void onDecreaseOffset() {
    if (offset.value > minOffset) {
      offset.value = (offset.value - 5.0).clamp(-50.0, 50.0);
    }
  }

  //Increase Phase Control
  void onIncreasePhaseControl() {
    if (phaseControl.value < maxPhaseControl) {
      phaseControl.value = (phaseControl.value + 1.0).clamp(0.0, 2 * pi);
    }
  }

  //Decrease Phase Control
  void onDecreasePhaseControl() {
    if (phaseControl.value > minPhaseControl) {
      phaseControl.value = (phaseControl.value - 1.0).clamp(0.0, 2 * pi);
    }
  }

  void onBackRoutes() {
    if (isPlaying.value == true) {
      timer?.cancel();
      stopFrequency();

    }
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  //Used to update the theme (dark or light)
  void setTheme(int theme) {
    parser.saveTheme(theme);
    currentTheme.value = theme;
  }

  //This function is used to generate sound according to particular frequency value (Native Approach)
  Future<void> playFrequency() async {
    changeProgramName();
    isPlaying.value = true;
    Map<String, dynamic> data = {
      'frequency': frequencyValue.value,
      'duty_cycle': dutyCycle.value,
      'amplitude': amplitude.value,
      'offset': offset.value,
      'phase': phaseControl.value
    };

    var channelName = const MethodChannel("nativeBridge");
    try {
      await channelName.invokeMethod<String>("playMusic", data);
    } catch (e) {
      print("Error getting string: $e");
    }
  }

  //Used to stop generated frequency sound
  Future<void> stopFrequency() async {
    if(isPlaying.value == true){
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
  void playNext() {

    print("Before Playing Value: ${frequencyValue.value}");
    // frequencyValue.value = frequenciesList[playingIndex.value + 1]!;

    resetTimer();
    isPlaying.value == false;
    if(playingIndex.value + 1 < frequenciesList.length){
      playingIndex.value = playingIndex.value + 1;
      frequencyValue.value = frequenciesList[playingIndex.value] as double;

      print("After Playing Value: ${frequencyValue.value}");
    }else{
      frequencyValue.value = frequenciesList[0]!;
      playingIndex.value = 0;
    }
    changeProgramName();

    Future.delayed(Duration(seconds: 3), (){
       playFrequency();
       startTime();
       isPlaying.value = true;
    });
  }

  //This function is used to play previous frequency in the list
  void playPrevious() {
    // frequencyValue.value = frequenciesList[playingIndex.value + 1]!;
    resetTimer();
    isPlaying.value == false;
    if (playingIndex.value - 1 >= 0) {
      playingIndex.value = playingIndex.value - 1;
      frequencyValue.value = frequenciesList[playingIndex.value] as double;

    } else {
      frequencyValue.value = frequenciesList[frequenciesList.length - 1]!;
      playingIndex.value = frequenciesList.length - 1;
    }

    changeProgramName();

    Future.delayed(Duration(seconds: 3), (){
      playFrequency();
      startTime();
      isPlaying.value = true;
    });
  }

  //Function used to fetch custom playlist created by user
  Future<void> fetchUserPlaylists() async {
    playlistNames.clear();
    final firestoreInstance = FirebaseFirestore.instance;
    var userId = parser.getUserId();

    try {
      final playlistsCollection = firestoreInstance.collection('users').doc(userId).collection('playlists');
      final querySnapshot = await playlistsCollection.get();

      querySnapshot.docs.forEach((doc) {
        playlistNames.add(doc.id);
      });
    } catch (e) {
      print('Error fetching user playlists: $e');
      return; // Handle the error as per your requirements
    }
  }

  //Function used to add frequency value in particular playlist
  Future<void> updatePlaylist(String playlistName, dynamic valueToAdd,String programName) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      var userId = parser.getUserId();

      // Create a reference to the document for the specified playlist
      final userPlaylistRef = firestoreInstance.collection('users').doc(userId).collection('playlists').doc(playlistName);

      // Update the data in the Firestore document
      await userPlaylistRef.update({
        "playlist": FieldValue.arrayUnion([{"name": programName.toString().isEmpty ? "No Name" :  programName.toString(), "frequency": valueToAdd.toString()}]),
      });

      Get.back();
      successToast('Playlist updated Successfully');
    } catch (e) {
      showToast('Error updating playlist: $e');
    }
  }


  Future<void> customTime(String newValue) async {
      selectedTimeObserver.value = newValue;
      var timeValue = int.parse(newValue);
      if(timeValue >= 6){
        showToast("Time can't be more then 5 min");
        return;
      }
      totalTimeInSeconds = timeValue * 60;
      resetTimer();
      // playFrequency();
      // startTime();
  }

  void changeProgramName(){
    if(screenName == "playlist" || screenName == "download" ){
      programName.value = programNameList[playingIndex.value] != 'No Name' ?  programNameList[playingIndex.value] : "";
    }
  }
}
