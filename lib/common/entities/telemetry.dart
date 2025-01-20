import 'dart:convert';

class TelemetryModel {
  final int satelliteId; // Foreign key to the satellite
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final double altitude;
  final double velocity;
  final String healthStatus; // 'Nominal', 'Warning', or 'Critical'
  final double? batteryVoltage; // Nullable field
  final bool solarPanelStatus;
  final double? temperature; // Nullable field
  final double? signalStrength; // Nullable field
  final double? pitch; // Nullable field
  final double? yaw; // Nullable field
  final double? roll; // Nullable field
  final double? powerConsumption; // Nullable field
  final double? dataRate; // Nullable field
  final String? errorCode; // Nullable field
  final String commandStatus; // 'Idle', 'Executing', 'Completed', or 'Failed'
  final Map<String, dynamic>? additionalData; // JSON field for extensibility

  TelemetryModel({
    required this.satelliteId,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.velocity,
    required this.healthStatus,
    this.batteryVoltage,
    required this.solarPanelStatus,
    this.temperature,
    this.signalStrength,
    this.pitch,
    this.yaw,
    this.roll,
    this.powerConsumption,
    this.dataRate,
    this.errorCode,
    required this.commandStatus,
    this.additionalData,
  });

  /// Factory constructor for creating a `TelemetryModel` from a JSON map
  factory TelemetryModel.fromJson(Map<String, dynamic> json) {
    return TelemetryModel(
      satelliteId: json['satelliteId'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      altitude: json['altitude'] as double,
      velocity: json['velocity'] as double,
      healthStatus: json['healthStatus'] as String,
      batteryVoltage: json['batteryVoltage'] as double?,
      solarPanelStatus: json['solarPanelStatus'] as bool,
      temperature: json['temperature'] as double?,
      signalStrength: json['signalStrength'] as double?,
      pitch: json['pitch'] as double?,
      yaw: json['yaw'] as double?,
      roll: json['roll'] as double?,
      powerConsumption: json['powerConsumption'] as double?,
      dataRate: json['dataRate'] as double?,
      errorCode: json['errorCode'] as String?,
      commandStatus: json['commandStatus'] as String,
      additionalData: json['additionalData'] != null
          ? jsonDecode(json['additionalData'] as String) as Map<String, dynamic>
          : null,
    );
  }

  /// Method for converting a `TelemetryModel` to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'satelliteId': satelliteId,
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'velocity': velocity,
      'healthStatus': healthStatus,
      'batteryVoltage': batteryVoltage,
      'solarPanelStatus': solarPanelStatus,
      'temperature': temperature,
      'signalStrength': signalStrength,
      'pitch': pitch,
      'yaw': yaw,
      'roll': roll,
      'powerConsumption': powerConsumption,
      'dataRate': dataRate,
      'errorCode': errorCode,
      'commandStatus': commandStatus,
      'additionalData':
      additionalData != null ? jsonEncode(additionalData) : null,
    };
  }

  @override
  String toString() {
    return 'TelemetryModel(satelliteId: $satelliteId, timestamp: $timestamp)';
  }
}
