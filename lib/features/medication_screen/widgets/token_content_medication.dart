import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/medication_screen/controller/medication_controller.dart';
import 'package:velvet_iron/features/medication_screen/widgets/custom_drop_down.dart';
import 'package:velvet_iron/features/medication_screen/widgets/dose_history.dart';
import 'package:velvet_iron/features/medication_screen/widgets/dose_name_textfield.dart';

class TokenContentMedication extends StatelessWidget {
  const TokenContentMedication({super.key, required this.controller});

  final MedicationController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Dose Name:",
              style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
            DoseNameTextField(),
            SizedBox(height: 16),
            Text(
              "Medicine Type:",
              style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 13),
            CustomDropdown(iconPath: IconPath.todo2),
            SizedBox(height: 12),
            Text(
              "Dose mg:",
              style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: TextField(
                cursorColor: themeController.activeTheme.accentGoldColor,
                style: getTextStyle(fontSize: 12, color: Colors.white),
                decoration: InputDecoration(
                  hintText: "mg",
                  hintStyle: getTextStyle(fontSize: 12, color: Colors.white),
                  filled: true,
                  fillColor: themeController.activeTheme.textfieldColor,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: themeController.activeTheme.borderColor,
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
            SizedBox(height: 14),
            CustomButton(label: "Log Meal (+10 XP)", onPressed: () {}),
            SizedBox(height: 16),
            Text(
              "Dose History",
              style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 5),
            DoseHistory(
              title: "Ozempic (4mg)",
              sub: "1 Injection",
              time: "Wed - 09:30 AM",
              iconPath: IconPath.injection,
              isSelected: RxBool(false),
            ),
            DoseHistory(
              title: "Metformin (400mg)",
              sub: "120 calories",
              time: "12 Dec, Wed - 09:00 PM",
              iconPath: IconPath.injection2,
              isSelected: RxBool(false),
            ),
          ],
        );
      },
    );
  }
}
