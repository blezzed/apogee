

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../pages/home/controller.dart';
import '../../theme.dart';


class BottomNav extends GetView<HomeController> {
  const BottomNav({super.key});


  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      padding: EdgeInsets.all(5.w),
      height: 60.h,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: ListView.builder(
        itemCount: controller.state.tabTitles.length,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        itemBuilder: (context, index) => Obx(() => Container(
          margin: EdgeInsets.only(right: 10.w),
          child: InkWell(
            onTap: () {
              controller.state.page.value=index;
              controller.handleNavBarTap(index);
              HapticFeedback.lightImpact();
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastLinearToSlowEaseIn,
                  width: index == controller.state.page.value
                      ? 115.w
                      : 60.w,
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn,
                    height: index == controller.state.page.value ? 40.w : 0.w,
                    width: index == controller.state.page.value ? 115.w : 0.w,
                    decoration: BoxDecoration(
                      color: index == controller.state.page.value
                          ? AppColors.rifleBlue
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastLinearToSlowEaseIn,
                  width: index == controller.state.page.value
                      ? 110.w
                      : 60.w,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            width:
                            index == controller.state.page.value ? 45.w : 0,
                          ),
                          AnimatedOpacity(
                            opacity: index == controller.state.page.value ? 1 : 0,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            child: Text(
                              index == controller.state.page.value
                                  ? controller.state.tabTitles[index]
                                  : '',
                              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            width:
                            index == controller.state.page.value ? 10.w : 20.w,
                          ),
                          Icon(
                            controller.state.listOfIcons[index],
                            size: 25.w,
                            color: index == controller.state.page.value
                                ? Colors.white
                                : AppColors.rifleBlue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    ));
  }

}
