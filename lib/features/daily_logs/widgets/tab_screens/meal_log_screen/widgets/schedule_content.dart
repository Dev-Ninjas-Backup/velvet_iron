import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/daily_logs/widgets/log_history_item.dart';
import 'package:velvet_iron/features/daily_logs/widgets/scan_code_button.dart';
import 'package:velvet_iron/features/daily_logs/widgets/selectable_option_row.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/controller/meal_log_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/widgets/date_and_time_picker.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/widgets/nutrition_input_field.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class ScheduleContent extends StatelessWidget {
  const ScheduleContent({super.key, required this.controller});

  final MealLogController controller;

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
        const SizedBox(height: 10),
        Text(
          "What did you eat?",
          style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 69,
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
                  color: Colors.white12,
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
        SizedBox(height: 14),
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
        SizedBox(height: 20),
        Obx(
          () => DateAndTimePicker(
            selectedDate: controller.selectedDate.value,
            selectedTime: controller.selectedTime.value,
            onDateChanged: controller.setDate,
            onTimeChanged: controller.setTime,
          ),
        ),
        SizedBox(height: 20),
        ScanCodeButton(onPressed: () {
          Get.toNamed(AppRoute.qrcodeScanScreen);
        }),
        SizedBox(height: 18),
        CustomButton(label: "Log Meal (+10 XP)", onPressed: () {}),
        const SizedBox(height: 14),
        Text(
          "Log History",
          style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 14),
        LogHistoryItem(
          title: "Feeling Good",
          xpText: "+10 XP",
          iconPath: IconPath.goodEmoji,
          secondText: "Moderate & Hungry",
          thirdText: "",
          dateTimeText: "15 Dec, Wed - 09:30 AM",
        ),
        const SizedBox(height: 6),
        LogHistoryItem(
          title: "Feeling Pissed",
          xpText: "+10 XP",
          iconPath: IconPath.pissedEmoji,
          secondText: "Low & Hungry",
          thirdText: "",
          dateTimeText: "15 Dec, Wed - 09:30 AM",
        ),
      ],
    );
  }
}

