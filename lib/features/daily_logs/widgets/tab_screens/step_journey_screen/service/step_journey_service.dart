import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/step_journey_screen/models/step_journey_model.dart';

class StepJourneyService {
  Future<Map<String, String>> _getHeaders() async {
    final accessToken = await SharedPreferencesHelper.getAccessToken() ?? '';
    final refreshToken = await SharedPreferencesHelper.getRefreshToken() ?? '';
    return {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
      if (refreshToken.isNotEmpty) 'x-refresh-token': refreshToken,
    };
  }

  /// GET /step-log/today
  Future<StepTodayResponse> getTodaySteps() async {
    final url = Uri.parse(Urls.stepLogToday);
    final headers = await _getHeaders();

    debugPrint('[StepJourneyService] GET $url');
    final response = await http.get(url, headers: headers);
    debugPrint('[StepJourneyService] Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return StepTodayResponse.fromJson(decoded);
    } else {
      final decoded = jsonDecode(response.body);
      final msg = decoded is Map && decoded['message'] != null
          ? decoded['message'].toString()
          : 'Failed to fetch step progress';
      throw Exception(msg);
    }
  }

  /// POST /step-log (update absolute steps or add incremental steps)
  Future<Map<String, dynamic>> updateSteps({
    int? steps,
    int? addSteps,
    String? date,
  }) async {
    final url = Uri.parse(Urls.stepLog);
    final headers = await _getHeaders();
    final payload = <String, dynamic>{};
    if (steps != null) payload['steps'] = steps;
    if (addSteps != null) payload['addSteps'] = addSteps;
    if (date != null) payload['date'] = date;
    final body = jsonEncode(payload);

    debugPrint('[StepJourneyService] POST $url body: $body');
    final response = await http.post(url, headers: headers, body: body);
    debugPrint('[StepJourneyService] Status: ${response.statusCode}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      final decoded = jsonDecode(response.body);
      final msg = decoded is Map && decoded['message'] != null
          ? decoded['message'].toString()
          : 'Failed to update steps';
      throw Exception(msg);
    }
  }

  /// POST /step-log/set-up-camp
  Future<SetUpCampResponse> setUpCamp() async {
    final url = Uri.parse(Urls.stepLogSetUpCamp);
    final headers = await _getHeaders();

    debugPrint('[StepJourneyService] POST $url');
    final response = await http.post(url, headers: headers);
    debugPrint('[StepJourneyService] Status: ${response.statusCode}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return SetUpCampResponse.fromJson(decoded);
    } else {
      final decoded = jsonDecode(response.body);
      final msg = decoded is Map && decoded['message'] != null
          ? decoded['message'].toString()
          : 'Failed to set up camp';
      throw Exception(msg);
    }
  }

  /// PUT /step-log/goal
  Future<Map<String, dynamic>> updateStepGoal(int dailyStepGoal) async {
    final url = Uri.parse(Urls.stepLogGoal);
    final headers = await _getHeaders();
    final body = jsonEncode({
      'dailyStepGoal': dailyStepGoal,
    });

    debugPrint('[StepJourneyService] PUT $url body: $body');
    final response = await http.put(url, headers: headers, body: body);
    debugPrint('[StepJourneyService] Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      final decoded = jsonDecode(response.body);
      final msg = decoded is Map && decoded['message'] != null
          ? decoded['message'].toString()
          : 'Failed to update step goal';
      throw Exception(msg);
    }
  }

  /// GET /step-log/history?limit=30
  Future<List<Map<String, dynamic>>> getStepHistory({int limit = 30}) async {
    final url = Uri.parse(Urls.stepLogHistory(limit));
    final headers = await _getHeaders();

    debugPrint('[StepJourneyService] GET $url');
    final response = await http.get(url, headers: headers);
    debugPrint('[StepJourneyService] Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is List) {
        return decoded.map((e) => e as Map<String, dynamic>).toList();
      }
      return [];
    } else {
      return [];
    }
  }
}
