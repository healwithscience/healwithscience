import '../api/api.dart';
import '../helper/shared_pref.dart';

class CategoryParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  CategoryParser({required this.sharedPreferencesManager, required this.apiService});

  void logout() {
    sharedPreferencesManager.clearAll();
  }
}
