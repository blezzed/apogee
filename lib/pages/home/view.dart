
import 'package:apogee/common/apis/websocket.dart';
import 'package:apogee/pages/home/widgets/ground_station.dart';
import 'package:apogee/pages/home/widgets/profile.dart';
import 'package:apogee/pages/home/widgets/satellite_passes.dart';
import 'package:apogee/pages/home/widgets/satellite_position.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../common/widget/bottom_nav.dart';
import 'controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  Widget _buildPageView(context) {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: controller.pageController,
      onPageChanged: controller.handlePageChanged,
      children:  [
        SatellitePasses(),
        SatellitePosition(),
        GroundStation(),
        ProfilePage(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        key: controller.scaffoldKey,
        body: _buildPageView(context),
        bottomNavigationBar: const BottomNav(),
      ),
    );
  }
}
