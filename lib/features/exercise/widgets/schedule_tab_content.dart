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
          const SizedBox(height: 12),
          Text(
            "Recurrence:",
            style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Row(
              children: ['DAILY', 'WEEKLY', 'SPECIFIC DAYS'].map((rec) {
                final isSel = controller.selectedRecurrence.value == rec;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => controller.selectedRecurrence.value = rec,
                    child: Container(
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSel
                            ? themeController.activeTheme.accentGoldColor
                                .withValues(alpha: 0.3)
                            : Colors.black26,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSel
                              ? themeController.activeTheme.accentGoldColor
                              : Colors.white24,
                        ),
                      ),
                      child: Text(
                        rec,
                        style: TextStyle(
                          color: isSel
                              ? themeController.activeTheme.accentGoldColor
                              : Colors.white70,
                          fontSize: 11,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 18),
          Text("Notes (optional)", style: getTextStyle()),
          const SizedBox(height: 10),
          SizedBox(
            height: 73,
            child: TextField(
              controller: controller.notesController,
              maxLines: 3,
              cursorColor: themeController.activeTheme.accentGoldColor,
              style: getTextStyle(fontSize: 12, color: Colors.white),
              decoration: InputDecoration(
                hintText: "How did it feel??",
                hintStyle: getTextStyle(
                  fontSize: 12,
                  color: themeController.activeTheme.textColor,
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
