import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens.dart/meal_log_screen/widgets/date_and_time_picker.dart';
import 'package:velvet_iron/features/exercise/controller/exercise_controller.dart';
import 'package:velvet_iron/features/exercise/widgets/excercise_dropdown.dart';
import 'package:velvet_iron/features/exercise/widgets/intensity_and_duaration.dart';
import 'package:velvet_iron/features/medication_screen/widgets/excercise_name_textfield.dart';

class ScheduleTabContent extends StatelessWidget {
  const ScheduleTabContent({super.key, required this.controller});

  final ExerciseController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Exercise Type:",
          style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 13),
        ExcerciseDropdown(iconPath: IconPath.heart),
        SizedBox(height: 13),
        Text(
          "Exercise Name:",
          style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 10),
        excerciseNameTextField(),
        SizedBox(height: 16),
        IntensityAndDuration(),
        SizedBox(height: 10),
        DateAndTimePicker(),
        SizedBox(height: 20),
        Text("Notes (optional)", style: getTextStyle()),
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
        SizedBox(height: 18),
        CustomButton(label: "Log Exercise (+10 XP)", onPressed: () {}),
      ],
    );
  }
}
