import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' as found;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:heal_with_science/backend/parser/features_parser.dart';
import '../model/Category.dart';
import '../util/all_constants.dart';
import '../util/extensions/static_values.dart';
import '../util/inactivity_manager.dart';
import '../util/utils.dart';
// import 'dart:js' as js;


class FeaturesController extends GetxController {
  final FeaturesParser parser;

  FeaturesController({required this.parser});

  final RxDouble currentIndex = 0.0.obs;

  // final RxDouble frequency = 0.0.obs;
  final RxInt selectedOption = 1.obs;

  final RxDouble dutyCycle = 0.50.obs;
  final double minDutyCycle = 0.0;
  final double maxDutyCycle = 1.0;

  final RxDouble amplitude = 10.0.obs;
  final double maxAmplitude = 20.0;
  final double minAmplitude = 0.0;

  final RxDouble offset = 0.0.obs;
  final double maxOffset = 50.0;
  final double minOffset = -50.0;

  final RxDouble phaseControl = 0.0.obs;
  final double maxPhaseControl = 2 * pi;
  final double minPhaseControl = 0.0;

  final RxInt currentTheme = 0.obs;

  late AnimationController animatedcontroller;

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
  String playerType = "";
  RxList playlistNames = <String>[].obs;

  List<String> programNameList = <String>[];

  TextEditingController timeController  = TextEditingController();

  List<String> options = ['1','2','3','4','5'];
  String selectedTime = '5';
  RxString selectedTimeObserver = '5'.obs;

  RxInt playType = 0.obs;

  RxList<int> downloadButtonClickedList = <int>[].obs;
  List<Category>? categoriesList = [];

  RxBool isButtonPressed = false.obs;
  RxBool isRadioSelected = false.obs;

  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;

  Rx<ConnectivityResult> connectivityResult = Rx<ConnectivityResult>(ConnectivityResult.none);

  final AdRequest request = const AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  RxString selectedList = "main".obs;

  @override
  onInit()  {
    super.onInit();
    print("Hello i am in main method");

    fetchAllData();

  }

  fetchAllData() async {
    connectivityResult.value = await Utils.checkInternetConnection();

    if(connectivityResult.value == ConnectivityResult.wifi || connectivityResult.value == ConnectivityResult.mobile){
      if(!found.kIsWeb){
        loadRewardedAd();
      }
    }

    final data = Get.arguments;
    frequencyValue.value = data['frequency'];
    print("helloFrequencyValue===> "+frequencyValue.value.toString());

    frequenciesList.value = data['frequenciesList'];
    playingIndex.value = data['index'];
    screenName = data['screenName'];
    downloadButtonClickedList.value =  List.filled(frequenciesList.length, 1);

    if(data['selectedList'] != null){
      selectedList.value = data['selectedList'];
    }else{
      selectedList.value = 'main';
    }

    if(selectedList.value == 'main'){
      if(screenName == "category"||screenName == "custom_program"){
        programName.value = data['name'];
      }else if(screenName == "playlist" || screenName == "download" ){
        programNameList = data['programName'];
        programName.value = programNameList[playingIndex.value] != 'No Name' ?  programNameList[playingIndex.value] : "";
      }
    }else{
      programName.value = StaticValue.queueProgramNameList[playingIndex.value] != 'No Name' ?  StaticValue.queueProgramNameList[playingIndex.value] : "" ;
    }




    if(data['type'] != null){
      playerType = data['type'];
      isPlaying.value = data['isPlaying'];
      currentTimeInSeconds = data['currentTimeInSeconds'];

      if(isPlaying.value){
        startTime();
        InactivityManager.resetTimer();
      }
    }else{
      playFrequency();
      startTime();
      InactivityManager.resetTimer();
      //Fetch reward point and update Reward Point
      if(parser.getPlan() == 'basic' && StaticValue.rewardPoint > 0){
        StaticValue.rewardPoint = await Utils.getRewardPoints(parser.getUserId());
        StaticValue.rewardPoint =  StaticValue.rewardPoint-1;
        Utils.updateRewardPoints(StaticValue.rewardPoint ,parser.getUserId());
      }

    }
    fetchDownloadlist();

    // Fetch current theme
    currentTheme.value = parser.getTheme();
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
        // print(currentTimeInSeconds.toString());
      } else {
        if(playType.value == 0){
          if(parser.getPlan() == 'basic'){
            if(StaticValue.rewardPoint > 0){
              playNext();
            }
            else{
              resetTimer();
              Future.delayed(Duration(seconds: 3), (){
                playFrequency();
                startTime();
                isPlaying.value = true;
              });
            }
          }else{
            playNext();
          }

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
      amplitude.value = (amplitude.value + 2.0).clamp(30.0, 70.0);
    }
  }

