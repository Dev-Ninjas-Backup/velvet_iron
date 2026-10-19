// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/app_timezone_helper.dart';
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/home/models/home_screen_model.dart';

class HomeService {
  Future<UserProfile> getProfile() async {
    final token = await SharedPreferencesHelper.getAccessToken() ?? '';
    final refreshToken = await SharedPreferencesHelper.getRefreshToken() ?? '';
    final timezone = await AppTimezoneHelper.getTimezoneName();

    final response = await http.get(
      Uri.parse(Urls.homeScreen),
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token',
        'x-refresh-token': refreshToken,
        'x-timezone': timezone,
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

  /// Fetch dynamic contextual companion dialogue from backend
  Future<Map<String, dynamic>?> fetchCompanionDialogue() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();
      if (token == null || token.isEmpty) return null;

      final response = await http.get(
        Uri.parse(Urls.companionDialogue),
        headers: {
          'Authorization': 'Bearer $token',
          'x-refresh-token': refreshToken ?? '',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['status'] == 'success' && data['data'] != null) {
          return data['data'] as Map<String, dynamic>;
        }
      }
      return null;
    } catch (e) {
      print('[HomeService] Error fetching companion dialogue: $e');
      return null;
    }
  }

  /// Claim the daily login reward (POST /profile/daily-login)
  /// Evaluated using user local timezone boundaries to award XP once per local day
  Future<Map<String, dynamic>> claimDailyLoginReward() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken() ?? '';
      final refreshToken =
          await SharedPreferencesHelper.getRefreshToken() ?? '';
      if (token.isEmpty) {
        return {'success': false, 'message': 'No access token available'};
      }

      final timezone = await AppTimezoneHelper.getTimezoneName();
      final todayDate = AppTimezoneHelper.getTodayDateString();

      final response = await http.post(
        Uri.parse(Urls.dailyLogsXP),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
          'x-refresh-token': refreshToken,
          'Content-Type': 'application/json',
          'x-timezone': timezone,
        },
        body: jsonEncode({'xp': 25}),
      );

      print(
        '🔵 [HomeService] Daily Login Status: ${response.statusCode}, Body: ${response.body}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final isSuccess = data['success'] == true;
        final xpAwarded =
            (data['xpAwarded'] as num?)?.toInt() ?? (isSuccess ? 25 : 0);
        final message =
            data['message'] as String? ?? 'Daily login reward processed';

        // Save last daily login date to mark as claimed today in user's local timezone
        await SharedPreferencesHelper.saveLastDailyLoginDate(todayDate);
        await SharedPreferencesHelper.saveLastDailyLoginTimestamp(
          DateTime.now(),
        );

        return {
          'success': true,
          'xpAwarded': xpAwarded,
          'message': message,
          'data': data,
        };
      }

      return {
        'success': false,
        'statusCode': response.statusCode,
        'message':
            'Failed to claim daily login reward (${response.statusCode})',
      };
    } catch (e) {
      print('🔴 [HomeService] Daily Login Exception: $e');
      return {
        'success': false,
        'message': 'Error claiming daily login: $e',
      };
    }
  }
}
