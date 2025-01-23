import 'dart:convert';

import 'package:apogee/common/entities/satellite_tle.dart';

class TelemetryModel {
  final int id;
  final SatelliteTLE satellite;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final double altitude;
  final double velocity;
  final String health_status; // 'Nominal', 'Warning', or 'Critical'
  final double? battery_voltage;
  final bool solar_panel_status;
  final double? temperature;
  final double? signal_strength;
  final double? pitch;
  final double? yaw;
  final double? roll;
  final double? power_consumption;
  final double? data_rate;
  final String? error_code;
  final String command_status; // 'Idle', 'Executing', 'Completed', or 'Failed'
  final Map<String, dynamic>? additionalData;

  TelemetryModel({
    required this.id,
    required this.satellite,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.velocity,
    required this.health_status,
    this.battery_voltage,
    required this.solar_panel_status,
    this.temperature,
    this.signal_strength,
    this.pitch,
    this.yaw,
    this.roll,
    this.power_consumption,
    this.data_rate,
    this.error_code,
    required this.command_status,
    this.additionalData,
  });

  /// Factory constructor for creating a `TelemetryModel` from a JSON map
  factory TelemetryModel.fromJson(Map<String, dynamic> json) {
    return TelemetryModel(
      id: json['id'],
      satellite: SatelliteTLE.fromJson(json['satellite']),
      timestamp: DateTime.parse(json['timestamp']),
      latitude: json['latitude'],
      longitude: json['longitude'],
      altitude: json['altitude'],
      velocity: json['velocity'],
      health_status: json['health_status'],
      battery_voltage: json['battery_voltage'],
      solar_panel_status: json['solar_panel_status'],
      temperature: json['temperature'],
      signal_strength: json['signal_strength'],
      pitch: json['pitch'],
      yaw: json['yaw'],
      roll: json['roll'],
      power_consumption: json['power_consumption'],
      data_rate: json['data_rate'],
      error_code: json['error_code'],
      command_status: json['command_status'],
      additionalData: json['additionalData'] != null
          ? jsonDecode(json['additionalData'])
          : null,
    );
  }

  /// Method for converting a `TelemetryModel` to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'satellite': satellite.toJson(),
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'velocity': velocity,
      'health_status': health_status,
      'battery_voltage': battery_voltage,
      'solar_panel_status': solar_panel_status,
      'temperature': temperature,
      'signal_strength': signal_strength,
      'pitch': pitch,
      'yaw': yaw,
      'roll': roll,
      'power_consumption': power_consumption,
      'data_rate': data_rate,
      'error_code': error_code,
      'command_status': command_status,
      'additionalData':
      additionalData != null ? jsonEncode(additionalData) : null,
    };
  }

  @override
  String toString() {
    return 'TelemetryModel(id: $id, timestamp: $timestamp)';
  }
}
