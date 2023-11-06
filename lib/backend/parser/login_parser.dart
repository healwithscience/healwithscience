
import 'package:get/get_connect/http/src/response/response.dart';

import '../../util/constants.dart';
import '../api/api.dart';
import '../helper/shared_pref.dart';

class LoginParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  LoginParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> loginPhoneNumber(dynamic body) async {
    var response = await apiService.postPublic(AppConstants.login_api, body);
    return response;
  }

  void saveUser(String uid,String username, String email,String profile) {
    sharedPreferencesManager.putString('uid', uid);
    sharedPreferencesManager.putString('name', username);
    sharedPreferencesManager.putString('email', email);
    sharedPreferencesManager.putString('profile', profile);
  }


}
