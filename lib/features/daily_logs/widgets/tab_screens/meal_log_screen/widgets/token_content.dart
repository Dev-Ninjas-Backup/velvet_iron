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
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/widgets/select_meal_type.dart';

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
            SizedBox(height: 12),
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
            SizedBox(height: 16),
            Text(
              "What did you eat?",
              style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 73,
              child: TextField(
                maxLines: 3,
                cursorColor: themeController.activeTheme.textfieldColor,
                style: getTextStyle(fontSize: 12, color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Grilled chicken salad with olive oil dressing...?",
                  hintStyle: getTextStyle(
                    fontSize: 12,
                    color: themeController.activeTheme.todoTimeColor,
                  ),
                  filled: true,
                  fillColor: themeController.activeTheme.textfieldColor
                      .withValues(alpha: 0.3),
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
            SizedBox(height: 16),
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
            SizedBox(height: 14),
            ScanCodeButton(onPressed: () {}),
            SizedBox(height: 18),
            CustomButton(label: "Log Meal (+10 XP)", onPressed: () {}),
            SizedBox(height: 16),
            Text(
              "What did you eat?",
              style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 5),
            SelectMealType(
              title: "Dinner",
              sub: "120 calories",
              time: "12 Dec, Wed - 09:00 PM",
              iconPath: IconPath.meat,
              isSelected: RxBool(false),
            ),
            SelectMealType(
              title: "Lounch",
              sub: "120 calories",
              time: "12 Dec, Wed - 09:00 PM",
              iconPath: IconPath.foodBall,
              isSelected: RxBool(false),
            ),
            SelectMealType(
              title: "Breakfast",
              sub: "120 calories",
              time: "12 Dec, Wed - 09:00 PM",
              iconPath: IconPath.cup,
              isSelected: RxBool(false),
            ),
          ],
        );
      },
    );
  }
}
