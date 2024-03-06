import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:heal_with_science/util/all_constants.dart';
import 'package:heart_bpm/heart_bpm.dart';
import '../backend/helper/app_router.dart';
import '../backend/parser/heart_parser.dart';
import '../util/extensions/static_values.dart';

class HeartController extends GetxController {
  // final HealthFactory health = HealthFactory();
  final HeartParser parser;

  HeartController({required this.parser});

  RxBool isBPMEnabled = false.obs;
  RxDouble progressValue = 0.0.obs;
  late Timer _timer;

  List<SensorValue> data = [];
  List<SensorValue> bpmValues = [];

  RxString heartRateValue = "".obs;

  RxList<double> hrvlist = <double>[].obs;

  RxString heartRateVariability = "".obs;



  // RxString heartRate = "".obs;
  RxDouble rmssd = 0.0.obs;
  RxString loading = '1'.obs;
  // List<HealthDataPoint> healthData = [];
  //
  //
  // static final types = [HealthDataType.HEART_RATE];
  // final permissions = types.map((e) => HealthDataAccess.READ).toList();

  // bool? hasPermissions = false;

  @override
  Future<void> onInit() async {
    super.onInit();
     await getHrvList();

  }


  Future<void> startTimer() async {
    progressValue.value = 0.0;
    int count = 0;
    double sumBPM = 0.0;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {

      if (progressValue.value < 1.0) {
        progressValue.value += 1.0 / 60.0; // 1 minute divided into 60 parts
      } else {
        isBPMEnabled.value = false;
        progressValue.value = 0.0;
        _timer.cancel();

        // Calculate average data value
        bpmValues.forEach((item) {
          sumBPM += item.value;
          count++;
        });

        double averageData = sumBPM / count;
        heartRateValue.value = averageData.toStringAsFixed(2);
        setHrv(double.parse(averageData.toStringAsFixed(2)));
        print("Average Data: $averageData");

      }
    });
  }

  // Update user heart count
  Future<void> setHrv(double hrvValue) async {
    final firestoreInstance = FirebaseFirestore.instance;

    // Create a reference to the document for the specified user
    final heartRate = firestoreInstance.collection('hrv').doc(parser.getUserId());

    // Run a transaction
    await firestoreInstance.runTransaction((transaction) async {
      // Get the document snapshot
      final docSnapshot = await transaction.get(heartRate);

      // Check if the document exists
      if (docSnapshot.exists) {
        // Document exists, update the existing list
        List<dynamic> currentList = docSnapshot.get('hrvList') ?? [];
        if (currentList.length >= 10) {
          // Remove the first value if the list length is greater than or equal to 10
          currentList.removeAt(0);
        }
        currentList.add(hrvValue);
        transaction.update(heartRate, {'hrvList': currentList});
        hrvlist.clear();
        Future.delayed(Duration(seconds: 3), (){
          getHrvList();
        });


      } else {
        // Document does not exist, create a new document
        transaction.set(heartRate, {'hrvList': [hrvValue]});
      }
    });
  }


  //GEt Hrv List
  Future<void> getHrvList() async {
    loading.value = '1';
    final firestoreInstance = FirebaseFirestore.instance;

    // Create a reference to the document for the specified user
    final heartRate = firestoreInstance.collection('hrv').doc(parser.getUserId());

    // Get the document snapshot
    final docSnapshot = await heartRate.get();

    // Check if the document exists
    if (docSnapshot.exists) {
      // Document exists, convert the dynamic list to a list of doubles
      final List<dynamic> list = docSnapshot.get('hrvList') ?? [];
      hrvlist.value =  list.map<double>((value) => value.toDouble()).toList();
      print("HelloList===> "+hrvlist.toString());
      calculateRMSSD(hrvlist);
    } else {
      // Document does not exist, return an empty list
      calculateRMSSD(hrvlist);
      showToast("No value found");
    }
  }



  void calculateRMSSD(List<double> heartRates) {

    int n = heartRates.length;


    if (n < 2) {
      loading.value = '2';
      // heartRateVariability.value = 'At least two heart rates are required for RMSSD calculation.';
    } else {
      List<double> rrIntervals = [];

      for (int i = 0; i < n; i++) {
        double rrInterval = 60000 / heartRates[i];
        rrIntervals.add(rrInterval);
      }

      double sumSquaredDifferences = 0;

      for (int i = 0; i < n - 1; i++) {
        double difference = rrIntervals[i + 1] - rrIntervals[i];
        sumSquaredDifferences += pow(difference, 2);
      }

      print("HelloHere");
      loading.value = '3';
      double meanSquaredDifferences = sumSquaredDifferences / (n - 1);
      rmssd.value = sqrt(meanSquaredDifferences);
      print("HelloHere==> "+rmssd.value.toString());

    }
  }


 /* Future<void> _checkPermissionsAndFetchData() async {
    hasPermissions = await health.hasPermissions(types);

    if (hasPermissions!) {
      fetchData();
    } else {
      await _requestPermissions();
    }
  }

  Future<void> _requestPermissions() async {
    try {
      bool authorized = await health.requestAuthorization(types, permissions: permissions);

      if (authorized) {
        print("Permission granted, fetching data...");
        fetchData();
      } else {
        loading.value = '2';
        print("Permission denied. User did not grant access.");
      }
    } catch (error) {
      print("Exception in authorize: $error");
    }
  }

  Future<void> fetchData() async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(hours: 24));

    try {
      healthData = await health.getHealthDataFromTypes(yesterday, now, types);


      if (healthData.isNotEmpty) {
        List<double> heartRateValues = [];
        // print("List of Heart Rate Values: $healthData");
        for (HealthDataPoint h in healthData) {
          if (h.type == HealthDataType.HEART_RATE) {
            var doubleValue = double.parse('${h.value}');
            String formattedValue = doubleValue.toStringAsFixed(2);
            heartRate.value = formattedValue;
            heartRateValues.add(doubleValue);
          }
        }
        // healthData = HealthFactory.removeDuplicates(healthData);
        print("List of Heart Rate Values: $heartRateValues");
        calculateRMSSD(heartRateValues);
      } else {
        showToast("At least two heart rates are required for RMSSD calculation");
        loading.value = '2';
      }
    } catch (error) {
      print("Exception in getHealthDataFromTypes: $error");
    }
  }

  void calculateRMSSD(List<double> heartRates) {
    int n = heartRates.length;

    if (n < 2) {
      loading.value = '2';
      // throw Exception("At least two heart rates are required for RMSSD calculation.");
    } else {
      List<double> rrIntervals = [];

      for (int i = 0; i < n; i++) {
        double rrInterval = 60000 / heartRates[i];
        rrIntervals.add(rrInterval);
      }

      double sumSquaredDifferences = 0;

      for (int i = 0; i < n - 1; i++) {
        double difference = rrIntervals[i + 1] - rrIntervals[i];
        sumSquaredDifferences += pow(difference, 2);
      }

      double meanSquaredDifferences = sumSquaredDifferences / (n - 1);
      rmssd.value = sqrt(meanSquaredDifferences);
      loading.value = '3';
    }
  }*/

  void goToNext(double hrv) {
    StaticValue.resetTimer();
    RxList<double?> filteredfrequencies = <double?>[].obs;
    filteredfrequencies.add(hrv);

    Get.toNamed(
      AppRouter.getFeaturesScreen(),
      arguments: {
        'frequency': filteredfrequencies[0],
        'frequenciesList': filteredfrequencies,
        'index': 0,
        'screenName': 'frequency'
        // Pass the data you want
      },
    );
  }

  void onBackRoutes() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

}




/* Future fetchData() async {
    // define the types to get


    // get data within the last 24 hours
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(hours: 24));

    // requesting access to the data types before reading them
    bool requested = await health.requestAuthorization(types);

    if (requested) {
      try {
        // fetch health data
        healthData = await health.getHealthDataFromTypes(yesterday, now, types);

        if (healthData.isNotEmpty) {
          print("Hello Data Health: $healthData");

          for (HealthDataPoint h in healthData) {
            if (h.type == HealthDataType.HEART_RATE) {
              var doubleValue = double.parse('${h.value}');
              String formattedValue = doubleValue.toStringAsFixed(2);
              heartRate.value = formattedValue;
            }
          }

          print("Hello Data1: ${heartRate.value}");
        }
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates
      healthData = HealthFactory.removeDuplicates(healthData);
    } else {
      print("Authorization not granted");
    }
  }
*/
