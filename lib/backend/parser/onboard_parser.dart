
import '../api/api.dart';
import '../helper/shared_pref.dart';

class OnBoardParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  OnBoardParser({required this.sharedPreferencesManager, required this.apiService});

  void saveWelcome() {
    sharedPreferencesManager.putBool('welcome', true);
  }
}
