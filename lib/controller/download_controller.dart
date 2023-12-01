import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:heal_with_science/backend/parser/category_parser.dart';
import 'package:heal_with_science/backend/parser/download_parser.dart';
import '../backend/helper/app_router.dart';
import '../model/Category.dart';
import '../util/all_constants.dart';
import '../util/extensions/static_values.dart';
import '../util/inactivity_manager.dart';

class DownloadController extends GetxController {
  final DownloadParser parser;
  DownloadController({required this.parser});

  final RxList<Category> categories = <Category>[].obs;
  final TextEditingController searchController = TextEditingController();

  List<double> frequencyList = [];
  List<String> programName = <String>[];

  List<Category>? downloadList = [];
  final RxBool isLoading = true.obs;
  // Track loading state
  final RxBool isFocus = false.obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      filterCategories(searchController.text); // Listen to text changes
    });
    getList();
    if(StaticValue.miniPlayer.value){
      InactivityManager.resetTimer();
    }
  }

  Future<void> getList() async {
    downloadList?.clear();

   downloadList = (await parser.fetchList());
    if (downloadList != null) {
      isLoading.value = false;
      categories.assignAll(downloadList as Iterable<Category>);
    }else{
      isLoading.value = false;
    }
  }



  void onBackRoutes() {
    if(StaticValue.miniPlayer.value){
      InactivityManager.resetTimer();
    }
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  void filterCategories(String query) {
    categories.assignAll(
      downloadList!.where((category) {
        return category.name.toLowerCase().contains(query.toLowerCase());
      }),
    );
  }

  void goToFeatures(String frequency, int index) {
    frequencyList.clear();
    programName.clear();
    for(Category category in categories){
      frequencyList.add(double.parse(category.frequency));
      programName.add(category.name);
    }

    print("helloSize===>${frequencyList.length} ${programName.length}");

    // frequencyList =  categories.map((category) => double.parse(category.frequency)).toList();
    // programName =  categories.map((category) => category.name).toList();
    Get.toNamed(
      AppRouter.getFeaturesScreen(),
      arguments: {
        'frequency': double.parse(frequency),
        'frequenciesList': frequencyList,
        'index': index,
        'programName':programName,
        'screenName': 'download'// Pass the data you want
      },
    );
  }
}

