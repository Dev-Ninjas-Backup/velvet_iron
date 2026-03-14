// ignore_for_file: avoid_print

import 'package:get/get_connect/connect.dart';
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';

class ThemeData {
  final String id;
  final String name;
  final bool isActive;
  final bool isUnlocked;
  final String tagline;
  final String description;
  final int unlockXp;

  ThemeData({
    required this.id,
    required this.name,
    required this.isActive,
    required this.isUnlocked,
    required this.tagline,
    required this.description,
    required this.unlockXp,
  });

  factory ThemeData.fromJson(Map<String, dynamic> json) {
    return ThemeData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      isActive: json['isAcitve'] ?? false, // Note: API has typo
      isUnlocked: json['isUnlocked'] ?? false,
      tagline: json['tagline'] ?? '',
      description: json['description'] ?? '',
      unlockXp: json['unlockXp'] ?? 0,
    );
  }
}

class ThemesResponse {
  final List<ThemeData> themes;
  final int unlockable;
  final int level;
  final int unlockedThemes;

  ThemesResponse({
    required this.themes,
    required this.unlockable,
    required this.level,
    required this.unlockedThemes,
  });

  factory ThemesResponse.fromJson(Map<String, dynamic> json) {
    return ThemesResponse(
      themes: List<ThemeData>.from(
        (json['themes'] as List<dynamic>).map(
          (x) => ThemeData.fromJson(x as Map<String, dynamic>),
        ),
      ),
      unlockable: json['Unlockable'] ?? 0,
      level: json['level'] ?? 1,
      unlockedThemes: json['unlockedThemes'] ?? 0,
    );
  }
}

class ThemesResult {
  final bool isSuccess;
  final ThemesResponse? data;
  final String? errorMessage;

  ThemesResult({required this.isSuccess, this.data, this.errorMessage});
}

class ThemesService extends GetConnect {
  Future<ThemesResult> fetchThemes() async {
    try {
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();

      if (accessToken == null || refreshToken == null) {
        return ThemesResult(
          isSuccess: false,
          errorMessage: 'Authentication tokens not found',
        );
      }

      final response = await get(
        Urls.getThemes,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
          'Content-Type': 'application/json',
        },
      );

      print('Themes Response Status: ${response.statusCode}');
      print('Themes Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final json = response.body is Map
            ? response.body
            : response.body as Map<String, dynamic>;

        final themesResponse = ThemesResponse.fromJson(json);
        return ThemesResult(isSuccess: true, data: themesResponse);
      } else {
        return ThemesResult(
          isSuccess: false,
          errorMessage: 'Failed: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching themes: $e');
      return ThemesResult(isSuccess: false, errorMessage: 'Error: $e');
    }
  }

  Future<Map<String, dynamic>> unlockTheme(String apiId) async {
    try {
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();

      if (accessToken == null || refreshToken == null) {
        return {'success': false, 'message': 'Authentication tokens not found'};
      }

      final response = await post(
        Urls.unlockNewTheme(apiId),
        '',
        headers: {
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
          'Content-Type': 'application/json',
        },
      );

      print('Unlock Theme Status: ${response.statusCode}');
      print('Unlock Theme Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          ...?(response.body is Map
              ? response.body as Map<String, dynamic>
              : null),
        };
      }

      if (response.statusCode == 400) {
        final message = response.body is Map
            ? (response.body['message'] ?? '')
            : '';
        if (message.toString().toLowerCase().contains('already unlocked')) {
          return {'success': true, 'message': message};
        }
      }

      final message = response.body is Map
          ? (response.body['message'] ?? 'Failed to unlock theme')
          : 'Failed to unlock theme';
      return {'success': false, 'message': message};
    } catch (e) {
      print('Error unlocking theme: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> activateTheme(String apiId) async {
    try {
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();

      if (accessToken == null || refreshToken == null) {
        return {'success': false, 'message': 'Authentication tokens not found'};
      }

      final response = await post(
        Urls.activateNewTheme(apiId),
        '',
        headers: {
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
          'Content-Type': 'application/json',
        },
      );

      print('Activate Theme Status: ${response.statusCode}');
      print('Activate Theme Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          ...?(response.body is Map
              ? response.body as Map<String, dynamic>
              : null),
        };
      }

      final message = response.body is Map
          ? (response.body['message'] ?? 'Failed to activate theme')
          : 'Failed to activate theme';
      return {'success': false, 'message': message};
    } catch (e) {
      print('Error activating theme: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
