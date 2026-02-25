// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/onboarding_screens/theme_onboading/model/theme_onboarding_model.dart';

class ThemeOnboardingService {
  Future<Map<String, dynamic>> unlockTheme(String themeId) async {
    final token = await SharedPreferencesHelper.getAccessToken();
    final refreshToken = await SharedPreferencesHelper.getRefreshToken();

    if (token == null ||
        token.isEmpty ||
        refreshToken == null ||
        refreshToken.isEmpty) {
      print('ERROR Token or Refresh Token is null or empty!');
      return {
        'success': false,
        'message': 'Token or Refresh Token is null or empty!',
      };
    }

    try {
      final response = await http.post(
        Uri.parse('${Urls.baseUrl}/onboarding/theme/$themeId'),
        headers: {
          'Authorization': 'Bearer $token',
          'x-refresh-token': refreshToken,
          'Content-Type': 'application/json',
        },
        body: '',
      );

      print('RESPONSE Status: ${response.statusCode}');
      print('RESPONSE Body: ${response.body}');

      final decoded = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('SUCCESS Theme unlocked and activated!');
        return {...decoded, 'success': true};
      }

      if (response.statusCode == 400) {
        final message = decoded['message'] ?? '';
        if (message.toString().toLowerCase().contains('already unlocked')) {
          print('INFO: Theme already unlocked — treating as success');
          return {'success': true, 'message': message};
        }
      }

      print('ERROR Failed to unlock theme. Error: ${response.body}');
      return {...decoded, 'success': false};
    } catch (e) {
      print('EXCEPTION Error unlocking theme: $e');
      return {'success': false, 'message': 'Error unlocking theme: $e'};
    }
  }

  Future<ThemeResponse?> fetchMyThemes() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    final refreshToken = await SharedPreferencesHelper.getRefreshToken();

    if (token == null ||
        token.isEmpty ||
        refreshToken == null ||
        refreshToken.isEmpty) {
      print('ERROR Token or Refresh Token is null or empty!');
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse(Urls.getThemes),
        headers: {
          'Authorization': 'Bearer $token',
          'x-refresh-token': refreshToken,
          'Content-Type': 'application/json',
        },
      );

      print('RESPONSE Status: ${response.statusCode}');
      print('RESPONSE Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        JsonEncoder encoder = const JsonEncoder.withIndent('  ');
        String prettyprint = encoder.convert(data);
        print('SUCCESS Themes Data:\n$prettyprint');

        return ThemeResponse.fromJson(data);
      } else {
        print('ERROR Failed to fetch themes. Error: ${response.body}');
        return null;
      }
    } catch (e) {
      print('EXCEPTION Error fetching themes: $e');
      return null;
    }
  }
}
