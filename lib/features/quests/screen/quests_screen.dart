import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/common/widgets/custom_small_button.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:velvet_iron/features/quests/controller/quest_controller.dart';
import 'package:velvet_iron/features/quests/widgets/progress_card.dart';
import 'package:velvet_iron/features/quests/widgets/quest_tips.dart';
import 'package:velvet_iron/features/quests/widgets/todays_quests.dart';

class QuestsScreen extends StatelessWidget {
  const QuestsScreen({super.key});

  BottomNavController get bottomNavController =>
      Get.find<BottomNavController>();

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
              NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          floating: true,
                          snap: true,
                          automaticallyImplyLeading: false,
                          titleSpacing: 16,
                          title: FigmaBackButton(
                            onPressed: () {
                              navController.changeTabIndex(0);
                            },
                            appBarTitle: 'Quests',
                          ),
                        ),
                      ];
                    },
                body: GetX<QuestController>(
                  init: QuestController(), // Initialize the controller here
                  builder: (controller) {
                    final questsData = controller.questsData.value!;
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ProgressCard(
                                  iconPath: questsData.progressPoints.iconPath,
                                  header: questsData.progressPoints.header,
                                  points: questsData.progressPoints.points,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ProgressCard(
                                  iconPath: questsData.totalXp.iconPath,
                                  header: questsData.totalXp.header,
                                  points: questsData.totalXp.points,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          ...questsData.todaysQuests.map(
                            (quest) => Padding(
                              padding: const EdgeInsets.only(bottom: 7),
                              child: TodaysQuestItem(
                                header: quest.header,
                                title: quest.title,
                                tagText: quest.tagText,
                                tagGradient: quest.tagGradient,
                                xp: quest.xp,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          QuestTips(),
                          CustomSmallButton(
                            width: 108,
                            text: "Read Article",
                            onPressed: () {},
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFFDE7BB),
                                Color(0xFF9D6933),
                                Color(0xFFFEE9BF),
                              ],
                            ),
                            fontColor: Colors.white,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
