import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/features/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:velvet_iron/features/home/controller/home_controller.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/home/widgets/mood_selector.dart';
import 'package:velvet_iron/features/home/widgets/todo_list.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/home/widgets/popup_dialogue.dart';
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

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  bool _popupShown = false;

  @override
  void initState() {
    super.initState();
    _showDailyRewardsPopup();
  }

  /// Check if 24 hours have passed since last daily login XP collection
  Future<bool> _can24HoursPassed() async {
    final lastLoginTimestamp =
        await SharedPreferencesHelper.getLastDailyLoginTimestamp();

    if (lastLoginTimestamp == null) {
      // First time collecting daily XP
      return true;
    }

    try {
      final lastLoginTime = DateTime.parse(lastLoginTimestamp);
      final now = DateTime.now();
      final difference = now.difference(lastLoginTime);

      // Check if 24 hours (86400 seconds) have passed
      return difference.inHours >= 24;
    } catch (e) {
      debugPrint('Error parsing last login timestamp: $e');
      // If there's an error, allow showing popup
      return true;
    }
  }

  Future<void> _showDailyRewardsPopup() async {
    // Only show the popup once per screen load
    if (_popupShown) return;

    // Small delay to let the screen render first
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Check if 24 hours have passed since last collection
    final canShowPopup = await _can24HoursPassed();

    if (!canShowPopup) {
      debugPrint('Daily XP popup already collected within 24 hours');
      return;
    }

    final accessToken = await SharedPreferencesHelper.getAccessToken();
    final refreshToken = await SharedPreferencesHelper.getRefreshToken();

    if (accessToken != null && refreshToken != null && mounted) {
      _popupShown = true;
      showDialog(
        context: context,
        builder: (BuildContext context) => PopUpDialogue(
          accessToken: accessToken,
          refreshToken: refreshToken,
          onCollectRewards: () {
            // Called on successful XP collection
            debugPrint('Daily rewards collected successfully');
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
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
      ),
    );
  }
}
