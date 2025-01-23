
import 'dart:async';

import 'package:apogee/common/apis/user.dart';
import 'package:apogee/pages/home/state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../common/entities/ground_station.dart';
import '../../common/provider/internet.dart';

class HomeController extends GetxController {
  HomeController();
  final state = HomeState();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  late final PageController pageController;
  late final List<BottomNavigationBarItem> bottomTabs;

  var currentTime = DateTime.now().obs;

  late Rx<GroundStationModel> station =GroundStationModel(id: 0, name: "", latitude: 0, longitude: 0, altitude: 0, startTrackingElevation: 0).obs;

  late GoogleMapController _mapController;
  GoogleMapController get mapController => _mapController;

  void setMapController(GoogleMapController mapController){
    _mapController = mapController;
  }


  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  void handlePageChanged(int index) {
    state.page.value = index;
  }

  void handleNavBarTap(int index) {
    pageController.jumpToPage(index);
  }

  Future<void> loadData() async {
    return await UserApi().fetchGroundStations().then((val){
      station.value = val.first;

      state.initialPosition.value = LatLng(station.value.latitude, station.value.longitude);
      state.cameraPosition.value = CameraPosition(target: state.initialPosition.value, zoom: 14);

      state.markerList.add(
          Marker(
              markerId: MarkerId(station.value.name),
              infoWindow: InfoWindow(
                  title: station.value.name
              ),
              position: LatLng(station.value.latitude, station.value.longitude),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              onTap: (){
                print(station.value.name);
              }
          ));
    });
  }


  @override
  void onInit() {
    super.onInit();

    state.tabTitles.value = ["Passes", "Satellites", "Storage", "Settings",];
    state.listOfIcons.value = [
      Icons.home_rounded,
      Icons.satellite_alt_outlined,
      Icons.storage_rounded,
      Icons.settings,
    ].obs;

    pageController = PageController(initialPage: state.page.value);

    Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTime.value = DateTime.now(); // Update the time every second
    });

  }

  @override
  Future<void> onReady() async {
    super.onReady();

    if (InternetProvider.to.hasInternet.value == true){
      await loadData();
    }

    InternetProvider.to.hasInternet.listen((net) async {
      if(net == true){
        await loadData();
      }
    });

  }


}
