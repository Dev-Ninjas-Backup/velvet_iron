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
      // One-time cleanup to ensure old un-scoped custom quests & local completion overrides are wiped
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_custom_quests');
      await prefs.remove('user_custom_quests_date');
      await prefs.remove('locally_completed_quests_date');
      await prefs.remove('locally_completed_quest_ids');
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

  Future<void> fetchQuests() async {
    try {
      isLoading(true);
      errorMessage('');
      await loadMedicationPreference();

      final rawData = await _service.getQuests();
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
      print('🔴 [QuestController] Error fetching quests: $e');
      errorMessage('Failed to fetch quests');
    } finally {
      isLoading(false);
    }
  }

  /// Complete a quest (Custom quests complete via server API; Codex quests are activity-driven)
  Future<void> completeQuest(String questId) async {
    try {
      final data = questsData.value;
      if (data == null) return;

      final questIndex = data.quests.indexWhere((q) => q.id == questId || q.originalRefId == questId);
      if (questIndex == -1) return;
      final quest = data.quests[questIndex];
      if (quest.isDone) return;

      if (quest.questType == 'CODEX') {
        EasyLoading.showInfo('Complete this Codex quest by logging your daily activity in Daily Logs!');
        return;
      }

      EasyLoading.show(status: 'Completing quest...');
      try {
        await _service.completeUnifiedQuest(
          questId: quest.originalRefId ?? quest.id,
          questType: quest.questType,
        );
        print('🔵 [QuestController] Custom quest completed on server: ${quest.id}');
        EasyLoading.showSuccess('+${quest.xp} XP Earned!');

        try {
          final cached = await SharedPreferencesHelper.getActiveCompanion();
          final companionName = cached?['name'] ?? 'Thyra';
          CompanionDialogueEngine.showDialogueSnackbar(
            trigger: 'Quest Completed',
            companionName: companionName,
            duration: const Duration(seconds: 4),
          );
        } catch (_) {}

        await fetchQuests();

        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().fetchData();
        }
      } catch (e) {
        print('🔴 [QuestController] Error completing quest on server: $e');
        EasyLoading.showError('Could not complete quest on server.');
      }
    } catch (e) {
      errorMessage('Failed to complete quest');
    }
  }

  /// Automatically refresh daily quests from the backend when an activity is logged
  Future<void> onActivityLogged(String activityType, {Map<String, dynamic>? meta}) async {
    await fetchQuests();
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().fetchData();
    }
  }

  @override
  void onClose() {
    questsData.value = null;
    super.onClose();
  }
}
