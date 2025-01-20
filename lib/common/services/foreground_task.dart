
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import '../apis/websocket.dart';

class SatelliteForegroundTask extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print('onStart(starter: ${starter.name})');
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    print('onDestroy');
    FlutterForegroundTask.updateService(
      notificationTitle: "Server",
      notificationText: "The server is down for a while.",
    );
  }

  @override
  void onNotificationPressed() {
    print("Foreground task notification pressed.");
    // Handle notification press if needed
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    print("Foreground task event triggered.");

    if (SatellitesData.to.webSocketMessageBuffer.isNotEmpty) {
      // Get the latest message from the buffer
      final message = SatellitesData.to.webSocketMessageBuffer.removeAt(0);

      // Send the message to the main isolate for further processing
      FlutterForegroundTask.sendDataToMain(message);

      // Optionally trigger a local notification
      if (message['message'] != null) {
        FlutterForegroundTask.updateService(
          notificationTitle: "Satellite Alert",
          notificationText: message['message'],
        );
      }

      // Notify the main isolate to check WebSocket connection
      FlutterForegroundTask.sendDataToMain({
        "action": "check_websocket",
        "timestampMillis": timestamp.millisecondsSinceEpoch,
      });

      final batch = SatellitesData.to.webSocketMessageBuffer.take(10).toList();
      SatellitesData.to.webSocketMessageBuffer.removeRange(0, batch.length);

      FlutterForegroundTask.sendDataToMain({
        "action": "process_batch",
        "data": batch,
      });

      FlutterForegroundTask.updateService(
        notificationTitle: "Satellite Data Received",
        notificationText: "Processing ${batch.length} new messages.",
      );
    }
  }

  @override
  void onReceiveData(Object data) {
    print('onReceiveData: $data');
  }

}