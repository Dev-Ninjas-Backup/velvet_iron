import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/features/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:velvet_iron/features/daily_logs/controller/daily_log_controller.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens.dart/meal_log_screen/meal_log_screen.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens.dart/weight_log_screen/weight_log_screen.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens.dart/mood_log_screen/mood_log_screen.dart';

class DailyLogScreen extends StatelessWidget {
  const DailyLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DailyLogController());
    final navController = Get.put(BottomNavController());

    return Scaffold(
      backgroundColor: const Color(0xFF1A0101),

      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E0000), Color(0xFF680B0B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/magicImage.png',
              width: 378,
              height: 411,
            ),
          ),
          Obx(() {
            switch (controller.selectedTab.value) {
              case 0:
                return WeightLog(
                  controller: controller,
                  navController: navController,
                );
              case 1:
                return MoodLog(controller: controller);
              case 2:
                return MealLog(controller: controller);
              default:
                return MoodLog(controller: controller);
            }
          }),
        ],
      ),
    );
  }
}
