
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../common/entities/telemetry.dart';

class HomeState{

  Rx<int> page = 0.obs;

  RxList<String> tabTitles = <String>[].obs;

  RxList<IconData> listOfIcons = <IconData>[].obs;

  List<Widget> pages = [];

  Rx<CameraPosition> cameraPosition = const CameraPosition(target: LatLng(-17.7848059, 31.05052), zoom: 12).obs;
  Rx<LatLng> initialPosition = const LatLng(-17.7848059, 31.05052).obs;
  Rx<GoogleMapController?> mapController = null.obs;

  RxBool loading = false.obs;

  RxList<Marker> markerList = <Marker>[].obs;



}