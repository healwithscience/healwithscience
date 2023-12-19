
import '../api/api.dart';
import '../helper/shared_pref.dart';

class DashboardParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  DashboardParser({required this.sharedPreferencesManager, required this.apiService});

  void logout() {
    sharedPreferencesManager.clearAll();
  }

  String getPlan(){
    return sharedPreferencesManager.getString('plan').toString();
  }

  void setPlan(String type){
     sharedPreferencesManager.putString('plan',type);
  }

  String getUserId(){
    return sharedPreferencesManager.getString('uid').toString();
  }

  void saveReferralUser(String referralId) {
    sharedPreferencesManager.putString('referralId', referralId);

  }
}
