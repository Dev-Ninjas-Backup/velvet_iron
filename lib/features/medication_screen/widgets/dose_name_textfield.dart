import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/medication_screen/controller/medication_controller.dart';

// ignore: non_constant_identifier_names
SizedBox DoseNameTextField() {
  final MedicationController controller = Get.find();
  return SizedBox(
    height: 40,
    child: GetBuilder<AppThemeController>(
      builder: (themeController) {
        return TextField(
          controller: controller.doseNameController,
          onChanged: (value) => controller.updateMedicationName(value),
          cursorColor: themeController.activeTheme.accentGoldColor,
          style: getTextStyle(fontSize: 12, color: Colors.white),
          decoration: InputDecoration(
            hintText: "Ozempic",
            hintStyle: getTextStyle(
              fontSize: 12,
              color: themeController.activeTheme.todoTimeColor,
            ),
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
        );
      },
    ),
  );
}
