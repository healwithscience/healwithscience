import 'dart:convert';

import '../../model/Category.dart';
import '../../util/toast.dart';
import '../api/api.dart';
import '../helper/shared_pref.dart';

class  FeaturesParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  FeaturesParser({required this.sharedPreferencesManager, required this.apiService});



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


  void saveTheme(int theme) {
    sharedPreferencesManager.putInt('theme', theme);
  }

  String getUserId(){
    return sharedPreferencesManager.getString('uid').toString();
  }

  int getTheme(){
    var value =  sharedPreferencesManager.getInt("theme") ?? 1;
    return value;
  }

  String getPlan(){
    return sharedPreferencesManager.getString('plan').toString();
  }


}
