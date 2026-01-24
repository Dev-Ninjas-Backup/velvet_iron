import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:velvet_iron/features/daily_logs/widgets/gradient_option_button.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/controller/meal_log_controller.dart';

class MealTabSwitcher extends StatelessWidget {
  final MealLogController controller;
  final Widget? tokenContent;
  final Widget? scheduleContent;

  const MealTabSwitcher({
    super.key,
    required this.controller,
    this.tokenContent,
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
                text: "Taken",
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
              ? (tokenContent ?? const SizedBox.shrink())
              : (scheduleContent ?? const SizedBox.shrink()),
        ],
      ),
    );
  }
}
