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
          final isActive = companion['isActive'] == true || companion['isAcitve'] == true;
          if (isActive) {
            final name = companion['name'] ?? '';
            final imagePath = _getCompanionImagePath(name);
            await SharedPreferencesHelper.saveActiveCompanion(
              name: name,
              imagePath: imagePath,
            );
            return {
              'name': name,
              'imagePath': imagePath,
              'title': companion['title'] ?? '',
            };
          }
        }
        return await SharedPreferencesHelper.getActiveCompanion();
      } else {
        print('ERROR: Failed to fetch companions. ${response.body}');
        return await SharedPreferencesHelper.getActiveCompanion();
      }
    } catch (e) {
      print('EXCEPTION: $e');
      return await SharedPreferencesHelper.getActiveCompanion();
    }
  }

  /// Map companion name to image path with canonical & legacy alias support
  static String _getCompanionImagePath(String name) {
    final lower = name.toLowerCase().trim();
    if (lower.contains('thyra') || lower.contains('kael')) {
      return ImagePath.thyra;
    } else if (lower.contains('leon') || lower.contains('bram')) {
      return ImagePath.generalLeon;
    } else if (lower.contains('visepheron') || lower.contains('pyraxis') || lower.contains('pyrax')) {
      return ImagePath.visepheron;
    } else if (lower.contains('riven')) {
      return ImagePath.riven;
    }
    return ImagePath.thyra;
  }
}
