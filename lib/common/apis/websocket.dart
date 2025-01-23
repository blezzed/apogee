
import 'dart:async';
import 'dart:convert';

import 'package:apogee/common/apis/telemetry.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../entities/sat_pass.dart';
import '../entities/telemetry.dart';
import '../provider/internet.dart';
import '../services/foreground_task.dart';
import '../services/notification_service.dart';
import '../values/storage.dart';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class SatellitesData extends GetxService with WidgetsBindingObserver{

  static SatellitesData get to => Get.find();

// Observable list to store satellite positions
  RxList<Map<String, dynamic>> satellitePositions = <Map<String, dynamic>>[].obs;
  RxList<SatellitePassModel> satellitePasses = <SatellitePassModel>[].obs;
  RxList<TelemetryModel> telemetryList = <TelemetryModel>[].obs;

  List<Map<String, dynamic>> webSocketMessageBuffer = [];

  // WebSocket channel
  late WebSocketChannel positionChannel;
  late WebSocketChannel passesChannel;
  late WebSocketChannel telemetryChannel;

  RxBool webSocketConnection = false.obs;

  Timer? reconnectTimer;
  final int maxRetries = 5; // Maximum reconnection attempts
  int retryCount = 0;

  Timer? pingTimer;

  void _startPing() {
    pingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      try {
        positionChannel.sink.add(jsonEncode({'type': 'ping'})); // Send a ping message to the server
      } catch (e) {
        print("Error sending ping: $e");
      }
    });
  }

  void _stopPing() {
    pingTimer?.cancel();
  }

  Future<void> _requestPermissions() async {
    final permission = await FlutterForegroundTask.checkNotificationPermission();
    if (permission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    // Check for battery optimizations (Android)
    if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }
  }

  @pragma('vm:entry-point')
  void startCallback() {
    FlutterForegroundTask.setTaskHandler(SatelliteForegroundTask());
  }

  @override
  Future<void> onInit() async {

    WidgetsBinding.instance.addObserver(this);

    await _requestPermissions();

    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'satellite_channel',
        channelName: 'Satellite Tracking Service',
        channelDescription: 'Keeps the WebSocket connection alive for satellite tracking.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );

    // Start the foreground service
    await FlutterForegroundTask.startService(
      notificationTitle: 'Satellite Tracking',
      notificationText: 'WebSocket connection is active.',
      callback: startCallback,
    );

    _initializeListeners();
    /*_connectWebSocketForPositions();
    _connectWebSocketForPasses();*/

    telemetryList.value = await TelemetryService().fetchTelemetry();

    FlutterForegroundTask.addTaskDataCallback((data) {
      if (data is Map<String, dynamic>) {
        if (data['action'] == 'check_websocket') {
          // Check and reconnect WebSocket if disconnected
          if (!webSocketConnection.value) {
            print("WebSocket disconnected. Attempting reconnection...");
            attemptReconnection();
          }
        }

        _processForegroundTaskData(data);
      }
    });

    super.onInit();
  }

  void _processForegroundTaskData(Map<String, dynamic> data) {
    print("Foreground Task Data: $data");

    if (data['satellite_passes'] != null) {
      final processedPasses = processSatellitePasses(data['satellite_passes']);
      satellitePasses.value = processedPasses;

      if (data['message'] != null) {
        LocalNotificationService.to.showNotificationAndroid(
          notification_id: DateTime.now().millisecondsSinceEpoch,
          title: "Satellite Pass Alert",
          body: data['message'],
        );
      }
    }
  }

  void _initializeListeners() {
    InternetProvider.to.hasInternet.listen((hasInternet) {
      if (hasInternet) {
        print("Internet available. Checking WebSocket connection...");
        attemptReconnection();
      } else {
        print("No internet connection. WebSocket connections paused.");
      }
    });
  }

  // Function to connect to the WebSocket server
  void _connectWebSocketForPositions() {
    try{
      // Replace 'ws://example.com/ws/satellite/' with your WebSocket URL
      positionChannel = WebSocketChannel.connect(
        Uri.parse('ws://$BASE_API/ws/satellite/'), // Adjust the URL to your WebSocket server
      );

      // Listen to the incoming WebSocket data
      positionChannel.stream.listen((data) {
        print("Received WebSocket Data: $data");

        // Decode the JSON data
        final decodedData = jsonDecode(data);

        // Check if the data has a 'position' key
        if (decodedData['position'] != null) {
          // Update the observable list with the satellite positions
          satellitePositions.value = List<Map<String, dynamic>>.from(decodedData['position']);
        }
        webSocketConnection.value = true;
        retryCount = 0;
      }, onError: (error) {
        print("WebSocket Error: $error");
        webSocketConnection.value = false;
        _scheduleReconnection();
      }, onDone: () {
        print("WebSocket Connection Closed");
        webSocketConnection.value = false;
        _scheduleReconnection();
      });
    } catch (e){
      print("Error connecting to WebSocket: $e");
      _scheduleReconnection();
    }
  }

  // Function to connect to WebSocket for passes
  void _connectWebSocketForPasses() {
    try{
      passesChannel = WebSocketChannel.connect(
        Uri.parse('ws://$BASE_API/ws/satellite_passes/'), // Adjust with your IP
      );

      passesChannel.stream.listen((data) {
        print("Received WebSocket Passes Data: $data");
        final decodedData = jsonDecode(data);
        if (decodedData['satellite_passes'] != null) {
          // Process the passes data into the required model format
          final processedPasses = processSatellitePasses(decodedData['satellite_passes']);
          satellitePasses.value = processedPasses;

          if (decodedData['message'] != null) {
            final pass = decodedData['pass_data'];
            LocalNotificationService.to.showNotificationAndroid(
              notification_id: decodedData['id'],
              title: "Satellite Pass Alert",
              body: decodedData['message'],
            );
            // Add the message to the buffer
            webSocketMessageBuffer.add(decodedData);

            // Optionally send the data to the foreground task
            /*FlutterForegroundTask.updateService(
              notificationTitle: "Satellite Pass Alert",
              notificationText: decodedData['message'],
            );*/
          }


        }
        webSocketConnection.value = true;
      }, onError: (error) {
        print("WebSocket Passes Error: $error");
        webSocketConnection.value = false;
        _scheduleReconnection();
      });
    } catch (e){
      print("Error connecting to WebSocket passes: $e");
      webSocketConnection.value = false;
      _scheduleReconnection();
    }
  }

  // Function to connect to WebSocket for telemetry
  void _connectWebSocketForTelemetry() async {
    try{
      telemetryChannel = WebSocketChannel.connect(
        Uri.parse('ws://$BASE_API/ws/telemetry/'), // Adjust with your IP
      );

      telemetryChannel.stream.listen((data) async {
        print("Received WebSocket Telemetry Data: $data");
        final decodedData = jsonDecode(data);
        if (decodedData['id'] != null) {

          LocalNotificationService.to.showNotificationAndroid(
            notification_id: decodedData['id'],
            title: "Telemetry Update for ${decodedData['satellite']}",
            body: "Time: ${decodedData['timestamp']} \nHealth: ${decodedData['health_status']} \nCommand status: ${decodedData['command_status']}",
          );
          print("Time: ${decodedData['timestamp']} \nHealth: ${decodedData['health_status']} \nCommand status: ${decodedData['command_status']}");
          // Add the message to the buffer
          webSocketMessageBuffer.add(decodedData);

        }
        telemetryList.value = await TelemetryService().fetchTelemetry();
        webSocketConnection.value = true;
      }, onError: (error) {
        print("WebSocket Passes Error: $error");
        webSocketConnection.value = false;
        _scheduleReconnection();
      });
    } catch (e){
      print("Error connecting to WebSocket telemetry: $e");
      webSocketConnection.value = false;
      _scheduleReconnection();
    }

    telemetryList.value = await TelemetryService().fetchTelemetry();
  }

  List<SatellitePassModel> processSatellitePasses(List<dynamic> passesData) {
    List<SatellitePassModel> groupedPasses = [];
    String? satelliteName;
    DateTime? riseTime;
    DateTime? setTime;
    double? maxElevation;

    for (var i = 0; i < passesData.length; i++) {
      var pass = passesData[i];

      // Assign the satellite name
      satelliteName = pass['satellite'];

      // If it's a "rise" event, store the rise time
      if (pass['event'] == 'Satellite Rise') {
        riseTime = DateTime.parse(pass['event_time']);
      }

      // If it's a "culminate" event, store max elevation
      if (pass['event'] == 'culminate') {
        maxElevation = pass['elevation'];
      }

      // If it's a "set" event, store the set time and finalize the pass
      if (pass['event'] == 'Satellite Set') {
        setTime = DateTime.parse(pass['event_time']); 

        // Create a SatellitePassModel and add it to the list
        SatellitePassModel satellitePass = SatellitePassModel(
          satelliteName: satelliteName,
          risePassTime: riseTime,
          setPassTime: setTime,
          maxElevation: maxElevation,
          azimuth: pass['azimuth']?.toDouble(),
          distance: pass['distance']?.toDouble(),
          createdAt: DateTime.now(), // Assuming createdAt is now
        );

        groupedPasses.add(satellitePass);
      }
    }

    print('grouped pass: $groupedPasses');
    // Sort the passes by rise time

    groupedPasses.sort((a, b) {
      print(a.risePassTime);
      return a.risePassTime!.compareTo(b.risePassTime!);
    });

    return groupedPasses;
  }

  void _scheduleReconnection() {
    if (retryCount >= maxRetries || !InternetProvider.to.hasInternet.value) {
      print("Max reconnection attempts reached or no internet. Stopping reconnection.");
      return;
    }

    reconnectTimer?.cancel();
    final delay = Duration(seconds: 2 * (1 << retryCount)); // Exponential backoff
    reconnectTimer = Timer(delay, () {
      retryCount++;
      print("Attempting reconnection... (Attempt $retryCount)");
      attemptReconnection();
    });
  }

  void attemptReconnection() {
    if (retryCount >= maxRetries) return;

    if (InternetProvider.to.hasInternet.value) {
      print("Internet is available. Reconnecting WebSockets...");
      _connectWebSocketForPositions();
      _connectWebSocketForPasses();
      _connectWebSocketForTelemetry();
    } else {
      print("No internet. Waiting to reconnect...");
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopPing();
    positionChannel.sink.close();
    passesChannel.sink.close();
    telemetryChannel.sink.close();
    reconnectTimer?.cancel();

    FlutterForegroundTask.stopService();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("App resumed. Checking WebSocket connection...");
      attemptReconnection();
    }
  }
}