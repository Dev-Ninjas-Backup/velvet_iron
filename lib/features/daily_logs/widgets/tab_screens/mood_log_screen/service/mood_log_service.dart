import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/mood_log_screen/model/mood_log_model.dart';

class MoodLogService {
  static const String _baseUrl = 'https://velvet.api.softvence.app';

  //  GET Mood-log/today 

  Future<MoodLogResponse?> getTodayMoodLog({
    required String accessToken,
    required String refreshToken,
  }) async {
    final uri = Uri.parse('$_baseUrl/mood-log/today');
    debugPrint('MoodLog GET today: $uri');

    try {
      final response = await http.get(
        uri,
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
        },
      );

      debugPrint('MoodLog today status: ${response.statusCode}');
      debugPrint('MoodLog today body  : ${response.body}');

      if (response.statusCode == 404) return null;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return MoodLogResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      }

      throw MoodLogException(
        'Failed to fetch today log (${response.statusCode})',
      );
    } on SocketException {
      throw MoodLogException('No internet connection.');
    } on HttpException catch (e) {
      throw MoodLogException('HTTP error: ${e.message}');
    } catch (e) {
      if (e is MoodLogException) rethrow;
      throw MoodLogException('Unexpected error: $e');
    }
  }

  //  GET Mood-log-history 
  Future<MoodLogHistoryResponse> getMoodLogHistory({
    required String accessToken,
    required String refreshToken,
    int limit = 30,
    int offset = 0,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/mood-log/history?limit=$limit&offset=$offset',
    );
    debugPrint('MoodLog GET history: $uri');

    try {
      final response = await http.get(
        uri,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
        },
      );

      debugPrint('MoodLog history status: ${response.statusCode}');
      debugPrint('MoodLog history body  : ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return MoodLogHistoryResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      }

      String errorMessage = 'Failed to fetch history (${response.statusCode})';
      try {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        errorMessage = body['message'] as String? ?? errorMessage;
      } catch (_) {}
      throw MoodLogException(errorMessage, statusCode: response.statusCode);
    } on SocketException {
      throw MoodLogException('No internet connection.');
    } on HttpException catch (e) {
      throw MoodLogException('HTTP error: ${e.message}');
    } catch (e) {
      if (e is MoodLogException) rethrow;
      throw MoodLogException('Unexpected error: $e');
    }
  }

  // POST Mood-log 

  Future<MoodLogResponse> logMood({
    required MoodType mood,
    required EnergyLevel energyLevel,
    required HungerLevel hungerLevel,
    required String accessToken,
    required String refreshToken,
    String? note,
  }) async {
    final uri = Uri.parse('$_baseUrl/mood-log');
    debugPrint('MoodLog POST $uri');

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

      debugPrint('MoodLog POST status: ${response.statusCode}');
      debugPrint('MoodLog POST body  : ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return MoodLogResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      }

      String errorMessage = 'Failed to log mood (${response.statusCode})';
      try {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        errorMessage = body['message'] as String? ?? errorMessage;
      } catch (_) {}
      throw MoodLogException(errorMessage, statusCode: response.statusCode);
    } on SocketException {
      throw MoodLogException('No internet connection.');
    } on HttpException catch (e) {
      throw MoodLogException('HTTP error: ${e.message}');
    } catch (e) {
      if (e is MoodLogException) rethrow;
      throw MoodLogException('Unexpected error: $e');
    }
  }
}

//  Exception 

class MoodLogException implements Exception {
  final String message;
  final int? statusCode;

  const MoodLogException(this.message, {this.statusCode});

  @override
  String toString() => statusCode != null
      ? 'MoodLogException [$statusCode]: $message'
      : 'MoodLogException: $message';
}
