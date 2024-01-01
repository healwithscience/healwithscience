import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:heal_with_science/backend/parser/frequency_parser.dart';
import '../backend/helper/app_router.dart';
import '../model/Category.dart';
import '../util/all_constants.dart';
import '../util/extensions/static_values.dart';
import '../util/inactivity_manager.dart';
import '../util/utils.dart';

class FrequencyController extends GetxController {
  final List<double?> frequencies = <double?>[];

  final FrequencyParser parser;
  RxList playlistNames = <String>[].obs;

  final TextEditingController searchController = TextEditingController();
  List<Category>? categoriesList = [];

  // Track loading state
  final RxBool isFocus = false.obs;

  FrequencyController({required this.parser});

  final RxList<double?> filteredfrequencies = <double?>[].obs;
  RxList<int> downloadButtonClickedList = <int>[].obs;

  final RxBool isLoading = true.obs;

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
  Future<void> onInit() async {
    super.onInit();
    connectivityResult.value = await Utils.checkInternetConnection();
    if (StaticValue.miniPlayer.value) {
      InactivityManager.resetTimer();
    }

    if(connectivityResult.value == ConnectivityResult.wifi || connectivityResult.value == ConnectivityResult.mobile){
      getSubscriptionStatus();
      fetchDownloadlist();
      fetchFrequencies();


      if(parser.getPlan() == "basic"){
        loadRewardedAd();
      }
      StaticValue.rewardPoint = await Utils.getRewardPoints(parser.getUserId());
    }else{
      isLoading.value = false;
      showToast("No Internet Connection");
    }
  }



  Future<void> getSubscriptionStatus() async {
    final firestoreInstance = FirebaseFirestore.instance;

    // Create a reference to the document for the specified user
    final subscriptionType = firestoreInstance.collection('subscription').doc(parser.getEmail());

    // Check if the document already exists
    final docSnapshot = await subscriptionType.get();

    if (!docSnapshot.exists) {
      parser.setPlan('basic');
    }else{
      final planType = docSnapshot.data()?['plan_type'];
      parser.setPlan(planType);
    }
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


  //Fetch Frequencies from firebase
  Future<void> fetchFrequencies() async {

    final firestore = FirebaseFirestore.instance;
   // const settings = Settings(persistenceEnabled: false);
   // firestore.settings = settings;
    firestore
        .collection('frequencies') // Replace with your collection name
       // .get(GetOptions(source: Source.cache))
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        // Loop through the documents and extract the "name" field
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          final data = doc.data()
              as Map<String, dynamic>?; // Cast to Map<String, dynamic>?
          if (data != null) {
            final name = data['name'] as String?;
            if (name != null) {
              final doubleValue = double.tryParse(name);
              frequencies.add(doubleValue);
              downloadButtonClickedList.value =  List.filled(frequencies.length, 1);
            }
          }
        }
        frequencies.removeWhere((element) => element == null);

        // Sort the frequencies list
        frequencies.sort();

        filteredfrequencies.addAll(frequencies);
        isLoading.value = false;
      } else {
        isLoading.value = false;
        print('No documents found in the collection.');
      }
    }).catchError((error) {
      isLoading.value = false;
      print('Error fetching data: $error');
    });
  }

  // Used to filter the frequency list(local search)
  void filterFrequencies(String searchText) {
    if (searchText.isEmpty) {
      // If the search text is empty, show all frequencies
      filteredfrequencies.assignAll(frequencies);
    } else {
      // Filter frequencies based on the search text
      final filtered = frequencies
          .where((frequency) =>
              frequency != null &&
              frequency.toString().contains(searchText.toLowerCase()))
          .toList();
      filteredfrequencies.assignAll(filtered);
    }
  }

  //Function used to fetch custom playlist created by user
  Future<void> fetchUserPlaylists() async {
    playlistNames.clear();
    final firestoreInstance = FirebaseFirestore.instance;
    var userId = parser.getUserId();

    try {
      final playlistsCollection = firestoreInstance
          .collection('users')
          .doc(userId)
          .collection('playlists');
      final querySnapshot = await playlistsCollection.get();

      querySnapshot.docs.forEach((doc) {
        playlistNames.add(doc.id);
      });
      print('Error fetching user playlists: $playlistNames');
    } catch (e) {
      print('Error fetching user playlists: $e');
      return; // Handle the error as per your requirements
    }
  }

  //Function used to add frequency value in particular playlist
  Future<void> updatePlaylist(String playlistName, dynamic valueToAdd) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      var userId = parser.getUserId();

      // Create a reference to the document for the specified playlist
      final userPlaylistRef = firestoreInstance
          .collection('users')
          .doc(userId)
          .collection('playlists')
          .doc(playlistName);

      // Update the data in the Firestore document
      await userPlaylistRef.update({
        "playlist": FieldValue.arrayUnion([
          {"name": "No Name", "frequency": valueToAdd.toString()}
        ]),
      });

      Get.back();
      successToast('Playlist updated Successfully');
    } catch (e) {
      showToast('Error updating playlist: $e');
    }
  }

  //Function used to navigate back to previous screen
  void onBackRoutes() {
    if (StaticValue.miniPlayer.value) {
      InactivityManager.resetTimer();
    }
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
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
            showToast('RewardedAd failed to load');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < 3) {
              loadRewardedAd();
            }
          },
        ));
  }

  // This function is used to play ad
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

  void goToNext( RxList<double?> filteredfrequencies, int index){
    StaticValue.resetTimer();
    Get.toNamed(
      AppRouter.getFeaturesScreen(),
      arguments: {
        'frequency': filteredfrequencies[index],
        'frequenciesList': filteredfrequencies,
        'index': index,
        'screenName': 'frequency'
        // Pass the data you want
      },
    );
  }


}
