import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/daily_logs/controller/daily_log_controller.dart';
import 'package:velvet_iron/features/exercise/widgets/excercise_dropdown.dart';
import 'package:velvet_iron/features/exercise/widgets/intensity_and_duration.dart';
import 'package:velvet_iron/features/medication_screen/widgets/excercise_name_textfield.dart';

class CompletedTabContent extends StatelessWidget {
  const CompletedTabContent({super.key, required this.controller});

  final DailyLogController controller;

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
        SizedBox(height: 16),
        const SizedBox(height: 10),

        SizedBox(height: 14),

        CustomButton(label: "Log Meal (+10 XP)", onPressed: () {}),

        // SizedBox(height: 16),
        // Text(
        //   "Dose History",
        //   style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        // ),
        SizedBox(height: 5),
        // DoseHistory(
        //   title: "Ozempic (4mg)",
        //   sub: "1 Injection",
        //   time: "Wed - 09:30 AM",
        //   iconPath: IconPath.injection,
        //   isSelected: RxBool(false),
        // ),
        // DoseHistory(
        //   title: "Metformin (400mg)",
        //   sub: "120 calories",
        //   time: "12 Dec, Wed - 09:00 PM",
        //   iconPath: IconPath.injection2,
        //   isSelected: RxBool(false),
        // ),
      ],
    );
  }
}
