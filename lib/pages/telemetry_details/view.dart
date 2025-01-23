
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../theme.dart';
import 'controller.dart';

class TelemetryDetailsPage extends GetView<TelemetryDetailsController> {
  const TelemetryDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tel = controller.telemetry;

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

    RichText _buildSubtitlePerformance(String label, String value) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$label: \n",
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffe7e7e7),
        centerTitle: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: Text(
                tel.satellite.name,
              style: Theme.of(context).textTheme.titleLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
        bottom: PreferredSize(preferredSize: Size.fromHeight(40.h),
            child: Padding(
              padding: EdgeInsets.only(left: 10.w, right: 5.w, bottom: 8.w),
              child: Column(
                children: [
                  Text(
                    tel.satellite.line1 ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    tel.satellite.line2 ?? '',maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                ],
              ),
            )),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TELEMETRY',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontSize: 24.sp
                  ),
                ),
                Text(
                  DateFormat('MMM dd, yyyy H:mm').format(tel.timestamp),
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: AppColors.rifleBlue600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h,),
            Text(
              'POWER AND SYSTEM HEALTH',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(

              ),
            ),
            _buildSubtitle('Battery', "${tel.battery_voltage!.toStringAsFixed(2)} V"),
            _buildSubtitle('Solar Panel Status', tel.solar_panel_status ? 'Operational' : 'Non Operational'),
            _buildSubtitle('Power Consumption', "${tel.power_consumption!.toStringAsFixed(2)} watts"),
            Row(
              children: [
                Text(
                  "Health Status: ",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                _buildHealthBadge(tel.health_status),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(5.h),
              child: Divider( ),
            ),
            Text(
              'TELEMETRY AND PERFORMANCE ',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(),
            ),
            SizedBox(
              width: double.maxFinite,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns
                  crossAxisSpacing: 8.w, // Horizontal spacing between items
                  mainAxisSpacing: 8.h, // Vertical spacing between items
                  childAspectRatio: 4, // Adjust aspect ratio to control the size of each item
                ),
                shrinkWrap: true, // Allows the GridView to shrink to fit its content
                physics: NeverScrollableScrollPhysics(), // Disables scrolling inside the GridView
                itemCount: 4, // Number of items in the grid
                itemBuilder: (context, index) {
                  // Return widgets based on the index
                  switch (index) {
                    case 0:
                      return _buildSubtitlePerformance('Data Rate', "${tel.battery_voltage!.toStringAsFixed(2)} Mbps");
                    case 1:
                      return _buildSubtitlePerformance('Temperature', "${tel.temperature!.toStringAsFixed(1)}°C");
                    case 2:
                      return _buildSubtitlePerformance('Velocity', "${tel.velocity.toStringAsFixed(2)} km/s");
                    case 3:
                      return _buildSubtitlePerformance('Signal Strength', "${tel.signal_strength!.toStringAsFixed(2)} dBm");
                    default:
                      return SizedBox.shrink(); // Fallback
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.h),
              child: Divider( ),
            ),
            Text(
              'LOCATION DATA ',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(),
            ),
            _buildSubtitle('Latitude', "${tel.latitude}"),
            _buildSubtitle('Longitude', "${tel.longitude}"),
            _buildSubtitle('Altitude', "${tel.power_consumption!.toStringAsFixed(2)} km"),
            Padding(
              padding: EdgeInsets.all(5.h),
              child: Divider( ),
            ),
            Text(
              'ORIENTATION AND CONTROL',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(),
            ),
            _buildSubtitle('Yaw', "${tel.yaw!.toStringAsFixed(1)}°"),
            _buildSubtitle('Roll', "${tel.roll!.toStringAsFixed(1)}°"),
            _buildSubtitle('Pitch', "${tel.pitch!.toStringAsFixed(1)}°"),
            Padding(
              padding: EdgeInsets.all(5.h),
              child: Divider( ),
            ),
            Text(
              'OPERATIONAL STATUS',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(),
            ),
            _buildSubtitle('Command Status', tel.command_status),
            _buildSubtitle('Error Code', "${tel.error_code}"),
          ],
        ),
      ),

    );
  }
}
