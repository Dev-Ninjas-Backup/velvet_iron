import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/features/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:velvet_iron/features/daily_logs/controller/daily_log_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/controller/meal_log_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/meal_log_screen/screen/meal_log_screen.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/mood_log_screen/controller/mood_log_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/weight_log_screen/controller/weight_log_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/weight_log_screen/screen/weight_log_screen.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/mood_log_screen/screen/mood_log_screen.dart';

class DailyLogScreen extends StatelessWidget {
  const DailyLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DailyLogController());
    final navController = Get.put(BottomNavController());
    final moodLogController = Get.put(MoodLogController());
    final weightLogController = Get.put(WeightLogController());
    final mealLogController = Get.put(MealLogController());

    return Scaffold(
      backgroundColor: const Color(0xFF1A0101),
      body: Stack(
        children: [
        Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF611313), Color(0xFF1A0101)],
              ),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.2,
              child: Image.asset('assets/images/backgroundOne.png'),
            ),
          ),
          Obx(() {
            switch (controller.selectedTab.value) {
              case 0:
                return WeightLog(
                  dailyLogController: controller,
                  navController: navController,
                  weightLogController: weightLogController,
                );
              case 1:
                return MoodLog(
                  dailyLogController: controller,
                  moodLogController: moodLogController,
                );
              case 2:
                return MealLog(
                  dailyLogController: controller,
                  mealLogController: mealLogController,
                );
              default:
                return MoodLog(
                  dailyLogController: controller,
                  moodLogController: moodLogController,
                );
            }
          }),
        ],
      ),
    );
  }
}
