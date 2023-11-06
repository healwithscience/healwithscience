
import '../api/api.dart';
import '../helper/shared_pref.dart';

class DashboardParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  DashboardParser({required this.sharedPreferencesManager, required this.apiService});

  void logout() {
    sharedPreferencesManager.clearAll();
  }
}
