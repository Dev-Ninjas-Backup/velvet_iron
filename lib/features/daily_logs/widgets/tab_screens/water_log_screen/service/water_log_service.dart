import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/water_log_screen/models/water_log_model.dart';

class WaterLogService {
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

  /// GET /water-log/today
  Future<WaterTodayResponse> getTodayWater() async {
    final url = Uri.parse(Urls.waterLogToday);
    final headers = await _getHeaders();

    debugPrint('[WaterLogService] GET $url');
    final response = await http.get(url, headers: headers);
    debugPrint('[WaterLogService] Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return WaterTodayResponse.fromJson(decoded);
    } else {
      final decoded = jsonDecode(response.body);
      final msg = decoded is Map && decoded['message'] != null
          ? decoded['message'].toString()
          : 'Failed to fetch water log';
      throw Exception(msg);
    }
  }

  /// POST /water-log
  Future<WaterLogItem> logWater({
    required double amount,
    String? unit,
    String? loggedAt,
  }) async {
    final url = Uri.parse(Urls.waterLog);
    final headers = await _getHeaders();
    final payload = <String, dynamic>{'amount': amount};
    if (unit != null && unit.isNotEmpty) payload['unit'] = unit;
    if (loggedAt != null) payload['loggedAt'] = loggedAt;
    final body = jsonEncode(payload);

    debugPrint('[WaterLogService] POST $url body: $body');
    final response = await http.post(url, headers: headers, body: body);
    debugPrint('[WaterLogService] Status: ${response.statusCode}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return WaterLogItem.fromJson(decoded);
    } else {
      final decoded = jsonDecode(response.body);
      final msg = decoded is Map && decoded['message'] != null
          ? decoded['message'].toString()
          : 'Failed to log water';
      throw Exception(msg);
    }
  }

  /// PUT /water-log/goal
  Future<Map<String, dynamic>> updateWaterGoal({
    required double dailyWaterGoal,
    required String waterUnit,
  }) async {
    final url = Uri.parse(Urls.waterLogGoal);
    final headers = await _getHeaders();
    final body = jsonEncode({
      'dailyWaterGoal': dailyWaterGoal,
      'waterUnit': waterUnit,
    });

    debugPrint('[WaterLogService] PUT $url body: $body');
    final response = await http.put(url, headers: headers, body: body);
    debugPrint('[WaterLogService] Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      final decoded = jsonDecode(response.body);
      final msg = decoded is Map && decoded['message'] != null
          ? decoded['message'].toString()
          : 'Failed to update water goal';
      throw Exception(msg);
    }
  }

  /// DELETE /water-log/:id
  Future<bool> deleteWaterLog(String id) async {
    final url = Uri.parse(Urls.deleteWaterLog(id));
    final headers = await _getHeaders();

    debugPrint('[WaterLogService] DELETE $url');
    final response = await http.delete(url, headers: headers);
    debugPrint('[WaterLogService] Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      return true;
    } else {
      final decoded = jsonDecode(response.body);
      final msg = decoded is Map && decoded['message'] != null
          ? decoded['message'].toString()
          : 'Failed to delete water log';
      throw Exception(msg);
    }
  }
}
