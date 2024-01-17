import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:heal_with_science/backend/parser/playlist_parser.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../backend/helper/app_router.dart';
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

  RxBool completePackage1 = false.obs;
  RxBool completePackage2 = false.obs;

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  // Used to check internet connectivity
  Rx<ConnectivityResult> connectivityResult = Rx<ConnectivityResult>(ConnectivityResult.none);

  @override
  Future<void> onInit() async {
    super.onInit();
    connectivityResult.value = await Utils.checkInternetConnection();
    if (StaticValue.miniPlayer.value) {
      InactivityManager.resetTimer();
    }
    if (connectivityResult.value == ConnectivityResult.wifi || connectivityResult.value == ConnectivityResult.mobile) {
      getCompletePackageStatus();
      fetchUserPlaylists();
      loadRewardedAd();
      StaticValue.rewardPoint = await Utils.getRewardPoints(parser.getUserId());
    } else {
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
      final playlistDoc = await firestoreInstance.collection('users').doc(userId).collection('playlists').doc(playlistName).get();

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

        print("HelloList" + frequencyList[0].toString());
        print("HelloList" + programName.length.toString());

        Get.toNamed(AppRouter.getFeaturesScreen(), arguments: {
          'frequency': frequencyList[0],
          'frequenciesList': frequencyList,
          'index': 0,
          'screenName': 'playlist',
          'programName': programName // Pass the data you want
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

  // Function used to handle mini player status and back press
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
        adUnitId: Platform.isAndroid ? AppConstants.android_ad_id : AppConstants.ios_ad_id,
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

  //This function is used to display ad
  void showRewardedAd() {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    Get.back();
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) => print('ad onAdShowedFullScreenContent.'),
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
    _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
      Utils.updateRewardPoints(5, parser.getUserId());
      StaticValue.rewardPoint = await Utils.getRewardPoints(parser.getUserId());
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    });

    _rewardedAd = null;
  }

  //Function used to store status of purchase packages
  Future<void> savePurchasePackage(String packageType) async {
    var firestoreInstance = FirebaseFirestore.instance;

    String userId = parser.getUserId();
    // Create a reference to the document for the specified user
    final docReference = firestoreInstance.collection('paid_frequency').doc(userId);

    // Check if the document exists
    bool documentExists = (await docReference.get()).exists;

    if (!documentExists) {
      // If the document doesn't exist, create it with the initial list
      await docReference.set({
        packageType: true,
      });
      print('List created and items added to Firestore');
    } else {
      await docReference.update({
        packageType: true,
      });
    }
  }

  //Function used to get the status of purchase packages
  Future<void> getCompletePackageStatus() async {
    var firestoreInstance = FirebaseFirestore.instance;

    String userId = parser.getUserId();
    // Create a reference to the document for the specified user
    final docReference = firestoreInstance.collection('paid_frequency').doc(userId);

    // Check if the document exists
    bool documentExists = (await docReference.get()).exists;

    if (documentExists) {
      // If the document exists, fetch the list of purchased categories
      DocumentSnapshot documentSnapshot = await docReference.get();

      if (documentSnapshot.exists) {
        Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('complete_package1')) {
          completePackage1.value = data['complete_package1'];
        }
        if (data != null && data.containsKey('complete_package2')) {
          completePackage2.value = data['complete_package2'];
        }
      }
      // Get the entire data as a Map
    } else {
      print('Document does not exist in Firestore');
    }
  }

  //Function used to purchase product
  Future<void> purchaseProduct(String packageId) async {
    try {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: await getProductDetails(packageId),
      );

      // Initiating the purchase process
      await _inAppPurchase.buyConsumable(
        purchaseParam: purchaseParam,
        autoConsume: true, // Automatically consume the purchase after buying
      );

      // Do additional processing if needed
      _subscription = _inAppPurchase.purchaseStream.listen((List<PurchaseDetails> purchaseDetailsList) {
        _handlePurchaseUpdates(purchaseDetailsList, packageId);
        _subscription.cancel();
      });
    } catch (error) {
      // Handle error
      print("Error during purchase: $error");
    }
  }

  Future<ProductDetails> getProductDetails(String packageId) async {
    final ProductDetailsResponse response = await InAppPurchase.instance.queryProductDetails(<String>{packageId});

    if (response.notFoundIDs.isNotEmpty) {
      // Handle not found IDs
      showToast("Product not found");
    }

    return response.productDetails.first;
  }

  // Function used to handle the status of purchase product(pending, complete , error)
  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList, String packageType) {
    print("Purchase Length   " + purchaseDetailsList.length.toString());
    for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        // Purchase was successful
        print("Purchase successful");
        savePurchasePackage(packageType);
        if (packageType == 'complete_package1') {completePackage1.value = true;} else {completePackage2.value = true;}
        _subscription.cancel();
      } else if (purchaseDetails.status == PurchaseStatus.pending) {
        // Purchase is pending
        print("Purchase pending");
        _subscription.cancel();
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        // Purchase failed
        print("Purchase failed: ${purchaseDetails.error}");
        _subscription.cancel();
      }
    }
  }
}
