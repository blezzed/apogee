import 'dart:convert';
import 'package:apogee/common/entities/entities.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../store/user.dart';
import '../values/storage.dart';

class AuthApiService {
  static const String baseUrl = 'http://$BASE_API/auth/jwt/create/';
  static const String userProfileUrl = 'http://$BASE_API/auth/users/me/';
  static const _storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>> loginUser(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Save tokens securely
        await _storage.write(key: 'access_token', value: data['access']);
        await _storage.write(key: 'refresh_token', value: data['refresh']);
        UserStore.to.setToken(data['access']);

        await AuthApiService.fetchUserData();

        return {'success': true};
      } else {
        print(response.body);
        return {'success': false, 'message': 'Invalid email or password'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred'};
    }
  }

  static Future<Map<String, dynamic>> fetchUserData() async {
    final token = await getAccessToken();

    try {
      final response = await http.get(
        Uri.parse(userProfileUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        print(userData);

        UserData user = UserData.fromJson(userData);
        UserStore.to.saveProfile(user);

        return {'success': true, 'data': userData};
      } else {
        return {'success': false, 'message': 'Failed to fetch user data'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred'};
    }
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  static Future<void> logout() async {
    await _storage.deleteAll();
  }
}
