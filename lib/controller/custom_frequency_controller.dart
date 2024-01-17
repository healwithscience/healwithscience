import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:heal_with_science/model/CustomCategory.dart';
import '../backend/helper/app_router.dart';
import '../backend/parser/custom_frequency_parser.dart';
import '../util/all_constants.dart';
import '../util/extensions/static_values.dart';
import '../util/inactivity_manager.dart';
import '../util/utils.dart';

class CustomFrequencyController extends GetxController {
  final CustomFrequencyParser parser;

  TextEditingController nameController  = TextEditingController();
  TextEditingController frequencyController  = TextEditingController();
  TextEditingController newFrequencyController  = TextEditingController();
  final RxBool isLoading = true.obs;
  final ScrollController scrollController = ScrollController();

  final RxList<CustomCategory> customProgram = <CustomCategory>[].obs;
  List<CustomCategory> fetchedProgram = [];

  CustomFrequencyController({required this.parser});


  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;

  final AdRequest request = const AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  // Used to check internet connectivity
  Rx<ConnectivityResult> connectivityResult = Rx<ConnectivityResult>(ConnectivityResult.none);

  @override
  void onInit() {
    super.onInit();
    if(StaticValue.miniPlayer.value){
      InactivityManager.resetTimer();
    }


      fetchCustomProgram();
      if(parser.getPlan() == 'basic'){
        loadRewardedAd();
      }



  }

  // This is used to create new custom program
  Future<void> createCustomProgram() async {
    if (nameController.value.text.isEmpty || nameController.value.text.length < 4) {
      showToast("Please enter a valid program name.");
      return;
    } else if (frequencyController.value.text.isEmpty || frequencyController.value.text.length <= 1) {
      showToast("Please enter a frequency value");
      return;
    }

    try {
      final firestoreInstance = FirebaseFirestore.instance;
      var userId = parser.getUserId();

      // Use the program name as the document ID
      final userPlaylistRef = firestoreInstance
          .collection('program')
          .doc(userId)
          .collection('custom_program')
          .doc(nameController.value.text);

      // Check if the document already exists with the same name
      final documentSnapshot = await userPlaylistRef.get();
      if (documentSnapshot.exists) {
        showToast("A program with the same name already exists.");
        return;
      }

      String newValue = double.parse(frequencyController.value.text.toString()).toStringAsFixed(2);
      if(double.parse(newValue) > 20000){
        showToast("Frequency value can't be higher then 20000");
        return;
      }

      // Create an array of values
      List<String> frequencyList = [newValue];

      // Update the data in the Firestore document
      await userPlaylistRef.set({
        "name": nameController.value.text,
        "frequency": frequencyList,
      });

      Get.back();
      successToast('Playlist updated Successfully');
      nameController.clear();
      frequencyController.clear();
      fetchCustomProgram();
    } catch (e) {
      showToast('Error updating playlist: $e');
    }
  }

  //Function used to fetch custom playlist created by user
  Future<void> fetchCustomProgram() async {

    var userId = parser.getUserId();
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      const settings = Settings(persistenceEnabled: false);
      firestoreInstance.settings = settings;


      CollectionReference categoriesCollection = firestoreInstance
          .collection('program')
          .doc(userId)
          .collection('custom_program');

      QuerySnapshot querySnapshot = await categoriesCollection.get();

      fetchedProgram = querySnapshot.docs
          .map((doc) => CustomCategory.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      fetchedProgram.sort((a, b) => a.name.compareTo(b.name));

      customProgram.assignAll(fetchedProgram);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print('Error fetching categories: $e');
    }
  }

  //This function is used to add frequency in existed program
  Future<void> addToFrequencyArray(String programName) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      var userId = parser.getUserId();

      // Reference to the Firestore document
      final userPlaylistRef = firestoreInstance
          .collection('program')
          .doc(userId)
          .collection('custom_program')
          .doc(programName);


      // Retrieve the current data from the Firestore document
      final documentSnapshot = await userPlaylistRef.get();
      if (!documentSnapshot.exists) {
        showToast("Program not found.");
        return;
      }

      // Get the existing frequency array
      List<dynamic> frequencyList = documentSnapshot.data()?['frequency'] ?? [];

      String newValue = double.parse(newFrequencyController.value.text.toString()).toStringAsFixed(2);

      if(double.parse(newValue) > 20000){
        showToast("Frequency value can't be higher then 20000");
        return;
      }else if(frequencyList.contains(newValue)){
        showToast("Value already exist");
        return;
      }

      // Add the new value to the array
      frequencyList.add(newValue);

      // Update the Firestore document with the modified array
      await userPlaylistRef.update({
        "frequency": frequencyList,
      });
      newFrequencyController.clear();
      Get.back();
      successToast('Frequency added successfully');
      fetchCustomProgram();
    } catch (e) {
      showToast('Error adding value to the "frequency" array: $e');
    }
  }


  //This function is used to remove program
  Future<void> removeProgram(String programName)  async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      var userId = parser.getUserId();

      // Reference to the Firestore document you want to remove
      final userPlaylistRef = firestoreInstance
          .collection('program')
          .doc(userId)
          .collection('custom_program')
          .doc(programName);

      // Check if the document exists before attempting to delete it xsdfsfsf
      final documentSnapshot = await userPlaylistRef.get();
      if (documentSnapshot.exists) {
        // Document exists, delete it
        await userPlaylistRef.delete();
        successToast('Program removed successfully');
        fetchCustomProgram();
      } else {
        // Document does not exist
        showToast('Program not found.');
      }
    } catch (e) {
      showToast('Error removing program: $e');
    }
  }

  void goToFeatures(List<String> frequency , String name) {

    print("HelloFrequency==>"+frequency.toString());
    List<double> frequencyList = frequency.map((str) => double.parse(str)).toList();

    Get.toNamed(AppRouter.getFeaturesScreen(), arguments: {
      'frequency':frequencyList[0],
      'frequenciesList':frequencyList,
      'index':0,
      'name': name,// Pass the data you want
      'screenName': 'custom_program'// Pass the data you want
    });
  }



  void onBackRoutes() {
    if(StaticValue.miniPlayer.value){
      InactivityManager.resetTimer();
    }
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
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
        loadRewardedAd();
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

  //This function is used to load ad
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
           // showToast('RewardedAd failed to load');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < 3) {
              loadRewardedAd();
            }
          },
        ));
  }
}
