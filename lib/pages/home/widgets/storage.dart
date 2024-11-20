import 'package:apogee/common/apis/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/apis/websocket.dart';
import '../../../common/entities/sat_pass.dart';
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

    return Scaffold(
      appBar: AppBar(
          title: Text(
            "History",
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontSize: 24.sp,
              color: AppColors.rifleBlue,
            ),
          )
      ),
      body: FutureBuilder<List<SatellitePassModel>>(
        future: passes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No satellite passes found'));
          }else if (SatellitesData.to.webSocketConnection.isFalse || snapshot.data!.isEmpty) {
            return Center(child: Text('Server is down'));
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
    );
  }
}
