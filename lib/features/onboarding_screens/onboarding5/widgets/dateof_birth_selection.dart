import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding5/controller/onboarding5_controller.dart';

class DateSelectionWidget extends StatelessWidget {
  const DateSelectionWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController5>();
    return Row(
      children: [
        Expanded(
          child: _buildDropdown(
            label: 'Day',
            value: controller.selectedDay,
            items: controller.days,
            onChanged: (value) => controller.selectedDay.value = value!,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDropdown(
            label: 'Month',
            value: controller.selectedMonth,
            items: controller.months,
            onChanged: (value) => controller.selectedMonth.value = value!,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDropdown(
            label: 'Year',
            value: controller.selectedYear,
            items: controller.years,
            onChanged: (value) => controller.selectedYear.value = value!,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required RxString value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF3A0303),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFF6B1717), width: 1.5),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value.value,
                isExpanded: true,
                dropdownColor: const Color(0xFF512212),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 20,
                ),
                style: getTextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                items: items.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}