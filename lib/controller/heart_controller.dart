import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:heal_with_science/backend/parser/heart_parser.dart';
import 'package:permission_handler/permission_handler.dart';
import '../util/all_constants.dart';

class HeartController extends GetxController {
  final HeartParser parser;

  HeartController({required this.parser});

  RxString heartRate = "".obs;
  RxString bp = "0".obs;
  RxString steps = "0".obs;
  RxString activeEnergy = "0".obs;

  RxString bloodPreSys = "0".obs;
  RxString bloodPreDia = "0".obs;

  // List<HealthDataPoint> healthData = [];
  //
  // HealthFactory health = HealthFactory();
  //
  // final types = [
  //   HealthDataType.HEART_RATE,
  //   HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
  //   HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
  //   HealthDataType.STEPS,
  //   HealthDataType.ACTIVE_ENERGY_BURNED,
  // ];

  @override
  void onInit() async {
    super.onInit();
    /*if (Platform.isAndroid) {
      final permissionStatus = Permission.activityRecognition.request();
      if (await permissionStatus.isDenied ||
          await permissionStatus.isPermanentlyDenied) {
        showToast(
            'activityRecognition permission required to fetch your steps count');
        return;
      }else{
        fetchData();
      }
    }*/
  }






/*  Future fetchData() async {
    // define the types to get
    final types = [
      HealthDataType.HEART_RATE,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
    ];

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
              heartRate.value = "${h.value}";
            } else if (h.type == HealthDataType.BLOOD_PRESSURE_SYSTOLIC) {
              bloodPreSys.value = "${h.value}";
            } else if (h.type == HealthDataType.BLOOD_PRESSURE_DIASTOLIC) {
              bloodPreDia.value = "${h.value}";
            } else if (h.type == HealthDataType.ACTIVE_ENERGY_BURNED) {
              activeEnergy.value = "${h.value}";
            }else if (h.type == HealthDataType.STEPS) {
              steps.value = "${h.value}";
            }


          }
          if (bloodPreSys.value != "null" && bloodPreDia.value != "null") {
            bp.value = "$bloodPreSys / $bloodPreDia mmHg";
          }
          print("Hello Data: ${bp.value}");
          print("Hello Data: ${steps.value}");
          print("Hello Data: ${heartRate.value}");
          print("Hello Data: ${activeEnergy.value}");
        }
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates
      healthData = HealthFactory.removeDuplicates(healthData);
    } else {
      print("Authorization not granted");
    }
  }*/

  void onBackRoutes() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }
}