  //Decrease Duty Cycle
  void onDecreaseAmplitude() {
    if (amplitude.value > minAmplitude) {
      amplitude.value = (amplitude.value - 2.0).clamp(30.0, 70.0);
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
    if(isButtonPressed.value == false){
      if (isPlaying.value == true) {
        timer?.cancel();
        // stopFrequency();
      }
      setMiniPlayerValue();
      InactivityManager.resetTimer();
      var context = Get.context as BuildContext;
      Navigator.of(context).pop(true);
    }else{
      // var context = Get.context as BuildContext;
      // Navigator.of(context).pop(false);
    }
  }

  //Used to update the theme (dark or light)
  void setTheme(int theme) {
    parser.saveTheme(theme);
    currentTheme.value = theme;
  }

  //This function is used to generate sound according to particular frequency value (Native Approach)
  Future<void> playFrequency() async {

    isPlaying.value = true;

    if(selectedList.value == "main"){
      changeProgramName();
    }else{
      programName.value = StaticValue.queueProgramNameList[playingIndex.value] != 'No Name' ?  StaticValue.queueProgramNameList[playingIndex.value] : "" ;
    }
    if(found.kIsWeb){
      //Commented because dart:js not working  only in web . You have to uncomment it if you have to run application in web
      // js.context.callMethod('generateAudio', [amplitude.value,frequencyValue.value,phaseControl.value,selectedOption.value]);
    }else{
      if(Platform.isAndroid){
        Map<String, dynamic> data = {
          'frequency': frequencyValue.value,
          'duty_cycle': dutyCycle.value,
          'amplitude': amplitude.value,
          'offset': offset.value,
          'phase': phaseControl.value,
          'wavetype':selectedOption.value
        };
        var channelName = const MethodChannel("nativeBridge");
        try {
          await channelName.invokeMethod<String>("playMusic", data);
        } catch (e) {
          print("Error getting string: $e");
        }
      }
    }
  }

  //Used to stop generated frequency sound
  Future<void> stopFrequency() async {
    if(isPlaying.value == true){
      isPlaying.value = false;

      if(found.kIsWeb){
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
        }
      }


    }
  }

  //This function is used to play next frequency in the list
  Future<void> playNext() async {

    if(!isButtonPressed.value){
      isButtonPressed.value = true;
      if(parser.getPlan() == "basic"){
        if(StaticValue.rewardPoint > 0){
          print("Reward Point ${StaticValue.rewardPoint}");
          StaticValue.rewardPoint = StaticValue.rewardPoint - 1;
          Utils.updateRewardPoints(StaticValue.rewardPoint,parser.getUserId());
        }
      }
      // frequencyValue.value = frequenciesList[playingIndex.value + 1]!;
      resetTimer();
      isPlaying.value == false;

      if(selectedList.value == "main"){
        if(playingIndex.value + 1 < frequenciesList.length){
          playingIndex.value = playingIndex.value + 1;
          frequencyValue.value = frequenciesList[playingIndex.value] as double;
        }
        else{
          frequencyValue.value = frequenciesList[0]!;
          playingIndex.value = 0;
        }
        changeProgramName();
      }
      else{
        if(playingIndex.value + 1 < StaticValue.queueFrequenciesList.length){
          playingIndex.value = playingIndex.value + 1;
          frequencyValue.value = StaticValue.queueFrequenciesList[playingIndex.value] as double;
        }else{
          selectedList.value = "main";
          frequencyValue.value = frequenciesList[0]!;
          playingIndex.value = 0;
        }
      }

      Future.delayed(Duration(seconds: 3), (){
        playFrequency();
        startTime();
        isPlaying.value = true;
        isButtonPressed.value = false;
      });
    }else{
      print("Hello I am disable");
    }
  }

