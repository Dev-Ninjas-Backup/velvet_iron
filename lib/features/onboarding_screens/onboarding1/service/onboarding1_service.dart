// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';

class Onboarding1Service {
  static const String baseUrl = 'https://velvet.api.softvence.app';

  Future<Map<String, dynamic>?> fetchMyCompanions() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    final refreshToken = await SharedPreferencesHelper.getRefreshToken();

    if (token == null ||
        token.isEmpty ||
        refreshToken == null ||
        refreshToken.isEmpty) {
      print('ERROR: Token or Refresh Token is null or empty!');
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/companions/my-companions'),
        headers: {
          'Authorization': 'Bearer $token',
          'x-refresh-token': refreshToken,
          'Content-Type': 'application/json',
        },
      );

      print('RESPONSE Status: ${response.statusCode}');
      print('RESPONSE Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print('ERROR: Failed to fetch companions. ${response.body}');
        return null;
      }
    } catch (e) {
      print('EXCEPTION: $e');
      return null;
    }
  }

  Future<bool> unlockCompanion(String companionId) async {
    final token = await SharedPreferencesHelper.getAccessToken();
    final refreshToken = await SharedPreferencesHelper.getRefreshToken();

    if (token == null ||
        token.isEmpty ||
        refreshToken == null ||
        refreshToken.isEmpty) {
      print('ERROR: Token or Refresh Token is null or empty!');
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/onboarding/companion/$companionId'),
        headers: {
          'Authorization': 'Bearer $token',
          'x-refresh-token': refreshToken,
          'Content-Type': 'application/json',
        },
        body: '',
      );

      print('RESPONSE Status: ${response.statusCode}');
      print('RESPONSE Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return json['success'] == true;
      } else {
        print('ERROR: Failed to unlock companion. ${response.body}');
        return false;
      }
    } catch (e) {
      print('EXCEPTION: $e');
      return false;
    }
  }
}
