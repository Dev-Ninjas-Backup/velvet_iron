import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/common/widgets/empty_state_card.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
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
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final local = dt.toLocal();
    final day = days[local.weekday - 1];
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';
    final now = DateTime.now();
    if (local.year == now.year &&
        local.month == now.month &&
        local.day == now.day) {
      return "Today - $hour:$minute $period";
    }
    return "$day - $hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Medication Name:",
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
                    "Medication Type:",
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    final homeController = Get.isRegistered<HomeController>()
                        ? Get.find<HomeController>()
                        : null;
                    showDialog(
                      context: context,
                      builder: (context) => MedicationPopup(
                        selectedCompanionImage:
                            homeController?.activeCompanionImage.value ??
                                ImagePath.thyra,
                        selectedCompanionName:
                            homeController?.activeCompanionName.value ??
                                'Thyra',
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      IconPath.exclametory,
                      width: 18,
                      height: 18,
                      fit: BoxFit.contain,
                    ),
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
            const SizedBox(height: 12),
            Text(
              "Recurrence:",
              style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Row(
                children: ['DAILY', 'WEEKLY', 'SPECIFIC DAYS'].map((rec) {
                  final isSel = controller.selectedRecurrence.value == rec;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => controller.selectedRecurrence.value = rec,
                      child: Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSel
                              ? themeController.activeTheme.accentGoldColor
                                  .withValues(alpha: 0.3)
                              : Colors.black26,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSel
                                ? themeController.activeTheme.accentGoldColor
                                : Colors.white24,
                          ),
                        ),
                        child: Text(
                          rec,
                          style: TextStyle(
                            color: isSel
                                ? themeController.activeTheme.accentGoldColor
                                : Colors.white70,
                            fontSize: 11,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: "Schedule Medication (+10 XP)",
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

              final logs = controller.completedMedications;

              if (logs.isEmpty) {
                return const EmptyStateCard(
                  icon: Icons.medication_outlined,
                  title: "No medication doses logged yet",
                  subtitle:
                      "Log or schedule medications above to track your regimen.",
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
              final scheduled = controller.scheduledMedications;
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
                  if (scheduled.isEmpty)
                    const EmptyStateCard(
                      icon: Icons.event_note_rounded,
                      title: "No upcoming scheduled doses",
                      subtitle:
                          "Schedule your medications to receive reminders and earn XP.",
                    )
                  else
                    ...scheduled.map((next) {
                    final timeStr = next.scheduledAt != null
                        ? _formatDateTime(next.scheduledAt!)
                        : '';
                    return DoseHistory(
                      title: "${next.name} (${next.doseMg.toInt()}mg)",
                      sub: next.type[0] + next.type.substring(1).toLowerCase(),
                      time: timeStr,
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
                      onEditTap: () => _showEditMedicationDialog(
                        context,
                        themeController,
                        next,
                      ),
                      onDeleteTap: () => _confirmDeleteMedication(
                        context,
                        themeController,
                        next,
                      ),
                    );
                  }),
                ],
              );
            }),
          ],
        );
      },
    );
  }

  void _confirmDeleteMedication(
    BuildContext context,
    AppThemeController themeController,
    dynamic med,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: themeController.activeTheme.dropdownBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: themeController.activeTheme.borderColor.withValues(alpha: 0.4),
          ),
        ),
        title: Text(
          'Delete Medication Schedule',
          style: getTextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to remove "${med.name}" from your scheduled medications?',
          style: getTextStyle(fontSize: 13, color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: getTextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(ctx);
              controller.deleteMedicationSchedule(med.id);
            },
            child: Text('Delete', style: getTextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditMedicationDialog(
    BuildContext context,
    AppThemeController themeController,
    dynamic med,
  ) {
    final nameCtrl = TextEditingController(text: med.name);
    final doseCtrl = TextEditingController(text: med.doseMg.toInt().toString());
    var selectedType = med.type.toString().toUpperCase();
    var editDate = med.scheduledAt ?? DateTime.now();
    var editTime = TimeOfDay.fromDateTime(editDate);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: themeController.activeTheme.dropdownBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: themeController.activeTheme.borderColor.withValues(alpha: 0.4),
            ),
          ),
          title: Text(
            'Edit Medication Schedule',
            style: getTextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Medication Name', style: getTextStyle(fontSize: 12, color: Colors.white70)),
                const SizedBox(height: 6),
                TextField(
                  controller: nameCtrl,
                  style: getTextStyle(fontSize: 13, color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),
                Text('Dose (mg)', style: getTextStyle(fontSize: 12, color: Colors.white70)),
                const SizedBox(height: 6),
                TextField(
                  controller: doseCtrl,
                  keyboardType: TextInputType.number,
                  style: getTextStyle(fontSize: 13, color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),
                Text('Scheduled Time', style: getTextStyle(fontSize: 12, color: Colors.white70)),
                const SizedBox(height: 6),
                DateAndTimePicker(
                  selectedDate: editDate,
                  selectedTime: editTime,
                  onDateChanged: (d) => setDialogState(() => editDate = d),
                  onTimeChanged: (t) => setDialogState(() => editTime = t),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: getTextStyle(color: Colors.white60)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeController.activeTheme.accentGoldColor,
              ),
              onPressed: () {
                final newName = nameCtrl.text.trim();
                final newDose = int.tryParse(doseCtrl.text.trim()) ?? med.doseMg.toInt();
                if (newName.isEmpty) return;

                final scheduledDt = DateTime(
                  editDate.year,
                  editDate.month,
                  editDate.day,
                  editTime.hour,
                  editTime.minute,
                );

                Navigator.pop(ctx);
                controller.updateMedicationSchedule(
                  medicationId: med.id,
                  name: newName,
                  type: selectedType,
                  doseMg: newDose,
                  scheduleTime: scheduledDt,
                );
              },
              child: Text('Save', style: getTextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
