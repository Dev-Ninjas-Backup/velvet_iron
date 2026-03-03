import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/widgets/date_and_time_picker.dart';
import 'package:velvet_iron/features/exercise/controller/exercise_controller.dart';
import 'package:velvet_iron/features/exercise/widgets/excercise_dropdown.dart';
import 'package:velvet_iron/features/exercise/widgets/exercise_name_textfield.dart';
import 'package:velvet_iron/features/exercise/widgets/intensity_and_duration.dart';

class ScheduleTabContent extends StatelessWidget {
  const ScheduleTabContent({super.key, required this.controller});

  final ExerciseController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Text(
            "Exercise Type:",
            style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 13),
          ExcerciseDropdown(iconPath: IconPath.heart, controller: controller),
          SizedBox(height: 13),
          Text(
            "Exercise Name:",
            style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 10),
          ExerciseNameTextField(controller: controller),
          SizedBox(height: 16),
          IntensityAndDuration(controller: controller),
          SizedBox(height: 10),
          Obx(
            () => DateAndTimePicker(
              selectedDate: controller.scheduleDate.value,
              selectedTime: controller.scheduleTime.value,
              onDateChanged: (date) => controller.setSelectedDate(date),
              onTimeChanged: (time) => controller.setSelectedTime(time),
            ),
          ),
          SizedBox(height: 20),
          Text("Notes (optional)", style: getTextStyle()),
          const SizedBox(height: 10),
          SizedBox(
            height: 73,
            child: TextField(
              maxLines: 3,
              cursorColor: themeController.activeTheme.accentGoldColor,
              style: getTextStyle(fontSize: 12, color: Colors.white),
              decoration: InputDecoration(
                hintText: "How did it feel??",
                hintStyle: getTextStyle(
                  fontSize: 12,
                  color: themeController.activeTheme.todoTimeColor,
                ),
                filled: true,
                fillColor: themeController.activeTheme.textfieldColor
                    .withValues(alpha: 0.2),
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
          SizedBox(height: 18),
          CustomButton(
            label: "Add Exercise (+10 XP)",
            onPressed: () => controller.scheduleExercise(),
          ),
        ],
      ),
    );
  }
}
