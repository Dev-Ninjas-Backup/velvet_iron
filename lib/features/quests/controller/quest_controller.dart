import 'dart:convert';
import 'package:velvet_iron/core/services/companion_dialogue_engine.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:velvet_iron/features/quests/model/quest_model.dart';
import 'package:velvet_iron/features/quests/service/quests_service.dart';

class QuestController extends GetxController {
  static const String _lastArticleXpKey = 'last_article_xp_time';

  Future<bool> canEarnArticleXp() async {
    final lastClaimStr = await SharedPreferencesHelper.getString(
      _lastArticleXpKey,
    );
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
      print(
        '🔵 [QuestController] XP Earned: xp=${response.xp}, reason=${response.reason}',
      );
      return 'You earned 10 XP for reading the article!';
    } catch (e) {
      errorMessage('Failed to earn XP for article');
      print('🔴 [QuestController] Error earning XP: $e');
      return 'Failed to earn XP: $e';
    } finally {
      isLoading(false);
    }
  }

  static const String _customQuestsKey = 'user_custom_quests';

  final Rx<DailyQuestResponse?> questsData = Rx<DailyQuestResponse?>(null);
  final RxList<Quest> customQuests = <Quest>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final QuestService _service = QuestService();

  int get logTarget {
    final count = questsData.value?.todayLogCount ?? 0;
    if (count < 10) return 10;
    if (count < 20) return 20;
    return 30;
  }

  @override
  void onInit() {
    super.onInit();
    fetchQuests();
  }

  Future<void> _loadCustomQuests() async {
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

  Future<void> _saveCustomQuests() async {
    try {
      final jsonStr = jsonEncode(customQuests.map((q) => q.toJson()).toList());
      await SharedPreferencesHelper.setString(_customQuestsKey, jsonStr);
      final todayStr = '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
      await SharedPreferencesHelper.setString('${_customQuestsKey}_date', todayStr);
    } catch (e) {
      print('Error saving custom quests: $e');
    }
  }

  Future<void> addCustomQuest({
    required String title,
    required String description,
    required int xp,
  }) async {
    final quest = Quest(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      xp: xp,
      description: description,
      isDone: false,
    );
    customQuests.add(quest);
    await _saveCustomQuests();
    _mergeCustomQuestsIntoData();
    CompanionDialogueEngine.showDialogueSnackbar(trigger: 'Quest Accepted');
  }

  Future<void> deleteCustomQuest(String id) async {
    customQuests.removeWhere((q) => q.id == id);
    await _saveCustomQuests();
    _mergeCustomQuestsIntoData();
  }

  void _mergeCustomQuestsIntoData() {
    final current = questsData.value;
    if (current == null) {
      questsData.value = DailyQuestResponse(
        todayTotalXp: 0,
        todayLogCount: 0,
        quests: List.from(customQuests),
      );
      return;
    }

    // Keep server quests and append custom quests
    final serverQuests = current.quests.where((q) => !q.id.startsWith('custom_')).toList();
    final combined = [...serverQuests, ...customQuests];

    questsData.value = current.copyWith(quests: combined);
  }

  static const List<Quest> defaultDailyQuests = [
    Quest(
      id: 'daily_water',
      title: 'Hydration of the Ancients',
      description: 'Drink 8 glasses of water throughout the day',
      xp: 15,
      isDone: false,
    ),
    Quest(
      id: 'daily_steps',
      title: 'Stride of the Ranger',
      description: 'Walk 5,000 steps or complete active movement',
      xp: 25,
      isDone: false,
    ),
    Quest(
      id: 'daily_mindful',
      title: 'Codex Reflection',
      description: 'Log your daily mood & check in with your companion',
      xp: 10,
      isDone: false,
    ),
  ];

  Future<void> fetchQuests() async {
    try {
      isLoading(true);
      errorMessage('');
      await _loadCustomQuests();
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

  Future<void> completeQuest(String questId) async {
    try {
      final data = questsData.value;
      if (data != null) {
        final questIndex = data.quests.indexWhere((q) => q.id == questId);
        if (questIndex == -1) return;
        final quest = data.quests[questIndex];
        if (quest.isDone) return;

        final updatedQuests = data.quests
            .map((q) => q.id == questId ? q.copyWith(isDone: true) : q)
            .toList();

        if (questId.startsWith('custom_')) {
          final cIndex = customQuests.indexWhere((q) => q.id == questId);
          if (cIndex != -1) {
            customQuests[cIndex] = customQuests[cIndex].copyWith(isDone: true);
            await _saveCustomQuests();
          }
        }

        // Try to add XP to backend
        try {
          await _service.addXp(xp: quest.xp, reason: 'Quest: ${quest.title}');
        } catch (e) {
          print('Failed to sync quest XP with server: $e');
        }

        questsData(
          data.copyWith(
            quests: updatedQuests,
            todayTotalXp: data.todayTotalXp + quest.xp,
            todayLogCount: data.todayLogCount + 1,
          ),
        );

        // Display companion congratulatory dialogue line
        try {
          final cached = await SharedPreferencesHelper.getActiveCompanion();
          final companionName = cached?['name'] ?? 'Thyra';
          // Companion dialogue celebration with enlarged portrait bust
          CompanionDialogueEngine.showDialogueSnackbar(
            trigger: 'Quest Completed',
            companionName: companionName,
            duration: const Duration(seconds: 4),
          );
        } catch (e) {
          print('Could not display companion quest dialogue: $e');
        }
      }
    } catch (e) {
      errorMessage('Failed to complete quest');
    }
  }
}
