import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/features/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:velvet_iron/features/home/controller/home_controller.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/home/widgets/mood_selector.dart';
import 'package:velvet_iron/features/home/widgets/todo_list.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/core/services/companion_dialogue_engine.dart';
import 'package:velvet_iron/features/home/widgets/popup_dialogue.dart';
import 'package:velvet_iron/features/home/widgets/companion_full_body_dialogue.dart';
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
                    opacity: 0.40,
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

class _HomeScreenContentState extends State<HomeScreenContent>
    with WidgetsBindingObserver {
  bool _popupShown = false;
  DateTime? _lastGreetingTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _showDailyRewardsPopup();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final now = DateTime.now();
      if (_lastGreetingTime == null ||
          now.difference(_lastGreetingTime!).inMinutes >= 5) {
        _lastGreetingTime = now;
        CompanionDialogueEngine.showDialogueSnackbar(
          trigger: 'App Open / Welcome Back',
        );
      }
    }
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

    // Delay to let screen transition fully finish
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    final isShownToday =
        await SharedPreferencesHelper.isFullBodyGreetingShownToday();
    final canCollectXp = await _can24HoursPassed();
    final homeController =
        Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;
    final compNameVal = homeController?.activeCompanionName.value;
    final String activeCompanion = (compNameVal != null && compNameVal.isNotEmpty)
        ? compNameVal
        : 'Thyra';

    final accessToken = await SharedPreferencesHelper.getAccessToken() ?? '';
    final refreshToken = await SharedPreferencesHelper.getRefreshToken() ?? '';

    if (!isShownToday) {
      _popupShown = true;
      _lastGreetingTime = DateTime.now();

      // Retrieve dynamic daily open quote
      final quote = await CompanionDialogueEngine().getDialogue(
        trigger: 'App Open / Welcome Back',
        companionName: activeCompanion,
      );

      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CompanionFullBodyDialogue(
          companionName: activeCompanion,
          contextMoment: 'daily_greeting',
          quote: quote,
          xpReward: canCollectXp ? 25 : 0,
          accessToken: accessToken.isNotEmpty ? accessToken : null,
          refreshToken: refreshToken.isNotEmpty ? refreshToken : null,
          onClaim: () {
            debugPrint('Daily full-body greeting completed');
          },
        ),
      );
    } else if (canCollectXp && accessToken.isNotEmpty && refreshToken.isNotEmpty) {
      if (!mounted) return;
      // If already greeted with full body today, but 24h XP cooldown reset, show standard collect dialog
      _popupShown = true;
      _lastGreetingTime = DateTime.now();
      showDialog(
        context: context,
        builder: (BuildContext context) => Obx(
          () => PopUpDialogue(
            accessToken: accessToken,
            refreshToken: refreshToken,
            selectedCompanionName: activeCompanion,
            selectedCompanionImage: homeController?.activeCompanionImage.value,
            quote: homeController?.dailyRewardQuote.value,
            onCollectRewards: () {
              debugPrint('Daily rewards collected successfully');
            },
          ),
        ),
      );
    } else {
      // Return to app later in the day: show smaller portrait dialogue banner as requested
      _popupShown = true;
      _lastGreetingTime = DateTime.now();
      CompanionDialogueEngine.showDialogueSnackbar(
        trigger: 'App Open / Welcome Back',
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
