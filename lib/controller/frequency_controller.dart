import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:heal_with_science/backend/parser/frequency_parser.dart';
import '../model/Category.dart';
import '../util/all_constants.dart';

class FrequencyController extends GetxController {
  final List<double?> frequencies = <double?>[];

  final FrequencyParser parser;
  RxList playlistNames = <String>[].obs;

  final TextEditingController searchController = TextEditingController();
  List<Category>? categoriesList = [];

  // Track loading state
  final RxBool isFocus = false.obs;

  FrequencyController({required this.parser});

  final RxList<double?> filteredfrequencies = <double?>[].obs;
  RxList<int> downloadButtonClickedList = <int>[].obs;


  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetDownloadlist();
    fetchFrequencies();

  }

  Future<void> fetDownloadlist() async {
    categoriesList =  await parser.fetchList();
  }

  bool checkStatus(String frequency)  {
    if(categoriesList != null){
      for (Category category in categoriesList!) {
           if(frequency.toString() == category.frequency.toString()){
             return true;
           }
      }
    }
    return false;
  }


  //Fetch Frequencies from firebase
  Future<void> fetchFrequencies() async {

    final firestore = FirebaseFirestore.instance;
    const settings = Settings(persistenceEnabled: false);
    firestore.settings = settings;
    firestore
        .collection('frequencies') // Replace with your collection name
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        // Loop through the documents and extract the "name" field
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          final data = doc.data()
              as Map<String, dynamic>?; // Cast to Map<String, dynamic>?
          if (data != null) {
            final name = data['name'] as String?;
            if (name != null) {
              final doubleValue = double.tryParse(name);
              frequencies.add(doubleValue);
              downloadButtonClickedList.value =  List.filled(frequencies.length, 1);
            }
          }
        }
        frequencies.removeWhere((element) => element == null);

        // Sort the frequencies list
        frequencies.sort();

        filteredfrequencies.addAll(frequencies);
        isLoading.value = false;
      } else {
        isLoading.value = false;
        print('No documents found in the collection.');
      }
    }).catchError((error) {
      isLoading.value = false;
      print('Error fetching data: $error');
    });
  }

  // Used to filter the frequency list(local search)
  void filterFrequencies(String searchText) {
    if (searchText.isEmpty) {
      // If the search text is empty, show all frequencies
      filteredfrequencies.assignAll(frequencies);
    } else {
      // Filter frequencies based on the search text
      final filtered = frequencies
          .where((frequency) =>
              frequency != null &&
              frequency.toString().contains(searchText.toLowerCase()))
          .toList();
      filteredfrequencies.assignAll(filtered);
    }
  }

  //Function used to fetch custom playlist created by user
  Future<void> fetchUserPlaylists() async {
    playlistNames.clear();
    final firestoreInstance = FirebaseFirestore.instance;
    var userId = parser.getUserId();

    try {
      final playlistsCollection = firestoreInstance
          .collection('users')
          .doc(userId)
          .collection('playlists');
      final querySnapshot = await playlistsCollection.get();

      querySnapshot.docs.forEach((doc) {
        playlistNames.add(doc.id);
      });
      print('Error fetching user playlists: $playlistNames');
    } catch (e) {
      print('Error fetching user playlists: $e');
      return; // Handle the error as per your requirements
    }
  }

  //Function used to add frequency value in particular playlist
  Future<void> updatePlaylist(String playlistName, dynamic valueToAdd) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      var userId = parser.getUserId();

      // Create a reference to the document for the specified playlist
      final userPlaylistRef = firestoreInstance
          .collection('users')
          .doc(userId)
          .collection('playlists')
          .doc(playlistName);

      // Update the data in the Firestore document
      await userPlaylistRef.update({
        "playlist": FieldValue.arrayUnion([
          {"name": "No Name", "frequency": valueToAdd.toString()}
        ]),
      });

      Get.back();
      successToast('Playlist updated Successfully');
    } catch (e) {
      showToast('Error updating playlist: $e');
    }
  }

  //Function used to navigate back to previous screen
  void onBackRoutes() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }


}
