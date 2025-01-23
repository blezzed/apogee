import 'dart:convert';
import 'package:http/http.dart' as http;

import '../entities/telemetry.dart';
import '../values/storage.dart';

class TelemetryService {
  final String baseUrl = "http://$BASE_API/api/telemetry/";

  /// Fetch telemetry data from the API and parse it into a list of TelemetryModel objects
  Future<List<TelemetryModel>> fetchTelemetry() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        // Decode JSON response

        final List<dynamic> telemetryJson = jsonDecode(response.body);
        print(telemetryJson);
        // Map the JSON data to a list of TelemetryModel objects
        return telemetryJson.map((json) {
          return TelemetryModel.fromJson(json as Map<String, dynamic>);
        }).toList();
      } else {
        throw Exception("Failed to load telemetry data: ${response.statusCode}");
      }
    } catch (e, trace) {
      throw Exception("An error occurred while fetching telemetry data: $e, $trace");
    }
  }
}
