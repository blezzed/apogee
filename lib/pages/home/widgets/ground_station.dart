import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../theme.dart';
import '../controller.dart';

class GroundStation extends GetView<HomeController> {
  const GroundStation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Ground Station",
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontSize: 24.sp,
              color: AppColors.rifleBlue,
            ),
          )
      ),
      body: const Center(child: Text("Ground Station")),
    );
  }
}
