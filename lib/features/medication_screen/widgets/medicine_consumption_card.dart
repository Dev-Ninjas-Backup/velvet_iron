import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/medication_screen/controller/medication_controller.dart';

class IconPath {
  static const String goldencircle = 'assets/icons/goldencircle.png';
  static const String whitecircle = 'assets/icons/whitecircle.png';
}

class MedicineConsumptionCard extends StatelessWidget {
  const MedicineConsumptionCard({super.key});
  static const List<String> _weekDayLabels = [
    "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
  ];
  static const List<String> _weekDayKeys = [
    "sunday",
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
  ];

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<MedicationController>()) {
      Get.put(MedicationController());
    }
    final medicationController = Get.find<MedicationController>();

    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: themeController.activeTheme.cardBackgroundColor.withValues(
              alpha: .4,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Obx(() {
            final h = medicationController.historyData.value;
            final completed = medicationController.completedMedications.length;
            final scheduled = medicationController.scheduledMedications.length;

            final Map<String, bool> weeklyPresent = {};
            for (final med in medicationController.completedMedications) {
              if (med.loggedAt != null) {
                final weekday = med.loggedAt!.weekday; 
                final dayIndex = weekday == 7
                    ? 0
                    : weekday; 
                final dayName = _weekDayKeys[dayIndex];
                weeklyPresent[dayName] = true;
              }
            }

            final doseProgress = (scheduled + completed) > 0
                ? (completed / (completed + scheduled)).clamp(0.0, 1.0)
                : 0.0;

            return Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Medicine Consumption",
                      style: getTextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const Spacer(),
                    Container(
                      height: 22,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: themeController.activeTheme.todoSubtitleColor
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: themeController.activeTheme.borderColor,
                          width: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_weekDayLabels.length, (index) {
                    final bool isActive =
                        weeklyPresent[_weekDayKeys[index]] ?? false;
                    String dotIcon = isActive
                        ? (themeController.activeTheme.id == 'adventurer'
                              ? 'assets/icons/doticon_adventure.png'
                              : themeController.activeTheme.id == 'mage'
                              ? 'assets/icons/doticon_mage.png'
                              : themeController.activeTheme.id == 'gamer'
                              ? 'assets/icons/doticon_gamer.png'
                              : 'assets/icons/doticon_reader.png')
                        : IconPath.whitecircle;

                    return Container(
                      width: 43,
                      height: 60,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: themeController.activeTheme.todoSubtitleColor
                            .withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(50),
                        border: isActive
                            ? Border.all(
                                color:
                                    themeController.activeTheme.dateNameborder,
                                width: 1,
                              )
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              Image.asset(dotIcon, width: 18, height: 18),
                            ],
                          ),
                          Text(
                            _weekDayLabels[index],
                            style: getTextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Doses Taken",
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "$completed/${completed + scheduled}",
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 6,
                      decoration: BoxDecoration(
                        color: themeController.activeTheme.textfieldColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          width: constraints.maxWidth * doseProgress,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient:
                                themeController.activeTheme.progressBarGradient,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            );
          }),
        );
      },
    );
  }
}
