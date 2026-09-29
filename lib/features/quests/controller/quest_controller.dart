// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/services/companion_dialogue_engine.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/quests/model/quest_model.dart';
import 'package:velvet_iron/features/quests/service/quests_service.dart';

class QuestController extends GetxController {
  static const String _lastArticleXpKey = 'last_article_xp_time';
  static const String _customQuestsKey = 'user_custom_quests';

  final Rx<DailyQuestResponse?> questsData = Rx<DailyQuestResponse?>(null);
  final RxList<Quest> customQuests = <Quest>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool enableMedicationQuest = false.obs;

  final QuestService _service = QuestService();

  int get logTarget {
    final total = questsData.value?.quests.length ?? 0;
    return total > 0 ? total : 4;
  }

  Future<void> loadMedicationPreference() async {
    final enabled = await SharedPreferencesHelper.getBool('enable_medication_quest');
    enableMedicationQuest.value = enabled ?? false;
  }

  Future<void> toggleMedicationQuest(bool value) async {
    enableMedicationQuest.value = value;
    await SharedPreferencesHelper.setBool('enable_medication_quest', value);
    await SharedPreferencesHelper.setBool('user_takes_medication', value);
    await fetchQuests();
    if (value) {
      EasyLoading.showSuccess('Medication quest added to your daily Codex!');
    } else {
      EasyLoading.showInfo('Medication quest hidden from daily Codex.');
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchQuests();
  }

  Future<bool> canEarnArticleXp() async {
    final lastClaimStr = await SharedPreferencesHelper.getString(_lastArticleXpKey);
    if (lastClaimStr == null) return true;
    final lastClaim = DateTime.tryParse(lastClaimStr);
    if (lastClaim == null) return true;
    final now = DateTime.now();
    return now.difference(lastClaim).inHours >= 24;
  }

  Future<void> setLastArticleXpTime() async {
    await SharedPreferencesHelper.setString(
      _lastArticleXpKey,
      DateTime.now().toIso8601String(),
    );
  }

  Future<String> earnArticleXp() async {
    if (!await canEarnArticleXp()) {
      return 'You have already claimed XP for reading an article in the last 24 hours.';
    }
    try {
      isLoading(true);
      errorMessage('');
      final response = await _service.addXp(xp: 10, reason: 'Read Article');
      await setLastArticleXpTime();
      print('🔵 [QuestController] XP Earned: xp=${response.xp}, reason=${response.reason}');
      return 'You earned 10 XP for reading the article!';
    } catch (e) {
      errorMessage('Failed to earn XP for article');
      print('🔴 [QuestController] Error earning XP: $e');
      return 'Failed to earn XP: $e';
    } finally {
      isLoading(false);
    }
  }

  Future<void> _loadLocalCustomQuests() async {
    try {
      final jsonStr = await SharedPreferencesHelper.getString(_customQuestsKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final List list = jsonDecode(jsonStr);
        final todayStr = '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
        final savedToday = await SharedPreferencesHelper.getString('${_customQuestsKey}_date');

        customQuests.assignAll(list.map((item) {
          final q = Quest.fromJson(item as Map<String, dynamic>);
          // If a new day, reset isDone
          if (savedToday != todayStr) {
            return q.copyWith(isDone: false);
          }
          return q;
        }).toList());
      }
    } catch (e) {
      print('Error loading custom quests: $e');
    }
  }

  Future<void> _saveLocalCustomQuests() async {
    try {
      final jsonStr = jsonEncode(customQuests.map((q) => q.toJson()).toList());
      await SharedPreferencesHelper.setString(_customQuestsKey, jsonStr);
      final todayStr = '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
      await SharedPreferencesHelper.setString('${_customQuestsKey}_date', todayStr);
    } catch (e) {
      print('Error saving custom quests: $e');
    }
  }

  /// Create a new custom quest (Syncs to Cloud + local fallback)
  Future<void> addCustomQuest({
    required String title,
    required String description,
    required int xp,
    String category = 'FITNESS',
    String recurrence = 'DAILY',
  }) async {
    try {
      EasyLoading.show(status: 'Forging quest...');
      Quest? serverQuest;
      try {
        serverQuest = await _service.createCustomQuest(
          name: title,
          category: category,
          recurrence: recurrence,
        );
      } catch (e) {
        print('Cloud custom quest creation failed, falling back to local: $e');
      }

      final quest = serverQuest ??
          Quest(
            id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
            title: title,
            xp: xp,
            description: description,
            isDone: false,
            questType: 'CUSTOM',
            category: category,
          );

      customQuests.add(quest);
      await _saveLocalCustomQuests();
      _mergeCustomQuestsIntoData();

      EasyLoading.showSuccess('Quest Forged!');
      CompanionDialogueEngine.showDialogueSnackbar(trigger: 'Quest Accepted');
    } catch (e) {
      EasyLoading.showError('Could not forge quest');
    }
  }

  /// Delete a custom quest (Cloud + local)
  Future<void> deleteCustomQuest(String id) async {
    try {
      // If it has a UUID ID from server, delete from cloud
      if (!id.startsWith('custom_')) {
        await _service.deleteCustomQuest(id);
      }
    } catch (e) {
      print('Failed to delete cloud custom quest: $e');
    }

    customQuests.removeWhere((q) => q.id == id);
    await _saveLocalCustomQuests();
    _mergeCustomQuestsIntoData();
    EasyLoading.showInfo('Quest removed');
  }

  List<Quest> _filterQuestsIfNeeded(List<Quest> list) {
    if (enableMedicationQuest.value) return list;
    return list.where((q) {
      final lowerTitle = q.title.toLowerCase();
      final lowerId = q.id.toLowerCase();
      final isMedQuest = lowerTitle.contains('elixir of the alchemist') ||
          lowerTitle.contains('track your shot') ||
          lowerId.contains('track-your-shot') ||
          lowerId.contains('track_your_shot') ||
          lowerId.startsWith('med_');
      return !isMedQuest;
    }).toList();
  }

  void _mergeCustomQuestsIntoData() {
    final current = questsData.value;
    if (current == null) {
      final filteredCustom = _filterQuestsIfNeeded(customQuests);
      final completed = filteredCustom.where((q) => q.isDone).length;
      final totalXp = filteredCustom.where((q) => q.isDone).fold(0, (sum, q) => sum + q.xp);
      questsData.value = DailyQuestResponse(
        todayTotalXp: totalXp,
        todayLogCount: completed,
        quests: List.from(filteredCustom),
      );
      return;
    }

    // Keep server non-custom quests and append custom quests uniquely
    final nonCustomQuests = current.quests.where((q) => q.questType != 'CUSTOM' && !q.id.startsWith('custom_')).toList();
    final Map<String, Quest> mergedMap = {};

    for (final q in nonCustomQuests) {
      mergedMap[q.id] = q;
    }
    // Add cloud and local custom quests
    for (final q in current.quests.where((q) => q.questType == 'CUSTOM')) {
      mergedMap[q.id] = q;
    }
    for (final q in customQuests) {
      mergedMap[q.id] = q;
    }

    final filtered = _filterQuestsIfNeeded(mergedMap.values.toList());
    final completed = filtered.where((q) => q.isDone).length;
    final totalXp = filtered.where((q) => q.isDone).fold(0, (sum, q) => sum + q.xp);

    questsData.value = current.copyWith(
      quests: filtered,
      todayLogCount: completed,
      todayTotalXp: totalXp > 0 ? totalXp : current.todayTotalXp,
      meta: current.meta != null
          ? UnifiedQuestMeta(
              totalQuests: filtered.length,
              completedQuests: completed,
              todayCustomXpEarned: current.meta!.todayCustomXpEarned,
              dailyCustomXpCap: current.meta!.dailyCustomXpCap,
            )
          : null,
    );
  }

  static const List<Quest> defaultDailyQuests = [
    Quest(
      id: 'daily_water',
      title: 'Hydration of the Ancients',
      description: 'Drink 8 glasses of water throughout the day',
      xp: 15,
      isDone: false,
      questType: 'CODEX',
    ),
    Quest(
      id: 'daily_steps',
      title: 'Stride of the Ranger',
      description: 'Walk 5,000 steps or complete active movement',
      xp: 25,
      isDone: false,
      questType: 'CODEX',
    ),
    Quest(
      id: 'daily_mindful',
      title: 'Codex Reflection',
      description: 'Log your daily mood & check in with your companion',
      xp: 10,
      isDone: false,
      questType: 'CODEX',
    ),
  ];

  Future<void> fetchQuests() async {
    try {
      isLoading(true);
      errorMessage('');
      await loadMedicationPreference();
      await _loadLocalCustomQuests();

      try {
        final data = await _service.getQuests();
        if (data.quests.isEmpty) {
          questsData(
            DailyQuestResponse(
              todayTotalXp: data.todayTotalXp,
              todayLogCount: data.todayLogCount,
              quests: List.from(defaultDailyQuests),
            ),
          );
        } else {
          questsData(data);
        }
      } catch (e) {
        print('Using local custom quests fallback: $e');
        questsData(
          DailyQuestResponse(
            todayTotalXp: 0,
            todayLogCount: 0,
            quests: List.from(defaultDailyQuests),
          ),
        );
      }
      _mergeCustomQuestsIntoData();
    } catch (e) {
      errorMessage('Failed to fetch quests');
    } finally {
      isLoading(false);
    }
  }

  /// Complete a quest (Unified completion routing with CODEX auto-complete guidance)
  Future<void> completeQuest(String questId) async {
    try {
      final data = questsData.value;
      if (data == null) return;

      final questIndex = data.quests.indexWhere((q) => q.id == questId);
      if (questIndex == -1) return;
      final quest = data.quests[questIndex];
      if (quest.isDone) return;

      // 1. CODEX quests cannot be completed manually (completed by user activities)
      if (quest.questType == 'CODEX') {
        EasyLoading.showInfo(
          'Codex quests are automatically tracked when you log your activities (meals, steps, water, workouts)!',
        );
        return;
      }

      // 2. Complete non-CODEX quests (CUSTOM, MEDICATION_SCHEDULE, WORKOUT_SCHEDULE)
      final updatedQuests = data.quests
          .map((q) => q.id == questId ? q.copyWith(isDone: true) : q)
          .toList();

      if (quest.questType == 'CUSTOM') {
        final cIndex = customQuests.indexWhere((q) => q.id == questId);
        if (cIndex != -1) {
          customQuests[cIndex] = customQuests[cIndex].copyWith(isDone: true);
          await _saveLocalCustomQuests();
        }
      }

      // Route through Milestone 3 unified completion endpoint or fallback
      try {
        await _service.completeUnifiedQuest(
          questId: quest.originalRefId ?? questId,
          questType: quest.questType,
        );
        print('🔵 [QuestController] Unified quest completed on server: $questId');
      } catch (e) {
        print('🟡 [QuestController] Falling back to addXp for completion: $e');
        try {
          await _service.addXp(xp: quest.xp, reason: 'Quest: ${quest.title}');
        } catch (_) {}
      }

      questsData(
        data.copyWith(
          quests: updatedQuests,
          todayTotalXp: data.todayTotalXp + quest.xp,
          todayLogCount: data.todayLogCount + 1,
        ),
      );

      EasyLoading.showSuccess('+${quest.xp} XP Earned!');

      // Display companion celebratory dialogue
      try {
        final cached = await SharedPreferencesHelper.getActiveCompanion();
        final companionName = cached?['name'] ?? 'Thyra';
        CompanionDialogueEngine.showDialogueSnackbar(
          trigger: 'Quest Completed',
          companionName: companionName,
          duration: const Duration(seconds: 4),
        );
      } catch (e) {
        print('Could not display companion quest dialogue: $e');
      }
    } catch (e) {
      errorMessage('Failed to complete quest');
    }
  }
}
