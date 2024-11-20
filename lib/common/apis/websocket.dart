
import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../entities/sat_pass.dart';
import '../provider/internet.dart';
import '../services/notification_service.dart';
import '../values/storage.dart';

class SatellitesData extends GetxService{

  static SatellitesData get to => Get.find();

// Observable list to store satellite positions
  RxList<Map<String, dynamic>> satellitePositions = <Map<String, dynamic>>[].obs;
  RxList<SatellitePassModel> satellitePasses = <SatellitePassModel>[].obs;

  // WebSocket channel
  late WebSocketChannel positionChannel;
  late WebSocketChannel passesChannel;

  RxBool webSocketConnection = false.obs;

  Timer? reconnectTimer;
  final int maxRetries = 5; // Maximum reconnection attempts
  int retryCount = 0;

  @override
  Future<void> onInit() async {
    _initializeListeners();
    _connectWebSocketForPositions();
    _connectWebSocketForPasses();
    super.onInit();
  }

  void _initializeListeners() {
    InternetProvider.to.hasInternet.listen((hasInternet) {
      if (hasInternet) {
        print("Internet available. Checking WebSocket connection...");
        _attemptReconnection();
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
      }, onError: (error) {
        print("WebSocket Error: $error");
      }, onDone: () {
        print("WebSocket Connection Closed");
        webSocketConnection.value = false;
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
              notification_id: int.parse(DateFormat('ddHHmm').format(pass.setPassTime!)),
              title: "Satellite Pass Alert",
              body: decodedData['message'],
            );
          }
        }
        webSocketConnection.value = true;
      }, onError: (error) {
        print("WebSocket Passes Error: $error");
      });
    } catch (e){
      print("Error connecting to WebSocket passes: $e");
      webSocketConnection.value = false;
      _scheduleReconnection();
    }
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

    // Sort the passes by rise time
    groupedPasses.sort((a, b) {
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
    reconnectTimer = Timer(Duration(seconds: 2 * (retryCount + 1)), () {
      retryCount++;
      print("Attempting reconnection... (Attempt $retryCount)");
      _attemptReconnection();
    });
  }

  void _attemptReconnection() {
    if (retryCount >= maxRetries) return;

    if (InternetProvider.to.hasInternet.value) {
      print("Internet is available. Reconnecting WebSockets...");
      _connectWebSocketForPositions();
      _connectWebSocketForPasses();
    } else {
      print("No internet. Waiting to reconnect...");
    }
  }

  @override
  void onClose() {
    // Close the WebSocket connection when the service is closed
    positionChannel.sink.close();
    passesChannel.sink.close();
    reconnectTimer?.cancel();
    super.onClose();
  }
}