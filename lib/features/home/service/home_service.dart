import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
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
}
