import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';

class LogYourWeightCard extends StatelessWidget {
  const LogYourWeightCard({
    super.key,
    required this.weightController,
    required this.noteController,
    required this.onPressed,
  });

  final TextEditingController weightController;
  final TextEditingController noteController;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: themeController.activeTheme.cardBackgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Weight (lbs):",
                style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: TextFormField(
                  controller: weightController,
                  style: getTextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "Enter current weight",
                    hintStyle: getTextStyle(fontSize: 12, color: Colors.white),
                    filled: true,
                    fillColor: themeController
                        .activeTheme
                        .dropdownBackgroundColor
                        .withValues(alpha: 0.3),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "lbs",
                            style: getTextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(
                        color: themeController.activeTheme.borderColor,
                        width: 1.11,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(
                        color: themeController.activeTheme.accentGoldColor,
                        width: 1.11,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                "Note (optional):",
                style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 69,
                child: TextFormField(
                  controller: noteController,
                  maxLines: 3,
                  style: getTextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "Feeling good today...",
                    hintStyle: getTextStyle(
                      fontSize: 12,
                      color: themeController.activeTheme.dropdownBackgroundColor
                          .withValues(alpha: 0.7),
                    ),
                    filled: true,
                    fillColor: themeController.activeTheme.todoSubtitleColor
                        .withValues(alpha: 0.3),
                    contentPadding: const EdgeInsets.all(12),
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
                  ),
                ),
              ),
              const SizedBox(height: 14),
              CustomButton(label: "Log Weight (+5 XP)", onPressed: onPressed),
            ],
          ),
        );
      },
    );
  }
}
