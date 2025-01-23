import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../common/widget/custom_button.dart';
import '../../../common/widget/custom_textField.dart';
import '../../../theme.dart';
import '../controller.dart';


class VetEmailSignPage extends GetView<AuthController> {
  const VetEmailSignPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if(controller.state.loading.isTrue){
        return Scaffold(
          body: Center(child: SizedBox(
              width: 40.h,
              height: 40.h,
              child: const CircularProgressIndicator())),
        );
      }
      return Container(
        color: Colors.white,
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Form(
                key: controller.key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                    Padding(
                      padding:  EdgeInsets.all(32.h),
                      child: Column(
                        children: [
                          SizedBox(height: 30.h),
                          CustomFmdTextField(
                            hintText: "Username",
                            controller: controller.usernameController,
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(height: 30.h),
                          CustomFmdTextField(
                            hintText: "Password",
                            controller: controller.passwordController,
                            keyboardType: TextInputType.visiblePassword,
                          ),
                          SizedBox(height: 15.h),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Not registered? ",
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () {
              
                                    },
                                    child: Text(
                                      "Sign up",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .copyWith(
                                          color: Colors.lightBlueAccent,
                                          fontSize: 14.dg
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30.h),
                          CustomButton(
                            buttonText: "Login",
                            onPressed: () async {
                              await controller.login();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
