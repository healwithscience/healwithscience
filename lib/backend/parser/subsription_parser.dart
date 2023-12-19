
import '../api/api.dart';
import '../helper/shared_pref.dart';

class SubscriptionParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  SubscriptionParser({required this.sharedPreferencesManager, required this.apiService});

  void setPlan(String type){
    sharedPreferencesManager.putString('plan',type);
  }

  String getPlan(){
    return sharedPreferencesManager.getString('plan').toString();
  }

}
