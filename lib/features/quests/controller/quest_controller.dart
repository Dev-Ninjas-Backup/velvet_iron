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

  final Rx<DailyQuestResponse?> questsData = Rx<DailyQuestResponse?>(null);
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

  Future<void> fetchQuests() async {
    try {
      isLoading(true);
      errorMessage('');
      final data = await _service.getQuests();
      questsData(data);
    } catch (e) {
      errorMessage('Failed to fetch quests');
    } finally {
      isLoading(false);
    }
  }

  Future<void> completeQuest(String questId) async {
    try {
      isLoading(true);
      errorMessage('');

      final data = questsData.value;
      if (data != null) {
        final updatedQuests = data.quests
            .map((q) => q.id == questId ? q.copyWith(isDone: true) : q)
            .toList();

        final completedXp = data.quests
            .firstWhere(
              (q) => q.id == questId,
              orElse: () => updatedQuests.first,
            )
            .xp;

        questsData(
          data.copyWith(
            quests: updatedQuests,
            todayTotalXp: data.todayTotalXp + completedXp,
            todayLogCount: data.todayLogCount + 1,
          ),
        );
      }
    } catch (e) {
      errorMessage('Failed to complete quest');
    } finally {
      isLoading(false);
    }
  }
}
