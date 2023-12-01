import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:heal_with_science/backend/parser/category_parser.dart';
import 'package:heal_with_science/backend/parser/playlist_parser.dart';
import '../backend/helper/app_router.dart';
import '../model/Category.dart';
import '../util/all_constants.dart';
import '../util/extensions/static_values.dart';
import '../util/inactivity_manager.dart';
import '../util/utils.dart';

class PlaylistController extends GetxController {
  final PlaylistParser parser;
  RxList playlistNames = <String>[].obs;
  RxList filteredPlaylist = <String>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isFocus = false.obs;
  final TextEditingController searchController = TextEditingController();

  List<double?> frequencyList = <double?>[];
  List<String> programName = <String>[];

  PlaylistController({required this.parser});

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
    if(connectivityResult.value == ConnectivityResult.wifi || connectivityResult.value == ConnectivityResult.mobile) {
      fetchUserPlaylists();
      loadRewardedAd();
      StaticValue.rewardPoint = await Utils.getRewardPoints(parser.getUserId());
    }else{
      isLoading.value = false;
      showToast("No Internet Connection");
    }

  }

  //Function used to fetch custom playlist created by user
  Future<void> fetchUserPlaylists() async {
    playlistNames.clear();
    filteredPlaylist.clear();
    final firestoreInstance = FirebaseFirestore.instance;
    const settings = Settings(persistenceEnabled: false);
    firestoreInstance.settings = settings;

    var userId = parser.getUserId();

    try {
      final playlistsCollection = firestoreInstance.collection('users').doc(userId).collection('playlists');
      final querySnapshot = await playlistsCollection.get();

      querySnapshot.docs.forEach((doc) {
        playlistNames.add(doc.id);
      });
      playlistNames.removeWhere((element) => element == null);
      // Sort the frequencies list
      playlistNames.sort();
      filteredPlaylist.addAll(playlistNames);
      isLoading.value = false;

    } catch (e) {
      isLoading.value = false;
      print('Error fetching user playlists: $e');
      return; // Handle the error as per your requirements
    }
  }

  //Function used to fetch list of frequency in a particular playlist
  Future<void> fetchFrequencyArray(String playlistName) async {
    frequencyList.clear();
    programName.clear();
    final firestoreInstance = FirebaseFirestore.instance;
    var userId = parser.getUserId();

    try {
      final playlistDoc = await firestoreInstance
          .collection('users')
          .doc(userId)
          .collection('playlists')
          .doc(playlistName)
          .get();

      if (playlistDoc.exists) {
        StaticValue.resetTimer();
        // Assuming the frequency array is stored as a field named 'frequency' within the playlist document.
        List<Map<String, dynamic>> playlistObjects = List.from(playlistDoc.data()?['playlist']);
        for (var playlistObject in playlistObjects) {
          String name = playlistObject['name'];
          String frequency = playlistObject['frequency'];
          frequencyList.add(double.parse(frequency));
          programName.add(name);
        }

        print("HelloList"+frequencyList[0].toString());
        print("HelloList"+programName.length.toString());

        Get.toNamed(AppRouter.getFeaturesScreen(), arguments: {
          'frequency':frequencyList[0],
          'frequenciesList':frequencyList,
          'index':0,
          'screenName':'playlist',
          'programName':programName// Pass the data you want
        });
      }
    } catch (e) {
      print('Error fetching frequency array for $playlistName: $e');
      // Handle the error as per your requirements.
    }
  }

 //Function used to filter playlist (local search)
  void filter(String searchText) {
    filteredPlaylist.clear(); // Clear the previous filtered list

    if (searchText.isEmpty) {
      // If the search text is empty, show all playlistNames
      filteredPlaylist.addAll(playlistNames);
    } else {
      // Filter playlistNames based on the search text
      for (String playlistName in playlistNames) {
        if (playlistName.toLowerCase().contains(searchText.toLowerCase())) {
          filteredPlaylist.add(playlistName);
        }
      }
    }
  }

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
            showToast('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < 3) {
              loadRewardedAd();
            }
          },
        ));
  }

  //This function is used to display ad
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

}

