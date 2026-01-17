import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:velvet_iron/features/daily_logs/controller/daily_log_controller.dart';
import 'package:velvet_iron/features/exercise/widgets/completed_tab_content.dart';
import 'package:velvet_iron/features/exercise/widgets/excercise_switcher.dart';
import 'package:velvet_iron/features/exercise/widgets/schedule_tab_content.dart';
import 'package:velvet_iron/features/medication_screen/widgets/log_container.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});
  DailyLogController get controller => Get.put(DailyLogController());
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
                // Navigate to previous bottom tab (Daily Log)
                navController.changeTabIndex(1);
              },
              appBarTitle: 'Exercise',
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
                  child: CustomLogContainer(
                    iconPath: IconPath.letter,
                    title: "Logged Exercise",
                    value: "64",
                    rewardAmount: "150",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomLogContainer(
                    iconPath: IconPath.time,
                    title: "Time Exercise ",
                    value: "120 min",
                    rewardAmount: "15+",
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Log a Exercise",
              style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF521212),
                borderRadius: BorderRadius.circular(10),
              ),

              child: ExcerciseSwitcher(
                controller: controller,
                completedContent: CompletedTabContent(controller: controller),
                scheduleContent: ScheduleTabContent(
                  controller: controller,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
