// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/services/app_timezone_helper.dart';
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/quests/model/quest_model.dart';

class QuestService {
  Future<Map<String, String>> _getHeaders() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    final refreshToken = await SharedPreferencesHelper.getRefreshToken();
    final timezone = await AppTimezoneHelper.getTimezoneName();
    return {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'x-timezone': timezone,
      if (refreshToken != null && refreshToken.isNotEmpty)
        'x-refresh-token': refreshToken,
    };
  }

  /// 1. Unified Quests Feed: GET /quests/today (Milestone 3)
  Future<DailyQuestResponse> getUnifiedQuestsToday() async {
    final headers = await _getHeaders();
    final date = AppTimezoneHelper.getTodayDateString();
    final url = '${Urls.questsToday}?date=$date';
    print('🔵 [QuestService] GET $url');

    final response = await http.get(
      Uri.parse(url),
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
      print('🔵 [QuestService] Unified feed loaded successfully (${unified.quests.length} quests)');
      return unified;
    } catch (e) {
      print('🟡 [QuestService] Unified feed not yet available on server, using fallback: $e');
    }

    // Fallback: Legacy Codex Quests from /xp-stats/quests
    final headers = await _getHeaders();
    final date = AppTimezoneHelper.getTodayDateString();
    final url = '${Urls.quests}?date=$date';
    print('🔵 [QuestService] Fallback GET $url');

    final response = await http.get(
      Uri.parse(url),
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

  /// 3. Fetch Cloud Custom Quests: GET /custom-quest or GET /quests/custom
  Future<List<Quest>> getCustomQuests({String? date}) async {
    final headers = await _getHeaders();
    final targetDate = date ?? AppTimezoneHelper.getTodayDateString();
    final timezone = await AppTimezoneHelper.getTimezoneName();
    final primaryUrl = '${Urls.customQuest}?date=$targetDate&timezone=$timezone';
    print('🔵 [QuestService] GET $primaryUrl');

    http.Response response;
    try {
      response = await http.get(Uri.parse(primaryUrl), headers: headers);
    } catch (_) {
      response = await http.get(Uri.parse(Urls.customQuests), headers: headers);
    }

    if (response.statusCode == 404) {
      response = await http.get(Uri.parse(Urls.customQuests), headers: headers);
    }

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

  /// 4. Create Cloud Custom Quest: POST /custom-quest or POST /quests/custom
  Future<Quest?> createCustomQuest({
    required String name,
    required String category,
    String recurrence = 'DAILY',
    String? description,
    int xp = 10,
    List<int>? daysOfWeek,
  }) async {
    final headers = await _getHeaders();
    final cleanRecurrence = recurrence.toUpperCase().replaceAll(' ', '_');
    final clampedXp = xp.clamp(1, 15);
    final payload = {
      'title': name,
      'name': name,
      'category': category.toUpperCase(),
      'frequency': cleanRecurrence,
      'recurrence': cleanRecurrence,
      'xpReward': clampedXp,
      'xp': clampedXp,
      if (description != null && description.isNotEmpty)
        'description': description,
      if (daysOfWeek != null && daysOfWeek.isNotEmpty) ...{
        'daysOfWeek': daysOfWeek,
        'repeatDays': daysOfWeek,
      },
    };
    final body = jsonEncode(payload);

    print('🔵 [QuestService] POST ${Urls.customQuest} body=$body');
    http.Response response;
    try {
      response = await http.post(
        Uri.parse(Urls.customQuest),
        headers: headers,
        body: body,
      );
    } catch (e) {
      print('🟡 [QuestService] Primary custom-quest failed ($e), trying alternate: ${Urls.customQuests}');
      response = await http.post(
        Uri.parse(Urls.customQuests),
        headers: headers,
        body: body,
      );
    }

    if (response.statusCode == 404) {
      print('🟡 [QuestService] ${Urls.customQuest} returned 404, falling back to ${Urls.customQuests}');
      response = await http.post(
        Uri.parse(Urls.customQuests),
        headers: headers,
        body: body,
      );
    }

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

  /// 5. Delete Cloud Custom Quest: DELETE /custom-quest/:id or DELETE /quests/custom/:id
  Future<bool> deleteCustomQuest(String id, {String? fallbackId}) async {
    final headers = await _getHeaders();
    final cleanId = id.trim();
    final rawId = cleanId.startsWith('custom_') ? cleanId.substring(7) : cleanId;
    final candidates = <String>{cleanId, rawId};
    if (fallbackId != null && fallbackId.isNotEmpty) {
      candidates.add(fallbackId);
      if (fallbackId.startsWith('custom_')) {
        candidates.add(fallbackId.substring(7));
      }
    }

    for (final targetId in candidates) {
      final urlsToTry = [
        Urls.deleteCustomQuestV2(targetId),
        Urls.deleteCustomQuest(targetId),
      ];
      for (final url in urlsToTry) {
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
          print('🔴 [QuestService] Error deleting quest $targetId on $url: $e');
        }
      }
    }
    return false;
  }

  /// 6. Complete Custom Quest: POST /custom-quest/:id/complete (with PATCH / legacy fallbacks)
  Future<Map<String, dynamic>> completeCustomQuest(String id) async {
    final headers = await _getHeaders();
    final cleanId = id.trim();
    final rawId = cleanId.startsWith('custom_') ? cleanId.substring(7) : cleanId;
    final todayDate = AppTimezoneHelper.getTodayDateString();
    final reqBody = jsonEncode({'dateStr': todayDate});

    final candidateUrls = <String>[
      '${Urls.completeCustomQuestV2(cleanId)}?date=$todayDate',
      Urls.completeCustomQuestV2(cleanId),
      if (cleanId != rawId) '${Urls.completeCustomQuestV2(rawId)}?date=$todayDate',
      if (cleanId != rawId) Urls.completeCustomQuestV2(rawId),
      '${Urls.completeCustomQuest(cleanId)}?date=$todayDate',
      Urls.completeCustomQuest(cleanId),
      if (cleanId != rawId) Urls.completeCustomQuest(rawId),
    ];

    for (final url in candidateUrls) {
      print('🔵 [QuestService] Complete custom quest POST $url');
      try {
        var response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: reqBody,
        );
        print('🔵 [QuestService] completeCustomQuest statusCode=${response.statusCode} on $url');
        if (response.statusCode == 404 || response.statusCode == 405) {
          // Dual support: try PATCH
          print('🔵 [QuestService] Trying PATCH $url');
          response = await http.patch(
            Uri.parse(url),
            headers: headers,
            body: reqBody,
          );
          print('🔵 [QuestService] completeCustomQuest PATCH statusCode=${response.statusCode}');
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('✅ [QuestService] Custom quest successfully completed on $url');
          return jsonDecode(response.body) as Map<String, dynamic>;
        }
      } catch (e) {
        print('🟡 [QuestService] Error completing on $url: $e');
      }
    }

    throw Exception('Custom quest completion failed for $id');
  }

  /// 7. Complete Unified Quest: POST /quests/complete or POST /quests/today/complete (Milestone 3)
  Future<Map<String, dynamic>> completeUnifiedQuest({
    required String questId,
    required String questType,
  }) async {
    // If it's a custom quest, prefer the dedicated custom quest completion endpoint
    if (questType.toUpperCase() == 'CUSTOM') {
      try {
        return await completeCustomQuest(questId);
      } catch (e) {
        print('🟡 [QuestService] Custom complete failed, falling back to unified: $e');
      }
    }

    final headers = await _getHeaders();
    final cleanType = questType.toLowerCase().replaceAll('-', '_');
    final todayDate = AppTimezoneHelper.getTodayDateString();
    final body = jsonEncode({
      'questId': questId,
      'questType': cleanType,
      'dateStr': todayDate,
    });

    print('🔵 [QuestService] POST ${Urls.completeQuestToday} body=$body');
    http.Response response;
    try {
      response = await http.post(
        Uri.parse(Urls.completeQuestToday),
        headers: headers,
        body: body,
      );
    } catch (_) {
      response = await http.post(
        Uri.parse(Urls.completeQuest),
        headers: headers,
        body: body,
      );
    }

    if (response.statusCode == 404) {
      print('🟡 [QuestService] ${Urls.completeQuestToday} 404, falling back to ${Urls.completeQuest}');
      response = await http.post(
        Uri.parse(Urls.completeQuest),
        headers: headers,
        body: body,
      );
    }

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