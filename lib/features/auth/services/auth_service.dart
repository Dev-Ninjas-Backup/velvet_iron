// ignore_for_file: avoid_print

import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/models/response_data.dart';
import 'package:velvet_iron/core/services/end_points.dart';

class AuthService {
  static const String baseUrl = Urls.baseUrl;

  Future<ResponseData> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/auth/register');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

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
            errorMessage: decodedData['message'] ?? 'Registration failed',
            responseData: null,
          );
        }
      } else {
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decodedData['message'] ?? 'Registration failed',
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

  // login

  Future<ResponseData> login({
    required String emailOrUsername,
    required String password,
  }) async {
    try {
      print('🔐 Logging in...');
      print('   - Email/Username: $emailOrUsername');

      final url = Uri.parse('$baseUrl/auth/login');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'emailOrUsername': emailOrUsername,
          'password': password,
        }),
      );

      print('📦 Login Response:');
      print('   - Status Code: ${response.statusCode}');
      print('   - Body: ${response.body}');

      final decodedData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (decodedData['access_token'] != null) {
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
            errorMessage: decodedData['message'] ?? 'Login failed',
            responseData: null,
          );
        }
      } else {
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decodedData['message'] ?? 'Login failed',
          responseData: null,
        );
      }
    } catch (e) {
      print('💥 Login Error: $e');
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: 'Network error: ${e.toString()}',
        responseData: null,
      );
    }
  }
}
