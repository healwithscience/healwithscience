import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:heal_with_science/backend/parser/subsription_parser.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../util/all_constants.dart';
import '../util/utils.dart';

class SubscriptionController extends GetxController {
  final SubscriptionParser parser;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  SubscriptionController({required this.parser});

  RxString currentPlan = "".obs;

  bool _subscriptionSetUp = false;

  @override
  void onInit() {
    super.onInit();

    currentPlan.value = parser.getPlan();

    // getSubScriptionDetail();
    saveSubscriptionzStatus();

    // initStoreInfo();
  }


  Future<void> saveSubscriptionzStatus() async {
    print("HelloHere==>");
    final firestoreInstance = FirebaseFirestore.instance;

    // Create a reference to the document for the specified user
    final subscriptionType = firestoreInstance.collection('subscription').doc(parser.getEmail());

    // Check if the document already exists
    final docSnapshot = await subscriptionType.get();

    if (!docSnapshot.exists) {
      // The document doesn't exist, so you can create a new one
      await subscriptionType.set({
        "plan_type": "basic",
      });
    }else{

      final planType = docSnapshot.data()?['plan_type'];
      parser.setPlan(planType);
      currentPlan.value = planType;
      print('Plan Type: $planType');
    }
  }



  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {

    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {

      if (purchaseDetails.status == PurchaseStatus.pending) {

      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
        } else if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored) {
          print("HelloHereSubscriptionScreen==>" + purchaseDetails.productID);
          if (purchaseDetails.productID == "intermediate_plan") {
            if (parser.getPlan() != 'advance') {
              parser.setPlan("intermediate");
              currentPlan.value = 'intermediate';
            }
          }
          if (purchaseDetails.productID == "advanced_plan") {
            parser.setPlan("advance");
            currentPlan.value = 'advance';
          }
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  void onBackRoutes() {
    try{
      _subscription.cancel();
    }catch(e){
      print("Error $e");
    }

    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  Future<void> initStoreInfo() async {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (available) {
      // const Set<String> _kIds = <String>{'product1', 'product2'};
      const Set<String> _kIds = <String>{'intermediate_plan', 'advanced_plan'};
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

  Future<void> purchaseProduct(String productId) async {
    try {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: await getProductDetails(productId),
        // Set to false for production
      );

      // Initiating the purchase process
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      if (!_subscriptionSetUp) {
        getSubScriptionDetail();
        _subscriptionSetUp = true;
      }


    } catch (error) {
      // Handle error
      print("Error during purchase: $error");
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


  String decodeEmail(String encodedData) {
    // Replace this with the actual decoding/decrypting logic
    // For illustration, we'll use base64 decoding as an example
    List<int> bytes = base64.decode(encodedData);
    String decodedEmail = utf8.decode(bytes);
    return decodedEmail;
  }

  void getSubScriptionDetail() {
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      print("Error in purchaseUpdated stream: $error");
    });
    _inAppPurchase.restorePurchases();
  }

}
