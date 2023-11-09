import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:heal_with_science/backend/helper/shared_pref.dart';
import 'package:heal_with_science/backend/parser/category_parser.dart';
import 'package:heal_with_science/backend/parser/create_playlist_parser.dart';
import 'package:heal_with_science/backend/parser/custom_frequency_parser.dart';
import 'package:heal_with_science/backend/parser/download_parser.dart';
import 'package:heal_with_science/backend/parser/features_parser.dart';
import 'package:heal_with_science/backend/parser/frequency_parser.dart';
import 'package:heal_with_science/backend/parser/playlist_parser.dart';
import 'package:heal_with_science/backend/parser/profile_parser.dart';
import 'package:heal_with_science/backend/parser/reward_parser.dart';
import 'package:heal_with_science/backend/parser/subsription_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../util/environment.dart';
import '../api/api.dart';
import '../parser/add_payment_parser.dart';
import '../parser/create_password_parser.dart';
import '../parser/dashboard_parser.dart';
import '../parser/forgot_password_parser.dart';
import '../parser/heart_parser.dart';
import '../parser/login_parser.dart';
import '../parser/onboard_parser.dart';
import '../parser/otp_verification_parser.dart';
import '../parser/password_success_parser.dart';
import '../parser/register_parser.dart';
import '../parser/splash_parser.dart';

class MainBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    final sharedPref = await SharedPreferences.getInstance();
    Get.put(
      SharedPreferencesManager(sharedPreferences: sharedPref),
      permanent: true,
    );

    Get.lazyPut(() => ApiService(appBaseUrl: Environments.apiBaseURL));

    // Parser LazyLoad
    Get.lazyPut(() => RigiterParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => OnBoardParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => LoginParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => SplashParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => SplashParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => AddPaymentParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => DashboardParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => ForgotPasswordParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => OtpVerificationParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => CreatePasswordParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => PasswordSuccessParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => CategoryParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => FrequencyParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => FeaturesParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => ProfileParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => CreatePlaylistParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => PlaylistParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => DownloadParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => HeartParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => CustomFrequencyParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => RewardParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => SubscriptionParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);
  }
}
