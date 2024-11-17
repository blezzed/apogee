import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class InternetProvider extends GetxService {

final RxBool _hasInternet = false.obs;

RxBool get hasInternet => _hasInternet;

late StreamSubscription<List<ConnectivityResult>> subscription;

static InternetProvider get to => Get.find();

Future checkInternetConnection() async {
  var result = await Connectivity().checkConnectivity();
  if (result == ConnectivityResult.none) {
    _hasInternet.value = false;
    print("NOT TO THE INTERNET");
  } else {
    _hasInternet.value = true;
    print("CONNECTED TO THE INTERNET");
  }
  final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult.contains(ConnectivityResult.mobile)) {
    print("Mobile network available.");
  } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
    print("Wi-fi is available.");
  } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
    print("Vpn connection active.");
  } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
    print("Bluetooth connection available.");
  }
}

@override void
onInit() async {
  await checkInternetConnection();

  subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.mobile)) {
      _hasInternet.value = true;
      print("Mobile network available.");
    } else if (result.contains(ConnectivityResult.wifi)) {
      _hasInternet.value = true;
      print("Wi-fi is available.");
    } else if (result.contains(ConnectivityResult.vpn)) {
      _hasInternet.value = true;
      print("Vpn connection active.");
    } else {
      _hasInternet.value = false;
      print("DISCONNECTED TO THE INTERNET");
    }

  });

  super.onInit();
}

@override
void onReady() {
  _hasInternet.listen((value) {
    if (value == true) {
      print("CONNECTED TO THE INTERNET");
    } else {
      print("DISCONNECTED TO THE INTERNET");
    }
  });
  super.onReady();
}}
