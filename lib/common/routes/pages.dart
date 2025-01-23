
import 'package:apogee/pages/home/index.dart';
import 'package:apogee/pages/telemetry_details/index.dart';
import 'package:get/get.dart';

import 'routes.dart';

class AppPages{


  static String getInitial() => AppRoutes.Home;

  static List<GetPage> routes = [

    GetPage(
        name: AppRoutes.Home,
        page: () => const HomePage(),
        binding: HomeBinding(),
    ),

    GetPage(
      name: AppRoutes.TelemetryDetails,
      page: () => const TelemetryDetailsPage(),
      binding: TelemetryDetailsBinding(),
    ),

    /*GetPage(
        name: AppRoutes.Sign_In,
        page: () => const AuthPage(),
        binding: AuthBinding(),
    ),

    GetPage(
      name: AppRoutes.Home,
      page: () => const HomePage(),
      binding: HomeBinding(),
      middlewares: [
        RouteAuthMiddleware(priority: 1),
      ],
    ),*/


  ];
}

class TelemetryDetails {
}