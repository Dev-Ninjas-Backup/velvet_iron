import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/widgets/date_and_time_picker.dart';
import 'package:velvet_iron/features/home/controller/home_controller.dart';
import 'package:velvet_iron/features/medication_screen/controller/medication_controller.dart';
import 'package:velvet_iron/features/medication_screen/widgets/custom_drop_down.dart';
import 'package:velvet_iron/features/medication_screen/widgets/dose_history.dart';
import 'package:velvet_iron/features/medication_screen/widgets/dose_name_textfield.dart';
import 'package:velvet_iron/features/medication_screen/widgets/medication_popup.dart';

class ScheduleContentMedication extends StatelessWidget {
  const ScheduleContentMedication({super.key, required this.controller});

  final MedicationController controller;
  String _getMedIcon(String type) {
    switch (type.toUpperCase()) {
      case 'INJECTION':
        return IconPath.injection;
      case 'CAPSULE':
      case 'TABLET':
        return IconPath.injection2;
      default:
        return IconPath.injection;
    }
  }

  String _formatDateTime(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final local = dt.toLocal();
    final day = days[local.weekday - 1];
    final month = months[local.month - 1];
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';
    return "${local.day} $month, $day - $hour:$minute $period";
  }

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
            SizedBox(height: 14),
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
            const SizedBox(height: 11),
            CustomDropdown(iconPath: IconPath.todo2),
            const SizedBox(height: 10),
            Text(
              "Dose (mg):",
              style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: TextField(
                controller: controller.doseMgController,
                keyboardType: TextInputType.number,
                cursorColor: themeController.activeTheme.accentGoldColor,
                style: getTextStyle(fontSize: 12, color: Colors.white),
                onChanged: (val) {
                  final parsed = double.tryParse(val);
                  if (parsed != null) controller.updateDoseMg(parsed);
                },
                decoration: InputDecoration(
                  hintText: "4",
                  hintStyle: getTextStyle(
                    fontSize: 12,
                    color: themeController.activeTheme.todoTimeColor.withValues(
                      alpha: 0.9,
                    ),
                  ),
                  filled: true,
                  fillColor: themeController.activeTheme.todoSubtitleColor
                      .withValues(alpha: 0.3),
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
            const SizedBox(height: 10),
            Obx(
              () => DateAndTimePicker(
                selectedDate: controller.selectedDate.value,
                selectedTime: controller.selectedTime.value,
                onDateChanged: (date) => controller.updateDate(date),
                onTimeChanged: (time) => controller.updateTime(time),
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: "Log Meal (+10 XP)",
              onPressed: () => controller.scheduleMedication(),
            ),
            const SizedBox(height: 14),
            Text(
              "Dose History",
              style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 14),
            Obx(() {
              if (controller.isHistoryLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final allLogs = controller.medicationHistory;
              final nextSchedule = controller.historyData.value?.nextSchedule;

              // Filter to only show medications that are NOT the next schedule
              // (only show completed/taken doses)
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
                              '[ScheduleContent] 🖱️ Status icon tapped for ${med.name}',
                            );
                            controller.markMedicationAsTaken(med.id);
                          }
                        : null,
                  );
                }).toList(),
              );
            }),

            const SizedBox(height: 14),
            Obx(() {
              final next = controller.historyData.value?.nextSchedule;
              if (next == null) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Next Dose",
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DoseHistory(
                    title: "${next.name} (${next.doseMg.toInt()}mg)",
                    sub: next.type[0] + next.type.substring(1).toLowerCase(),
                    time: next.scheduledAt != null
                        ? _formatDateTime(next.scheduledAt!)
                        : '',
                    iconPath: _getMedIcon(next.type),
                    isSelected: RxBool(false),
                    isTaken: next.isTaken,
                    onStatusIconTap: !next.isTaken
                        ? () {
                            debugPrint(
                              '[ScheduleContent] 🖱️ Status icon tapped for next dose ${next.name}',
                            );
                            controller.markMedicationAsTaken(next.id);
                          }
                        : null,
                  ),
                ],
              );
            }),
          ],
        );
      },
    );
  }
}
