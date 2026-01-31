import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:velvet_iron/features/home/controller/home_controller.dart';
import 'package:velvet_iron/features/home/controller/theme_controller.dart';
import 'package:velvet_iron/features/home/models/home_theme_model.dart';
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
    Get.put(ThemeController());

    final bottomNavController = Get.find<BottomNavController>();

    return Scaffold(
      backgroundColor: const Color(0xFF1A0101).withValues(alpha: .5),
      body: Obx(() {
        final isHomeScreen = bottomNavController.tabIndex.value == 0;

        return Stack(
          children: [
            GetBuilder<ThemeController>(
              builder: (themeController) {
                final activeTheme =
                    themeController.currentTheme.value ??
                    HomeThemeModel.adventurerTheme;
                return Container(
                  decoration: BoxDecoration(
                    gradient: isHomeScreen
                        ? activeTheme.backgroundGradient
                        : const LinearGradient(
                            colors: [Color(0xFF1E0000), Color(0xFF680B0B)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                  ),
                );
              },
            ),

            // Magic image - theme specific
            GetBuilder<ThemeController>(
              builder: (themeController) {
                final activeTheme =
                    themeController.currentTheme.value ??
                    HomeThemeModel.adventurerTheme;
                if (isHomeScreen) {
                  switch (activeTheme.id) {
                    case 'mage':
                      break;
                    case 'reader':
                      break;
                    case 'gamer':
                      break;
                    default:
                  }
                } else {
                }

                return Positioned(
                  child: Opacity(
                    opacity: 0.2, // 0.0 - 1.0
                    child: Image.asset(ImagePath.backgroundOne),
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
