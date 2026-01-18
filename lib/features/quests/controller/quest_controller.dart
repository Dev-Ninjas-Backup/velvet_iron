import 'package:get/get.dart';
import 'package:flutter/material.dart'; // Import for Color
import 'package:velvet_iron/features/quests/model/quest_model.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';

class QuestController extends GetxController {
  final Rx<QuestsData?> questsData = Rx<QuestsData?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchQuests();
  }

  void fetchQuests() {
    // Mock data based on quests_screen.dart
    final mockQuestsData = QuestsData(
      progressPoints: QuestProgress(
        iconPath: IconPath.progress,
        header: "Today's Progress",
        points: "2/10",
      ),
      totalXp: QuestProgress(
        iconPath: IconPath.trophy,
        header: "Today's Progress",
        points: "45 XP",
      ),
      todaysQuests: [
        Quest(
          header: 'Track Your Shot',
          title: 'Log your GLP-1 medication',
          tagText: 'Health',
          tagGradient: const [Color(0xFFA60404), Color(0xFFF0AA48)],
          xp: 10,
        ),
        Quest(
          header: 'Three Meals a Day',
          title: 'Log breakfast, lunch, and dinner',
          tagText: 'Nutrition',
          tagGradient: const [Color(0xFF04A647), Color(0xFFF0AA48)],
          xp: 30,
        ),
        Quest(
          header: 'Mood Check',
          title: 'Log your mood and energy levels',
          tagText: 'Mindfulness',
          tagGradient: const [Color(0xFF7804A6), Color(0xFFF0AA48)],
          xp: 15,
        ),
        Quest(
          header: 'Step Master',
          title: 'Do 30 minutes of workout',
          tagText: 'Activity',
          tagGradient: const [Color(0xFF0495A6), Color(0xFFF0AA48)],
          xp: 20,
        ),
        Quest(
          header: 'Protein Power',
          title: 'Log a meal with 20g+ protein',
          tagText: 'Nutrition',
          tagGradient: const [Color(0xFF04A647), Color(0xFFF0AA48)],
          xp: 30,
        ),
      ],
    );

    questsData(mockQuestsData);
  }
}
