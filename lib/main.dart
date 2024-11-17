import 'package:apogee/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'common/routes/pages.dart';
import 'global.dart';

void main() async {
  await Global.init();
  runApp(MyApp(appTheme: AppTheme()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.appTheme,});
  final AppTheme appTheme;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 780),
        builder: (context, child) {
          return GetMaterialApp(
            theme: appTheme.light,
            darkTheme: appTheme.dark,
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.light,
            initialRoute: AppPages.getInitial(),
            initialBinding: GlobalBindings(),
            getPages: AppPages.routes,
            //home: RootPage(),
          );
        }
    );
  }
}


