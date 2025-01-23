class SatelliteTLE {
  final int id;
  final String name;
  final String? line1;
  final String? line2;
  final bool autoTracking;
  final String orbitStatus;
  final String tleGroup;

  SatelliteTLE({
    required this.id,
    required this.name,
    this.line1,
    this.line2,
    required this.autoTracking,
    required this.orbitStatus,
    required this.tleGroup,
  });

  factory SatelliteTLE.fromJson(Map<String, dynamic> json) {
    return SatelliteTLE(
      id: json['id'],
      name: json['name'],
      line1: json['line1'],
      line2: json['line2'],
      autoTracking: json['auto_tracking'],
      orbitStatus: json['orbit_status'],
      tleGroup: json['tle_group'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'line1': line1,
      'line2': line2,
      'auto_tracking': autoTracking,
      'orbit_status': orbitStatus,
      'tle_group': tleGroup,
    };
  }

  @override
  String toString() {
    return 'SatelliteTLE(name: $name, orbitStatus: $orbitStatus, tleGroup: $tleGroup)';
  }
}
