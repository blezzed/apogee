import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/apis/websocket.dart';
import '../../../common/entities/sat_pass.dart';
import '../../../theme.dart';
import '../controller.dart';

class SatellitePasses extends GetView<HomeController> {
  const SatellitePasses({super.key});
  
  Widget _buildSatellitePassTile(context, SatellitePassModel pass) {
    bool isAboveHorizonDuringPass() {
      final now = controller.currentTime.value;

      // Check if the current time is within the rise and set time of the pass
      if (pass.risePassTime != null && pass.setPassTime != null) {
        return now.isAfter(pass.risePassTime!) && now.isBefore(pass.setPassTime!);
      }
      return false;
    }
    final tileColor = isAboveHorizonDuringPass() ? AppColors.paraColor  : Colors.transparent;

    TextSpan subTitle(title, value)=> TextSpan(
      children: [
        TextSpan(
          text: '$title: ', // Label part
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
            color: AppColors.signColor,
            height: 1.5
          ),
        ),
        TextSpan(
          text: value, // Dynamic satellite name
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: AppColors.darkBrown,
              height: 1.5
          ),
        ),
      ],
    );
    
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.w, horizontal: 5.h),
      padding: EdgeInsets.symmetric(vertical: 6.w, horizontal: 5.h),
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(10.r)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Satellite: ${pass.satelliteName ?? 'Unknown Satellite'}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(DateFormat('dd MMMM yyyy').format(pass.risePassTime!),
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: AppColors.darkBrown,
                    height: 1.5
                ),
              ),
            ],
          ),
          RichText(text: subTitle("Rise Time", DateFormat('HH:mm').format(pass.risePassTime!))),
          RichText(text: subTitle("Max Elevation", "${pass.maxElevation}°")),
          RichText(text: subTitle("Azimuth", "${pass.azimuth}°")),
          RichText(text: subTitle("Set Time", DateFormat('HH:mm').format(pass.setPassTime!))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var satellitesData = SatellitesData.to;
    print(satellitesData.satellitePasses.isEmpty);
    return Obx(()=>Scaffold(
      appBar: AppBar(
        title: Text(
          "Satellite Passes",
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
      ) : ListView.separated(
        itemCount: satellitesData.satellitePasses.length,
        itemBuilder: (context, index) {
          final satellitePass = satellitesData.satellitePasses[index];
          return _buildSatellitePassTile(context, satellitePass);
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: AppColors.lytBrown, // Color of the divider
            thickness: 0.5,       // Thickness of the divider
            indent: 15.w,         // Left spacing
            endIndent: 15.w,      // Right spacing
          );
        },
      ),
    ));
  }
}
