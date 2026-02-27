import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/mood_log_screen/model/mood_log_model.dart';

class MoodLogService {
  Future<MoodLogResponse?> getTodayMoodLog({
    required String accessToken,
    required String refreshToken,
  }) async {
    final uri = Uri.parse(Urls.getTodayMoodLog);
    debugPrint('MoodLog] GET $uri');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
        },
      );

      debugPrint('MoodLog GET Status: ${response.statusCode}');
      debugPrint('MoodLog GET Body  : ${response.body}');

      if (response.statusCode == 404) return null;
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return MoodLogResponse.fromJson(json);
      }

      String errorMessage =
          'Failed to fetch today mood log (${response.statusCode})';
      try {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        errorMessage = body['message'] as String? ?? errorMessage;
      } catch (_) {}
      throw MoodLogException(errorMessage, statusCode: response.statusCode);
    } on SocketException {
      throw MoodLogException(
        'No internet connection. Please check your network.',
      );
    } on HttpException catch (e) {
      throw MoodLogException('HTTP error: ${e.message}');
    } catch (e) {
      if (e is MoodLogException) rethrow;
      throw MoodLogException('Unexpected error: $e');
    }
  }

  // POST mood-log

  Future<MoodLogResponse> logMood({
    required MoodType mood,
    required EnergyLevel energyLevel,
    required HungerLevel hungerLevel,
    required String accessToken,
    required String refreshToken,
    String? note,
  }) async {
    final uri = Uri.parse(Urls.moodLog);

    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'x-refresh-token': refreshToken,
      })
      ..fields['mood'] = mood.value
      ..fields['energyLevel'] = energyLevel.value
      ..fields['hungerLevel'] = hungerLevel.value
      ..fields['note'] = note ?? '';

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('MoodLog Status: ${response.statusCode}');
      debugPrint('MoodLog Body  : ${response.body}');

      return _handleResponse(response);
    } on SocketException {
      throw MoodLogException(
        'No internet connection. Please check your network.',
      );
    } on HttpException catch (e) {
      throw MoodLogException('HTTP error: ${e.message}');
    } catch (e) {
      if (e is MoodLogException) rethrow;
      throw MoodLogException('Unexpected error: $e');
    }
  }

  MoodLogResponse _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return MoodLogResponse.fromJson(json);
    }

    String errorMessage = 'Failed to log mood (${response.statusCode})';
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      errorMessage = body['message'] as String? ?? errorMessage;
    } catch (_) {}

    throw MoodLogException(errorMessage, statusCode: response.statusCode);
  }
}

class MoodLogException implements Exception {
  final String message;
  final int? statusCode;

  const MoodLogException(this.message, {this.statusCode});

  @override
  String toString() => statusCode != null
      ? 'MoodLogException [$statusCode]: $message'
      : 'MoodLogException: $message';
}
