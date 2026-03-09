import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/weight_log_screen/model/weight_log_model.dart';

class WeightLogService {
  static const String _baseUrl = Urls.weightLog;

  Map<String, String> _headers({
    required String accessToken,
    required String refreshToken,
  }) {
    return {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
      'x-refresh-token': refreshToken,
    };
  }

  //  POST weight-log

  Future<CreateWeightLogResponse> createWeightLog({
    required String weight,
    String? note,
    required String accessToken,
    required String refreshToken,
  }) async {
    final url = Uri.parse(_baseUrl);
    final request = CreateWeightLogRequest(weight: weight, note: note);
    final requestBody = jsonEncode(request.toJson());
    final headers = _headers(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    debugPrint('URL     : $url');
    debugPrint('Headers : $headers');
    debugPrint('Body    : $requestBody');

    final response = await http.post(url, headers: headers, body: requestBody);

    final decodedBody = jsonDecode(response.body);

    debugPrint('Status  : ${response.statusCode}');
    debugPrint('Body    : ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return CreateWeightLogResponse.fromJson(decodedBody);
    } else {
      final message = decodedBody['message'] ?? 'Failed to create weight log';
      debugPrint('WeightLog Error: $message');
      throw Exception(message);
    }
  }

  //  GET weight-log-history

  Future<WeightLogHistoryModel> getWeightLogHistory({
    required String accessToken,
    required String refreshToken,
  }) async {
    final url = Uri.parse(Urls.weightLogHistory);
    final headers = _headers(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    debugPrint('URL     : $url');
    debugPrint('Headers : $headers');

    final response = await http.get(url, headers: headers);

    final decodedBody = jsonDecode(response.body);

    debugPrint('Status  : ${response.statusCode}');
    debugPrint('Body    : ${response.body}');

    if (response.statusCode == 200) {
      return WeightLogHistoryModel.fromJson(decodedBody);
    } else {
      final message =
          decodedBody['message'] ?? 'Failed to fetch weight log history';
      debugPrint('WeightLog Error: $message');
      throw Exception(message);
    }
  }

  //  GET weekly weight chart

  Future<WeeklyWeightChartModel> getWeeklyWeightChart({
    required String accessToken,
    required String refreshToken,
  }) async {
    final url = Uri.parse(Urls.weeklyWeightLog);
    final headers = _headers(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    debugPrint('URL     : $url');

    final response = await http.get(url, headers: headers);

    final decodedBody = jsonDecode(response.body);

    debugPrint('Status  : ${response.statusCode}');
    debugPrint('Body    : ${response.body}');

    if (response.statusCode == 200) {
      return WeeklyWeightChartModel.fromJson(decodedBody);
    } else {
      final message =
          decodedBody['message'] ?? 'Failed to fetch weekly weight chart';
      debugPrint('WeightLog Error: $message');
      throw Exception(message);
    }
  }
}
