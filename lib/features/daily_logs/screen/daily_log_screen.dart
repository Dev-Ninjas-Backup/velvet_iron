import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/features/daily_logs/controller/daily_log_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens.dart/meal_log_screen/meal_log_screen.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens.dart/weight_log_screen/weight_log_screen.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens.dart/mood_log_screen/mood_log_screen.dart';

class DailyLogScreen extends StatelessWidget {
  const DailyLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DailyLogController());

    return Scaffold(
      backgroundColor: const Color(0xFF1A0101),
      body: Obx(() {
        switch (controller.selectedTab.value) {
          case 0:
            return WeightLog(controller: controller);
          case 1:
            return MoodLog(controller: controller);
          case 2:
            return MealLog(controller: controller);
          default:
            return MoodLog(controller: controller);
        }
      }),
    );
  }
}
