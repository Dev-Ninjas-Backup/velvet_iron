import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';

class NutritionInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool enabled;
  final String unit;
  final double? width;

  const NutritionInputField({
    super.key,
    required this.hintText,
    this.controller,
    this.enabled = true,
    this.unit = "g",
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Container(
          width: width,
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: enabled
                ? themeController.activeTheme.textfieldColor
                : themeController.activeTheme.textfieldColor.withValues(
                    alpha: 0.5,
                  ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: enabled
                  ? themeController.activeTheme.borderColor
                  : themeController.activeTheme.borderColor.withValues(
                      alpha: 0.3,
                    ),
              width: 1.11,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: enabled,
                  keyboardType: TextInputType.number,
                  cursorColor: themeController.activeTheme.todoTimeColor,
                  style: getTextStyle(
                    fontSize: 12,
                    color: enabled ? Colors.white : Colors.white54,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: getTextStyle(
                      fontSize: 12,
                      color: enabled
                          ? themeController.activeTheme.textColor
                          : themeController.activeTheme.textColor.withValues(
                              alpha: 0.5,
                            ),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              Text(
                unit,
                style: getTextStyle(
                  fontSize: 11,
                  color: enabled ? Colors.white : Colors.white54,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
