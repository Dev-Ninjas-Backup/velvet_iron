import 'package:velvet_iron/features/medication_screen/widgets/medication_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/home/controller/home_controller.dart';
import 'package:velvet_iron/features/medication_screen/controller/medication_controller.dart';
import 'package:velvet_iron/features/medication_screen/widgets/custom_drop_down.dart';
import 'package:velvet_iron/features/medication_screen/widgets/dose_history.dart';
import 'package:velvet_iron/features/medication_screen/widgets/dose_name_textfield.dart';

class TokenContentMedication extends StatelessWidget {
  String _formatDateTime(DateTime dateTime) {
    // Example: Wed - 09:30 AM
    final weekDay = [
      "Mon",
      "Tue",
      "Wed",
      "Thu",
      "Fri",
      "Sat",
      "Sun",
    ][dateTime.weekday - 1];
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final ampm = dateTime.hour >= 12 ? "PM" : "AM";
    return "$weekDay - $hour:$minute $ampm";
  }

  String _getMedIcon(String type) {
    switch (type.toLowerCase()) {
      case 'injection':
        return IconPath.injection;
      case 'tablet':
        return IconPath.injection2;
      default:
        return IconPath.injection;
    }
  }

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
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    "Medicine Type:",
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () {
                    final homeController = Get.find<HomeController>();
                    showDialog(
                      context: context,
                      builder: (context) => MedicationPopup(
                        selectedCompanionImage:
                            homeController.activeCompanionImage.value,
                        selectedCompanionName:
                            homeController.activeCompanionName.value,
                      ),
                    );
                  },
                  child: Image.asset(
                    IconPath.exclametory,
                    width: 18,
                    height: 18,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
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
                controller: controller.doseMgController,
                onChanged: (value) {
                  final dose = double.tryParse(value);
                  if (dose != null) {
                    controller.updateDoseMg(dose);
                  }
                },
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
            CustomButton(
              label: "Log Meal (+10 XP)",
              onPressed: () => controller.logMedication(),
            ),
            SizedBox(height: 16),
            Text(
              "Dose History",
              style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 5),
            Obx(() {
              if (controller.isHistoryLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final allLogs = controller.medicationHistory;
              final nextSchedule = controller.historyData.value?.nextSchedule;

              // Filter to only show medications that are NOT the next schedule
              final logs = allLogs
                  .where(
                    (med) => nextSchedule == null || med.id != nextSchedule.id,
                  )
                  .toList();

              if (logs.isEmpty) {
                return Center(
                  child: Text(
                    "No dose history found",
                    style: getTextStyle(fontSize: 14, color: Colors.white54),
                  ),
                );
              }
              return Column(
                children: logs.map((med) {
                  final timeStr = med.loggedAt != null
                      ? _formatDateTime(med.loggedAt!)
                      : med.scheduledAt != null
                      ? _formatDateTime(med.scheduledAt!)
                      : '';
                  return DoseHistory(
                    title: "${med.name} (${med.doseMg.toInt()}mg)",
                    sub: med.type[0] + med.type.substring(1).toLowerCase(),
                    time: timeStr,
                    iconPath: _getMedIcon(med.type),
                    isSelected: RxBool(false),
                    isTaken: med.isTaken,
                    onStatusIconTap: !med.isTaken
                        ? () {
                            debugPrint(
                              '[TokenContent] 🖱️ Status icon tapped for ${med.name}',
                            );
                            controller.markMedicationAsTaken(med.id);
                          }
                        : null,
                  );
                }).toList(),
              );
            }),
          ],
        );
      },
    );
  }
}
