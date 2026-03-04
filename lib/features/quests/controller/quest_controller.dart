import 'package:get/get.dart';
import 'package:velvet_iron/features/quests/model/quest_model.dart';
import 'package:velvet_iron/features/quests/service/quests_service.dart';

class QuestController extends GetxController {
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
