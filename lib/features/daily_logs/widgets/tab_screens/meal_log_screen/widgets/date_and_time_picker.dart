import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';

class DateAndTimePicker extends StatelessWidget {
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const DateAndTimePicker({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.onDateChanged,
    required this.onTimeChanged,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      onDateChanged(picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      onTimeChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Date",
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPickerField(
                    value: DateFormat('yyyy-MM-dd').format(selectedDate),
                    hint: "Choose",
                    iconPath: IconPath.calendar,
                    onTap: () => _selectDate(context),
                    themeController: themeController,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Time",
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPickerField(
                    value: selectedTime.format(context),
                    hint: "Choose",
                    iconPath: IconPath.whiteClock,
                    onTap: () => _selectTime(context),
                    themeController: themeController,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPickerField({
    required String value,
    required String hint,
    required String iconPath,
    required VoidCallback onTap,
    required AppThemeController themeController,
  }) {
    return SizedBox(
      height: 40,
      child: TextFormField(
        controller: TextEditingController(text: value),
        readOnly: true,
        onTap: onTap,
        style: getTextStyle(
          fontSize: 12,
          color: themeController.activeTheme.textColor,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: getTextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: themeController.activeTheme.todoSubtitleColor,
          ),
          filled: true,
          fillColor: themeController.activeTheme.todoSubtitleColor.withValues(
            alpha: 0.3,
          ),
          contentPadding: const EdgeInsets.only(
            left: 12,
            right: 12,
            top: 8,
            bottom: 8,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              iconPath == IconPath.whiteClock ? IconPath.whiteClock : iconPath,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
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
    );
  }
}
