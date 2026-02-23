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
                                      value: controller
                                          .exerciseStats
                                          .value
                                          .loggedExercises
                                          .toString(),
                                      rewardAmount: "150",
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GetBuilder<AppThemeController>(
                                  builder: (themeController) {
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
                                      value:
                                          "${controller.exerciseStats.value.timeExercises} min",
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
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.exercises.length,
                            itemBuilder: (context, index) {
                              final exercise = controller.exercises[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 7.0),
                                child: ExcersiseHistory(
                                  title: exercise.name,
                                  sub:
                                      "${exercise.type} - ${exercise.duration} min",
                                  time:
                                      "Wed - ${exercise.dateTime.hour}:${exercise.dateTime.minute}",
                                  iconPath: _getIconPath(exercise.type),
                                  isSelected: RxBool(false),
                                ),
                              );
                            },
                          ),
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

  String _getIconPath(String type) {
    switch (type) {
      case 'Cardio':
        return IconPath.heart;
      case 'Strength':
        return IconPath.dumble;
      default:
        return IconPath.yoga;
    }
  }
}
