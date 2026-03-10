// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:get/get_connect/connect.dart';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/models/response_data.dart';
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/home/models/home_screen_model.dart';

class SettingsService {
  static const String baseUrl = Urls.baseUrl;

  Future<ResponseData> logout() async {
    try {
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();

      if (accessToken == null || refreshToken == null) {
        await SharedPreferencesHelper.clearAll();
        return ResponseData(
          isSuccess: false,
          statusCode: 401,
          errorMessage: 'Tokens not found',
          responseData: null,
        );
      }

      final url = Uri.parse(Urls.logout);
      print('Logout URL: $url');

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
        },
      );

      print('Response Status Code: ${response.statusCode}');

      final decodedData = jsonDecode(response.body);
      print('Decoded Response: $decodedData');

      if (response.statusCode == 200) {
        bool isSuccess = decodedData['success'] ?? false;
        print('Is Success: $isSuccess');

        if (isSuccess) {
          await SharedPreferencesHelper.clearAll();

          return ResponseData(
            isSuccess: true,
            statusCode: response.statusCode,
            errorMessage: '',
            responseData: decodedData,
          );
        } else {
          await SharedPreferencesHelper.clearAll();
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: decodedData['message'] ?? 'Logout failed',
            responseData: null,
          );
        }
      } else {
        await SharedPreferencesHelper.clearAll();
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decodedData['message'] ?? 'Logout failed',
          responseData: null,
        );
      }
    } catch (e) {
      print('Error: ${e.toString()}');
      await SharedPreferencesHelper.clearAll();
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: 'Network error: ${e.toString()}',
        responseData: null,
      );
    }
  }
}

class UserProfileResult {
  final bool isSuccess;
  final UserProfile? data;
  final String? errorMessage;

  UserProfileResult({required this.isSuccess, this.data, this.errorMessage});
}

class UserProfileService extends GetConnect {
  Future<UserProfileResult> fetchProfile() async {
    try {
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();

      if (accessToken == null || refreshToken == null) {
        return UserProfileResult(
          isSuccess: false,
          errorMessage: 'Tokens not found',
        );
      }

      final response = await get(
        Urls.getProfile,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = response.body is Map
            ? response.body
            : response.body as Map<String, dynamic>;

        final profile = UserProfile.fromJson(json);
        return UserProfileResult(isSuccess: true, data: profile);
      } else {
        return UserProfileResult(
          isSuccess: false,
          errorMessage: 'Failed: ${response.statusCode}',
        );
      }
    } catch (e) {
      return UserProfileResult(isSuccess: false, errorMessage: 'Error: $e');
    }
  }
}
