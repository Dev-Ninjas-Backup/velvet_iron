import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding7/model/onboarding7_model.dart';

class Onboarding7Service {
  Future<Map<String, dynamic>> logMood({
    required String accessToken,
    required String refreshToken,
    required MoodLogModel model,
  }) async {
    final uri = Uri.parse(Urls.moodLog);

    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'x-refresh-token': refreshToken,
      })
      ..fields.addAll(model.toFields());

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    final Map<String, dynamic> responseBody =
        jsonDecode(response.body) as Map<String, dynamic>;

    log('--- LogMood ---');
    log('Status : ${response.statusCode}');
    log('Body   : ${response.body}');

    return responseBody;
  }
}
