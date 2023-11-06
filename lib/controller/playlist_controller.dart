import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:heal_with_science/backend/parser/category_parser.dart';
import 'package:heal_with_science/backend/parser/playlist_parser.dart';
import '../backend/helper/app_router.dart';
import '../model/Category.dart';
import '../util/all_constants.dart';

class PlaylistController extends GetxController {
  final PlaylistParser parser;
  RxList playlistNames = <String>[].obs;
  RxList filteredPlaylist = <String>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isFocus = false.obs;
  final TextEditingController searchController = TextEditingController();

  List<double?> frequencyList = <double?>[];
  List<String> programName = <String>[];

  PlaylistController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    fetchUserPlaylists();
  }

  //Function used to fetch custom playlist created by user
  Future<void> fetchUserPlaylists() async {
    playlistNames.clear();
    filteredPlaylist.clear();
    final firestoreInstance = FirebaseFirestore.instance;
    const settings = Settings(persistenceEnabled: false);
    firestoreInstance.settings = settings;

    var userId = parser.getUserId();

    try {
      final playlistsCollection = firestoreInstance.collection('users').doc(userId).collection('playlists');
      final querySnapshot = await playlistsCollection.get();

      querySnapshot.docs.forEach((doc) {
        playlistNames.add(doc.id);
      });
      playlistNames.removeWhere((element) => element == null);
      // Sort the frequencies list
      playlistNames.sort();
      filteredPlaylist.addAll(playlistNames);
      isLoading.value = false;

    } catch (e) {
      isLoading.value = false;
      print('Error fetching user playlists: $e');
      return; // Handle the error as per your requirements
    }
  }

  //Function used to fetch list of frequency in a particular playlist
  Future<void> fetchFrequencyArray(String playlistName) async {
    frequencyList.clear();
    programName.clear();
    final firestoreInstance = FirebaseFirestore.instance;
    var userId = parser.getUserId();

    try {
      final playlistDoc = await firestoreInstance
          .collection('users')
          .doc(userId)
          .collection('playlists')
          .doc(playlistName)
          .get();

      if (playlistDoc.exists) {
        // Assuming the frequency array is stored as a field named 'frequency' within the playlist document.
        List<Map<String, dynamic>> playlistObjects = List.from(playlistDoc.data()?['playlist']);
        for (var playlistObject in playlistObjects) {
          String name = playlistObject['name'];
          String frequency = playlistObject['frequency'];
          frequencyList.add(double.parse(frequency));
          programName.add(name);
        }


          Get.toNamed(AppRouter.getFeaturesScreen(), arguments: {
            'frequency':frequencyList[0],
            'frequenciesList':frequencyList,
            'index':0,
            'screenName':'playlist',
            'programName':programName// Pass the data you want
          });



      }
    } catch (e) {
      print('Error fetching frequency array for $playlistName: $e');
      // Handle the error as per your requirements.
    }
  }





 //Function used to filter playlist (local search)
  void filter(String searchText) {
    filteredPlaylist.clear(); // Clear the previous filtered list

    if (searchText.isEmpty) {
      // If the search text is empty, show all playlistNames
      filteredPlaylist.addAll(playlistNames);
    } else {
      // Filter playlistNames based on the search text
      for (String playlistName in playlistNames) {
        if (playlistName.toLowerCase().contains(searchText.toLowerCase())) {
          filteredPlaylist.add(playlistName);
        }
      }
    }
  }

  void onBackRoutes() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

}

