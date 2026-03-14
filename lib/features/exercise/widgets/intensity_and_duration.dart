import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/exercise/controller/exercise_controller.dart';

class IntensityAndDuration extends StatelessWidget {
  final ExerciseController controller;
  final List<String> _intensities = const ["Low", "Moderate", "High"];

  const IntensityAndDuration({super.key, required this.controller});

  TextStyle getTextStyle() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontFamily: 'Serif',
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Obx(() {
          // Ensure only valid intensity value is set
          if (!_intensities.contains(controller.intensity.value)) {
            controller.intensity.value = "Moderate";
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Intensity:", style: getTextStyle()),
                        const SizedBox(height: 8),
                        Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: themeController.activeTheme.textfieldColor
                                .withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: themeController.activeTheme.borderColor,
                              width: 1.11,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: controller.intensity.value,
                              isExpanded: true,
                              icon: const Icon(
                                Icons.expand_more,
                                color: Colors.white,
                                size: 18,
                              ),
                              dropdownColor: themeController
                                  .activeTheme
                                  .dropdownBackgroundColor,
                              items: _intensities.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: getTextStyle().copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  controller.intensity.value = newValue;
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Duration:", style: getTextStyle()),
                        const SizedBox(height: 8),
                        Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: themeController.activeTheme.textfieldColor
                                .withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: themeController.activeTheme.borderColor,
                              width: 1.11,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextField(
                                  onChanged: (value) {
                                    controller.duration.value =
                                        int.tryParse(value) ?? 30;
                                  },
                                  style: getTextStyle(),
                                  decoration: InputDecoration(
                                    hintText:
                                        "${controller.duration.value} min",
                                    hintStyle: TextStyle(
                                      color:
                                          themeController.activeTheme.textColor,
                                      fontSize: 12,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              Text(
                                "min",
                                style: getTextStyle().copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        });
      },
    );
  }
}
