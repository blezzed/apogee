import 'package:apogee/common/apis/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/apis/websocket.dart';
import '../../../common/entities/sat_pass.dart';
import '../../../common/entities/telemetry.dart';
import '../../../common/routes/routes.dart';
import '../../../theme.dart';
import '../controller.dart';

class StoragePage extends GetView<HomeController> {
  StoragePage({super.key});

  final Future<List<SatellitePassModel>> passes = UserApi().fetchSatellitePasses();

  @override
  Widget build(BuildContext context) {
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

    RichText _buildSubtitle(String label, String value) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$label: ",
              style: Theme.of(context).textTheme.labelSmall,
            ),
            TextSpan(
              text: value,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildHealthBadge(String healthStatus) {
      final bgColor = healthStatus == 'Nominal'
          ? Colors.green[100]
          : healthStatus == 'Warning'
          ? Color(0xFFFFF885)
          : Colors.red[100];

      final textColor = healthStatus == 'Nominal'
          ? Colors.green[800]
          : healthStatus == 'Warning'
          ? Color(0xFFE29400)
          : Colors.red[800];

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.circle,
              size: 6.h,
              color: textColor,
            ),
            SizedBox(width: 4.w),
            Text(
              healthStatus,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      );
    }



    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              "Storage",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontSize: 24.sp,
                color: AppColors.rifleBlue,
              ),
            ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(40.h),
            child: TabBar(
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
              indicator: BoxDecoration(
                color: AppColors.rifleBlue100, // Background color for active tab
                borderRadius: BorderRadius.circular(10.r), // Rounded corners
              ),
              indicatorPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: -10.w),
              indicatorColor: AppColors.rifleBlue,
              dividerColor: Colors.transparent,
              labelStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontWeight: FontWeight.bold
              ),
              labelColor: AppColors.rifleBlue700,
              unselectedLabelColor: AppColors.signColor,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.graphic_eq_rounded, size: 18.sp), // Adjust icon size if needed
                      SizedBox(width: 5.w), // Space between icon and text
                      Text("Telemetry"),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.history, size: 18.sp), // Adjust icon size if needed
                      SizedBox(width: 5.w), // Space between icon and text
                      Text("Passes"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(children: [
          Obx((){
            if (SatellitesData.to.telemetryList == []) {
              return const Center(child: Text('No Satellite Telemetry found'));
            } else {
              return ListView.separated(
                itemCount: SatellitesData.to.telemetryList.length,
                itemBuilder: (context, index) {
                  final tel = SatellitesData.to.telemetryList[index];
                  return ListTile(
                    onTap: (){
                      Get.toNamed(AppRoutes.TelemetryDetails, arguments: {
                        "telemetry": tel.toJson()
                      });
                    },
                    title: Text(
                      tel.satellite.name,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('MMM dd, yyyy H:mm').format(tel.timestamp),
                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: AppColors.rifleBlue600,
                            height: 1.5,
                          ),
                        ),
                        _buildSubtitle("Temperature", "${tel.temperature?.toStringAsFixed(1) ?? 'N/A'}°C"),
                        _buildSubtitle("Battery", "${tel.battery_voltage?.toStringAsFixed(2) ?? 'N/A'} V"),
                        _buildSubtitle("Velocity", "${tel.velocity.toStringAsFixed(2)} km/s"),
                      ],
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Health Status:',
                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: AppColors.rifleBlue,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 5.w),
                        _buildHealthBadge(tel.health_status),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                  color: AppColors.rifleBlue200,
                  thickness: 0.5,
                  indent: 15.0,
                  endIndent: 15.0,
                ),
              );
            }
          }),
          FutureBuilder<List<SatellitePassModel>>(
            future: passes,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No satellite passes found'));
              }else if (SatellitesData.to.webSocketConnection.isFalse || snapshot.data!.isEmpty) {
                return const Center(child: Text('Server is down'));
              } else {
                return ListView.separated(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final pass = snapshot.data![index];
                    return ListTile(
                      title: Text(pass.satelliteName??""),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(text: subTitle("Max Elv:", "${pass.maxElevation}°")),
                          RichText(text: subTitle("Azimuth:", "${pass.azimuth}°")),
                        ],
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(DateFormat('dd MMMM yyyy').format(pass.risePassTime!),
                            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                color: AppColors.darkBrown,
                                height: 1.5
                            ),
                          ),
                          SizedBox(height: 5.h,),
                          Text('Rise Time: ${DateFormat('HH:mm').format(pass.risePassTime!)}', style: Theme.of(context).textTheme.labelSmall!),
                          Text('Set Time: ${DateFormat('HH:mm').format(pass.setPassTime!)}', style: Theme.of(context).textTheme.labelSmall!),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: AppColors.lytBrown, // Color of the divider
                      thickness: 0.5,       // Thickness of the divider
                      indent: 15.w,         // Left spacing
                      endIndent: 15.w,      // Right spacing
                    );
                  },
                );
              }
            },
          )
        ])
      ),
    );
  }
}
