import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:heal_with_science/backend/binding/category_binding.dart';
import 'package:heal_with_science/backend/binding/create_playlist_binding.dart';
import 'package:heal_with_science/backend/binding/custom_frequency_binding.dart';
import 'package:heal_with_science/backend/binding/download_binding.dart';
import 'package:heal_with_science/backend/binding/features_binding.dart';
import 'package:heal_with_science/backend/binding/heart_binding.dart';
import 'package:heal_with_science/backend/binding/playlist_binding.dart';
import 'package:heal_with_science/view/category_screen.dart';
import 'package:heal_with_science/view/create_playlist_screen.dart';
import 'package:heal_with_science/view/custom_frequency_screen.dart';
import 'package:heal_with_science/view/download_screen.dart';
import 'package:heal_with_science/view/features_screen.dart';
import 'package:heal_with_science/view/frequency_screen.dart';
import 'package:heal_with_science/view/heart_rate_screen.dart';
import 'package:heal_with_science/view/playlist_screen.dart';
import '../../view/add_payment_screen.dart';
import '../../view/authentication_typescreen.dart';
import '../../view/create_password_screen.dart';
import '../../view/dashboard_screen.dart';
import '../../view/forgot_password_screen.dart';
import '../../view/login_view.dart';
import '../../view/onboardingscreens.dart';
import '../../view/otp_verification_screen.dart';
import '../../view/password_success_screen.dart';
import '../../view/profile_screen.dart';
import '../../view/register_screen.dart';
import '../../view/splash_screen.dart';
import '../binding/add_paymentinfo_binding.dart';
import '../binding/authentication_type_binding.dart';
import '../binding/create_password_binding.dart';
import '../binding/dashboard_binding.dart';
import '../binding/forgot_binding.dart';
import '../binding/frequency_binding.dart';
import '../binding/login_binding.dart';
import '../binding/onboard_binding.dart';
import '../binding/otp_verification_binding.dart';
import '../binding/password_success_binding.dart';
import '../binding/profile_binding.dart';
import '../binding/register_binding.dart';
import '../binding/splash_binding.dart';

class AppRouter {

  static const String onboardingScreen = '/onboardingscreens';
  static const String phoneVerification = '/phone_verificationscreen';
  static const String authenticationTypeScreen = '/authentication_typescreen';
  static const String addPaymentScreen = '/add_payment_screen';

  static const String splash = '/splash';
  static const String register = '/register';
  static const String login = '/login_view';
  static const String dashboardScreen = '/dashboard_screen';
  static const String forgotPasswordScreen = '/forgot_password_screen';
  static const String otpVerificationScreen = '/otp_verification_screen';
  static const String createPasswordScreen = '/create_password_screen';
  static const String passwordSuccessScreen = '/password_success_screen';
  static const String categoryScreen = '/category_screen';
  static const String frequencyScreen = '/frequency_screen';
  static const String featuresScreen = '/features_screen';
  static const String profileScreen = '/profile_screen';
  static const String createPlaylistScreen = '/create_playlist_screen';
  static const String playlistScreen = '/playlist_screen';
  static const String downloadScreen = '/download_screen';
  static const String heartScreen = '/heart_screen';
  static const String customFrequencyScreen = '/custom_frequency_screen';


  static String onBoardingRoute() => onboardingScreen;
  static String phoneVerificationRoute() => phoneVerification;
  static String authenticationTypeRoute() => authenticationTypeScreen;
  static String addPaymentScreenRoute() => addPaymentScreen;

  static String getSplashRoute() => splash;
  static String getRegisterRoute() => register;
  static String getLoginRoute() => login;
  static String addDashboardScreenRoute() => dashboardScreen;
  static String getforgotPasswordScreen() => forgotPasswordScreen;
  static String getOtpVerificationScreen() => otpVerificationScreen;
  static String getCreatePasswordScreen() => createPasswordScreen;
  static String getPasswordSuccessScreen() => passwordSuccessScreen;
  static String getCategoryScreen() => categoryScreen;
  static String getFrequencyScreen() => frequencyScreen;
  static String getFeaturesScreen() => featuresScreen;
  static String getProfileScreen() => profileScreen;
  static String getcreatePlaylistScreen() => createPlaylistScreen;
  static String getPlaylistScreen() => playlistScreen;
  static String getDownloadScreen() => downloadScreen;
  static String getHeartScreen() => heartScreen;
  static String getCustomFrequencyScreen() => customFrequencyScreen;

  static List<GetPage> routes = [
    GetPage(name: onboardingScreen, page: () => OnBoardScreen(), binding: OnBoardBinding()),
    GetPage(name: authenticationTypeScreen, page: () => AuthenticationTypeScreen(), binding: AuthenticationTypeBinding()),
    GetPage(name: addPaymentScreen, page: () => AddPaymentScreen(), binding: AddPaymentBinding()),
    GetPage(name: splash, page: () => SplashScreen(), binding: SplashBinding()),
    GetPage(name: register, page: () => RegisterScreen(), binding: RegisterBinding()),
    GetPage(name: login, page: () => LoginScreen(), binding: LoginBinding()),
    GetPage(name: dashboardScreen, page: () => DashboardScreen(), binding: DashboardBinding()),
    GetPage(name: forgotPasswordScreen, page: () => ForgotPasswordScreen(), binding: ForgotPasswordBinding()),
    GetPage(name: otpVerificationScreen, page: () => OtpVerificationScreen(), binding: OtpVerificationBinding()),
    GetPage(name: createPasswordScreen, page: () => CreatePasswordScreen(), binding: CreatePasswordBinding()),
    GetPage(name: passwordSuccessScreen, page: () => PasswordSuccessScreen(), binding: PasswordSuccessBinding()),
    GetPage(name: categoryScreen, page: () => CategoryScreen(), binding: CategoryBinding()),
    GetPage(name: frequencyScreen, page: () => FrequencyScreen(), binding: FrequencyBinding()),
    GetPage(name: featuresScreen, page: () => FeaturesScreen(), binding: FeaturesBinding()),
    GetPage(name: profileScreen, page: () => ProfileScreen(), binding: ProfileBinding()),
    GetPage(name: createPlaylistScreen, page: () => CreatePlaylistScreen(), binding: CreatePlaylistBinding()),
    GetPage(name: playlistScreen, page: () => PlayListScreen(), binding: PlaylistBinding()),
    GetPage(name: downloadScreen, page: () => DownloadScreen(), binding: DownloadBinding()),
    GetPage(name: heartScreen, page: () => HeartRateScreen(), binding: HeartBinding()),
    GetPage(name: customFrequencyScreen, page: () => CustomFrequencyScreen(), binding: CustomFrequencyBinding()),
  ];
}
