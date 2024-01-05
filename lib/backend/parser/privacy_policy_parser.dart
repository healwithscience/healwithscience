
import '../api/api.dart';
import '../helper/shared_pref.dart';

class PrivacyPolicyParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  PrivacyPolicyParser({required this.sharedPreferencesManager, required this.apiService});

}
