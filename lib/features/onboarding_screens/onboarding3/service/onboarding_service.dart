// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/models/response_data.dart';
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';

class Onboarding3Service {
  Future<ResponseData> updateFitnessGoal({required String goal}) async {
    try {
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();

      if (accessToken == null || refreshToken == null) {
        return ResponseData(
          isSuccess: false,
          statusCode: 401,
          errorMessage: 'Authentication tokens not found',
          responseData: null,
        );
      }

      final uri = Uri.parse(Urls.fitnessGoal);

      final response = await http.patch(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'goal': goal}),
      );
      print("----Response body----: ${response.body}");

      final decodedData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (decodedData['fitnessGoal'] != null) {
          return ResponseData(
            isSuccess: true,
            statusCode: response.statusCode,
            errorMessage: '',
            responseData: decodedData,
          );
        } else {
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage:
                decodedData['message'] ?? 'Fitness goal update failed',
            responseData: null,
          );
        }
      } else {
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decodedData['message'] ?? 'Fitness goal update failed',
          responseData: null,
        );
      }
    } catch (e) {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: 'Network error: ${e.toString()}',
        responseData: null,
      );
    }
  }
}
