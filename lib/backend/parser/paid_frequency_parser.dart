import '../api/api.dart';
import '../helper/shared_pref.dart';

class PaidFrequencyParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  PaidFrequencyParser({required this.sharedPreferencesManager, required this.apiService});

  void logout() {
    sharedPreferencesManager.clearAll();
  }

  String getUserId(){
    return sharedPreferencesManager.getString('uid').toString();
  }

  String getPlan(){
    return sharedPreferencesManager.getString('plan').toString();
  }

}
