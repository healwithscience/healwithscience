import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heal_with_science/backend/parser/profile_parser.dart';
import 'package:path/path.dart';
import '../backend/helper/app_router.dart';
import '../util/all_constants.dart';
import '../util/extensions/static_values.dart';
import '../util/inactivity_manager.dart';
import '../util/theme.dart';
import '../util/utils.dart';

class ProfileController extends GetxController {
  final ProfileParser parser;
  XFile? _selectedImage;
  String username = "";
  String email = "";
  String imageUrl = "";
  RxString profileImage = "".obs;

  ProfileController({required this.parser});

  @override
  void onInit() {
    super.onInit();

    username = parser.getUserName().toString();
    email = parser.getUserEmail().toString();
    profileImage.value = parser.getUserImage().toString();
    if(StaticValue.miniPlayer.value){
      InactivityManager.resetTimer();
    }
  }

  void onBackRoutes() {
    if(StaticValue.miniPlayer.value){
      InactivityManager.resetTimer();
    }
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  void selectFromGallery(String kind) async {

    _selectedImage = await ImagePicker().pickImage(
        source: kind == 'gallery' ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 25);
    update();
    Utils.showProgressbar();

    if (_selectedImage != null) {
      final file = File(_selectedImage!.path); // Convert to a File object
      final fileName = basename(file.path);
      final destination = 'files/$fileName';

      final storageReference = FirebaseStorage.instance.ref(destination).child('images/$fileName.jpg');
      final uploadTask =  storageReference.putFile(file);

      await uploadTask.whenComplete(() {
        print('Image uploaded to Firebase Storage');
      });

      imageUrl = await storageReference.getDownloadURL();
      profileImage.value = imageUrl;
      parser.saveUserImage(imageUrl);
      updateProfileImage(imageUrl);
    } else {
      Get.back();
      showToast("No image selected");
    }
  }

// Function used for logout
  Future<void> signOut() async {
    try {
      Utils.showProgressbar();
      StaticValue.stopFrequency();
      StaticValue.miniPlayer.value = false;
      InactivityManager.doNotStart();
      await FirebaseAuth.instance.signOut();
      parser.logout();
      Get.back();
      Get.offNamedUntil(AppRouter.getLoginRoute(), (route) => false);


      // The user has been signed out successfully.
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<void> updateProfileImage(String imageUrl) async {
    // Check if the user is already signed in
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Update the user's photoURL with the new image URL
        await user.updatePhotoURL(imageUrl);
        // Reload the user to ensure the updated information is available
        await user.reload();
        // Fetch the updated user information
        User? updatedUser = FirebaseAuth.instance.currentUser;

        // Check if the user's photoURL has been updated
        if (updatedUser != null && updatedUser.photoURL == imageUrl) {
          Get.back();
          successToast("Image Uploaded Successfully");
        } else {
          Get.back();
          showToast('Failed to update profile image');
        }
      } catch (e) {
        Get.back();
        showToast('Error updating profile image: $e');
      }
    } else {
      // User is not signed in; you might want to handle this case accordingly
      Get.back();
      showToast('User not signed in');
    }
  }
}
