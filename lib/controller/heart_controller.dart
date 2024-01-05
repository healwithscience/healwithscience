import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

import '../backend/parser/heart_parser.dart';

class HeartController extends GetxController {
  final HealthFactory health = HealthFactory();
  final HeartParser parser;

  HeartController({required this.parser});

  RxString heartRate = "".obs;
  RxDouble rmssd = 0.0.obs;
  RxString loading = '1'.obs;
  List<HealthDataPoint> healthData = [];


  static final types = [HealthDataType.HEART_RATE];
  final permissions = types.map((e) => HealthDataAccess.READ_WRITE).toList();


 /* // define the types to get
  final types = [
    HealthDataType.HEART_RATE
  ];

  // with coresponsing permissions
  final permissions = [
    HealthDataAccess.READ_WRITE,
    // HealthDataAccess.READ,
  ];*/


  bool? hasPermissions = false;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _checkPermissionsAndFetchData();
  }

  Future<void> _checkPermissionsAndFetchData() async {
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

        for (HealthDataPoint h in healthData) {
          if (h.type == HealthDataType.HEART_RATE) {
            var doubleValue = double.parse('${h.value}');
            String formattedValue = doubleValue.toStringAsFixed(2);
            heartRate.value = formattedValue;
            heartRateValues.add(doubleValue);
          }
        }
        healthData = HealthFactory.removeDuplicates(healthData);
        print("List of Heart Rate Values: $heartRateValues");
        calculateRMSSD(heartRateValues);
      } else {
        print("Hello Loading");
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
