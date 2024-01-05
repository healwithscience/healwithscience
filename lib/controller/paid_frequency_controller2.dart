import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:heal_with_science/util/extensions/static_values.dart';
import 'package:heal_with_science/util/inactivity_manager.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../backend/helper/app_router.dart';
import '../backend/parser/paid_frequency_parser2.dart';
import '../model/Category.dart';
import '../util/all_constants.dart';
import '../util/utils.dart';

class PaidFrequencyController2 extends GetxController {
  final PaidFrequencyParser2 parser;
  PaidFrequencyController2({required this.parser});

  final RxList<Category> categories = <Category>[].obs;
  List<Category> fetchedCategories = [];

  final RxList<double?> frequenciesList = <double?>[].obs;

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;


  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final RxBool isLoading = true.obs;
  // Track loading state
  final RxBool isFocus = false.obs;

  List<String> purchasedCategory = [];

  bool purchased = false;

  // Used to check internet connectivity
  Rx<ConnectivityResult> connectivityResult = Rx<ConnectivityResult>(ConnectivityResult.none);

  @override
  Future<void> onInit() async {
    super.onInit();

    final data = Get.arguments;
    purchased = data['purchased'];

    connectivityResult.value = await Utils.checkInternetConnection();
    if(StaticValue.miniPlayer.value){
      InactivityManager.resetTimer();
    }

    if(connectivityResult.value == ConnectivityResult.wifi || connectivityResult.value == ConnectivityResult.mobile) {
      getPurchasedCategoryList();
      fetchPaidCategories();
      // initStoreInfo();
    }else{
      isLoading.value = false;
      showToast("No Internet Connection");
    }

    searchController.addListener(() {
      filterCategories(searchController.text); // Listen to text changes
    });
  }


  //Function use to filter list (local search)
  void filterCategories(String query) {
    categories.assignAll(
      fetchedCategories.where((category) {
        return category.name.toLowerCase().contains(query.toLowerCase());
      }),
    );
  }

  //Fetch Paid Category from firebase
  Future<void> fetchPaidCategories() async {
    fetchedCategories.clear();
    try {
      final firestoreInstance = FirebaseFirestore.instance;

      CollectionReference categoriesCollection = firestoreInstance.collection('biophotonic2');

      QuerySnapshot querySnapshot = await categoriesCollection.get();

      fetchedCategories = querySnapshot.docs
          .map((doc) => Category.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      fetchedCategories.sort((a, b) => a.name.compareTo(b.name));
      categories.assignAll(fetchedCategories);
      isLoading.value = false;

      // No need to call update() since RxList automatically triggers UI updates.
    } catch (e) {
      isLoading.value = false;
      print('Error fetching categories: $e');
    }
  }

  //Function used to next screen;
  void goToFeatures(String frequency , String name) {

    StaticValue.resetTimer();
    List<String> numberStringList = frequency.split('/');
    List<double> frequencyList = numberStringList
        .map((str) => double.tryParse(str)) // Use tryParse to handle invalid values
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



  Future<void> initStoreInfo() async {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (available) {
      // const Set<String> _kIds = <String>{'product1', 'product2'};
      const Set<String> _kIds = <String>{'paid_category'};
      final ProductDetailsResponse response = await InAppPurchase.instance.queryProductDetails(_kIds);
      if (response.notFoundIDs.isNotEmpty) {
        // showToast("I am here ${response.error}");
      }
      List<ProductDetails> products = response.productDetails;
      for (ProductDetails product in products) {
        print("Product Name: " + product.id);
      }
    }
  }


  Future<void> purchaseProduct(String productId, String categoryName) async {
    try {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: await getProductDetails(productId),
      );

      // Initiating the purchase process
      await _inAppPurchase.buyConsumable(
        purchaseParam: purchaseParam,
        autoConsume: true, // Automatically consume the purchase after buying
      );

      // Do additional processing if needed
      _subscription = _inAppPurchase.purchaseStream.listen((List<PurchaseDetails> purchaseDetailsList) {
        _handlePurchaseUpdates(purchaseDetailsList,categoryName);
      });

    } catch (error) {
      // Handle error
      print("Error during purchase: $error");
    }
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList, String categoryName) {
    for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        // Purchase was successful
        print("Purchase successful");

        _subscription.cancel();
        savePurchaseFrequency(categoryName);
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

  Future<ProductDetails> getProductDetails(String productId) async {
    final ProductDetailsResponse response = await InAppPurchase.instance.queryProductDetails(<String>{productId});

    if (response.notFoundIDs.isNotEmpty) {
      // Handle not found IDs
      showToast("Product not found");
    }

    return response.productDetails.first;
  }


  //Function used to navigate back to previous screen
  void onBackRoutes() {
    if(StaticValue.miniPlayer.value){
      InactivityManager.resetTimer();
    }
    try{
      _subscription.cancel();
    }catch(e){
      print("Error $e");
    }
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  //Function Used to save category after purchase
  Future<void> savePurchaseFrequency(String categoryName) async {
    var firestoreInstance = FirebaseFirestore.instance;

    String userId = parser.getUserId();
    // Create a reference to the document for the specified user
    final docReference = firestoreInstance.collection('paid_frequency').doc(userId);

    List<String> purchasedFrequency = [categoryName];

    // Check if the document exists
    bool documentExists = (await docReference.get()).exists;

    if (!documentExists) {
      // If the document doesn't exist, create it with the initial list
      await docReference.set({'purchasedFrequency2': purchasedFrequency});
      getPurchasedCategoryList();
      print('List created and items added to Firestore');
    } else {
      // If the document exists, add individual items to the existing list
      for (String item in purchasedFrequency) {
        docReference.update({'purchasedFrequency2': FieldValue.arrayUnion([item]),
        }).then((_) {
          print('$item added to Firestore');
        }).catchError((error) {
          print('Error adding $item to Firestore: $error');
        });
      }
      getPurchasedCategoryList();
    }
  }


  Future<void> getPurchasedCategoryList() async {
    var firestoreInstance = FirebaseFirestore.instance;

    String userId = parser.getUserId();
    // Create a reference to the document for the specified user
    final docReference = firestoreInstance.collection('paid_frequency').doc(userId);

    // Check if the document exists
    bool documentExists = (await docReference.get()).exists;

    if (documentExists) {
      purchasedCategory.clear();
      // If the document exists, fetch the list of purchased categories
      DocumentSnapshot documentSnapshot = await docReference.get();

      Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('purchasedFrequency2')) {
        purchasedCategory = List<String>.from(documentSnapshot['purchasedFrequency2']);
      }
      print('List retrieved from Firestore: $purchasedCategory');
    } else {
      print('Document does not exist in Firestore');
    }
  }

  //Function Used to check category status(Purchased or Not)
  bool checkPurchasedStatus(String categoryName)  {
    if(purchasedCategory.isNotEmpty){
      for (String s in purchasedCategory) {
        if(s.trim() == categoryName.trim()){
          return true;
        }
      }
    }
    return false;
  }

}

