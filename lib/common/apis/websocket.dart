
import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../entities/sat_pass.dart';
import '../services/notification_service.dart';

class SatellitesData extends GetxService{

  static SatellitesData get to => Get.find();

// Observable list to store satellite positions
  RxList<Map<String, dynamic>> satellitePositions = <Map<String, dynamic>>[].obs;
  RxList<SatellitePassModel> satellitePasses = <SatellitePassModel>[].obs;

  // WebSocket channel
  late WebSocketChannel positionChannel;
  late WebSocketChannel passesChannel;

  @override
  Future<void> onInit() async {
    // todo check if there is network
    // Initialize the WebSocket connection
    connectWebSocketForPositions();
    connectWebSocketForPasses();
    super.onInit();
  }

  // Function to connect to the WebSocket server
  void connectWebSocketForPositions() {
    // Replace 'ws://example.com/ws/satellite/' with your WebSocket URL
    positionChannel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.1.107:8001/ws/satellite/'), // Adjust the URL to your WebSocket server
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
    }, onError: (error) {
      print("WebSocket Error: $error");
    }, onDone: () {
      print("WebSocket Connection Closed");
    });
  }

  // Function to connect to WebSocket for passes
  void connectWebSocketForPasses() {
    passesChannel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.1.107:8001/ws/satellite_passes/'), // Adjust with your IP
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
            title: "Satellite Pass Alert",
            body: decodedData['message'],
          );
        }
      }
    }, onError: (error) {
      print("WebSocket Passes Error: $error");
    });
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



  @override
  void onClose() {
    // Close the WebSocket connection when the service is closed
    positionChannel.sink.close();
    passesChannel.sink.close();
    super.onClose();
  }
}