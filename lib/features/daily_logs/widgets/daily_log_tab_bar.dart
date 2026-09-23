import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/features/daily_logs/controller/daily_log_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/gradient_option_button.dart';

class DailyLogTabBar extends StatelessWidget {
  final DailyLogController controller;

  const DailyLogTabBar({
    super.key,
    required this.controller,
  });

  static const List<String> tabNames = [
    'Weight Log',
    'Mood Log',
    'Meal Log',
    'Water Log',
    'Step Journey',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Obx(
        () => Row(
          children: List.generate(tabNames.length, (index) {
            final isSelected = controller.selectedTab.value == index;
            return Padding(
              padding: EdgeInsets.only(right: index == tabNames.length - 1 ? 0 : 8),
              child: CustomGradientOptionButton(
                text: tabNames[index],
                isSelected: isSelected,
                onPressed: () => controller.setTab(index),
              ),
            );
          }),
        ),
      ),
    );
  }
}
