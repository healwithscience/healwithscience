import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:heal_with_science/model/CustomCategory.dart';
import '../backend/helper/app_router.dart';
import '../backend/parser/custom_frequency_parser.dart';
import '../util/all_constants.dart';

class CustomFrequencyController extends GetxController {
  final CustomFrequencyParser parser;

  TextEditingController nameController  = TextEditingController();
  TextEditingController frequencyController  = TextEditingController();
  TextEditingController newFrequencyController  = TextEditingController();
  final RxBool isLoading = true.obs;
  final ScrollController scrollController = ScrollController();

  final RxList<CustomCategory> customProgram = <CustomCategory>[].obs;
  List<CustomCategory> fetchedProgram = [];

  CustomFrequencyController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    fetchCustomProgram();
  }

  // This is used to create new custom program
  Future<void> createCustomProgram() async {
    if (nameController.value.text.isEmpty || nameController.value.text.length < 4) {
      showToast("Please enter a valid program name.");
      return;
    } else if (frequencyController.value.text.isEmpty || frequencyController.value.text.length <= 1) {
      showToast("Please enter a frequency value");
      return;
    }

    try {
      final firestoreInstance = FirebaseFirestore.instance;
      var userId = parser.getUserId();

      // Use the program name as the document ID
      final userPlaylistRef = firestoreInstance
          .collection('program')
          .doc(userId)
          .collection('custom_program')
          .doc(nameController.value.text);

      // Check if the document already exists with the same name
      final documentSnapshot = await userPlaylistRef.get();
      if (documentSnapshot.exists) {
        showToast("A program with the same name already exists.");
        return;
      }

      String newValue = double.parse(frequencyController.value.text.toString()).toStringAsFixed(2);
      if(double.parse(newValue) > 20000){
        showToast("Frequency value can't be higher then 20000");
        return;
      }

      // Create an array of values
      List<String> frequencyList = [newValue];

      // Update the data in the Firestore document
      await userPlaylistRef.set({
        "name": nameController.value.text,
        "frequency": frequencyList,
      });

      Get.back();
      successToast('Playlist updated Successfully');
      nameController.clear();
      frequencyController.clear();
      fetchCustomProgram();
    } catch (e) {
      showToast('Error updating playlist: $e');
    }
  }

  //Function used to fetch custom playlist created by user
  Future<void> fetchCustomProgram() async {

    var userId = parser.getUserId();
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      const settings = Settings(persistenceEnabled: false);
      firestoreInstance.settings = settings;


      CollectionReference categoriesCollection = firestoreInstance
          .collection('program')
          .doc(userId)
          .collection('custom_program');

      QuerySnapshot querySnapshot = await categoriesCollection.get();

      fetchedProgram = querySnapshot.docs
          .map((doc) => CustomCategory.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      fetchedProgram.sort((a, b) => a.name.compareTo(b.name));

      customProgram.assignAll(fetchedProgram);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print('Error fetching categories: $e');
    }
  }

  //This function is used to add frequency in existed program
  Future<void> addToFrequencyArray(String programName) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      var userId = parser.getUserId();

      // Reference to the Firestore document
      final userPlaylistRef = firestoreInstance
          .collection('program')
          .doc(userId)
          .collection('custom_program')
          .doc(programName);


      // Retrieve the current data from the Firestore document
      final documentSnapshot = await userPlaylistRef.get();
      if (!documentSnapshot.exists) {
        showToast("Program not found.");
        return;
      }

      // Get the existing frequency array
      List<dynamic> frequencyList = documentSnapshot.data()?['frequency'] ?? [];

      String newValue = double.parse(newFrequencyController.value.text.toString()).toStringAsFixed(2);

      if(double.parse(newValue) > 20000){
        showToast("Frequency value can't be higher then 20000");
        return;
      }else if(frequencyList.contains(newValue)){
        showToast("Value already exist");
        return;
      }

      // Add the new value to the array
      frequencyList.add(newValue);

      // Update the Firestore document with the modified array
      await userPlaylistRef.update({
        "frequency": frequencyList,
      });
      newFrequencyController.clear();
      Get.back();
      successToast('Frequency added successfully');
    } catch (e) {
      showToast('Error adding value to the "frequency" array: $e');
    }
  }


  //This function is used to remove program
  Future<void> removeProgram(String programName) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      var userId = parser.getUserId();

      // Reference to the Firestore document you want to remove
      final userPlaylistRef = firestoreInstance
          .collection('program')
          .doc(userId)
          .collection('custom_program')
          .doc(programName);

      // Check if the document exists before attempting to delete it
      final documentSnapshot = await userPlaylistRef.get();
      if (documentSnapshot.exists) {
        // Document exists, delete it
        await userPlaylistRef.delete();
        successToast('Program removed successfully');
        fetchCustomProgram();
      } else {
        // Document does not exist
        showToast('Program not found.');
      }
    } catch (e) {
      showToast('Error removing program: $e');
    }
  }

  void goToFeatures(List<String> frequency , String name) {

    print("HelloFrequency==>"+frequency.toString());
    List<double> frequencyList = frequency.map((str) => double.parse(str)).toList();

    Get.toNamed(AppRouter.getFeaturesScreen(), arguments: {
      'frequency':frequencyList[0],
      'frequenciesList':frequencyList,
      'index':0,
      'name': name,// Pass the data you want
      'screenName': 'custom_program'// Pass the data you want
    });
  }



  void onBackRoutes() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }
}
