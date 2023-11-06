
import '../api/api.dart';
import '../helper/shared_pref.dart';

class ProfileParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ProfileParser({required this.sharedPreferencesManager, required this.apiService});

  String? getUserName() {
    return sharedPreferencesManager.getString('name');
  }

  String? getUserEmail() {
    return sharedPreferencesManager.getString('email');
  }

  String? getUserImage() {
    return sharedPreferencesManager.getString('profile');
  }

  void saveUserImage(String url) {
     sharedPreferencesManager.putString('profile',url);
  }

  void logout() {
    sharedPreferencesManager.clearAll();
  }


}
