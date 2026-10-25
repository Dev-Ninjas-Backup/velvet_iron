// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/app_timezone_helper.dart';
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
    DateTime? loggedAt,
  }) async {
    final accessToken = await SharedPreferencesHelper.getAccessToken();
    final refreshToken = await SharedPreferencesHelper.getRefreshToken();

    if (accessToken == null || refreshToken == null) {
      print('❌ Tokens not found in SharedPreferences');
      return null;
    }

    final timezone = await AppTimezoneHelper.getTimezoneName();
    final uri = Uri.parse(Urls.exerciseLog);
    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
      'x-refresh-token': refreshToken,
      'x-timezone': timezone,
    });

    String cleanIntensity = intensity.toUpperCase().trim();
    if (cleanIntensity == 'MODERATE' || cleanIntensity == 'MED' || cleanIntensity.isEmpty) {
      cleanIntensity = 'MEDIUM';
    } else if (cleanIntensity != 'LOW' && cleanIntensity != 'HIGH') {
      cleanIntensity = 'MEDIUM';
    }

    String cleanType = type.toUpperCase().trim();
    if (cleanType != 'CARDIO' && cleanType != 'STRENGTH' && cleanType != 'FLEXIBILITY' && cleanType != 'BALANCE') {
      cleanType = 'CARDIO';
    }

    final exerciseName = name.trim().isNotEmpty ? name.trim() : (type.isNotEmpty ? type : 'Exercise');
    final exerciseDuration = duration > 0 ? duration : 30;

    request.fields['type'] = cleanType;
    request.fields['name'] = exerciseName;
    request.fields['intensity'] = cleanIntensity;
    request.fields['duration'] = exerciseDuration.toString();
    request.fields['note'] = note.trim();
    final logTime = loggedAt ?? DateTime.now();
    request.fields['loggedAt'] = logTime.toUtc().toIso8601String();

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

    final timezone = await AppTimezoneHelper.getTimezoneName();
    print('📤 Fetching Exercise History (tz: $timezone)...');

    final getConnect = GetConnect();
    final response = await getConnect.get(
      Urls.exerciseHistory, // GET endpoint for fetching exercise history
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'x-refresh-token': refreshToken,
        'x-timezone': timezone,
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
    String recurrence = 'DAILY',
    List<int>? daysOfWeek,
  }) async {
    final accessToken = await SharedPreferencesHelper.getAccessToken();
    final refreshToken = await SharedPreferencesHelper.getRefreshToken();

    if (accessToken == null || refreshToken == null) {
      print('❌ Tokens not found in SharedPreferences');
      return null;
    }

    final timezone = await AppTimezoneHelper.getTimezoneName();
    final uri = Uri.parse(Urls.exerciseLogSchedule);
    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
      'x-refresh-token': refreshToken,
      'x-timezone': timezone,
    });

    String cleanIntensity = intensity.toUpperCase().trim();
    if (cleanIntensity == 'MODERATE' || cleanIntensity == 'MED' || cleanIntensity.isEmpty) {
      cleanIntensity = 'MEDIUM';
    } else if (cleanIntensity != 'LOW' && cleanIntensity != 'HIGH') {
      cleanIntensity = 'MEDIUM';
    }

    String cleanType = type.toUpperCase().trim();
    if (cleanType != 'CARDIO' && cleanType != 'STRENGTH' && cleanType != 'FLEXIBILITY' && cleanType != 'BALANCE') {
      cleanType = 'CARDIO';
    }

    final exerciseName = name.trim().isNotEmpty ? name.trim() : (type.isNotEmpty ? type : 'Exercise');
    final exerciseDuration = duration > 0 ? duration : 30;
    final cleanRecurrence = recurrence.toUpperCase().replaceAll(' ', '_');

    request.fields['type'] = cleanType;
    request.fields['name'] = exerciseName;
    request.fields['intensity'] = cleanIntensity;
    request.fields['duration'] = exerciseDuration.toString();
    request.fields['note'] = note.trim();
    request.fields['scheduledAt'] = scheduledAt.toUtc().toIso8601String();
    request.fields['recurrence'] = cleanRecurrence;
    if (daysOfWeek != null && daysOfWeek.isNotEmpty) {
      request.fields['daysOfWeek'] = jsonEncode(daysOfWeek);
    }

    print('📤 Schedule Request Fields: ${request.fields}');

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    print('📡 Schedule Status Code: ${response.statusCode}');
    print('📡 Schedule Response Body: $responseBody');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> jsonData = jsonDecode(responseBody);
      print('✅ Schedule Exercise Response: $jsonData');
      return jsonData;
    }

    // Fallback: try JSON request to /exercise-logs/schedules or /exercise-log/schedule
    try {
      print('🟡 Multipart schedule returned ${response.statusCode}, falling back to JSON...');
      final jsonPayload = {
        'name': exerciseName,
        'type': cleanType,
        'intensity': cleanIntensity,
        'duration': exerciseDuration,
        'note': note.trim(),
        'scheduledAt': scheduledAt.toUtc().toIso8601String(),
        'recurrence': cleanRecurrence,
        if (daysOfWeek != null && daysOfWeek.isNotEmpty) ...{
          'daysOfWeek': daysOfWeek,
          'repeatDays': daysOfWeek,
        },
      };

      final jsonHeaders = {
        'accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'x-refresh-token': refreshToken,
        'x-timezone': timezone,
      };

      var jsonRes = await http.post(
        Uri.parse(Urls.exerciseLogSchedule),
        headers: jsonHeaders,
        body: jsonEncode(jsonPayload),
      );

      if (jsonRes.statusCode == 404) {
        jsonRes = await http.post(
          Uri.parse(Urls.exerciseLogSchedules),
          headers: jsonHeaders,
          body: jsonEncode(jsonPayload),
        );
      }

      print('📡 JSON Schedule Status Code: ${jsonRes.statusCode}');
      if (jsonRes.statusCode == 200 || jsonRes.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(jsonRes.body);
        return jsonData;
      }
    } catch (fallbackErr) {
      print('🔴 Fallback JSON schedule error: $fallbackErr');
    }

    print('❌ Schedule Exercise Error: $responseBody');
    return null;
  }

  /// Fetch today's recurring scheduled exercises (GET /exercise-log/schedules/today)
  Future<List<dynamic>> fetchTodaySchedules({String? date}) async {
    final accessToken = await SharedPreferencesHelper.getAccessToken();
    final refreshToken = await SharedPreferencesHelper.getRefreshToken();
    if (accessToken == null || refreshToken == null) return [];

    final timezone = await AppTimezoneHelper.getTimezoneName();
    final targetDate = date ?? AppTimezoneHelper.getTodayDateString();
    final url = '${Urls.exerciseSchedulesToday}?date=$targetDate&timezone=$timezone';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
          'x-timezone': timezone,
        },
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body is List) return body;
        if (body is Map<String, dynamic> && body['data'] is List) {
          return body['data'] as List;
        }
      }
    } catch (e) {
      print('🟡 [ExerciseService] fetchTodaySchedules error: $e');
    }
    return [];
  }

  /// Mark a scheduled exercise as taken for a specific date (POST /exercise-log/schedule/:id/take)
  Future<Map<String, dynamic>?> markExerciseAsTaken({
    required String exerciseId,
    required String accessToken,
    required String refreshToken,
    String? date,
  }) async {
    final timezone = await AppTimezoneHelper.getTimezoneName();
    final targetDate = date ?? AppTimezoneHelper.getTodayDateString();

    // 1. Try date-isolated schedule take: POST /exercise-log/schedule/:id/take
    final takeUri = Uri.parse(Urls.takeExerciseSchedule(exerciseId));
    print('[ExerciseService] Trying take POST: $takeUri with date=$targetDate');

    try {
      final takeResponse = await http.post(
        takeUri,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
          'x-timezone': timezone,
        },
        body: jsonEncode({'date': targetDate}),
      );

      print('[ExerciseService] Take Response status: ${takeResponse.statusCode}');
      if (takeResponse.statusCode >= 200 && takeResponse.statusCode < 300) {
        final jsonData = jsonDecode(takeResponse.body) as Map<String, dynamic>;
        print('[ExerciseService] Marked as taken via /take! id=$exerciseId');
        return jsonData;
      }
    } catch (e) {
      print('[ExerciseService] /take failed, trying fallback: $e');
    }

    // 2. Fallback: PATCH /exercise-log/:id/taken?isTaken=true
    final uri = Uri.parse(Urls.updateExerciseHHistory(exerciseId));
    print('[ExerciseService] Fallback Mark taken PATCH: $uri');

    try {
      final response = await http.patch(
        uri,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
          'x-timezone': timezone,
        },
      );

      print(
        '[ExerciseService] Mark taken Response status: ${response.statusCode}',
      );
      print('[ExerciseService] Mark taken Response body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        print('[ExerciseService] Marked as taken! id=$exerciseId');
        return jsonData;
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        print(
          '[ExerciseService] ❌ Mark taken error: ${errorData['message'] ?? response.body}',
        );
        return null;
      }
    } catch (e) {
      print('[ExerciseService] ❌ Mark taken Exception: ${e.toString()}');
      return null;
    }
  }

  /// Delete an exercise schedule (DELETE /exercise-log/schedule/:id or /exercise-log/scheduled/:id)
  Future<bool> deleteExerciseSchedule({
    required String exerciseId,
    required String accessToken,
    required String refreshToken,
  }) async {
    final urlsToTry = [
      Urls.deleteExerciseSchedule(exerciseId),
      Urls.deleteExerciseScheduled(exerciseId),
      Urls.deleteExerciseLog(exerciseId),
    ];

    final timezone = await AppTimezoneHelper.getTimezoneName();
    for (final url in urlsToTry) {
      print('[ExerciseService] DELETE $url');
      try {
        final response = await http.delete(
          Uri.parse(url),
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'x-refresh-token': refreshToken,
            'x-timezone': timezone,
          },
        );
        print('[ExerciseService] DELETE status: ${response.statusCode}');
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return true;
        }
      } catch (e) {
        print('[ExerciseService] Error deleting exercise: $e');
      }
    }
    return false;
  }

  /// Update an exercise schedule (PATCH /exercise-log/schedule/:id)
  Future<Map<String, dynamic>?> updateExerciseSchedule({
    required String exerciseId,
    required String type,
    required String name,
    required String intensity,
    required int duration,
    required String note,
    required DateTime scheduledAt,
    required String accessToken,
    required String refreshToken,
  }) async {
    final urlsToTry = [
      Urls.updateExerciseSchedule(exerciseId),
      Urls.updateExerciseScheduled(exerciseId),
    ];

    final timezone = await AppTimezoneHelper.getTimezoneName();
    for (final url in urlsToTry) {
      print('[ExerciseService] PATCH $url');
      try {
        final request = http.MultipartRequest('PATCH', Uri.parse(url));
        request.headers.addAll({
          'accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'x-refresh-token': refreshToken,
          'x-timezone': timezone,
        });

        request.fields['type'] = type.toUpperCase().trim();
        request.fields['name'] = name.trim();
        request.fields['intensity'] = intensity.toUpperCase().trim();
        request.fields['duration'] = duration.toString();
        request.fields['note'] = note.trim();
        request.fields['scheduledAt'] = scheduledAt.toUtc().toIso8601String();

        final response = await request.send();
        final body = await response.stream.bytesToString();
        print('[ExerciseService] PATCH status: ${response.statusCode}');

        if (response.statusCode >= 200 && response.statusCode < 300) {
          return jsonDecode(body) as Map<String, dynamic>;
        }
      } catch (e) {
        print('[ExerciseService] Error updating exercise schedule: $e');
      }
    }
    return null;
  }
}
