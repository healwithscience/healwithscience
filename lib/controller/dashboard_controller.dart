import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:heal_with_science/backend/parser/dashboard_parser.dart';
import 'package:heal_with_science/model/ListItem.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../backend/helper/app_router.dart';
import '../model/Category.dart';
import '../util/all_constants.dart';
import '../util/utils.dart';

class DashboardController extends GetxController {
  final DashboardParser parser;

  DashboardController({required this.parser});

  // final countryCodeController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final countryCodeController = TextEditingController();

  var has8Char = false.obs;
  var hasLN = false.obs;

  final formKey = GlobalKey<FormState>();
  List<ListItem> listItem = [];

  get itemList => listItem;

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  RxString currentPlan = "".obs;
  bool _subscriptionSetUp = false;


  // List<String,String> itemList = ["Category", "Custom Playlist", "Frequencies","Hear Rate","Playlist"];

  @override
  void onInit() {
    super.onInit();

    saveSubscriptionStatus();


    listItem.add(ListItem(name: "Category", imagePath: AssetPath.category));
    listItem.add(ListItem(name: "Custom Frequency", imagePath: AssetPath.custom_playlist));
    listItem.add(ListItem(name: "Frequencies", imagePath: AssetPath.frequencies));
    listItem.add(ListItem(name: "Heart Rate", imagePath: AssetPath.heart_rate));
    listItem.add(ListItem(name: "Playlist", imagePath: AssetPath.playlist));

    rewardPoint();
    parser.saveReferralUser("");
    // getCollectionSize();
    // populateDB();
  }

  Future<void> logout() async {
    parser.logout();
    Get.offNamedUntil(AppRouter.getLoginRoute(), (route) => false);
  }

  void onBackRoutes() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  Future<void> rewardPoint() async {
    final firestoreInstance = FirebaseFirestore.instance;
    var userId = parser.getUserId();

    // Create a reference to the document for the specified user
    final userPoint = firestoreInstance.collection('reward').doc(userId);

    // Check if the document already exists
    final docSnapshot = await userPoint.get();

    if (!docSnapshot.exists) {
      // The document doesn't exist, so you can create a new one
      await userPoint.set({
        "points": "100",
      });
    }
  }

  Future<void> saveSubscriptionStatus() async {
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

  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {

    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
        } else if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored) {
          if(purchaseDetails.productID == "intermediate_plan"){
            if(parser.getPlan() != 'advance'){
              Utils.updateSubscription("intermediate",parser.getEmail());
              setSubscriptionType("intermediate");
            }
          }
          if(purchaseDetails.productID == "advanced_plan"){
            Utils.updateSubscription("advance",parser.getEmail());
            setSubscriptionType("advance");

          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
    currentPlan.value = parser.getPlan();

  }

  void setSubscriptionType(String type){
    parser.setPlan(type);
    currentPlan.value = type;
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


/*Future<void> populateDB() async {

    try {
      // Read the text file from the assets
      ByteData data = await rootBundle.load('assets/spooky_data.txt');
      List<int> bytes = data.buffer.asUint8List();
      String fileContent = String.fromCharCodes(bytes);

      // Split the file content into lines
      List<String> lines = fileContent.split('\n');

      List<Category> categories = [];
      categories.clear();

      try{
        for (String line in lines) {
          List<String> name = line.split(',');
          String data = line.split('"')[1];
          String newDAta = data.replaceAll(',','/');
          String stringWithoutLastChar = newDAta.substring(0, newDAta.length - 1);
          categories.add(Category(name: name[0], frequency: stringWithoutLastChar));

        }
      }catch (e){
        print("HelloError===>"+e.toString());
      }

      try {
        // Get a reference to the Firestore collection
        CollectionReference categoriesCollection =
        FirebaseFirestore.instance.collection('new_categories');

        // Loop through the list of Category objects and add them to Firestore
        for (Category category in categories) {
          print("Hello CategoryName===>${category.name}");
          await categoriesCollection.add(category.toMap());
        }

        print('Categories added to Firestore successfully');
      } catch (e) {
        print('Error adding categories to Firestore: $e');
      }
    } catch (e) {
      print('Error: $e');
    }
  }*/



/*  Future<void> populateDB() async {
    print("Hello I am here");
    try {
      // Read the text file from the assets
      ByteData data = await rootBundle.load('assets/List_EN_IS_Final.txt');
      List<int> bytes = data.buffer.asUint8List();
      String fileContent = String.fromCharCodes(bytes);

      // Split the file content into lines
      List<String> lines = fileContent.split('\n');

      List<Category> categories = [];
      List<String> arrayList2 = [];
      String sb = '';

      for (String line in lines) {
        List<String> split2 = line.split(';');

        if (split2.length == 6) {
          for (String str in split2[4].split('/')) {
            double d = 0.0;
            try {
              d = double.parse(str);
            } catch (e) {
              // Handle NumberFormatException if needed
            }
            if (d < 20000.0) {
              if (arrayList2.contains(str)) {
                for (int i = 0; i < arrayList2.length; i++) {
                  if (arrayList2[i] == str) {
                    if (sb.isEmpty) {
                      sb = '1,$i';
                    } else {
                      sb += '-1,$i';
                    }
                  }
                }
              } else {
                arrayList2.add(str);
                if (sb.isEmpty) {
                  sb = '1,${arrayList2.length - 1}';
                } else {
                  sb += '-1,${arrayList2.length - 1}';
                }
              }
            }
          }
          if (split2[0] != 'YES' && sb.isNotEmpty) {

            categories.add(Category(name: split2[0], frequency: split2[4]));
            // await database.rawInsert(
            //   "INSERT INTO Frequency_lists (name, list, description, name_is, description_is) VALUES (?, ?, ?, ?, ?);",
            //   [split2[0], sb, split2[1], split2[2], split2[3]],
            // );
            sb = '';
          }else{
          }
        } else {

          // print('${split2[0]}, length: ${split2.length}');
        }
      }



      try {
        // Get a reference to the Firestore collection
        CollectionReference categoriesCollection =
        FirebaseFirestore.instance.collection('categories');

        // Loop through the list of Category objects and add them to Firestore
        for (Category category in categories) {
          print('HelloCategoriesadd===>'+category.name.toString());
          await categoriesCollection.add(category.toMap());
        }

        print('Categories added to Firestore successfully');
      } catch (e) {
        print('Error adding categories to Firestore: $e');
      }

      int size = arrayList2.length;

      // for (int i = 0; i < size; i++) {
      //   // try {
      //   //     await categoriesCollection.add({'name': arrayList2[i].toString()});
      //   //
      //   //   print('Categories added to Firestore successfully');
      //   // } catch (e) {
      //   //   print('Error adding categories to Firestore: $e');
      //   // }
      //
      //   // print('Frequencies Are======================>$i  ${arrayList2[i].toString()}');
      //   // await database.rawInsert(
      //   //   "INSERT INTO Frequencies (column_name1, column_name2, column_name3, column_name4, column_name5) VALUES (?, ?, ?, ?, ?);",
      //   //   [i, arrayList2[i], 0, 100, 'false'],
      //   // );
      // }
    } catch (e) {
      print('Error: $e');
    }
  }*/
}
