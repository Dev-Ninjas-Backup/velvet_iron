import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/daily_logs/controller/daily_log_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/scan_code_button.dart';
import 'package:velvet_iron/features/daily_logs/widgets/selectable_option_row.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens.dart/meal_log_screen/widgets/nutrition_input_field.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens.dart/meal_log_screen/widgets/select_meal_type.dart';

class TokenContent extends StatelessWidget {
  const TokenContent({super.key, required this.controller});

  final DailyLogController controller;

  @override
  Widget build(BuildContext context) {
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
            cursorColor: const Color(0xFFDCAA64),
            style: getTextStyle(fontSize: 12, color: Colors.white),
            decoration: InputDecoration(
              hintText: "Grilled chicken salad with olive oil dressing...?",
              hintStyle: getTextStyle(
                fontSize: 12,
                color: const Color(0xFF723737),
              ),
              filled: true,
              fillColor: const Color(0xFF3A0303),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFFDCAA64),
                  width: 1.11,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFFDCAA64),
                  width: 1.11,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFFDCAA64),
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
              children: const [
                NutritionInputField(hintText: "carbs"),
                NutritionInputField(hintText: "protein"),
                NutritionInputField(hintText: "fats"),
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
  }
}
