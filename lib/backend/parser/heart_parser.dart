
import '../api/api.dart';
import '../helper/shared_pref.dart';

class HeartParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  HeartParser({required this.sharedPreferencesManager, required this.apiService});

  String getUserId(){
    return sharedPreferencesManager.getString('uid').toString();
  }
}
