import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../backend/helper/app_router.dart';
import '../backend/parser/login_parser.dart';
import '../util/toast.dart';
import '../util/utils.dart';

class LoginController extends GetxController {
  final LoginParser parser;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginController({required this.parser});

  var _isObscured = true.obs; // Use RxBool for reactivity
  bool get isObscured => _isObscured.value;

  @override
  void onInit() {
    super.onInit();
    handleDynamicLinks();
  }

  void togglePasswordVisibility() {
    _isObscured.value = !isObscured;
  }

  // Function to handle Apple login
  Future<void> signInWithApple() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      Utils.showProgressbar();
      final AuthCredential authCredential = OAuthProvider('apple.com').credential(
        accessToken: credential.authorizationCode,
        idToken: credential.identityToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(authCredential);

      // Check if the user is signed in
      final User? user = userCredential.user;
      Get.back();
      if (user != null) {
        // User successfully signed in with Apple
        String? uid = user.uid;
        String username = user.displayName ?? "No Display Name Set";
        String? email = user.email;
        String profile = user.photoURL !=  null ? user.photoURL.toString()  : "" ;
        parser.saveUser(uid, username,email.toString(),profile);

        Get.offNamed(AppRouter.addDashboardScreenRoute());
        // You can navigate to another screen or perform other actions here.
      } else {
        // Apple sign-in was canceled or failed
        print('Apple sign-in canceled or failed');
      }
    } catch (e) {
      // Handle any errors here
      print('Error during Apple sign-in: $e');
    }
  }

  //Function to handle Google Login
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
      Utils.showProgressbar();
      if (googleSignInAccount == null) {
        // The user canceled the Google Sign In process.
        return;
      }

      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      // Sign in to Firebase with the Google credentials
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      Get.back();
      if (user != null) {
        String? uid = user.uid;
        String username = user.displayName ?? "No Display Name Set";
        String email = user.email.toString();
        String profile = user.photoURL !=  null ? user.photoURL.toString()  : "" ;
        parser.saveUser(uid, username,email.toString(),profile);
        // Google Sign In successful, you can navigate to the next screen or perform other actions.
        Get.offNamed(AppRouter.addDashboardScreenRoute());
      } else {
        // Google Sign In failed.
        print('Google Sign In Failed');
      }
    } catch (error) {
      Get.back();
      print('Error signing in with Google: $error');
    }
  }

 //Function to handle facebook login
  Future<void> handleFacebookLogin() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      Utils.showProgressbar();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final AuthCredential credential = FacebookAuthProvider.credential(accessToken.token);

        // Sign in with Firebase using Facebook credentials
        final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
        final User user = authResult.user!;

        String? uid = user.uid;
        String username = user.displayName ?? "No Display Name Set";
        String? email = user.email;
        String profile = user.photoURL !=  null ? user.photoURL.toString()  : "" ;
        parser.saveUser(uid, username,email.toString(),profile);

        // You can now use 'user' for further user-related operations
        Get.back();
        successToast('user login successful');
        Get.offNamed(AppRouter.addDashboardScreenRoute());
      } else {
        Get.back();
        showToast('Facebook login failed');
      }
    } catch (e) {
      Get.back();
      showToast('Error during Facebook login: $e');
    }
  }

  //firebase login with email and password
  Future<void> onSubmit() async {
    if (emailController.value.text.isEmpty ||
        passwordController.value.text.isEmpty
    ){
      showToast('All fields are required');
      return;
    } else if (!isEmailValid(emailController.value.text)) {
      showToast('Invalid email address');
      return;
    }

    Utils.showProgressbar();

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.value.text.toString(),
          password: passwordController.value.text.toString()
      );
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String? uid = credential.user?.uid;
        String username = credential.user?.displayName ?? "No Display Name Set";
        String? email = credential.user?.email ;
        String profile = user.photoURL !=  null ? user.photoURL.toString()  : "" ;
        parser.saveUser(uid.toString(), username,email.toString(),profile);
      } else {
        print("User not logged in.");
      };
      // showToast('User signed Account : ${credential.user?.displayName}');
      Get.back();
      Get.offNamed(AppRouter.addDashboardScreenRoute());
      successToast('user login successful');
    } on FirebaseAuthException catch (e) {
      Get.back();
      if (e.code == 'INVALID_LOGIN_CREDENTIALS'){
        showToast('Username or Password is not correct');
      }else{
        showToast(e.code.toString());
      }
    }
  }

  void onBackRoutes() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  bool isEmailValid(String email) {
    // Regular expression for email validation
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> handleDynamicLinks() async {
    // Get the initial dynamic link
    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    if(data != null){
      _handleDeepLink(data);
    }

    // Listen for dynamic links
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      print("onLinkSuccess");

    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
  }

  void _handleDeepLink(PendingDynamicLinkData data) {
    final Uri deepLink = data.link;

    String? deepUserId = deepLink.queryParameters['userId'];

    // Handle the deep link as needed, for example, navigate to a specific screen
    parser.saveReferralUser(deepUserId.toString());
    print('Deep link123: $deepLink');
    print('Deep link123: $deepUserId');
  }



}
