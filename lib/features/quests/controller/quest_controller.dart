// ignore_for_file: avoid_print

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvet_iron/core/services/companion_dialogue_engine.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/home/controller/home_controller.dart';
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
      final currentQuests = questsData.value?.quests ?? [];
      final quest = currentQuests.firstWhereOrNull((q) => q.id == id || q.originalRefId == id);
      final fallbackId = quest?.originalRefId;

      final success = await _service.deleteCustomQuest(id, fallbackId: fallbackId);
      if (success) {
        if (questsData.value != null) {
          final updated = questsData.value!.quests.where((q) => q.id != id && q.originalRefId != id).toList();
          questsData.value = questsData.value!.copyWith(quests: updated);
        }
        EasyLoading.showInfo('Quest removed');
        await fetchQuests();
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().fetchData();
        }
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
      description: 'Walk 5,000 steps in the step tracker',
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

  /// Complete a quest (Unified completion routing, works for all types including CODEX)
  Future<void> completeQuest(String questId) async {
    try {
      final data = questsData.value;
      if (data == null) return;

      final questIndex = data.quests.indexWhere((q) => q.id == questId || q.originalRefId == questId);
      if (questIndex == -1) return;
      final quest = data.quests[questIndex];
      if (quest.isDone) return;

      // Update local state immediately
      final updatedQuests = data.quests
          .map((q) => (q.id == quest.id || q.originalRefId == quest.id) ? q.copyWith(isDone: true) : q)
          .toList();

      questsData.value = data.copyWith(
        quests: updatedQuests,
        todayTotalXp: data.todayTotalXp + quest.xp,
        todayLogCount: data.todayLogCount + 1,
      );

      // Route through Milestone 3 unified completion endpoint or fallback
      try {
        await _service.completeUnifiedQuest(
          questId: quest.originalRefId ?? quest.id,
          questType: quest.questType,
        );
        print('🔵 [QuestController] Quest completed on server: ${quest.id} (${quest.questType})');
      } catch (e) {
        print('🟡 [QuestController] Falling back to addXp for completion: $e');
        try {
          await _service.addXp(xp: quest.xp, reason: 'Quest: ${quest.title}');
        } catch (_) {}
      }

      EasyLoading.showSuccess('+${quest.xp} XP Earned!');

      // Sync HomeController so Home screen immediately reflects completion
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().fetchData();
      }

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

  /// Automatically trigger completion of corresponding Codex quest when an activity is logged
  Future<void> onActivityLogged(String activityType, {Map<String, dynamic>? meta}) async {
    final data = questsData.value;
    if (data == null || data.quests.isEmpty) {
      await fetchQuests();
    }
    final currentData = questsData.value;
    if (currentData == null) return;

    final targetQuests = <Quest>[];
    final lower = activityType.toLowerCase();

    for (final q in currentData.quests) {
      if (q.isDone) continue;
      final t = q.title.toLowerCase();
      final id = q.id.toLowerCase();
      final ref = (q.originalRefId ?? '').toLowerCase();

      if (lower.contains('mood') || lower.contains('spirit')) {
        if (t.contains('attunement') || t.contains('spirit') || t.contains('mood') || id.contains('mood') || ref.contains('mood')) {
          targetQuests.add(q);
        }
      } else if (lower.contains('meal') || lower.contains('food') || lower.contains('nutrition')) {
        final proteinAmount = (meta?['protein'] as num?)?.toDouble() ?? 0.0;
        final mealCount = (meta?['mealCount'] as num?)?.toInt() ?? 1;

        // 1. Protein-specific quest: "Titan's Nourishment" / "protein-power" (requires 30g+ protein)
        final isProteinQuest = t.contains('nourishment') || t.contains('titan') || t.contains('protein') || id.contains('protein') || ref.contains('protein');
        if (isProteinQuest) {
          if (proteinAmount >= 30.0) {
            targetQuests.add(q);
          }
          continue;
        }

        // 2. Three meals a day quest: "Feast of the Hearth" / "three-meals" (requires 3 meals logged)
        final isThreeMealsQuest = t.contains('feast') || t.contains('hearth') || t.contains('three-meal') || id.contains('three-meal') || ref.contains('three-meal');
        if (isThreeMealsQuest) {
          if (mealCount >= 3) {
            targetQuests.add(q);
          }
          continue;
        }

        // 3. Generic custom meal quest
        if (t.contains('meal') || id.contains('meal') || ref.contains('meal') || t.contains('nutrition')) {
          targetQuests.add(q);
        }
      } else if (lower.contains('water') || lower.contains('hydration')) {
        if (t.contains('hydration') || t.contains('ancients') || t.contains('water') || id.contains('water') || ref.contains('water')) {
          targetQuests.add(q);
        }
      } else if (lower.contains('exercise') || lower.contains('workout') || lower.contains('training') || lower.contains('run')) {
        // IMPORTANT (Issue 2): Never complete step quests when an exercise/workout is logged!
        final isStepQuest = t.contains('stride') || t.contains('realmwalker') || t.contains('step') || id.contains('step') || ref.contains('step');
        if (isStepQuest) {
          continue;
        }

        if (t.contains('training') || t.contains('workout') || t.contains('exercise') || t.contains('iron') || id.contains('workout') || id.contains('exercise')) {
          targetQuests.add(q);
        }
      } else if (lower.contains('step') || lower.contains('walk')) {
        if (t.contains('stride') || t.contains('realmwalker') || t.contains('step') || id.contains('step') || ref.contains('step')) {
          targetQuests.add(q);
        }
      } else if (lower.contains('med') || lower.contains('dose') || lower.contains('alchemy')) {
        if (t.contains('elixir') || t.contains('medication') || t.contains('alchemy') || t.contains('dose') || id.contains('medication') || ref.contains('medication')) {
          targetQuests.add(q);
        }
      }
    }

    for (final targetQuest in targetQuests) {
      print('🔵 [QuestController] Auto-completing tracked quest: ${targetQuest.title}');
      await completeQuest(targetQuest.id);
    }
  }

  @override
  void onClose() {
    questsData.value = null;
    super.onClose();
  }
}
