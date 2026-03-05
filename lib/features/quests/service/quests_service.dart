// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/quests/model/quest_model.dart';

class AddXpResponse {
  final int xp;
  final String reason;

  const AddXpResponse({required this.xp, required this.reason});

  factory AddXpResponse.fromJson(Map<String, dynamic> json) {
    return AddXpResponse(
      xp: json['xp'] as int,
      reason: json['reason'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'xp': xp, 'reason': reason};
}

class QuestService {
  Future<DailyQuestResponse> getQuests() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    final refreshToken = await SharedPreferencesHelper.getRefreshToken();

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

  Future<AddXpResponse> addXp({required int xp, required String reason}) async {
    final token = await SharedPreferencesHelper.getAccessToken();
    final refreshToken = await SharedPreferencesHelper.getRefreshToken();

    print('🔵 [QuestService] POST ${Urls.addXP}');

    final response = await http.post(
      Uri.parse(Urls.addXP),
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token',
        'x-refresh-token': refreshToken ?? '',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'xp': xp, 'reason': reason}),
    );

    print('🔵 [QuestService] statusCode=${response.statusCode}');
    print('🔵 [QuestService] body=${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return AddXpResponse.fromJson(json);
    } else {
      throw Exception('Failed to add XP: ${response.statusCode}');
    }
  }
}