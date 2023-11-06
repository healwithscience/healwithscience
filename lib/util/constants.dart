import 'environment.dart';

class AppConstants {
  static const String appName = Environments.appName;
  static const String companyName = Environments.companyName;

  static const String login_api = 'api/auth/send-otp';
  static const String verify_api = 'api/auth/login-verifyotp';
  static const String signup_api = 'api/auth/register';
}
