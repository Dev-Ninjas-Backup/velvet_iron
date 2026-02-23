// ignore_for_file: avoid_print

import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/models/response_data.dart';
import 'package:velvet_iron/core/services/end_points.dart';

class SetPasswordService {
  static const String baseUrl = Urls.baseUrl;

  Future<ResponseData> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      print('Resetting password...');
      print('Email: $email');

      final url = Uri.parse('$baseUrl/auth/reset-password');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'newPassword': newPassword}),
      );

      print('Reset Password Response:');
      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');

      final decodedData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        bool isSuccess = decodedData['success'] ?? false;

        if (isSuccess) {
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
            errorMessage: decodedData['message'] ?? 'Failed to reset password',
            responseData: null,
          );
        }
      } else {
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decodedData['message'] ?? 'Failed to reset password',
          responseData: null,
        );
      }
    } catch (e) {
      print('Reset Password Error: $e');
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: 'Network error: ${e.toString()}',
        responseData: null,
      );
    }
  }
}
