// ignore_for_file: avoid_print

import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/models/response_data.dart';
import 'package:velvet_iron/core/services/end_points.dart';

class OtpService {
  static const String baseUrl = Urls.baseUrl;

  // Verify Email OTP
  Future<ResponseData> verifyEmail({
    required String email,
    required String otp,
  }) async {
    try {
      print('📧 Verifying email OTP...');
      print('   - Email: $email');
      print('   - OTP: $otp');

      final url = Uri.parse('$baseUrl/auth/verify-email');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      print('📦 Verify Email Response:');
      print('   - Status Code: ${response.statusCode}');
      print('   - Body: ${response.body}');

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
            errorMessage: decodedData['message'] ?? 'Verification failed',
            responseData: null,
          );
        }
      } else {
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decodedData['message'] ?? 'Verification failed',
          responseData: null,
        );
      }
    } catch (e) {
      print('💥 Verify Email Error: $e');
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: 'Network error: ${e.toString()}',
        responseData: null,
      );
    }
  }

  // Resend Verification OTP

  Future<ResponseData> resendVerificationOtp({required String email}) async {
    try {
      print('🔄 Resending verification OTP...');
      print('   - Email: $email');

      final url = Uri.parse('$baseUrl/auth/resend-verification-otp');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      print('📦 Resend OTP Response:');
      print('   - Status Code: ${response.statusCode}');
      print('   - Body: ${response.body}');

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
            errorMessage: decodedData['message'] ?? 'Failed to resend OTP',
            responseData: null,
          );
        }
      } else {
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decodedData['message'] ?? 'Failed to resend OTP',
          responseData: null,
        );
      }
    } catch (e) {
      print('💥 Resend OTP Error: $e');
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: 'Network error: ${e.toString()}',
        responseData: null,
      );
    }
  }
}
