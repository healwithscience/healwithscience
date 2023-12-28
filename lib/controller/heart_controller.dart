import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:heal_with_science/backend/parser/heart_parser.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import '../util/all_constants.dart';

class HeartController extends GetxController {
  final HeartParser parser;

  HeartController({required this.parser});

  RxString heartRate = "".obs;
  List<HealthDataPoint> healthData = [];

  static final types = [
    HealthDataType.HEART_RATE,
  ];
  final permissions = types.map((e) => HealthDataAccess.READ_WRITE).toList();

  HealthFactory health = HealthFactory();

  bool? hasPermissions = false;
  bool authorized = false;

  @override
  void onInit() async {
    super.onInit();
    hasPermissions = await HealthFactory.hasPermissions(types, permissions: permissions);

    if (!hasPermissions!) {
      // requesting access to the data types before reading them
      try {
        authorized = await health.requestAuthorization(types, permissions: permissions);
      } catch (error) {
        print("Exception in authorize: $error");
      }
    }else{
      fetchData();
    }

   /* if (Platform.isAndroid) {
      final permissionStatus = Permission.activityRecognition.request();

      if (await permissionStatus.isDenied ||
          await permissionStatus.isPermanentlyDenied) {
        showToast(
            'activityRecognition permission required to fetch your steps count');
        return;
      }else{

      }
    }*/
  }

  Future fetchData() async {
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

          print("Hello Data: ${heartRate.value}");
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

  void onBackRoutes() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }
}
