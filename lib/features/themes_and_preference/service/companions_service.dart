// ignore_for_file: avoid_print

import 'package:get/get_connect/connect.dart';
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';

class CompanionData {
  final String id;
  final String name;
  final String title;
  final String quote;
  final bool isActive;
  final bool isUnlocked;
  final int unlockXp;

  CompanionData({
    required this.id,
    required this.name,
    required this.title,
    required this.quote,
    required this.isActive,
    required this.isUnlocked,
    required this.unlockXp,
  });

  factory CompanionData.fromJson(Map<String, dynamic> json) {
    return CompanionData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      quote: json['quote'] ?? '',
      isActive: json['isAcitve'] ?? false, // Note: API has typo
      isUnlocked: json['isUnlocked'] ?? false,
      unlockXp: json['unlockXp'] ?? 0,
    );
  }
}

class CompanionsResponse {
  final List<CompanionData> companions;
  final int unlockable;
  final int level;
  final int unlockedCompanions;

  CompanionsResponse({
    required this.companions,
    required this.unlockable,
    required this.level,
    required this.unlockedCompanions,
  });

  factory CompanionsResponse.fromJson(Map<String, dynamic> json) {
    return CompanionsResponse(
      companions: List<CompanionData>.from(
        (json['companions'] as List<dynamic>).map(
          (x) => CompanionData.fromJson(x as Map<String, dynamic>),
        ),
      ),
      unlockable: json['Unlockable'] ?? 0,
      level: json['level'] ?? 1,
      unlockedCompanions: json['unlockedCompanions'] ?? 0,
    );
  }
}

class CompanionsResult {
  final bool isSuccess;
  final CompanionsResponse? data;
  final String? errorMessage;

  CompanionsResult({required this.isSuccess, this.data, this.errorMessage});
}

class CompanionsService extends GetConnect {
  Future<CompanionsResult> fetchCompanions() async {
    try {
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();

      if (accessToken == null || refreshToken == null) {
        return CompanionsResult(
          isSuccess: false,
          errorMessage: 'Authentication tokens not found',
        );
      }

      final response = await get(
        Urls.getCompanions,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
          'Content-Type': 'application/json',
        },
      );

      print('Companions Response Status: ${response.statusCode}');
      print('Companions Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final json = response.body is Map
            ? response.body
            : response.body as Map<String, dynamic>;

        final companionsResponse = CompanionsResponse.fromJson(json);
        return CompanionsResult(isSuccess: true, data: companionsResponse);
      } else {
        return CompanionsResult(
          isSuccess: false,
          errorMessage: 'Failed: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching companions: $e');
      return CompanionsResult(isSuccess: false, errorMessage: 'Error: $e');
    }
  }

  Future<Map<String, dynamic>> unlockCompanion(String apiId) async {
    try {
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();

      if (accessToken == null || refreshToken == null) {
        return {'success': false, 'message': 'Authentication tokens not found'};
      }

      final response = await post(
        Urls.unlockNewCompanion(apiId),
        '',
        headers: {
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
          'Content-Type': 'application/json',
        },
      );

      print('Unlock Companion Status: ${response.statusCode}');
      print('Unlock Companion Body: ${response.body}');

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
          ? (response.body['message'] ?? 'Failed to unlock companion')
          : 'Failed to unlock companion';
      return {'success': false, 'message': message};
    } catch (e) {
      print('Error unlocking companion: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> activateCompanion(String apiId) async {
    try {
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();

      if (accessToken == null || refreshToken == null) {
        return {'success': false, 'message': 'Authentication tokens not found'};
      }

      final response = await post(
        Urls.activateNewCompanion(apiId),
        '',
        headers: {
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
          'Content-Type': 'application/json',
        },
      );

      print('Activate Companion Status: ${response.statusCode}');
      print('Activate Companion Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          ...?(response.body is Map
              ? response.body as Map<String, dynamic>
              : null),
        };
      }

      final message = response.body is Map
          ? (response.body['message'] ?? 'Failed to activate companion')
          : 'Failed to activate companion';
      return {'success': false, 'message': message};
    } catch (e) {
      print('Error activating companion: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
