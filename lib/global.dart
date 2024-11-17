

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'common/apis/websocket.dart';
import 'common/provider/internet.dart';
import 'common/services/notification_service.dart';
import 'common/services/storage.dart';
import 'common/store/user.dart';

class Global {
  static Future init() async{

    WidgetsFlutterBinding.ensureInitialized();

    Get.put<InternetProvider>(InternetProvider());

    await Get.putAsync<StorageService>(() => StorageService().init());

    await Get.putAsync<UserStore>(() => UserStore().onInit());

    Get.put<SatellitesData>(SatellitesData());

    Get.put<LocalNotificationService>(LocalNotificationService());

  }

}

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
  }

}