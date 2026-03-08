// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';

class OnboardingStatusService {
  Future<Map<String, dynamic>> getOnboardingStatus() async {
    try {
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();

      if (accessToken == null || refreshToken == null) {
        return {
          'success': false,
          'message': 'Authentication tokens not found',
          'iscomplete': false,
        };
      }

      final uri = Uri.parse(Urls.onboardingStatus);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
          'Content-Type': 'application/json',
        },
      );

      print('Onboarding Status Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedData = jsonDecode(response.body);
        final isComplete = decodedData['data']?['iscomplete'] ?? false;

        return {
          'success': true,
          'message': 'Onboarding status retrieved',
          'iscomplete': isComplete,
          'data': decodedData,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch onboarding status',
          'iscomplete': false,
        };
      }
    } catch (e) {
      print('Error fetching onboarding status: $e');
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
        'iscomplete': false,
      };
    }
  }
}
