

class GroundStationModel {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final double altitude;
  final double startTrackingElevation;

  GroundStationModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.startTrackingElevation,
  });

  factory GroundStationModel.fromJson(Map<String, dynamic> json) {
    return GroundStationModel(
      id: json['id'],
      name: json['name'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      altitude: json['altitude'],
      startTrackingElevation: json['start_tracking_elevation'],
    );
  }
}

