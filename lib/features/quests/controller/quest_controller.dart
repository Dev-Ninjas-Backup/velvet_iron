// ignore_for_file: avoid_print

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvet_iron/core/services/companion_dialogue_engine.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/quests/model/quest_model.dart';
import 'package:velvet_iron/features/quests/service/quests_service.dart';

class QuestController extends GetxController {
  static const String _lastArticleXpKey = 'last_article_xp_time';

  final Rx<DailyQuestResponse?> questsData = Rx<DailyQuestResponse?>(null);
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
    _cleanupLegacyLocalQuests();
    fetchQuests();
  }

  Future<void> _cleanupLegacyLocalQuests() async {
    try {
      // One-time cleanup to ensure old un-scoped custom quests from previous installs are wiped
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_custom_quests');
      await prefs.remove('user_custom_quests_date');
    } catch (_) {}
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

  /// Create a new custom quest (Cloud via POST /quests/custom)
  Future<void> addCustomQuest({
    required String title,
    required String description,
    required int xp,
    String category = 'FITNESS',
    String recurrence = 'DAILY',
  }) async {
    try {
      EasyLoading.show(status: 'Forging quest...');
      final serverQuest = await _service.createCustomQuest(
        name: title,
        category: category,
        recurrence: recurrence,
      );

      if (serverQuest != null) {
        EasyLoading.showSuccess('Quest Forged!');
        CompanionDialogueEngine.showDialogueSnackbar(trigger: 'Quest Accepted');
        await fetchQuests();
      } else {
        EasyLoading.showError('Could not forge quest on server.');
      }
    } catch (e) {
      print('Cloud custom quest creation failed: $e');
      EasyLoading.showError('Could not forge quest');
    }
  }

  /// Delete a custom quest (Cloud via DELETE /quests/custom/:id)
  Future<void> deleteCustomQuest(String id) async {
    try {
      EasyLoading.show(status: 'Removing quest...');
      final success = await _service.deleteCustomQuest(id);
      if (success) {
        EasyLoading.showInfo('Quest removed');
        await fetchQuests();
      } else {
        EasyLoading.showError('Could not remove quest from server.');
      }
    } catch (e) {
      print('Failed to delete cloud custom quest: $e');
      EasyLoading.showError('Could not remove quest');
    }
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

      DailyQuestResponse rawData;
      try {
        final data = await _service.getQuests();
        if (data.quests.isEmpty) {
          rawData = DailyQuestResponse(
            todayTotalXp: data.todayTotalXp,
            todayLogCount: data.todayLogCount,
            quests: List.from(defaultDailyQuests),
          );
        } else {
          rawData = data;
        }
      } catch (e) {
        print('Using default daily quests fallback: $e');
        rawData = DailyQuestResponse(
          todayTotalXp: 0,
          todayLogCount: 0,
          quests: List.from(defaultDailyQuests),
        );
      }

      final filtered = _filterQuestsIfNeeded(rawData.quests);
      final completed = filtered.where((q) => q.isDone).length;
      final totalXp =
          filtered.where((q) => q.isDone).fold(0, (sum, q) => sum + q.xp);

      questsData.value = rawData.copyWith(
        quests: filtered,
        todayLogCount: completed,
        todayTotalXp: totalXp > 0 ? totalXp : rawData.todayTotalXp,
        meta: rawData.meta != null
            ? UnifiedQuestMeta(
                totalQuests: filtered.length,
                completedQuests: completed,
                todayCustomXpEarned: rawData.meta!.todayCustomXpEarned,
                dailyCustomXpCap: rawData.meta!.dailyCustomXpCap,
              )
            : null,
      );
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

      questsData.value = data.copyWith(
        quests: updatedQuests,
        todayTotalXp: data.todayTotalXp + quest.xp,
        todayLogCount: data.todayLogCount + 1,
      );

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

  @override
  void onClose() {
    questsData.value = null;
    super.onClose();
  }
}
