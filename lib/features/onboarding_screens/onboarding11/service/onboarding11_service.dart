// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';

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
}
