// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/features/daily_logs/controller/daily_log_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/gradient_option_button.dart';
import 'package:velvet_iron/features/daily_logs/widgets/log_history_item.dart';
import 'package:velvet_iron/features/daily_logs/widgets/mood_option_widget.dart';
import 'package:velvet_iron/features/daily_logs/widgets/selectable_option_row.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/mood_log_screen/controller/mood_log_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/mood_log_screen/model/mood_log_model.dart';
import 'package:velvet_iron/features/home/controller/home_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/mood_log_screen/widgets/note_textfield.dart';
import 'package:velvet_iron/features/settings/controller/setting_controller.dart';

class MoodLog extends StatelessWidget {
  const MoodLog({
    super.key,
    required this.dailyLogController,
    required this.moodLogController,
  });

  final DailyLogController dailyLogController;
  final MoodLogController moodLogController;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      moodLogController.fetchTodayLog();
    });

    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        final themeId = themeController.currentTheme.value?.id ?? 'adventurer';

        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                floating: true,
                snap: true,
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                title: Row(
                  children: [
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: themeController.activeTheme.todoSubtitleColor
                              .withValues(alpha: .2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Daily Logs",
                      style: getTextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Obx(
                            () => CustomGradientOptionButton(
                              text: "Weight Log",
                              isSelected:
                                  dailyLogController.selectedTab.value == 0,
                              onPressed: () => dailyLogController.setTab(0),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Obx(
                            () => CustomGradientOptionButton(
                              text: "Mood Log",
                              isSelected:
                                  dailyLogController.selectedTab.value == 1,
                              onPressed: () => dailyLogController.setTab(1),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Obx(
                            () => CustomGradientOptionButton(
                              text: "Meal Log",
                              isSelected:
                                  dailyLogController.selectedTab.value == 2,
                              onPressed: () => dailyLogController.setTab(2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "How are you feeling?",
                        style: getTextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: themeController.activeTheme.todoSubtitleColor
                      .withValues(alpha: .2),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: themeController.activeTheme.cardBackgroundColor
                              .withValues(alpha: .4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => moodLogController.isLoading.value
                                  ? const Padding(
                                      padding: EdgeInsets.only(bottom: 12),
                                      child: Center(
                                        child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white54,
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            Text(
                              "Select Mood:",
                              style: getTextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 12),
                            Obx(
                              () => Row(
                                children: List.generate(
                                  moodLogController.moods.length,
                                  (index) => Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right:
                                            index <
                                                moodLogController.moods.length -
                                                    1
                                            ? 8
                                            : 0,
                                      ),
                                      child: MoodOptionWidget(
                                        icon:
                                            moodLogController.moods[index].icon,
                                        title: moodLogController
                                            .moods[index]
                                            .title,
                                        isSelected:
                                            moodLogController
                                                .selectedMood
                                                .value ==
                                            index,
                                        onTap: () =>
                                            moodLogController.selectMood(index),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              "Energy Level:",
                              style: getTextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 12),
                            Obx(
                              () => SelectableOptionRow(
                                options: moodLogController.energyLevels,
                                selectedIndex:
                                    moodLogController.selectedEnergy.value,
                                onTap: moodLogController.selectEnergy,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              "Hunger Level:",
                              style: getTextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 12),
                            Obx(
                              () => SelectableOptionRow(
                                options: moodLogController.hungerLevels,
                                selectedIndex:
                                    moodLogController.selectedHunger.value,
                                onTap: moodLogController.selectHunger,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              "Note (optional):",
                              style: getTextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 10),
                            NoteTextField(
                              controller: moodLogController.noteController,
                              onChanged: moodLogController.setNote,
                            ),
                            const SizedBox(height: 14),
                            CustomButton(
                              label: "Log Entry (+10 XP)",
                              onPressed: () async {
                                await moodLogController.logEntry();
                                // Refresh home screen data after logging mood
                                try {
                                  final homeController = Get.put(
                                    HomeController(),
                                  );
                                  await homeController.fetchData();

                                  // Also refresh SettingsController if it exists
                                  if (Get.isRegistered<SettingsController>()) {
                                    final settingsController =
                                        Get.find<SettingsController>();
                                    await settingsController.fetchUserProfile();
                                  }
                                } catch (e) {
                                  print(
                                    '[MoodLog] Error refreshing controllers: $e',
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),
                      Obx(
                        () => Text(
                          "Log History (${moodLogController.totalCount.value})",
                          style: getTextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Obx(() {
                        if (moodLogController.isHistoryLoading.value) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white54,
                              ),
                            ),
                          );
                        }

                        if (moodLogController.historyLogs.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Text(
                                'No mood logs yet',
                                style: getTextStyle(
                                  fontSize: 14,
                                  color: Colors.white54,
                                ),
                              ),
                            ),
                          );
                        }
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: moodLogController.historyLogs.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 6),
                          itemBuilder: (_, index) {
                            final log = moodLogController.historyLogs[index];
                            final moodType = MoodType.toIconPath(log.mood);
                            final iconPath = moodLogController.getEmojiPath(
                              themeId,
                              moodType,
                            );

                            return LogHistoryItem(
                              title:
                                  log.mood.substring(0, 1).toUpperCase() +
                                  log.mood.substring(1).toLowerCase(),
                              xpText: '+${log.earnedXp} XP',
                              iconPath: iconPath,
                              secondText:
                                  log.energyLevel
                                      .substring(0, 1)
                                      .toUpperCase() +
                                  log.energyLevel
                                      .substring(1)
                                      .toLowerCase()
                                      .replaceAll('_', ' '),
                              thirdText: log.note ?? '',
                              dateTimeText: log.formattedDate,
                              moodType: moodType,
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
