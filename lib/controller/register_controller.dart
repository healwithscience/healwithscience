import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../backend/helper/app_router.dart';
import '../backend/parser/register_parser.dart';
import '../util/theme.dart';
import '../util/toast.dart';
import '../util/utils.dart';

class RegisterController extends GetxController {
  final RigiterParser parser;

  final firstNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final conPasswordController = TextEditingController();

  RegisterController({required this.parser});

  var _isObscured = true.obs; // Use RxBool for reactivity
  bool get isObscured => _isObscured.value;

  var _isConfirmObscured = true.obs; // Use RxBool for reactivity
  bool get isConfirmObscured => _isConfirmObscured.value;

  @override
  void onInit() {
    super.onInit();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmObscured.value = !isConfirmObscured;
  }

  void togglePasswordVisibility() {
    _isObscured.value = !isObscured;
  }

  void onBackRoutes() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  Future<void> onRegister() async {
    if (firstNameController.value.text.isEmpty) {
      showToast('Please enter your name');
      return;
    } else if (emailController.value.text.isEmpty) {
      showToast('Please enter your email address');
      return;
    } else if (!isEmailValid(emailController.value.text)) {
      showToast('Invalid email address');
      return;
    } else if (passwordController.value.text.isEmpty) {
      showToast('Password field cannot be blank');
      return;
    } else if (!isPasswordValid(passwordController.value.text.toString())) {
      showToast(
          'Password must be at least 8 characters long and should contain at least one letter one digit and special character too.');
      return;
    } else if (conPasswordController.value.text.isEmpty) {
      showToast('Confirm password cannot be blank');
      return;
    } else if (conPasswordController.value.text !=
        passwordController.value.text) {
      showToast('Password and confirm password do not match');
      return;
    }
    Get.dialog(
        SimpleDialog(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 30,
                ),
                CircularProgressIndicator(
                  color: ThemeProvider.primary,
                ),
                const SizedBox(
                  width: 30,
                ),
                SizedBox(
                    child: Text(
                  "Please wait".tr,
                  style: const TextStyle(fontFamily: 'bold'),
                )),
              ],
            )
          ],
        ),
        barrierDismissible: false);

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.value.text.toString(),
        password: passwordController.value.text.toString(),
      );

      await credential.user!.updateDisplayName(firstNameController.value.text.toString());

      String? uid = credential.user?.uid;
      String username = firstNameController.value.text.toString();
      String? email = credential.user?.email;

      parser.saveUser(uid.toString(), username , email.toString());

      Get.back();
      successToast('Registration successful');
      Get.offNamedUntil(AppRouter.addDashboardScreenRoute(), (route) => false);
      // Get.offNamedUntil(
      //     AppRouter.getLoginRoute(), (route) => false);
    } on FirebaseAuthException catch (e) {
      Get.back();
      if (e.code == 'weak-password') {
        showToast('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showToast('The account already exists for that email.');
      } else {
        showToast(e.message.toString());
      }
    } catch (e) {
      Get.back();
      print(e);
    }
  }

  //Function to handle Google Login
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();
      Utils.showProgressbar();
      if (googleSignInAccount == null) {
        // The user canceled the Google Sign In process.
        return;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
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
        String? email = user.email;
        parser.saveUser(uid.toString(), username, email.toString());
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
    print('I am in facebook login');
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      Utils.showProgressbar();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final AuthCredential credential =
            FacebookAuthProvider.credential(accessToken.token);

        // Sign in with Firebase using Facebook credentials
        final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
        final User user = authResult.user!;

        String? uid = user.uid;
        String username = user.displayName ?? "No Display Name Set";
        String? email = user.email;
        parser.saveUser(uid.toString(),username,email.toString());

        // You can now use 'user' for further user-related operations
        Get.back();
        successToast('Login successful');
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

      final AuthCredential authCredential =
          OAuthProvider('apple.com').credential(
        accessToken: credential.authorizationCode,
        idToken: credential.identityToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(authCredential);

      // Check if the user is signed in
      final User? user = userCredential.user;
      if (user != null) {
        String? uid = user.uid;
        String username = user.displayName ?? "No Display Name Set";
        String? email = user.email ;
        parser.saveUser(uid.toString(), username , email.toString());
        // User successfully signed in with Apple
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

  bool isEmailValid(String email) {
    // Regular expression for email validation
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  bool isPasswordValid(String password) {
    // Check if the password has at least 8 characters
    if (password.length < 8 || password.isEmpty) {
      return false;
    }
    // Check if the password contains at least one letter (a-zA-Z)
    if (!RegExp(r'[a-zA-Z]').hasMatch(password)) {
      return false;
    }
    // Check if the password contains at least one digit (0-9)
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return false;
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return false;
    }

    // Add any additional password criteria here as needed

    return true; // Password meets all criteria
  }
}
