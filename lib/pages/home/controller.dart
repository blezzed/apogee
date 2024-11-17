
import 'dart:async';

import 'package:apogee/pages/home/state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  HomeController();
  final state = HomeState();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  late final PageController pageController;
  late final List<BottomNavigationBarItem> bottomTabs;

  var currentTime = DateTime.now().obs;


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

  @override
  void onInit() {
    super.onInit();

    state.tabTitles.value = ["Passes", "Satellites", "G station", "Profile",];
    state.listOfIcons.value = [
      Icons.home_rounded,
      Icons.satellite_alt_outlined,
      Icons.settings_input_antenna_outlined,
      Icons.person_rounded,
    ].obs;

    pageController = PageController(initialPage: state.page.value);

    Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTime.value = DateTime.now(); // Update the time every second
    });

  }


}
