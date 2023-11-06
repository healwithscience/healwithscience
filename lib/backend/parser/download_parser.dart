import 'dart:convert';

import '../../model/Category.dart';
import '../api/api.dart';
import '../helper/shared_pref.dart';

class DownloadParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  DownloadParser({required this.sharedPreferencesManager, required this.apiService});


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
    myList.forEach((obj) {
      print("Name: ${obj.name}, Age: ${obj.frequency}");
    });

    return myList;
  }
}
