
import 'dart:async';

import 'package:apogee/common/apis/user.dart';
import 'package:apogee/pages/home/state.dart';
import 'package:apogee/pages/telemetry_details/state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../common/entities/ground_station.dart';
import '../../common/entities/telemetry.dart';
import '../../common/provider/internet.dart';

class TelemetryDetailsController extends GetxController {
  TelemetryDetailsController();
  final state = TelemetryDetailsState();

  late TelemetryModel telemetry;

  @override
  void onInit() {
    super.onInit();
    final data = Get.arguments;
    telemetry = TelemetryModel.fromJson(data['telemetry']);

  }

  @override
  Future<void> onReady() async {
    super.onReady();


  }


}
