
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:heal_with_science/backend/parser/create_playlist_parser.dart';
import 'package:heal_with_science/util/utils.dart';
import '../util/all_constants.dart';

class CreatePlaylistController extends GetxController {
  final CreatePlaylistParser parser;
  List<String> selectedWords = [];
  final nameController = TextEditingController();
  RxString frequencyValue = "".obs;
  RxString programName = "".obs;

  final List<String> meditationWords = [
    "Meditation",
    "Mindfulness",
    "Zen",
    "Yoga",
    "Transcendental",
    "Vipassana",
    "Mantra",
    "Chakra",
    "Retreat",
    "Enlightenment",
    "Concentration",
    "Awareness",
    "Breath",
    "Calm",
    "Inner peace",
    "Serenity",
    "Contemplation",
    "Stillness",
    "Om",
    "Mind-body",
    "Inner self",
    "Guided meditation",
    "Deep breathing",
    "Self-discovery",
    "Stress relief",
    "Relaxation",
    "Spiritual growth",
    "Silence",
    "Visualization",
    "Centering",
    "Kundalini",
    "Lotus position",
    "Samadhi",
    "Metta",
    "Non-attachment",
    "Present moment",
    "Trataka",
    "Loving-kindness",
    "Compassion",
    "Zafu",
    "Dhyana",
    "Mudra",
    "Mandala",
    "Pranayama",
    "Body scan",
    "Chanting",
    "Insight",
    "Inner harmony",
    "Satsang",
    "Solitude",
  ];

  CreatePlaylistController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    final data = Get.arguments;
    frequencyValue.value = data['frequency'];
    programName.value = data['name'];
    randomWords();
  }

  //Function used to generate list of random 6 words
  void randomWords() {
    var random = Random();
    while (selectedWords.length < 6) {
      var word = meditationWords[random.nextInt(meditationWords.length)];
      if (!selectedWords.contains(word)) {
        selectedWords.add(word);
      }
    }
  }

  // Function to create a custom document for a user's playlist if it doesn't already exist
  Future<void> createUserPlaylist( ) async {
    if(nameController.value.text.isEmpty){
      showToast("Please enter name for playlist");
      return;
    }else if(nameController.value.text.length < 4){
      showToast("Playlist name should have at least 4 character");
      return;
    }
    Utils.showProgressbar();

    final firestoreInstance = FirebaseFirestore.instance;
    var userId = parser.getUserId();

    try {
      // Create a reference to the document with the custom name
      final userPlaylistRef = firestoreInstance.collection('users').doc(userId).collection('playlists').doc(nameController.value.text.trim());

      // Create a List of Maps to store the objects
      List<Map<String, String>> playlistObjects = [
        {"name": programName.value, "frequency": frequencyValue.value},
      ];

     // Set the data in the Firestore document
      userPlaylistRef.set({
        "playlist": playlistObjects,
      }).then((_) {
        nameController.clear();
        Get.back();
        onBackRoutes();
        successToast('Playlist created Successfully');
      }).catchError((error) {
        Get.back();
        onBackRoutes();
        showToast("Error writing document: $error");
      });
    } catch (e) {
      Get.back();
      showToast('Error creating playlist: $e');
    }
  }

  void onBackRoutes() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

}

