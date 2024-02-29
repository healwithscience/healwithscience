import 'environment.dart';

class AppConstants {
  static const String appName = Environments.appName;
  static const String companyName = Environments.companyName;

  static const String login_api = 'api/auth/send-otp';
  static const String verify_api = 'api/auth/login-verifyotp';
  static const String signup_api = 'api/auth/register';

  //Test Ad Unit Id
  static const String android_ad_id = 'ca-app-pub-3940256099942544/5224354917';
  static const String ios_ad_id = 'ca-app-pub-3940256099942544/1712485313';


  // Productin Ad Unit Id
/*  static const String android_ad_id = 'ca-app-pub-3940256099942544/5224354917';
  static const String ios_ad_id = 'ca-app-pub-5659251749892291/3553161185';*/
}
