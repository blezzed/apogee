
import 'package:apogee/pages/home/index.dart';
import 'package:get/get.dart';

import '../middlewares/router_auth.dart';
import 'routes.dart';

class AppPages{


  static String getInitial() => AppRoutes.Home;

  static List<GetPage> routes = [

    GetPage(
        name: AppRoutes.Home,
        page: () => const HomePage(),
        binding: HomeBinding(),
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