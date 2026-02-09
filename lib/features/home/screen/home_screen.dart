import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/features/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:velvet_iron/features/home/controller/home_controller.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/home/widgets/mood_selector.dart';
import 'package:velvet_iron/features/home/widgets/todo_list.dart';
import '../widgets/header_section.dart';
import '../widgets/welcome_card.dart';
import '../widgets/weight_progress.dart';
import '../../bottom_nav/screen/bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BottomNavController());
    Get.put(HomeController());

    final bottomNavController = Get.find<BottomNavController>();

    return Scaffold(
      backgroundColor: const Color(0xFF1A0101).withValues(alpha: .5),
      body: Obx(() {
        return Stack(
          children: [
            GetBuilder<AppThemeController>(
              builder: (themeController) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: themeController.activeTheme.backgroundGradient,
                  ),
                );
              },
            ),

            // Magic image - theme specific
            GetBuilder<AppThemeController>(
              builder: (themeController) {
                return Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Opacity(
                    opacity: 0.2,
                    child: Image.asset(
                      themeController.activeTheme.backgroundImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),

            // Content
            Padding(
              padding: const EdgeInsets.only(bottom: 115),
              child: bottomNavController.getCurrentScreen(),
            ),

            // Bottom nav
            const Positioned(bottom: 20, left: 0, right: 0, child: BottomNav()),
          ],
        );
      }),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            HeaderSection(),
            SizedBox(height: 20),
            WelcomeCard(),
            SizedBox(height: 26),
            WeightProgress(title: 'Weekly Activity'),
            SizedBox(height: 26),
            MoodSelector(),
            SizedBox(height: 26),
            TodoSection(),
          ],
        ),
      ),
    );
  }
}
