
import '../api/api.dart';
import '../helper/shared_pref.dart';

class PasswordSuccessParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  PasswordSuccessParser({required this.apiService, required this.sharedPreferencesManager});

}
