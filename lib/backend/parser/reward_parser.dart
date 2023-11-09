
import '../api/api.dart';
import '../helper/shared_pref.dart';

class RewardParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  RewardParser({required this.apiService, required this.sharedPreferencesManager});

  String getUserId(){
    return sharedPreferencesManager.getString('uid').toString();
  }
}
