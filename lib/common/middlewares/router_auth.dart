

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../theme.dart';
import '../routes/routes.dart';
import '../store/user.dart';

class RouteAuthMiddleware extends GetMiddleware{

  @override
  int? priority = 0;

  RouteAuthMiddleware({required this.priority});

  @override
  RouteSettings? redirect(String? route) {
    if (UserStore.to.isLogin || route == AppRoutes.Sign_In){
       return null;

    }else{
      Future.delayed(
        const Duration(seconds: 2),
          () => Get.snackbar("Tips", "Welcome to FMD", colorText: AppColors.textDark)
      );
      return const RouteSettings(name: AppRoutes.Sign_In);
    }
  }
}