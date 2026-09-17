import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/common/widgets/empty_state_card.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:velvet_iron/features/quests/controller/quest_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/features/quests/widgets/progress_card.dart';
import 'package:velvet_iron/features/quests/widgets/quest_tips.dart';
import 'package:velvet_iron/features/quests/widgets/todays_quests.dart';

class QuestsScreen extends StatelessWidget {
  const QuestsScreen({super.key});

  BottomNavController get bottomNavController =>
      Get.find<BottomNavController>();

  void _showCreateQuestDialog(BuildContext context, QuestController controller, AppThemeController themeController) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    int selectedXp = 10;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: themeController.activeTheme.popupBackgroundColor ??
                    themeController.activeTheme.cardBackgroundColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: themeController.activeTheme.accentGoldColor,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Forge New Quest',
                        style: getTextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Quest Objective', style: getTextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: titleController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'e.g. Drink 2L water, 30 min walk...',
                      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 13),
                      filled: true,
                      fillColor: Colors.black26,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text('Details / Notes', style: getTextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: descController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'e.g. Focus on hydration and recovery',
                      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 13),
                      filled: true,
                      fillColor: Colors.black26,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('XP Reward', style: getTextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [10, 15, 25].map((xp) {
                      final isSel = selectedXp == xp;
                      return GestureDetector(
                        onTap: () => setState(() => selectedXp = xp),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSel
                                ? themeController.activeTheme.accentGoldColor
                                : Colors.black26,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: themeController.activeTheme.accentGoldColor,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '+$xp XP',
                            style: getTextStyle(
                              color: isSel ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      label: 'Create Quest',
                      onPressed: () {
                        final title = titleController.text.trim();
                        if (title.isEmpty) {
                          EasyLoading.showInfo('Please enter a quest objective');
                          return;
                        }
                        controller.addCustomQuest(
                          title: title,
                          description: descController.text.trim().isEmpty ? 'Custom Player Quest' : descController.text.trim(),
                          xp: selectedXp,
                        );
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final navController = bottomNavController;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GetBuilder<AppThemeController>(
        builder: (themeController) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: themeController.activeTheme.backgroundGradient,
                ),
              ),
              Opacity(
                opacity: 0.2,
                child: Image.asset(
                  themeController.activeTheme.backgroundImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              GetX<QuestController>(
                init: QuestController(),
                builder: (controller) {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.errorMessage.value.isNotEmpty) {
                    return Center(child: Text(controller.errorMessage.value));
                  }
                  final questsData = controller.questsData.value;
                  if (questsData == null) {
                    return const Center(
                      child: Text('No quest data available.'),
                    );
                  }

                  return NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverAppBar(
                              backgroundColor: Colors.transparent,
                              title: FigmaBackButton(
                                onPressed: () {
                                  navController.changeTabIndex(0);
                                },
                                appBarTitle: 'Quests',
                              ),
                            ),
                          ];
                        },
                    body: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ProgressCard(
                                    iconPath: 'steelyard',
                                    header: "Today's Progress",
                                    points:
                                        '${questsData.todayLogCount}/${controller.logTarget}',
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ProgressCard(
                                    iconPath: 'trophy',
                                    header: 'Total XP',
                                    points: '${questsData.todayTotalXp} XP',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Today's Quests",
                                  style: getTextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _showCreateQuestDialog(context, controller, themeController),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: themeController.activeTheme.accentGoldColor,
                                        width: 1,
                                      ),
                                      color: themeController.activeTheme.cardBackgroundColor.withValues(alpha: 0.3),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.add, size: 16, color: themeController.activeTheme.accentGoldColor),
                                        const SizedBox(width: 4),
                                        Text(
                                          "Create Quest",
                                          style: getTextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: themeController.activeTheme.accentGoldColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            if (questsData.quests.isEmpty)
                              const EmptyStateCard(
                                icon: Icons.military_tech_outlined,
                                title: "No quests available today",
                                subtitle:
                                    "Check back tomorrow for new heroic quests to earn XP!",
                              )
                            else
                              ...questsData.quests.map(
                                (quest) => Padding(
                                  padding: const EdgeInsets.only(bottom: 7),
                                  child: TodaysQuestItem(
                                    id: quest.id,
                                    header: quest.title,
                                    title: quest.description,
                                    xp: quest.xp,
                                    isActive: quest.isDone,
                                    onTap: () => controller.completeQuest(quest.id),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 20),
                            QuestTips(
                              onXpEarned: (message) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(message),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
