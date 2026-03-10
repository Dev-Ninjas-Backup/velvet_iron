// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';

class Onboarding11Service {
  Future<Map<String, dynamic>> completeOnboarding() async {
    try {
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();

      if (accessToken == null || refreshToken == null) {
        return {'success': false, 'message': 'Authentication tokens not found'};
      }

      final uri = Uri.parse(Urls.onboardingStatus);

      // Create multipart request
      final request = http.MultipartRequest('PATCH', uri);

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $accessToken',
        'x-refresh-token': refreshToken,
      });

      // Add form fields
      request.fields['iscomplete'] = 'true';
      request.fields['fitnessGoal'] = '';

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('Response Status: ${response.statusCode}');
      print('Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Onboarding completed successfully',
          'data': responseBody,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to complete onboarding',
          'status': response.statusCode,
        };
      }
    } catch (e) {
      print('Error: ${e.toString()}');
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  /// Fetch companions and return the active one with its image path
  Future<Map<String, dynamic>?> fetchActiveCompanion() async {
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
        Uri.parse(Urls.getCompanions),
        headers: {
          'Authorization': 'Bearer $token',
          'x-refresh-token': refreshToken,
          'Content-Type': 'application/json',
        },
      );

      print('COMPANIONS Response Status: ${response.statusCode}');
      print('COMPANIONS Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final List companions = data['companions'] ?? [];

        // Find the active companion
        for (var companion in companions) {
          if (companion['isAcitve'] == true) {
            final name = companion['name'] ?? '';
            final imagePath = _getImagePath(name);
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
  static String _getImagePath(String name) {
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
