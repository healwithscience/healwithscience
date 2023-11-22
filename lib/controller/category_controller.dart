import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:heal_with_science/backend/parser/category_parser.dart';
import 'package:heal_with_science/controller/features_controller.dart';
import 'package:heal_with_science/util/extensions/static_values.dart';
import '../backend/helper/app_router.dart';
import '../model/Category.dart';
import '../util/all_constants.dart';
import '../util/utils.dart';

class CategoryController extends GetxController {
  final CategoryParser parser;
  final RxList<Category> categories = <Category>[].obs;
  List<Category> fetchedCategories = [];
  final RxList<double?> frequenciesList = <double?>[].obs;

  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final RxBool isLoading = true.obs;
  // Track loading state
  final RxBool isFocus = false.obs;

  CategoryController({required this.parser});
  final alphabets = List.generate(26, (index) => String.fromCharCode(index + 65));

  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;

  RxBool visibility = false.obs;
  RxString alphabet = "A".obs;

  final AdRequest request = const AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );


  @override
  Future<void> onInit() async {
    super.onInit();
    fetchCategories();
    loadRewardedAd();
    StaticValue.rewardPoint = await Utils.getRewardPoints(parser.getUserId());

    // categories.assignAll(categories); // Initialize with all categories
    searchController.addListener(() {
      filterCategories(searchController.text); // Listen to text changes
    });
  }

  //Function use to fetch category list and their frequency from firebase
  Future<void> fetchCategories() async {
    fetchedCategories.clear();
    try {
      final firestoreInstance = FirebaseFirestore.instance;
     /* const settings = Settings(persistenceEnabled: false);
      firestoreInstance.settings = settings;
*/
    CollectionReference categoriesCollection = firestoreInstance.collection('categories');
      // CollectionReference categoriesCollection = firestoreInstance.collection('new_categories');

      QuerySnapshot querySnapshot = await categoriesCollection.get();

     fetchedCategories = querySnapshot.docs
          .map((doc) => Category.fromMap(doc.data() as Map<String, dynamic>))
          .toList();


      fetchedCategories.sort((a, b) => a.name.compareTo(b.name));
      print('Hello Here1 Length======>'+fetchedCategories.length.toString());

      categories.assignAll(fetchedCategories);
      isLoading.value = false;

      // No need to call update() since RxList automatically triggers UI updates.
    } catch (e) {
      isLoading.value = false;
      print('Error fetching categories: $e');
    }
  }

  //Function use to filter list (local search)
  void filterCategories(String query) {
    categories.assignAll(
      fetchedCategories.where((category) {
        return category.name.toLowerCase().contains(query.toLowerCase());
      }),
    );
  }

  //Function used to navigate back to previous screen
  void onBackRoutes() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  //Function used to split frequency string then convert it into list and then pass to next screen
  void goToFeatures(String frequency , String name) {

    List<String> numberStringList = frequency.split('/');
    List<double> frequencyList = numberStringList
        .map((str) => double.tryParse(str)) // Use tryParse to handle invalid values
        .where((value) => value != null && value <= 20000)
        .cast<double>()
        .toList();

    Get.toNamed(AppRouter.getFeaturesScreen(), arguments: {
      'frequency':frequencyList[0],
      'frequenciesList':frequencyList,
      'index':0,
      'name': name,// Pass the data you want
      'screenName': 'category'// Pass the data you want
    });
  }


  //Function used to scroll to specific position(Alphabetic Scroll View)
  void scrollToCategoryByAlphabet(String selectedAlphabet, double screenHeight) {
    int indexOfFirstMatchingCategory = categories.indexWhere(
          (category) => category.name.startsWith(selectedAlphabet),
    );

    if (indexOfFirstMatchingCategory != -1) {
      // Scroll to the first matching category
      scrollController.animateTo(
        indexOfFirstMatchingCategory * (screenHeight * 0.07),
        duration: Duration(seconds: 1),
        curve: Curves.ease,
      );
    }
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
            showToast('RewardedAd failed to load: $error');
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

