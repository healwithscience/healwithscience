import '../api/api.dart';
import '../helper/shared_pref.dart';

class CreatePlaylistParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  CreatePlaylistParser({required this.sharedPreferencesManager, required this.apiService});

  String getUserId(){
    return sharedPreferencesManager.getString('uid').toString();
  }

}
