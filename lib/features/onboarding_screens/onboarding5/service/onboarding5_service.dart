import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/end_points.dart';

class OnboardingService {
  Future<Map<String, dynamic>> updateDateOfBirth({
    required String accessToken,
    required String refreshToken,
    required String dateOfBirth, 
  }) async {
    final uri = Uri.parse(Urls.profile);

    final request = http.MultipartRequest('PATCH', uri)
      ..headers.addAll({
        'accept': '*/*',
        'Authorization': 'Bearer $accessToken',
        'x-refresh-token': refreshToken,
      })
      ..fields['dateOfBirth'] = dateOfBirth;

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    final Map<String, dynamic> responseBody =
        jsonDecode(response.body) as Map<String, dynamic>;

    log('--- UpdateDateOfBirth ---');
    log('Status : ${response.statusCode}');
    log('Body   : ${response.body}');

    return responseBody;
  }
}
