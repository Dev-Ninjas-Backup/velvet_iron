// ignore_for_file: avoid_print

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvet_iron/core/services/companion_dialogue_engine.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/exercise/controller/exercise_controller.dart';
import 'package:velvet_iron/features/exercise/model/exercise_model.dart';
import 'package:velvet_iron/features/exercise/service/exercise_service.dart';
import 'package:velvet_iron/features/home/controller/home_controller.dart';
import 'package:velvet_iron/features/quests/model/quest_model.dart';
import 'package:velvet_iron/features/quests/service/quests_service.dart';
import 'package:velvet_iron/features/medication_screen/service/medication_service.dart';

class QuestController extends GetxController {
  static const String _lastArticleXpKey = 'last_article_xp_time';

  final Rx<DailyQuestResponse?> questsData = Rx<DailyQuestResponse?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool enableMedicationQuest = false.obs;
  final RxInt preferredInjectionDay = 7.obs; // 1 = Mon ... 7 = Sun (Default: Sunday)

  final QuestService _service = QuestService();

  int get logTarget {
    final total = questsData.value?.quests.length ?? 0;
    return total > 0 ? total : 4;
  }

  Future<void> loadMedicationPreference() async {
    final enabled = await SharedPreferencesHelper.getBool('enable_medication_quest');
    enableMedicationQuest.value = enabled ?? false;
    final day = await SharedPreferencesHelper.getInt('preferred_injection_day');
    preferredInjectionDay.value = (day != null && day >= 1 && day <= 7) ? day : 7;
  }

