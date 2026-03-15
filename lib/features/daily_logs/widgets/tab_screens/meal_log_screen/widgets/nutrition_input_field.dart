import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';

class NutritionInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool enabled;

  const NutritionInputField({
    super.key,
    required this.hintText,
    this.controller,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Container(
          width: 98.33, // Fill width as requested
          height: 40, // Fixed height
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                "g",
                style: getTextStyle(
                  fontSize: 12,
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
