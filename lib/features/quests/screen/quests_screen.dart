import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:velvet_iron/features/quests/widgets/progress_card.dart';
import 'package:velvet_iron/features/quests/widgets/todays_quests.dart';

class QuestsScreen extends StatelessWidget {
  const QuestsScreen({super.key});
  BottomNavController get bottomNavController =>
      Get.find<BottomNavController>();
  @override
  Widget build(BuildContext context) {
    final navController = bottomNavController;
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ProgressCard(
                    iconPath: IconPath.progress,
                    header: "Today's Progress",
                    points: "2/10",
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ProgressCard(
                    iconPath: IconPath.trophy,
                    header: "Today's Progress",
                    points: "2/10",
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TodaysQuestItem(
              header: 'Track Your Shot',
              title: 'Log your GLP-1 medication',
              tagText: 'Health',
              tagGradient: const [Color(0xFFA60404), Color(0xFFF0AA48)],
              xp: 10,
            ),
            const SizedBox(height: 7),

            TodaysQuestItem(
              header: 'Three Meals a Day',
              title: 'Log breakfast, lunch, and dinner',
              tagText: 'Nutrition',
              tagGradient: const [Color(0xFF04A647), Color(0xFFF0AA48)],
              xp: 30,
            ),
            const SizedBox(height: 7),

            TodaysQuestItem(
              header: 'Mood Check',
              title: 'Log your mood and energy levels',
              tagText: 'Mindfulness',
              tagGradient: const [Color(0xFF7804A6), Color(0xFFF0AA48)],
              xp: 15,
            ),
            const SizedBox(height: 7),

            TodaysQuestItem(
              header: 'Step Master',
              title: 'Do 30 minutes of workout',
              tagText: 'Activity',
              tagGradient: const [Color(0xFF0495A6), Color(0xFFF0AA48)],
              xp: 20,
            ),
            const SizedBox(height: 7),

            TodaysQuestItem(
              header: 'Protein Power',
              title: 'Log a meal with 20g+ protein',
              tagText: 'Nutrition',
              tagGradient: const [Color(0xFF04A647), Color(0xFFF0AA48)],
              xp: 30,
            ),

            SizedBox(height: 7),
          ],
        ),
      ),
    );
  }
}