  //This function is used to play previous frequency in the list
  void playPrevious() {
    if(!isButtonPressed.value){
      isButtonPressed.value = true;
      if(parser.getPlan() == "basic"){
        if(StaticValue.rewardPoint != 0){
          StaticValue.rewardPoint = StaticValue.rewardPoint - 1;
          Utils.updateRewardPoints(StaticValue.rewardPoint,parser.getUserId());
        }
      }

      // frequencyValue.value = frequenciesList[playingIndex.value + 1]!;
      resetTimer();
      isPlaying.value == false;


      if(selectedList.value == "main"){
        if (playingIndex.value - 1 >= 0) {
          playingIndex.value = playingIndex.value - 1;
          frequencyValue.value = frequenciesList[playingIndex.value] as double;
        } else {
          frequencyValue.value = frequenciesList[frequenciesList.length - 1]!;
          playingIndex.value = frequenciesList.length - 1;
        }
        changeProgramName();
      }else{
        if (playingIndex.value - 1 >= 0) {
          playingIndex.value = playingIndex.value - 1;
          frequencyValue.value = StaticValue.queueFrequenciesList[playingIndex.value] as double;
        } else {
          frequencyValue.value = StaticValue.queueFrequenciesList[StaticValue.queueFrequenciesList.length - 1]!;
          playingIndex.value = StaticValue.queueFrequenciesList.length - 1;
        }
      }



      Future.delayed(Duration(seconds: 3), (){
        playFrequency();
        startTime();
        isPlaying.value = true;
        isButtonPressed.value = false;
      });
    }

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
  }

  void changeProgramName(){
    final data = Get.arguments;
    if(screenName == "category"||screenName == "custom_program"){
      programName.value = data['name'];
    }else if(screenName == "playlist" || screenName == "download" ){
      programNameList = data['programName'];
      programName.value = programNameList[playingIndex.value] != 'No Name' ?  programNameList[playingIndex.value] : "";
    }else{
      programName.value = "";
    }

    StaticValue.frequencyValue.value = frequencyValue.value;
    StaticValue.frequencyName.value = programName.value;
  }

  void loadRewardedAd() {
    RewardedAd.load(
        adUnitId:Platform.isAndroid
            ? AppConstants.android_ad_id
            : AppConstants.ios_ad_id,
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            // print('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
          //  showToast('RewardedAd failed to load');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < 3) {
              loadRewardedAd();
            }
          },
        ));
  }

  void showRewardedAd() {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    Get.back();
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        // loadRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
          Utils.updateRewardPoints(5,parser.getUserId());
          StaticValue.rewardPoint = await Utils.getRewardPoints(parser.getUserId());
          print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
        });
    _rewardedAd = null;
  }

  void selectRadioButton(int? newValue) {
    if(isRadioSelected.value == false){
      isRadioSelected.value = true;
      selectedOption(newValue);
      resetTimer();
      Get.back();
      Future.delayed(const Duration(seconds: 2), ()
      {

        // playFrequency();
        // startTime();
        isRadioSelected.value = false;
      });
    }

  }

  void setMiniPlayerValue() {
    print("helloFrequencyValue===> "+frequencyValue.value.toString());

    StaticValue.miniPlayer.value = true;
    StaticValue.dutyCycle = dutyCycle.value;
    StaticValue.amplitude = amplitude.value;
    StaticValue.offset = offset.value;
    StaticValue.phaseControl = phaseControl.value;
    StaticValue.frequencyValue.value = frequencyValue.value;
    StaticValue.frequencyName.value = programName.value;
    StaticValue.isPlaying.value = isPlaying.value;
    StaticValue.totalTimeInSeconds = totalTimeInSeconds;
    StaticValue.currentTimeInSeconds = currentTimeInSeconds;
    StaticValue.waveType = selectedOption.value;


    // StaticValue.frequenciesList.clear();
    // StaticValue.programNameList.clear();
    StaticValue.frequenciesList = frequenciesList;
    StaticValue.programNameList = programNameList;

    StaticValue.playingIndex.value = playingIndex.value;
    StaticValue.screenName = screenName;
    StaticValue.selectedList = selectedList.value;

    if(isPlaying.value == true){
      StaticValue.startTime();
    }

  }
}



/*
//Fibonacci wave radio button
const SizedBox(height: 10),
ListTile(
title: Column(
mainAxisAlignment: MainAxisAlignment.start,
crossAxisAlignment: CrossAxisAlignment.start,
children: [
CommonTextWidget(
heading: AppString.golden_wave,
fontSize: Dimens.forteen,
color: ThemeProvider.blackColor,
fontFamily: 'light',
),
const SizedBox(height: 10),
SvgPicture.asset(AssetPath.triangular,
)
],
),
leading: Obx(
() => Radio<int>(
value: 9,
activeColor: ThemeProvider.primary,
groupValue: value.selectedOption.value,
onChanged: (int?newValue) {
value.selectRadioButton(newValue);
},
)),
),*/
