// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/core/common/widgets/empty_state_card.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:velvet_iron/features/exercise/controller/exercise_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/widgets/date_and_time_picker.dart';
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
                opacity: 0.40,
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
                                      title: "Exercises Logged",
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
                                    final completed = controller.completedExercises;
                                    final totalDuration = completed.isNotEmpty
                                        ? completed.fold<int>(
                                            0,
                                            (sum, item) => sum + item.duration,
                                          )
                                        : controller.exercises.fold<int>(
                                            0,
                                            (sum, item) => sum + item.duration,
                                          );
                                    final totalCompletedXp = controller.totalEarnedXp.value > 0
                                        ? controller.totalEarnedXp.value
                                        : completed.fold<int>(
                                            0,
                                            (sum, item) => sum + item.earnedXp,
                                          );
                                    String nextScheduleStr =
                                        "$totalDuration min";
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
                                      title: "Time Trained",
                                      value: nextScheduleStr,
                                      rewardAmount: "$totalCompletedXp+",
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Log an Exercise",
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
                          const SizedBox(height: 10),
                          if (controller.completedExercises.isEmpty)
                            const EmptyStateCard(
                              icon: Icons.fitness_center_rounded,
                              title: "No exercise history yet",
                              subtitle:
                                  "Log your completed workouts above to earn XP!",
                            )
                          else
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

                          Obx(() {
                            if (controller.selectedExerciseTab.value != 1) {
                              return const SizedBox.shrink();
                            }
                            final scheduled = controller.scheduledExercises;
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
                                if (scheduled.isEmpty)
                                  const EmptyStateCard(
                                    icon: Icons.calendar_month_outlined,
                                    title: "No scheduled exercises",
                                    subtitle:
                                        "Schedule your upcoming workouts to plan your routine.",
                                  )
                                else
                                  ...scheduled.map((next) {
                                  final local = next.scheduledAt?.toLocal();
                                  final dayName = local != null
                                      ? const [
                                          'Mon',
                                          'Tue',
                                          'Wed',
                                          'Thu',
                                          'Fri',
                                          'Sat',
                                          'Sun',
                                        ][local.weekday - 1]
                                      : '-';
                                  final hourNum = local != null
                                      ? (local.hour % 12 == 0 ? 12 : local.hour % 12)
                                      : null;
                                  final hour = hourNum != null
                                      ? hourNum.toString().padLeft(2, '0')
                                      : '--';
                                  final minute = local != null
                                      ? local.minute
                                            .toString()
                                            .padLeft(2, '0')
                                      : '--';
                                  final period = local != null
                                      ? (local.hour >= 12 ? 'PM' : 'AM')
                                      : '';
                                  final now = DateTime.now();
                                  final isToday = local != null &&
                                      local.year == now.year &&
                                      local.month == now.month &&
                                      local.day == now.day;
                                  final prefix = isToday ? 'Today' : dayName;
                                  final timeStr = local != null
                                      ? "$prefix - $hour:$minute $period"
                                      : '-';
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
                                    onEditTap: () => _showEditExerciseDialog(
                                      context,
                                      themeController,
                                      next,
                                      controller,
                                    ),
                                    onDeleteTap: () => _confirmDeleteExercise(
                                      context,
                                      themeController,
                                      next,
                                      controller,
                                    ),
                                  );
                                }),
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

  void _confirmDeleteExercise(
    BuildContext context,
    AppThemeController themeController,
    dynamic exercise,
    ExerciseController controller,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: themeController.activeTheme.dropdownBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: themeController.activeTheme.borderColor.withValues(alpha: 0.4),
          ),
        ),
        title: Text(
          'Delete Exercise Schedule',
          style: getTextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to remove "${exercise.name}" from your scheduled workouts?',
          style: getTextStyle(fontSize: 13, color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: getTextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(ctx);
              controller.deleteExerciseSchedule(exercise.id);
            },
            child: Text('Delete', style: getTextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditExerciseDialog(
    BuildContext context,
    AppThemeController themeController,
    dynamic exercise,
    ExerciseController controller,
  ) {
    final nameCtrl = TextEditingController(text: exercise.name);
    final durationCtrl = TextEditingController(text: exercise.duration.toString());
    final noteCtrl = TextEditingController(text: exercise.note);
    var selectedType = exercise.type.toString();
    var selectedIntensity = exercise.intensity.toString();
    final localDt = exercise.scheduledAt?.toLocal() ?? DateTime.now();
    var editDate = localDt;
    var editTime = TimeOfDay.fromDateTime(localDt);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: themeController.activeTheme.dropdownBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: themeController.activeTheme.borderColor.withValues(alpha: 0.4),
            ),
          ),
          title: Text(
            'Edit Scheduled Workout',
            style: getTextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Workout Name', style: getTextStyle(fontSize: 12, color: Colors.white70)),
                const SizedBox(height: 6),
                TextField(
                  controller: nameCtrl,
                  style: getTextStyle(fontSize: 13, color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),
                Text('Duration (min)', style: getTextStyle(fontSize: 12, color: Colors.white70)),
                const SizedBox(height: 6),
                TextField(
                  controller: durationCtrl,
                  keyboardType: TextInputType.number,
                  style: getTextStyle(fontSize: 13, color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),
                Text('Scheduled Time', style: getTextStyle(fontSize: 12, color: Colors.white70)),
                const SizedBox(height: 6),
                DateAndTimePicker(
                  selectedDate: editDate,
                  selectedTime: editTime,
                  onDateChanged: (d) => setDialogState(() => editDate = d),
                  onTimeChanged: (t) => setDialogState(() => editTime = t),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: getTextStyle(color: Colors.white60)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeController.activeTheme.accentGoldColor,
              ),
              onPressed: () {
                final newName = nameCtrl.text.trim();
                final newDuration = int.tryParse(durationCtrl.text.trim()) ?? exercise.duration;
                if (newName.isEmpty) return;

                final scheduledDt = DateTime(
                  editDate.year,
                  editDate.month,
                  editDate.day,
                  editTime.hour,
                  editTime.minute,
                );

                Navigator.pop(ctx);
                controller.editExerciseSchedule(
                  exerciseId: exercise.id,
                  type: selectedType,
                  name: newName,
                  intensity: selectedIntensity,
                  duration: newDuration,
                  note: noteCtrl.text.trim(),
                  scheduledAt: scheduledDt,
                );
              },
              child: Text('Save', style: getTextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
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
