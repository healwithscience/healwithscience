
import '../api/api.dart';
import '../helper/shared_pref.dart';

class CustomFrequencyParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  CustomFrequencyParser({required this.sharedPreferencesManager, required this.apiService});

  String getUserId(){
    return sharedPreferencesManager.getString('uid').toString();
  }


  String getPlan(){
    return sharedPreferencesManager.getString('plan').toString();
  }

}
