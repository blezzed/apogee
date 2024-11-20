import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../entities/ground_station.dart';
import '../entities/sat_pass.dart';
import '../entities/satellite_tle.dart';
import '../values/storage.dart';


class UserApi extends ChangeNotifier{

  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;

  String? _provider;
  String? get provider => _provider;

  UserApi();

  Future<List<GroundStationModel>> fetchGroundStations() async {
    final response = await http.get(
      Uri.parse('http://$BASE_API/api/ground_stations/'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> stations = json.decode(response.body);
      return stations.map((station) => GroundStationModel.fromJson(station)).toList();
    } else {
      throw Exception('Failed to load ground stations');
    }
  }

  Future<List<SatelliteTLE>> fetchSatellites() async {
    final response = await http.get(
      Uri.parse('http://$BASE_API/api/satellites/'), // Replace with your server URL
    );

    if (response.statusCode == 200) {
      List<dynamic> satelliteList = json.decode(response.body);
      return satelliteList.map((json) => SatelliteTLE.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load satellites');
    }
  }


  Future<List<SatellitePassModel>> fetchSatellitePasses() async {
    final response = await http.get(
      Uri.parse('http://$BASE_API/api/satellite_passes/'), // Replace with your server URL
    );

    if (response.statusCode == 200) {
      List<dynamic> passList = json.decode(response.body);
      return passList.map((json) => SatellitePassModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load satellite passes');
    }
  }


}