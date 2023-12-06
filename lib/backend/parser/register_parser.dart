
import 'package:get/get_connect/http/src/response/response.dart';

import '../../util/constants.dart';
import '../api/api.dart';
import '../helper/shared_pref.dart';

class RigiterParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  RigiterParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> registerEmail(dynamic body) async {
    var response = await apiService.postPublic(AppConstants.signup_api, body);
    return response;
  }

  void saveUser(String uid, String username, String email) {
    sharedPreferencesManager.putString('uid', uid);
    sharedPreferencesManager.putString('name', username);
    sharedPreferencesManager.putString('email', email);
  }

  String getReferralUser() {
    String? referralUser = sharedPreferencesManager.getString('referralId');
    return referralUser.toString();

  }
}
