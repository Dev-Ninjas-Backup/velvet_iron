import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';

class IntensityAndDuration extends StatelessWidget {
  const IntensityAndDuration({super.key});

  static final List<String> _intensities = ["Low", "Moderate", "High"];

  TextStyle getTextStyle({Color? color}) {
    return TextStyle(
      color: color ?? Colors.white,
      fontSize: 16,
      fontFamily: 'Serif',
    );
  }

  @override
  Widget build(BuildContext context) {
    final RxString selectedIntensity = "Moderate".obs;
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
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
                          color: themeController.activeTheme.todoSubtitleColor
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: themeController.activeTheme.borderColor,
                            width: 1.11,
                          ),
                        ),
                        child: Obx(
                          () => DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedIntensity.value,
                              isExpanded: true,
                              icon: const Icon(
                                Icons.expand_more,
                                color: Colors.white,
                                size: 18,
                              ),
                              dropdownColor: themeController
                                  .activeTheme
                                  .todoSubtitleColor
                                  .withValues(alpha: 0.3),
                              items: _intensities.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: getTextStyle(
                                      color: Colors.white,
                                    ).copyWith(fontSize: 12),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  selectedIntensity.value = newValue;
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16), // Space between the two columns
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
                          color: themeController.activeTheme.todoSubtitleColor
                              .withValues(alpha: 0.3),
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
                                style: getTextStyle(),
                                decoration: InputDecoration(
                                  hintText: "e.g. 30 min",
                                  hintStyle: TextStyle(
                                    color: themeController
                                        .activeTheme
                                        .todoTimeColor,
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
      },
    );
  }
}
