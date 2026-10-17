import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
          Obx(() {
            final isSpecific = controller.selectedRecurrence.value == 'SPECIFIC DAYS' ||
                controller.selectedRecurrence.value == 'WEEKLY';
            if (!isSpecific) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Repeat On:",
                    style: getTextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      {'day': 'Mon', 'val': 1},
                      {'day': 'Tue', 'val': 2},
                      {'day': 'Wed', 'val': 3},
                      {'day': 'Thu', 'val': 4},
                      {'day': 'Fri', 'val': 5},
                      {'day': 'Sat', 'val': 6},
                      {'day': 'Sun', 'val': 7},
                    ].map((d) {
                      final dayVal = d['val'] as int;
                      final isDaySel = controller.selectedDaysOfWeek.contains(dayVal);
                      return GestureDetector(
                        onTap: () {
                          if (isDaySel) {
                            if (controller.selectedDaysOfWeek.length > 1) {
                              controller.selectedDaysOfWeek.remove(dayVal);
                            } else {
                              EasyLoading.showInfo('Select at least one day');
                            }
                          } else {
                            controller.selectedDaysOfWeek.add(dayVal);
                          }
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isDaySel
                                ? themeController.activeTheme.accentGoldColor
                                    .withValues(alpha: 0.35)
                                : Colors.black26,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDaySel
                                  ? themeController.activeTheme.accentGoldColor
                                  : Colors.white24,
                              width: isDaySel ? 1.5 : 1,
                            ),
                          ),
                          child: Text(
                            d['day'] as String,
                            style: TextStyle(
                              color: isDaySel
                                  ? themeController.activeTheme.accentGoldColor
                                  : Colors.white70,
                              fontSize: 10,
                              fontWeight: isDaySel ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }),
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
