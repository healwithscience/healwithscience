
import 'package:get/get_connect/http/src/response/response.dart';

import '../../util/constants.dart';
import '../api/api.dart';
import '../helper/shared_pref.dart';

class ForgotPasswordParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ForgotPasswordParser({required this.sharedPreferencesManager, required this.apiService});


}
