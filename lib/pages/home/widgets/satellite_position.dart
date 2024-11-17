import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/apis/websocket.dart';
import '../../../theme.dart';
import '../controller.dart';

class SatellitePosition extends GetView<HomeController> {
  const SatellitePosition({super.key});

  @override
  Widget build(BuildContext context) {
    var satellitesData = SatellitesData.to;
    return Obx(()=> Scaffold(
      appBar: AppBar(
        title: Text(
          "Satellite Position",
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
            fontSize: 24.sp,
            color: AppColors.rifleBlue,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Text(
              DateFormat.Hms().format(controller.currentTime.value),
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: AppColors.signColor
              ),
            ),
          )
        ],
      ),
      body: (satellitesData.satellitePasses.isEmpty)? Center(
        child: Text(
          'Waiting for satellite pass data...',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ) : ListView.builder(
        itemCount: satellitesData.satellitePositions.length,
        itemBuilder: (context, index) {
          final satellite = satellitesData.satellitePositions[index];
          return ListTile(
            title: Text(satellite['name'] ?? 'Unknown Satellite'),
            subtitle: Text(
              'Elevation: ${satellite['elevation']}°, '
                  'Azimuth: ${satellite['azimuth']}°, '
                  'Distance: ${satellite['distance_km']} km',
            ),
          );
        },
      ),
    ));
  }
}
