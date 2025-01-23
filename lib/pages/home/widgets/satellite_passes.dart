import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    final tileColor = isAboveHorizonDuringPass() ? AppColors.rifleBlue200  : Colors.transparent;

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
              isAboveHorizonDuringPass() ? Text(
                "Being tracked ...",
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: AppColors.rifleBlue700,
                    fontWeight: FontWeight.bold,
                    height: 1.5
                ),
              ) :Text(DateFormat('dd MMMM yyyy').format(pass.risePassTime!),
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

    return Obx(() => Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            automaticallyImplyLeading: false,
            pinned: true, // Keeps the app bar visible when scrolled
            expandedHeight: 180.h, // Height of the expanded app bar
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                padding: EdgeInsets.only(left: 10.w,bottom: 10.h),
                child: Text(
                  "Predictions",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontSize: 18.sp, // Adjusted size for the collapsed state
                    color: AppColors.rifleBlue,
                  ),
                ),
              ),
              centerTitle: false,
              background: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    SvgPicture.asset(
                      'assets/images/dark_apogee.svg', // Replace with your SVG asset path
                      height: 80.h,
                      semanticsLabel: 'Logo', // Optional, for accessibility
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Apogee",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontSize: 24.sp,
                        color: AppColors.rifleBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottom: PreferredSize(preferredSize: Size.fromHeight(20.h),
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.only(left: 10.w, bottom: 8.w),
                  child: Text(
                    "Future satellite passes",
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Colors.grey.shade500,
                    ),
                  ),
                )),
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Obx(() => Text(
                  DateFormat.Hms().format(controller.currentTime.value),
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: AppColors.signColor,
                  ),
                )),
              )
            ],
          ),
          satellitesData.satellitePasses.isEmpty
              ? SliverFillRemaining(
            child: Center(
              child: Text(
                'Waiting for satellite pass data...',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          )
              : SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final satellitePass =
                satellitesData.satellitePasses[index];
                return _buildSatellitePassTile(
                    context, satellitePass);
              },
              childCount: satellitesData.satellitePasses.length,
            ),
          ),
        ],
      ),
    ));
  }

}
