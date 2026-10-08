// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/quests/model/quest_model.dart';

class QuestService {
  Future<Map<String, String>> _getHeaders() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    final refreshToken = await SharedPreferencesHelper.getRefreshToken();
    return {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      if (refreshToken != null && refreshToken.isNotEmpty)
        'x-refresh-token': refreshToken,
    };
  }

  /// 1. Unified Quests Feed: GET /quests/today (Milestone 3)
  Future<DailyQuestResponse> getUnifiedQuestsToday() async {
    final headers = await _getHeaders();
    print('🔵 [QuestService] GET ${Urls.questsToday}');

    final response = await http.get(
      Uri.parse(Urls.questsToday),
      headers: headers,
    );

    print('🔵 [QuestService] getUnifiedQuestsToday statusCode=${response.statusCode}');
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return DailyQuestResponse.fromJson(json);
    } else {
      throw Exception('Unified quests endpoint returned ${response.statusCode}');
    }
  }

  /// 2. Primary Quests Aggregator (Tries Unified Feed first, gracefully falls back to legacy + custom)
  Future<DailyQuestResponse> getQuests() async {
    // Attempt the new Milestone 3 unified feed first
    try {
      final unified = await getUnifiedQuestsToday();
      if (unified.quests.isNotEmpty) {
        print('🔵 [QuestService] Unified feed loaded successfully (${unified.quests.length} quests)');
        return unified;
      }
    } catch (e) {
      print('🟡 [QuestService] Unified feed not yet available on server, using fallback: $e');
    }

    // Fallback: Legacy Codex Quests from /xp-stats/quests
    final headers = await _getHeaders();
    print('🔵 [QuestService] Fallback GET ${Urls.quests}');

    final response = await http.get(
      Uri.parse(Urls.quests),
      headers: headers,
    );

    DailyQuestResponse codexResponse;
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      codexResponse = DailyQuestResponse.fromJson(json);
    } else {
      codexResponse = const DailyQuestResponse(
        todayTotalXp: 0,
        todayLogCount: 0,
        quests: [],
      );
    }

    // Also fetch cloud Custom Quests from GET /quests/custom
    try {
      final customList = await getCustomQuests();
      if (customList.isNotEmpty) {
        final existingIds = codexResponse.quests.map((q) => q.id).toSet();
        final newCustom =
            customList.where((q) => !existingIds.contains(q.id)).toList();
        final combined = [...codexResponse.quests, ...newCustom];
        return codexResponse.copyWith(quests: combined);
      }
    } catch (e) {
      print('🟡 [QuestService] Could not fetch cloud custom quests: $e');
    }

    return codexResponse;
  }

  /// 3. Fetch Cloud Custom Quests: GET /quests/custom
  Future<List<Quest>> getCustomQuests() async {
    final headers = await _getHeaders();
    print('🔵 [QuestService] GET ${Urls.customQuests}');

    final response = await http.get(
      Uri.parse(Urls.customQuests),
      headers: headers,
    );

    print('🔵 [QuestService] getCustomQuests statusCode=${response.statusCode}');
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final list = (json['data'] as List<dynamic>?) ??
          (json['quests'] as List<dynamic>?) ??
          [];
      return list.map((q) => Quest.fromJson(q as Map<String, dynamic>)).toList();
    }
    return [];
  }

  /// 4. Create Cloud Custom Quest: POST /quests/custom
  Future<Quest?> createCustomQuest({
    required String name,
    required String category,
    String recurrence = 'DAILY',
    String? description,
    int? xp,
  }) async {
    final headers = await _getHeaders();
    final body = jsonEncode({
      'name': name,
      'category': category.toUpperCase(),
      'recurrence': recurrence.toUpperCase(),
      if (description != null && description.isNotEmpty)
        'description': description,
      if (xp != null && xp > 0) 'xpReward': xp,
    });

    print('🔵 [QuestService] POST ${Urls.customQuests} body=$body');
    final response = await http.post(
      Uri.parse(Urls.customQuests),
      headers: headers,
      body: body,
    );

    print('🔵 [QuestService] createCustomQuest statusCode=${response.statusCode}');
    print('🔵 [QuestService] createCustomQuest body=${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final data = json['data'] is Map<String, dynamic>
          ? json['data'] as Map<String, dynamic>
          : json;
      return Quest.fromJson(data);
    }
    return null;
  }

  /// 5. Delete Cloud Custom Quest: DELETE /quests/custom/:id
  Future<bool> deleteCustomQuest(String id, {String? fallbackId}) async {
    final headers = await _getHeaders();
    final candidates = <String>[];
    if (id.isNotEmpty) candidates.add(id);
    if (id.startsWith('custom_')) {
      candidates.add(id.replaceFirst('custom_', ''));
    }
    if (fallbackId != null && fallbackId.isNotEmpty && !candidates.contains(fallbackId)) {
      candidates.add(fallbackId);
      if (fallbackId.startsWith('custom_')) {
        candidates.add(fallbackId.replaceFirst('custom_', ''));
      }
    }

    for (final targetId in candidates) {
      final url = Urls.deleteCustomQuest(targetId);
      print('🔵 [QuestService] DELETE $url');
      try {
        final response = await http.delete(
          Uri.parse(url),
          headers: headers,
        );
        print('🔵 [QuestService] deleteCustomQuest ($targetId) statusCode=${response.statusCode}');
        if (response.statusCode == 200 || response.statusCode == 204) {
          return true;
        }
      } catch (e) {
        print('🔴 [QuestService] Error deleting quest $targetId: $e');
      }
    }
    return false;
  }

  /// 6. Complete Custom Quest: POST /quests/custom/:id/complete
  Future<Map<String, dynamic>> completeCustomQuest(String id) async {
    final headers = await _getHeaders();
    final url = Urls.completeCustomQuest(id);
    print('🔵 [QuestService] POST $url');

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
    );

    print('🔵 [QuestService] completeCustomQuest statusCode=${response.statusCode}');
    print('🔵 [QuestService] completeCustomQuest body=${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Custom quest completion returned ${response.statusCode}');
    }
  }

  /// 7. Complete Unified Quest: POST /quests/today/complete (Milestone 3)
  Future<Map<String, dynamic>> completeUnifiedQuest({
    required String questId,
    required String questType,
  }) async {
    // If it's a custom quest, prefer the dedicated custom quest completion endpoint
    if (questType == 'CUSTOM') {
      try {
        return await completeCustomQuest(questId);
      } catch (e) {
        print('🟡 [QuestService] Custom complete failed, falling back to unified: $e');
      }
    }

    final headers = await _getHeaders();
    final body = jsonEncode({
      'questId': questId,
      'questType': questType,
    });

    print('🔵 [QuestService] POST ${Urls.completeQuestToday} body=$body');
    final response = await http.post(
      Uri.parse(Urls.completeQuestToday),
      headers: headers,
      body: body,
    );

    print('🔵 [QuestService] completeUnifiedQuest statusCode=${response.statusCode}');
    print('🔵 [QuestService] completeUnifiedQuest body=${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Unified quest completion returned ${response.statusCode}');
    }
  }

  /// 7. Add XP directly (Fallback / general XP logging)
  Future<AddXpResponse> addXp({required int xp, required String reason}) async {
    final headers = await _getHeaders();
    print('🔵 [QuestService] POST ${Urls.addXP}');

    final response = await http.post(
      Uri.parse(Urls.addXP),
      headers: headers,
      body: jsonEncode({'xp': xp, 'reason': reason}),
    );

    print('🔵 [QuestService] addXp statusCode=${response.statusCode}');
    print('🔵 [QuestService] addXp body=${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return AddXpResponse.fromJson(json);
    } else {
      throw Exception('Failed to add XP: ${response.statusCode}');
    }
  }
}