class SatellitePassModel {
  final String? satelliteName;
  final DateTime? risePassTime;
  final DateTime? setPassTime;
  final double? maxElevation;
  final double? azimuth;
  final double? distance;
  final DateTime? createdAt;

  SatellitePassModel({
    this.satelliteName,
    this.risePassTime,
    this.setPassTime,
    this.maxElevation,
    this.azimuth,
    this.distance,
    this.createdAt,
  });

  factory SatellitePassModel.fromJson(Map<String, dynamic> json) {
    return SatellitePassModel(
      satelliteName: json['satellite_name'],
      risePassTime: json['rise_pass_time'] != null
          ? DateTime.parse(json['rise_pass_time'])
          : null,
      setPassTime: json['set_pass_time'] != null
          ? DateTime.parse(json['set_pass_time'])
          : null,
      maxElevation: json['max_elevation']?.toDouble(),
      azimuth: json['azimuth']?.toDouble(),
      distance: json['distance']?.toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'satellite_name': satelliteName,
      'rise_pass_time': risePassTime?.toIso8601String(),
      'set_pass_time': setPassTime?.toIso8601String(),
      'max_elevation': maxElevation,
      'azimuth': azimuth,
      'distance': distance,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
