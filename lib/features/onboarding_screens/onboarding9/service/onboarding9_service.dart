// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/models/response_data.dart';
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';

class Onboarding9Service {
  Future<ResponseData> addMedication({
    required String name,
    required String type,
    required int doseMg,
  }) async {
    try {
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();

      if (accessToken == null || refreshToken == null) {
        print(
          '[DEBUG] Token missing: accessToken=$accessToken, refreshToken=$refreshToken',
        );
        return ResponseData(
          isSuccess: false,
          statusCode: 401,
          errorMessage: 'Authentication tokens not found',
          responseData: null,
        );
      }

      final requestBody = {
        'name': name,
        'type': type.toUpperCase(),
        'doseMg': doseMg,
      };
      print('[DEBUG] POST ${Urls.medication}');
      print(
        '[DEBUG] Headers: Authorization=Bearer $accessToken, x-refresh-token=$refreshToken',
      );
      print('[DEBUG] Body: $requestBody');

      final response = await http.post(
        Uri.parse(Urls.medication),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('[DEBUG] Response status: ${response.statusCode}');
      print('[DEBUG] Response body: ${response.body}');

      final decodedData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (decodedData['id'] != null) {
          print('[DEBUG] Medication added successfully: ${decodedData['id']}');
          return ResponseData(
            isSuccess: true,
            statusCode: response.statusCode,
            errorMessage: '',
            responseData: decodedData,
          );
        } else {
          print('[DEBUG] Medication add failed: ${decodedData['message']}');
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: decodedData['message'] ?? 'Failed to add medication',
            responseData: null,
          );
        }
      } else {
        print('[DEBUG] Medication add failed: ${decodedData['message']}');
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decodedData['message'] ?? 'Failed to add medication',
          responseData: null,
        );
      }
    } catch (e) {
      print('[DEBUG] Network error: $e');
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: 'Network error: ${e.toString()}',
        responseData: null,
      );
    }
  }
}
