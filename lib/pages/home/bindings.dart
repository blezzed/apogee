
import 'package:get/get.dart';

import '../../common/apis/websocket.dart';
import 'controller.dart';

class HomeBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<SatellitesData>(SatellitesData());
    Get.lazyPut<HomeController>(() => HomeController());
  }

}