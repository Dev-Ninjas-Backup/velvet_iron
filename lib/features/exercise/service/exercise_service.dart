// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/core/services/end_points.dart';

class ExerciseService {
  /// Log a completed exercise (POST /exercise-log)
  /// Used when user logs an exercise in the 'Completed' tab
  Future<Map<String, dynamic>?> logExercise({
    required String type,
    required String name,
    required String intensity,
    required int duration,
    required String note,
  }) async {
    final accessToken = await SharedPreferencesHelper.getAccessToken();
    final refreshToken = await SharedPreferencesHelper.getRefreshToken();

    if (accessToken == null || refreshToken == null) {
      print('❌ Tokens not found in SharedPreferences');
      return null;
    }

    final uri = Uri.parse(Urls.exerciseLog);
    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
      'x-refresh-token': refreshToken,
    });

    request.fields['type'] = type.toUpperCase();
    request.fields['name'] = name;
    request.fields['intensity'] = intensity.toUpperCase();
    request.fields['duration'] = duration.toString();
    request.fields['note'] = note;

    print('📤 Request Fields: ${request.fields}');

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    print('📡 Status Code: ${response.statusCode}');
    print('📡 Response Body: $responseBody');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> jsonData = jsonDecode(responseBody);
      print('✅ Log Exercise Response: $jsonData');
      return jsonData;
    } else {
      print('❌ Log Exercise Error: $responseBody');
      return null;
    }
  }

  /// Fetch exercise history (GET /exercise-log/history)
  /// Used to display all logged and scheduled exercises
  Future<Map<String, dynamic>?> fetchExerciseHistory() async {
    final accessToken = await SharedPreferencesHelper.getAccessToken();
    final refreshToken = await SharedPreferencesHelper.getRefreshToken();

    if (accessToken == null || refreshToken == null) {
      print('❌ Tokens not found in SharedPreferences');
      return null;
    }

    print('📤 Fetching Exercise History...');

    final getConnect = GetConnect();
    final response = await getConnect.get(
      Urls.exerciseHistory, // GET endpoint for fetching exercise history
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'x-refresh-token': refreshToken,
      },
    );

    print('📡 Status Code: ${response.statusCode}');
    print('📡 Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> jsonData = response.body is String
          ? jsonDecode(response.body)
          : response.body;
      print('✅ Fetch Exercise History Response: $jsonData');
      return jsonData;
    } else {
      print('❌ Fetch Exercise History Error: ${response.body}');
      return null;
    }
  }

  /// Schedule an exercise for the future (POST /exercise-log/schedule)
  /// Used when user schedules an exercise in the 'Schedule' tab
  Future<Map<String, dynamic>?> scheduleExercise({
    required String type,
    required String name,
    required String intensity,
    required int duration,
    required String note,
    required DateTime scheduledAt,
  }) async {
    final accessToken = await SharedPreferencesHelper.getAccessToken();
    final refreshToken = await SharedPreferencesHelper.getRefreshToken();

    if (accessToken == null || refreshToken == null) {
      print('❌ Tokens not found in SharedPreferences');
      return null;
    }

    final uri = Uri.parse(Urls.exerciseLogSchedule);
    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
      'x-refresh-token': refreshToken,
    });

    request.fields['type'] = type.toUpperCase();
    request.fields['name'] = name;
    request.fields['intensity'] = intensity.toUpperCase();
    request.fields['duration'] = duration.toString();
    request.fields['note'] = note;
    request.fields['scheduledAt'] = scheduledAt.toUtc().toIso8601String();

    print('📤 Schedule Request Fields: ${request.fields}');

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    print('📡 Schedule Status Code: ${response.statusCode}');
    print('📡 Schedule Response Body: $responseBody');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> jsonData = jsonDecode(responseBody);
      print('✅ Schedule Exercise Response: $jsonData');
      return jsonData;
    } else {
      print('❌ Schedule Exercise Error: $responseBody');
      return null;
    }
  }
}
