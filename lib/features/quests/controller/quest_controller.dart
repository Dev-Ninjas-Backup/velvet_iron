import 'package:get/get.dart';
import 'package:flutter/material.dart'; // Import for Color
import 'package:velvet_iron/features/quests/model/quest_model.dart';

class QuestController extends GetxController {
  final Rx<QuestsData?> questsData = Rx<QuestsData?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // final QuestService _service = QuestService();

  @override
  void onInit() {
    super.onInit();
    fetchQuests();
  }

  Future<void> fetchQuests() async {
    try {
      isLoading(true);
      errorMessage('');
      // final data = await _service.getQuests();
      // questsData(data);

      // Simulated API response
      await Future.delayed(const Duration(seconds: 1));
      final mockQuestsData = QuestsData(
        progressPoints: QuestProgress(
          iconPath: 'steelyard',
          header: "Today's Progress",
          points: "2/10",
        ),
        totalXp: QuestProgress(
          iconPath: 'trophy',
          header: "Today's Progress",
          points: "45 XP",
        ),
        todaysQuests: [
          Quest(
            id: '1',
            header: 'Track Your Shot',
            title: 'Log your GLP-1 medication',
            tagText: 'Health',
            tagGradient: const [Color(0xFFA60404), Color(0xFFF0AA48)],
            xp: 10,
            completed: false,
          ),
          Quest(
            id: '2',
            header: 'Three Meals a Day',
            title: 'Log breakfast, lunch, and dinner',
            tagText: 'Nutrition',
            tagGradient: const [Color(0xFF04A647), Color(0xFFF0AA48)],
            xp: 30,
            completed: false,
          ),
          Quest(
            id: '3',
            header: 'Mood Check',
            title: 'Log your mood and energy levels',
            tagText: 'Mindfulness',
            tagGradient: const [Color(0xFF7804A6), Color(0xFFF0AA48)],
            xp: 15,
            completed: false,
          ),
          Quest(
            id: '4',
            header: 'Step Master',
            title: 'Do 30 minutes of workout',
            tagText: 'Activity',
            tagGradient: const [Color(0xFF0495A6), Color(0xFFF0AA48)],
            xp: 20,
            completed: false,
          ),
          Quest(
            id: '5',
            header: 'Protein Power',
            title: 'Log a meal with 20g+ protein',
            tagText: 'Nutrition',
            tagGradient: const [Color(0xFF04A647), Color(0xFFF0AA48)],
            xp: 30,
            completed: false,
          ),
        ],
      );
      questsData(mockQuestsData);
    } catch (e) {
      errorMessage('Failed to fetch quests');
    } finally {
      isLoading(false);
    }
  }

  // Example method to mark a quest as complete (API call placeholder)
  Future<void> completeQuest(String questId) async {
    try {
      isLoading(true);
      errorMessage('');
      // await _service.completeQuest(questId);

      // Simulate local update
      final data = questsData.value;
      if (data != null) {
        final updatedQuests = data.todaysQuests
            .map(
              (q) => q.id == questId
                  ? Quest(
                      id: q.id,
                      header: q.header,
                      title: q.title,
                      tagText: q.tagText,
                      tagGradient: q.tagGradient,
                      xp: q.xp,
                      completed: true,
                    )
                  : q,
            )
            .toList();
        questsData(
          QuestsData(
            progressPoints: data.progressPoints,
            totalXp: data.totalXp,
            todaysQuests: updatedQuests,
          ),
        );
      }
    } catch (e) {
      errorMessage('Failed to complete quest');
    } finally {
      isLoading(false);
    }
  }

  // ...existing code...
}
