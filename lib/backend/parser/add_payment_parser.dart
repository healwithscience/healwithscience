
import 'package:get/get_connect/http/src/response/response.dart';

import '../../util/constants.dart';
import '../api/api.dart';
import '../helper/shared_pref.dart';

class AddPaymentParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  AddPaymentParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> addPaymentMethod(dynamic body) async {
    var response = await apiService.postPublic(AppConstants.login_api, body);
    return response;
  }
}
