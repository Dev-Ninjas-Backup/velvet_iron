import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding8/model/meal_log_model.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding8/model/meal_log_request.dart';

class MealLogService {

  Future<MealLogModel> logMeal({
    required MealLogRequest request,
    required String accessToken,
    required String refreshToken,
  }) async {
    final uri = Uri.parse(Urls.mealLog);

    final multipartRequest = http.MultipartRequest('POST', uri)
      ..headers.addAll(_buildHeaders(accessToken, refreshToken))
      ..fields.addAll(request.toFormData());

    try {
      final streamedResponse = await multipartRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } on SocketException {
      throw MealLogException(
        'No internet connection. Please check your network.',
      );
    } on HttpException catch (e) {
      throw MealLogException('HTTP error: ${e.message}');
    } catch (e) {
      throw MealLogException('Unexpected error: $e');
    }
  }

  //  Private helpers

  Map<String, String> _buildHeaders(String accessToken, String refreshToken) {
    return {
      'accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
      'x-refresh-token': refreshToken,
    };
  }

  MealLogModel _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return MealLogModel.fromJson(json);
    }

    // Try to extract a server error message

    String errorMessage = 'Failed to log meal (${response.statusCode})';
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      errorMessage = body['message'] as String? ?? errorMessage;
    } catch (_) {}

    throw MealLogException(errorMessage, statusCode: response.statusCode);
  }
}

//  Exception

class MealLogException implements Exception {
  final String message;
  final int? statusCode;

  const MealLogException(this.message, {this.statusCode});

  @override
  String toString() => statusCode != null
      ? 'MealLogException [$statusCode]: $message'
      : 'MealLogException: $message';
}
