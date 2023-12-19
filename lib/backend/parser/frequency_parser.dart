import 'dart:convert';
import 'package:heal_with_science/model/Category.dart';
import 'package:heal_with_science/util/all_constants.dart';

import '../api/api.dart';
import '../helper/shared_pref.dart';

class FrequencyParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  FrequencyParser({required this.sharedPreferencesManager, required this.apiService});

  String getUserId(){
    return sharedPreferencesManager.getString('uid').toString();
  }


  Future<void> updateList( String name,String frequency) async {
    // Retrieve the existing list from SharedPreferences
    final jsonList = sharedPreferencesManager.getString('downloadList');

    List<Category> myList = [];

    if (jsonList != null) {
      // Parse the JSON string back into a list of maps
      final List<Map<String, dynamic>> mapList =
      json.decode(jsonList).cast<Map<String, dynamic>>();

      // Convert the list of maps to a list of MyObject instances
      myList = mapList.map((map) => Category.fromMap(map)).toList();
    }

    // Create a new MyObject instance
    final newObj = Category(name: name,frequency: frequency);
    final isDuplicate = myList.any((obj) =>
    obj.name == newObj.name && obj.frequency == newObj.frequency);

    if (!isDuplicate) {
      // Add the new object to the list if it's not a duplicate
      myList.add(newObj);

      // Serialize the modified list back to a JSON string
      final updatedJsonList =
      json.encode(myList.map((obj) => obj.toMap()).toList());

      // Update the stored string in SharedPreferences
      await sharedPreferencesManager.putString('downloadList', updatedJsonList);
    }else{
      showToast("Duplicate Value");
    }

  }

  Future<List<Category>?> fetchList() async {
    // Retrieve the JSON string from SharedPreferences
    final jsonList = sharedPreferencesManager.getString('downloadList');

    if (jsonList == null) {
      return null; // List doesn't exist in SharedPreferences
    }

    // Parse the JSON string back into a list of maps
    final List<Map<String, dynamic>> mapList =
    json.decode(jsonList).cast<Map<String, dynamic>>();

    // Convert the list of maps to a list of Category instances
    final myList = mapList.map((map) => Category.fromMap(map)).toList();

    return myList;
  }

  // Future<void> updateList(String newValue) async {
  //
  //   // Retrieve the existing list from SharedPreferences
  //   final jsonList = sharedPreferencesManager.getString('downloadList');
  //
  //   List<String> myList = [];
  //
  //   if (jsonList != null) {
  //     // Parse the JSON string back into a list
  //     myList = jsonList.split(','); // Split using the same delimiter as above
  //   }
  //
  //   // Add the new value to the list
  //   if (!myList.contains(newValue)) {
  //     myList.add(newValue);
  //   }
  //
  //   // Serialize the modified list back to a string
  //   final updatedJsonList = myList.join(',');
  //   // Update the stored string in SharedPreferences
  //   await sharedPreferencesManager.putString('downloadList',updatedJsonList);
  //
  // }


  //  Future<List<String>> getDownloadList() async {
  //
  //   // Retrieve the existing list from SharedPreferences
  //   final jsonList = sharedPreferencesManager.getString('downloadList');
  //
  //   List<String> myList = [];
  //   if(jsonList != null){
  //     myList = jsonList.split(',');
  //   }
  //
  //   return myList;
  // }

  String getPlan(){
    return sharedPreferencesManager.getString('plan').toString();
  }
}
