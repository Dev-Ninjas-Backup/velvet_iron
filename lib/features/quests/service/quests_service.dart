// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/quests/model/quest_model.dart';

class QuestService {
  Future<DailyQuestResponse> getQuests() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    final refreshToken = await SharedPreferencesHelper.getRefreshToken();

    print('🔵 [QuestService] token=$token');
    print('🔵 [QuestService] refreshToken=$refreshToken');
    print('🔵 [QuestService] GET ${Urls.quests}');

    final response = await http.get(
      Uri.parse(Urls.quests),
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token',
        'x-refresh-token': refreshToken ?? '',
      },
    );

    print('🔵 [QuestService] statusCode=${response.statusCode}');
    print('🔵 [QuestService] body=${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return DailyQuestResponse.fromJson(json);
    } else {
      throw Exception('Failed to load quests: ${response.statusCode}');
    }
  }
}
