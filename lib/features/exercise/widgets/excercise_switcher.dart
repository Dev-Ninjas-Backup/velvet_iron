import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:velvet_iron/features/daily_logs/controller/daily_log_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/gradient_option_button.dart';

class ExcerciseSwitcher extends StatelessWidget {
  final DailyLogController controller;
  final Widget? completedContent;
  final Widget? scheduleContent;

  const ExcerciseSwitcher({
    super.key,
    required this.controller,
    this.completedContent,
    this.scheduleContent,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomGradientOptionButton(
                text: "Completed",
                isSelected: controller.selectedMealTab.value == 0,
                onPressed: () => controller.setMealTab(0),
              ),
              const SizedBox(width: 10),
              CustomGradientOptionButton(
                text: "Schedule",
                isSelected: controller.selectedMealTab.value == 1,
                onPressed: () => controller.setMealTab(1),
              ),
            ],
          ),
          const SizedBox(height: 16),
          controller.selectedMealTab.value == 0
              ? (completedContent ?? const SizedBox.shrink())
              : (scheduleContent ?? const SizedBox.shrink()),
        ],
      ),
    );
  }
}
