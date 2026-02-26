import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/end_points.dart';

class Onboarding6Service {
 
  // ── POST /weight-log ──────────────────────────────────────────────────────
  Future<Map<String, dynamic>> logWeight({
    required String accessToken,
    required String refreshToken,
    required double weightInLbs,
  }) async {
    final uri = Uri.parse(Urls.weightLog);

    final response = await http.post(
      uri,
      headers: {
        
        'Authorization': 'Bearer $accessToken',
        'x-refresh-token': refreshToken,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'weight': weightInLbs.toStringAsFixed(2)}),
    );

    final Map<String, dynamic> responseBody =
        jsonDecode(response.body) as Map<String, dynamic>;

    log('--- LogWeight ---');
    log('Status : ${response.statusCode}');
    log('Body   : ${response.body}');

    return responseBody;
  }
}
