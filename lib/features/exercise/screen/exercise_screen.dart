// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:velvet_iron/features/exercise/controller/exercise_controller.dart';
import 'package:velvet_iron/features/exercise/widgets/completed_tab_content.dart';
import 'package:velvet_iron/features/exercise/widgets/excercise_switcher.dart';
import 'package:velvet_iron/features/exercise/widgets/excersise_history.dart';
import 'package:velvet_iron/features/exercise/widgets/log_container_excercise.dart';
import 'package:velvet_iron/features/exercise/widgets/schedule_tab_content.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});
  ExerciseController get controller => Get.put(ExerciseController());
  BottomNavController get bottomNavController =>
      Get.find<BottomNavController>();

  @override
  Widget build(BuildContext context) {
    final navController = bottomNavController;
    return Scaffold(
      backgroundColor: const Color(0xFF1A0101),
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
                              navController.changeTabIndex(1);
                            },
                            appBarTitle: 'Exercise',
                          ),
                        ),
                      ];
                    },
                body: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: GetBuilder<AppThemeController>(
                                  builder: (themeController) {
                                    return CustomLogContainerExercise(
                                      iconPath:
                                          themeController.activeTheme.id ==
                                              'adventurer'
                                          ? 'assets/icons/letter_adventure.png'
                                          : themeController.activeTheme.id ==
                                                'mage'
                                          ? 'assets/icons/letter_mage.png'
                                          : themeController.activeTheme.id ==
                                                'gamer'
                                          ? 'assets/icons/letter_gamer.png'
                                          : 'assets/icons/letter_reader.png',
                                      title: "Logged Exercise",
                                      value: controller.totalCount.value
                                          .toString(),
                                      rewardAmount: controller
                                          .totalEarnedXp
                                          .value
                                          .toString(),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GetBuilder<AppThemeController>(
                                  builder: (themeController) {
                                    String nextScheduleStr = '-';
                                    final next = controller.nextSchedule.value;
                                    if (next != null &&
                                        next.scheduledAt != null) {
                                      final dayName = const [
                                        'Mon',
                                        'Tue',
                                        'Wed',
                                        'Thu',
                                        'Fri',
                                        'Sat',
                                        'Sun',
                                      ][next.scheduledAt!.weekday - 1];
                                      final hour = next.scheduledAt!.hour
                                          .toString()
                                          .padLeft(2, '0');
                                      final minute = next.scheduledAt!.minute
                                          .toString()
                                          .padLeft(2, '0');
                                      nextScheduleStr =
                                          "${next.name} - $dayName $hour:$minute";
                                    }
                                    return CustomLogContainerExercise(
                                      iconPath:
                                          themeController.activeTheme.id ==
                                              'adventurer'
                                          ? 'assets/icons/time_adventure.png'
                                          : themeController.activeTheme.id ==
                                                'mage'
                                          ? 'assets/icons/time_mage.png'
                                          : themeController.activeTheme.id ==
                                                'gamer'
                                          ? 'assets/icons/time_gamer.png'
                                          : 'assets/icons/time_reader.png',
                                      title: "Time Exercise ",
                                      value: nextScheduleStr,
                                      rewardAmount: "15+",
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Log a Exercise",
                            style: getTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: themeController
                                  .activeTheme
                                  .cardBackgroundColor
                                  .withValues(alpha: .5),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: ExcerciseSwitcher(
                              controller: controller,
                              completedContent: CompletedTabContent(
                                controller: controller,
                              ),
                              scheduleContent: ScheduleTabContent(
                                controller: controller,
                              ),
                            ),
                          ),
                          Text(
                            "Exercise History",
                            style: getTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // Exercise History (only completed)
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.completedExercises.length,
                            itemBuilder: (context, index) {
                              final exercise =
                                  controller.completedExercises[index];
                              final loggedAt = exercise.loggedAt.toLocal();
                              final dayName = const [
                                'Mon',
                                'Tue',
                                'Wed',
                                'Thu',
                                'Fri',
                                'Sat',
                                'Sun',
                              ][loggedAt.weekday - 1];
                              final hour = loggedAt.hour.toString().padLeft(
                                2,
                                '0',
                              );
                              final minute = loggedAt.minute.toString().padLeft(
                                2,
                                '0',
                              );
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 7.0),
                                child: ExcersiseHistory(
                                  title: exercise.name,
                                  sub:
                                      "${exercise.type} - ${exercise.duration} min",
                                  time: "$dayName - $hour:$minute",
                                  iconPath: _getIconPath(
                                    exercise.type,
                                    exercise.name,
                                  ),
                                  isSelected: RxBool(false),
                                  isTaken: exercise.isTaken,
                                  onStatusIconTap: !exercise.isTaken
                                      ? () {
                                          debugPrint(
                                            '[ExerciseScreen] 🖱️ Status icon tapped for ${exercise.name}',
                                          );
                                          controller.markExerciseAsTaken(
                                            exercise.id,
                                          );
                                        }
                                      : null,
                                ),
                              );
                            },
                          ),

                          // Next Exercise section (all scheduled, not just one)
                          Obx(() {
                            if (controller.selectedExerciseTab.value != 1)
                              return const SizedBox.shrink();
                            final scheduled = controller.scheduledExercises;
                            if (scheduled.isEmpty)
                              return const SizedBox.shrink();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 18),
                                Text(
                                  "Next Exercise",
                                  style: getTextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ...scheduled.map((next) {
                                  final dayName = next.scheduledAt != null
                                      ? const [
                                          'Mon',
                                          'Tue',
                                          'Wed',
                                          'Thu',
                                          'Fri',
                                          'Sat',
                                          'Sun',
                                        ][next.scheduledAt!.weekday - 1]
                                      : '-';
                                  final hour = next.scheduledAt != null
                                      ? next.scheduledAt!.hour
                                            .toString()
                                            .padLeft(2, '0')
                                      : '--';
                                  final minute = next.scheduledAt != null
                                      ? next.scheduledAt!.minute
                                            .toString()
                                            .padLeft(2, '0')
                                      : '--';
                                  final timeStr = "$dayName - $hour:$minute";
                                  String iconPath;
                                  switch (next.name) {
                                    case 'Yoga Meditation':
                                      iconPath = IconPath.yoga;
                                      break;
                                    case 'Running':
                                      iconPath = IconPath.heart;
                                      break;
                                    case 'Squats':
                                      iconPath = IconPath.dumble;
                                      break;
                                    default:
                                      iconPath = IconPath.heart;
                                  }
                                  return ExcersiseHistory(
                                    title: next.name,
                                    sub: "${next.type} - ${next.duration} min",
                                    time: timeStr,
                                    iconPath: iconPath,
                                    isSelected: RxBool(false),
                                    isTaken: next.isTaken,
                                    onStatusIconTap: !next.isTaken
                                        ? () {
                                            debugPrint(
                                              '[ExerciseScreen] 🖱️ Status icon tapped for next exercise ${next.name}',
                                            );
                                            controller.markExerciseAsTaken(
                                              next.id,
                                            );
                                          }
                                        : null,
                                  );
                                }).toList(),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getIconPath(String type, String name) {
    if (name == 'Yoga Meditation') {
      return IconPath.yoga;
    } else if (name == 'Running') {
      return IconPath.heart;
    } else if (name == 'Squats') {
      return IconPath.dumble;
    } else {
      return IconPath.heart;
    }
  }
}
