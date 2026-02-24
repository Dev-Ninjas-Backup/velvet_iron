import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/models/response_data.dart';
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';

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
      // print('Logout URL: $url');

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
        },
      );

      // print('Response Status Code: ${response.statusCode}');

      final decodedData = jsonDecode(response.body);
      // print('Decoded Response: $decodedData');

      if (response.statusCode == 200) {
        bool isSuccess = decodedData['success'] ?? false;
        // print('Is Success: $isSuccess');

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
      // print('Error: ${e.toString()}');
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
