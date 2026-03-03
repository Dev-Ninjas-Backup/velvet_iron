import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/exercise/controller/exercise_controller.dart';

class ExcerciseDropdown extends StatelessWidget {
  final String iconPath;
  final ExerciseController controller;
  final List<String> options = const [
    "Cardio",
    "Strength",
    "Flexibility",
    "Balance",
  ];

  const ExcerciseDropdown({
    super.key,
    required this.iconPath,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Obx(() {
          return Container(
            width: double.infinity,
            height: 40,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            decoration: BoxDecoration(
              color: themeController.activeTheme.todoSubtitleColor.withValues(
                alpha: 0.3,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.exerciseType.value,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
                isExpanded: true,
                dropdownColor:
                    themeController.activeTheme.dropdownBackgroundColor,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.exerciseType.value = newValue;
                  }
                },
                items: options.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        Image.asset(
                          iconPath,
                          width: 20,
                          height: 20,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        });
      },
    );
  }
}
