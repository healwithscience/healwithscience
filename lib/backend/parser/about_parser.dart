
import '../api/api.dart';
import '../helper/shared_pref.dart';

class AboutParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  AboutParser({required this.sharedPreferencesManager, required this.apiService});

}
