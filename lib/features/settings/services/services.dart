// ignore_for_file: avoid_print

import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/models/response_data.dart';
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';

class SettingsService {
  static const String baseUrl = Urls.baseUrl;

  Future<ResponseData> logout() async {
    try {
      print('=== Logout Request Started ===');

      // Get tokens from SharedPreferences
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();

      print('Access Token: ${accessToken?.substring(0, 20)}...');
      print('Refresh Token: ${refreshToken?.substring(0, 20)}...');

      if (accessToken == null || refreshToken == null) {
        print('Error: Tokens not found in SharedPreferences');
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
      print('Response Body: ${response.body}');

      final decodedData = jsonDecode(response.body);
      print('Decoded Response: $decodedData');

      if (response.statusCode == 200) {
        bool isSuccess = decodedData['success'] ?? false;
        print('Is Success: $isSuccess');

        if (isSuccess) {
          print('Clearing shared preferences...');
          await SharedPreferencesHelper.clearAll();
          print('Shared preferences cleared successfully');

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
      print('=== Logout Error ===');
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
