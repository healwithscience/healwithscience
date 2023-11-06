
import '../api/api.dart';
import '../helper/shared_pref.dart';

class SplashParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  SplashParser({required this.apiService, required this.sharedPreferencesManager});

  bool haveLoggedIn() {
    return sharedPreferencesManager.getString('uid') != '' &&
        sharedPreferencesManager.getString('uid') != null
        ? true
        : false;
  }

  bool isNewUser() {
    return sharedPreferencesManager.getBool('welcome');
  }

  String? token() {
    return sharedPreferencesManager.getString('token');
  }
}
