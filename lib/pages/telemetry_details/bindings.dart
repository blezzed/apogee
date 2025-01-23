
import 'package:get/get.dart';

import 'controller.dart';

class TelemetryDetailsBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<TelemetryDetailsController>(() => TelemetryDetailsController());
  }

}