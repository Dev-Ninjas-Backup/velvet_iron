// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/daily_logs/widgets/scan_code_button.dart';
import 'package:velvet_iron/features/daily_logs/widgets/selectable_option_row.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/controller/meal_log_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/widgets/nutrition_input_field.dart';

class TokenContent extends StatelessWidget {
  const TokenContent({super.key, required this.controller});

  final MealLogController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Log a Meal:",
              style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 12),
            Obx(
              () => SelectableOptionRow(
                options: ["Breakfast", "Lunch", "Dinner", "Snack"],
                selectedIndex: controller.selectedMealType.value,
                onTap: (index) => controller.selectMealType(index),
                assetIcons: [
                  IconPath.cup,
                  IconPath.foodBall,
                  IconPath.meat,
                  IconPath.cookie,
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "What did you eat?",
              style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 73,
              child: TextField(
                controller: controller.descriptionController,
                maxLines: 3,
                cursorColor: themeController.activeTheme.textfieldColor,
                style: getTextStyle(fontSize: 12, color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Grilled chicken salad with olive oil dressing...?",
                  hintStyle: getTextStyle(
                    fontSize: 12,
                    color: themeController.activeTheme.textColor,
                  ),
                  filled: true,
                  fillColor: themeController.activeTheme.textfieldColor,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: themeController.activeTheme.accentGoldColor,
                      width: 1.11,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: themeController.activeTheme.accentGoldColor,
                      width: 1.11,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: themeController.activeTheme.accentGoldColor,
                      width: 1.11,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 98,
                      child: Text("Carbs", style: getTextStyle(fontSize: 14)),
                    ),
                    SizedBox(
                      width: 98,
                      child: Text("Protein", style: getTextStyle(fontSize: 14)),
                    ),
                    SizedBox(
                      width: 98,
                      child: Text("Fats", style: getTextStyle(fontSize: 14)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NutritionInputField(
                      hintText: "carbs",
                      controller: controller.carbsController,
                    ),
                    NutritionInputField(
                      hintText: "protein",
                      controller: controller.proteinController,
                    ),
                    NutritionInputField(
                      hintText: "fats",
                      controller: controller.fatController,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),

            ScanCodeButton(onPressed: () {}),
            const SizedBox(height: 18),
            Obx(
              () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(
                      label: "Log Meal (+10 XP)",
                      onPressed: () => controller.submitMealLog(),
                    ),
            ),
            const SizedBox(height: 16),

            Obx(() {
              String _getMealIcon(String mealType) {
                switch (mealType.toUpperCase()) {
                  case 'BREAKFAST':
                    return IconPath.cup;
                  case 'LUNCH':
                    return IconPath.foodBall;
                  case 'DINNER':
                    return IconPath.meat;
                  case 'SNACK':
                    return IconPath.cookie;
                  default:
                    return IconPath.foodBall;
                }
              }

              String _formatDateTime(DateTime dt) {
                const months = [
                  'Jan',
                  'Feb',
                  'Mar',
                  'Apr',
                  'May',
                  'Jun',
                  'Jul',
                  'Aug',
                  'Sep',
                  'Oct',
                  'Nov',
                  'Dec',
                ];
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                final local = dt.toLocal();
                final day = days[local.weekday - 1];
                final month = months[local.month - 1];
                final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
                final minute = local.minute.toString().padLeft(2, '0');
                final period = local.hour >= 12 ? 'PM' : 'AM';
                return "${local.day} $month, $day - $hour:$minute $period";
              }

              final logs = controller.history.value?.logs ?? [];
              logs.where((e) => e.entryType == 'SCHEDULE').toList();
              final taken = logs.where((e) => e.entryType == 'LOG').toList();
              // Tab 0: Show both sections
              if (controller.selectedMealTab.value == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Log History",
                      style: getTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (controller.isHistoryLoading.value)
                      const Center(child: CircularProgressIndicator())
                    else if (taken.isEmpty)
                      Center(
                        child: Text(
                          "No history found",
                          style: getTextStyle(
                            fontSize: 14,
                            color: Colors.white54,
                          ),
                        ),
                      )
                    else
                      ...taken.map(
                        (log) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: themeController
                                .activeTheme
                                .cardBackgroundColor
                                .withValues(alpha: .4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              // Left-side status icon
                              Image.asset(
                                log.isTaken == true
                                    ? (themeController.activeTheme.name ==
                                              'adventure'
                                          ? IconPath.doticonAdventure
                                          : themeController.activeTheme.name ==
                                                'mage'
                                          ? IconPath.doticonMage
                                          : themeController.activeTheme.name ==
                                                'gamer'
                                          ? IconPath.doticonGamer
                                          : themeController.activeTheme.name ==
                                                'reader'
                                          ? IconPath.doticonReader
                                          : IconPath.whitecircle)
                                    : IconPath.whitecircle,
                                width: 18,
                                height: 18,
                              ),
                              const SizedBox(width: 8),
                              Image.asset(
                                _getMealIcon(log.mealType),
                                width: 24,
                                height: 24,
                                color: Colors.white,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.fastfood,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      log.mealType[0] +
                                          log.mealType
                                              .substring(1)
                                              .toLowerCase(),
                                      style: getTextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "${log.calories.toInt()} kcal  •  C:${log.carbs.toInt()}g  P:${log.protein.toInt()}g  F:${log.fats.toInt()}g",
                                      style: getTextStyle(
                                        fontSize: 11,
                                        color: themeController
                                            .activeTheme
                                            .textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "+${log.earnedXp} XP",
                                    style: getTextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatDateTime(log.loggedAt),
                                    style: getTextStyle(
                                      fontSize: 11,
                                      color:
                                          themeController.activeTheme.textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              }
              // Tab 1: Only show log history section
              else if (controller.selectedMealTab.value == 1) {
                final logs = controller.history.value?.logs ?? [];
                final taken = logs.where((e) => e.entryType == 'LOG').toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Log History",
                      style: getTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (controller.isHistoryLoading.value)
                      const Center(child: CircularProgressIndicator())
                    else if (taken.isEmpty)
                      Center(
                        child: Text(
                          "No history found",
                          style: getTextStyle(
                            fontSize: 14,
                            color: Colors.white54,
                          ),
                        ),
                      )
                    else
                      ...taken.map(
                        (log) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: themeController
                                .activeTheme
                                .cardBackgroundColor
                                .withValues(alpha: .4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                _getMealIcon(log.mealType),
                                width: 24,
                                height: 24,
                                color: Colors.white,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.fastfood,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      log.mealType[0] +
                                          log.mealType
                                              .substring(1)
                                              .toLowerCase(),
                                      style: getTextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "${log.calories.toInt()} kcal  •  C:${log.carbs.toInt()}g  P:${log.protein.toInt()}g  F:${log.fats.toInt()}g",
                                      style: getTextStyle(
                                        fontSize: 11,
                                        color: themeController
                                            .activeTheme
                                            .accentGoldColor,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _formatDateTime(log.loggedAt),
                                      style: getTextStyle(
                                        fontSize: 11,
                                        color: themeController
                                            .activeTheme
                                            .todoTimeColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "+${log.earnedXp} XP",
                                    style: getTextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: log.entryType == 'LOG'
                                          ? Colors.green.withValues(alpha: .3)
                                          : Colors.blue.withValues(alpha: .3),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      log.entryType,
                                      style: getTextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        );
      },
    );
  }
}
