import '../api/api.dart';
import '../helper/shared_pref.dart';

class PlaylistParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  PlaylistParser({required this.sharedPreferencesManager, required this.apiService});

  String getUserId(){
    return sharedPreferencesManager.getString('uid').toString();
  }
}
