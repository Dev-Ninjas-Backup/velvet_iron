// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/home/models/home_screen_model.dart';

class HomeService {
  Future<UserProfile> getProfile() async {
    final token = await SharedPreferencesHelper.getAccessToken() ?? '';
    final refreshToken = await SharedPreferencesHelper.getRefreshToken() ?? '';

    final response = await http.get(
      Uri.parse(Urls.homeScreen),
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token',
        'x-refresh-token': refreshToken,
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return UserProfile.fromJson(json);
    }

    throw Exception(
      'Failed to load profile. '
      'Status: ${response.statusCode} | Body: ${response.body}',
    );
  }

  /// Fetch active companion from API
  Future<Map<String, dynamic>?> fetchActiveCompanion() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();

      if (token == null ||
          token.isEmpty ||
          refreshToken == null ||
          refreshToken.isEmpty) {
        print('ERROR: Token or Refresh Token is null or empty!');
        return null;
      }

      final response = await http.get(
        Uri.parse(Urls.getCompanions),
        headers: {
          'Authorization': 'Bearer $token',
          'x-refresh-token': refreshToken,
          'Content-Type': 'application/json',
        },
      );

      print('COMPANIONS Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final List companions = data['companions'] ?? [];

        // Find the active companion
        for (var companion in companions) {
          if (companion['isAcitve'] == true) {
            final name = companion['name'] ?? '';
            final imagePath = _getCompanionImagePath(name);
            return {
              'name': name,
              'imagePath': imagePath,
              'title': companion['title'] ?? '',
            };
          }
        }
        return null;
      } else {
        print('ERROR: Failed to fetch companions. ${response.body}');
        return null;
      }
    } catch (e) {
      print('EXCEPTION: $e');
      return null;
    }
  }

  /// Map companion name to image path
  static String _getCompanionImagePath(String name) {
    switch (name) {
      case 'Ser Kael Thornwatch':
        return ImagePath.serKael;
      case 'Riven Ashcroft':
        return ImagePath.rvenAshcroft;
      case 'Pyraxis':
        return ImagePath.pyraxis;
      case 'Bram Ironledger':
        return ImagePath.bramIronledger;
      default:
        return ImagePath.serKael;
    }
  }
}
