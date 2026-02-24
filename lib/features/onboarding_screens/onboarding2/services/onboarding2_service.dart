import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:velvet_iron/core/models/response_data.dart';
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';

class Onboarding2Service {
  Future<ResponseData> updateProfile({
    required String username,
    File? profilePhoto,
  }) async {
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

      final uri = Uri.parse(Urls.profile);
      final request = http.MultipartRequest('PATCH', uri);

      request.headers['Authorization'] = 'Bearer $accessToken';
      request.headers['x-refresh-token'] = refreshToken;
      request.headers['accept'] = '*/*';

      request.fields['username'] = username;

      if (profilePhoto != null) {
        final extension = profilePhoto.path.split('.').last.toLowerCase();
        String mimeType = 'image/jpeg';
        if (extension == 'png') {
          mimeType = 'image/png';
        } else if (extension == 'gif') {
          mimeType = 'image/gif';
        } else if (extension == 'webp') {
          mimeType = 'image/webp';
        }

        final file = await http.MultipartFile.fromPath(
          'profilePhoto',
          profilePhoto.path,
          contentType: MediaType.parse(mimeType),
        );
        request.files.add(file);
      }

      // print('=== Profile Update Request ===');
      // print('URL: ${uri.toString()}');
      // print('Username: $username');
      // print('Profile Photo: ${profilePhoto?.path ?? 'null'}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // print('=== Profile Update Response ===');
      // print('Status Code: ${response.statusCode}');
      // print('Response Body: ${response.body}');

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
            errorMessage: decodedData['message'] ?? 'Profile update failed',
            responseData: null,
          );
        }
      } else {
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decodedData['message'] ?? 'Profile update failed',
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