  Future<void> setPreferredInjectionDay(int day) async {
    if (day < 1 || day > 7) return;
    preferredInjectionDay.value = day;
    await SharedPreferencesHelper.setInt('preferred_injection_day', day);
    
    // Sync weekly GLP-1 injection schedule with backend
    try {
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();
      if (accessToken != null && refreshToken != null) {
        await MedicationService().scheduleMedication(
          name: 'GLP-1 Injection',
          type: 'INJECTION',
          doseMg: 5,
          scheduleTime: DateTime.now().toUtc().toIso8601String(),
          recurrence: 'WEEKLY',
          daysOfWeek: [day],
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      }
    } catch (e) {
      print('🟡 [QuestController] Could not sync weekly injection schedule: $e');
    }
    await fetchQuests();
  }

  Future<void> toggleMedicationQuest(bool value) async {
    enableMedicationQuest.value = value;
    await SharedPreferencesHelper.setBool('enable_medication_quest', value);
    await SharedPreferencesHelper.setBool('user_takes_medication', value);
    if (value) {
      await setPreferredInjectionDay(preferredInjectionDay.value);
    }
    await fetchQuests();
    if (value) {
      const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      final dayName = days[preferredInjectionDay.value - 1];
      EasyLoading.showSuccess('Weekly GLP-1 quest scheduled for every $dayName!');
    } else {
      EasyLoading.showInfo('Medication quest hidden from Codex.');
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

  /// Create a new custom quest (Cloud via POST /quests/custom or /custom-quests)
  Future<void> addCustomQuest({
    required String title,
    required String description,
    required int xp,
    String category = 'FITNESS',
    String recurrence = 'DAILY',
    List<int>? daysOfWeek,
  }) async {
    try {
      EasyLoading.show(status: 'Forging quest...');
      final serverQuest = await _service.createCustomQuest(
        name: title,
        category: category,
        recurrence: recurrence,
        description: description,
        xp: xp,
        daysOfWeek: daysOfWeek,
      );

      if (serverQuest != null) {
        EasyLoading.showSuccess('Quest Forged! (+${serverQuest.xp} XP)');
        CompanionDialogueEngine.showDialogueSnackbar(trigger: 'Quest Accepted');
        await fetchQuests();
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().fetchData();
        }
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
    final todayWeekday = DateTime.now().weekday; // 1 = Monday ... 7 = Sunday
    final isInjectionDay = todayWeekday == preferredInjectionDay.value;

    return list.where((q) {
      final lowerTitle = q.title.toLowerCase();
      final lowerId = q.id.toLowerCase();
      final isMedQuest = q.questType == 'MEDICATION_SCHEDULE' ||
          lowerTitle.contains('elixir of the alchemist') ||
          lowerTitle.contains('track your shot') ||
          lowerTitle.contains('glp-1') ||
          lowerTitle.contains('injection') ||
          lowerId.contains('track-your-shot') ||
          lowerId.contains('track_your_shot') ||
          lowerId.startsWith('med_');

      if (!isMedQuest) return true;

      // If user disabled medication quest, hide it
      if (!enableMedicationQuest.value) return false;

      // If enabled, only appear on their preferred weekly injection day
      return isInjectionDay;
    }).toList();
  }

  /// Synchronize workouts scheduled for user's local today into Today's Quests
  Future<List<Quest>> _syncScheduledExercisesWithQuests(List<Quest> backendQuests) async {
    List<Exercise> allExercises = [];
    if (Get.isRegistered<ExerciseController>()) {
      final exCtrl = Get.find<ExerciseController>();
      if (exCtrl.exercises.isEmpty) {
        await exCtrl.fetchExerciseHistory();
      }
      allExercises = exCtrl.exercises;
    } else {
      try {
        final res = await ExerciseService().fetchExerciseHistory();
        if (res != null && res['logs'] is List) {
          allExercises = (res['logs'] as List)
              .map((e) => Exercise.fromJson(e))
              .toList();
        }
      } catch (e) {
        print('🟡 [QuestController] Could not fetch exercise history: $e');
      }
    }

    final now = DateTime.now();
    // Strictly filter exercises scheduled for TODAY in user's device local timezone
    final todayExercises = allExercises.where((ex) {
      if (ex.scheduledAt == null) return false;
      final local = ex.scheduledAt!.toLocal();
      return local.year == now.year &&
          local.month == now.month &&
          local.day == now.day;
    }).toList();

    final result = <Quest>[];

    // Filter out any WORKOUT_SCHEDULE quest from backend that doesn't match local today
    for (final q in backendQuests) {
      if (q.questType == 'WORKOUT_SCHEDULE') {
        if (q.scheduledAt != null) {
          final local = q.scheduledAt!.toLocal();
          if (local.year != now.year || local.month != now.month || local.day != now.day) {
            continue; // Exclude workout that isn't on local calendar day
          }
        }
      }
      result.add(q);
    }

    // Merge each today's scheduled exercise into quests
    for (final ex in todayExercises) {
      final matchIndex = result.indexWhere((q) =>
          q.id == 'workout_${ex.id}' ||
          q.id == ex.id ||
          q.originalRefId == ex.id ||
          (q.questType == 'WORKOUT_SCHEDULE' &&
              q.title.toLowerCase().trim() == ex.name.toLowerCase().trim()));

      final formattedDesc = Quest.formatWorkoutScheduleDescription(
        type: ex.type,
        duration: ex.duration,
        scheduledAt: ex.scheduledAt!,
      );

      if (matchIndex != -1) {
        // Update existing quest with local timezone formatted description & status
        final existing = result[matchIndex];
        result[matchIndex] = existing.copyWith(
          id: 'workout_${ex.id}',
          title: ex.name.isNotEmpty ? ex.name : ex.type,
          description: formattedDesc,
          isDone: ex.isTaken,
          questType: 'WORKOUT_SCHEDULE',
          originalRefId: ex.id,
          category: ex.type,
          scheduledAt: ex.scheduledAt,
        );
      } else {
        // Backend didn't include it (or filtered by server date) - insert at top
        result.insert(
          0,
          Quest(
            id: 'workout_${ex.id}',
            title: ex.name.isNotEmpty ? ex.name : ex.type,
            xp: ex.earnedXp > 0 ? ex.earnedXp : 10,
            description: formattedDesc,
            isDone: ex.isTaken,
            questType: 'WORKOUT_SCHEDULE',
            originalRefId: ex.id,
            category: ex.type,
            scheduledAt: ex.scheduledAt,
          ),
        );
      }
    }

    return result;
  }

  Future<void> fetchQuests() async {
    try {
      isLoading(true);
      errorMessage('');
      await loadMedicationPreference();

      final rawData = await _service.getQuests();
      final filtered = _filterQuestsIfNeeded(rawData.quests);
      final syncedQuests = await _syncScheduledExercisesWithQuests(filtered);
      final completed = syncedQuests.where((q) => q.isDone).length;
      final totalXp =
          syncedQuests.where((q) => q.isDone).fold(0, (sum, q) => sum + q.xp);

      questsData.value = rawData.copyWith(
        quests: syncedQuests,
        todayLogCount: completed,
        todayTotalXp: totalXp > 0 ? totalXp : rawData.todayTotalXp,
        meta: rawData.meta != null
            ? UnifiedQuestMeta(
                totalQuests: syncedQuests.length,
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

  /// Complete a quest (Custom & Workout quests complete via server API; Codex quests are activity-driven)
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

      if (quest.questType == 'WORKOUT_SCHEDULE') {
        EasyLoading.show(status: 'Completing workout...');
        final exerciseId = quest.originalRefId ??
            (quest.id.startsWith('workout_') ? quest.id.substring(8) : quest.id);

        bool marked = false;
        if (Get.isRegistered<ExerciseController>()) {
          try {
            await Get.find<ExerciseController>().markExerciseAsTaken(exerciseId);
            marked = true;
          } catch (e) {
            print('🟡 [QuestController] ExerciseController mark as taken failed: $e');
          }
        }
        if (!marked) {
          try {
            final accessToken = await SharedPreferencesHelper.getAccessToken();
            final refreshToken = await SharedPreferencesHelper.getRefreshToken();
            if (accessToken != null && refreshToken != null) {
              await ExerciseService().markExerciseAsTaken(
                exerciseId: exerciseId,
                accessToken: accessToken,
                refreshToken: refreshToken,
              );
            }
          } catch (e) {
            print('🟡 [QuestController] ExerciseService mark as taken failed: $e');
          }
        }

        try {
          await _service.completeUnifiedQuest(
            questId: exerciseId,
            questType: 'WORKOUT_SCHEDULE',
          );
        } catch (_) {}

        EasyLoading.showSuccess('+${quest.xp} XP Earned!');
        await fetchQuests();
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().fetchData();
        }
        return;
      }

      EasyLoading.show(status: 'Completing quest...');
      try {
        if (quest.questType == 'CUSTOM' ||
            quest.id.startsWith('custom_') ||
            (quest.originalRefId != null && quest.originalRefId!.startsWith('custom_'))) {
          final targetId = quest.originalRefId ?? quest.id;
          final res = await _service.completeCustomQuest(targetId);
          print('🔵 [QuestController] Custom quest completed on server: ${quest.id} -> $res');
          final earnedXp = res['earnedXp'] ?? res['data']?['xpAwarded'] ?? quest.xp;
          EasyLoading.showSuccess('+$earnedXp XP Earned!');
        } else {
          await _service.completeUnifiedQuest(
            questId: quest.originalRefId ?? quest.id,
            questType: quest.questType,
          );
          print('🔵 [QuestController] Quest completed on server: ${quest.id}');
          EasyLoading.showSuccess('+${quest.xp} XP Earned!');
        }

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
