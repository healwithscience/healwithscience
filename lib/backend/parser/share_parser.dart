
import '../api/api.dart';
import '../helper/shared_pref.dart';

class ShareParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ShareParser({required this.apiService, required this.sharedPreferencesManager});

  String getUserId(){
    return sharedPreferencesManager.getString('uid').toString();
  }
}
