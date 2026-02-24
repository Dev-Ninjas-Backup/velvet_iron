import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/settings/services/logout_service.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class SettingsController extends GetxController {
  final userName = 'Unbound'.obs;
  final userLevel = 1.obs;
  final currentXP = 220.obs;
  final maxXP = 500.obs;

  final upcomingLog = 'Breakfast'.obs;
  final upcomingLogXP = 10.obs;
  final upcomingLogTime = 'Wed - 8:30 AM'.obs;

  final appVersion = 'v1.0'.obs;

  String get progressText => 'Progress to level ${userLevel.value + 1}';
  String get xpText => '${currentXP.value}/${maxXP.value} XP';
  double get progressPercentage => currentXP.value / maxXP.value;

  void navigateToProfile() {
    Get.toNamed('/profileScreen');
  }

  void navigateToDailyMacroGoal() {
    Get.toNamed('/dailyMacroGoal');
  }

  void navigateToThemes() {
    Get.toNamed('/themes');
  }

  void navigateToFeedback() {
    Get.toNamed('/feedback');
  }

  void navigateToAbout() {
    Get.toNamed('/about');
  }

  void logout() {
    final themeController = Get.find<AppThemeController>();
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            gradient: themeController.activeTheme.backgroundGradient,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: themeController.activeTheme.accentGoldColor.withValues(
                alpha: 0.3,
              ),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => LinearGradient(
                  colors:
                      themeController.activeTheme.progressBarGradient.colors,
                ).createShader(bounds),
                child: Text(
                  'Logout',
                  style: getTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Content
              Text(
                'Are you sure you want to logout?',
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: themeController
                              .activeTheme
                              .dropdownBackgroundColor
                              .withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: themeController.activeTheme.accentGoldColor
                                .withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: getTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        Get.back();
                        EasyLoading.show(status: 'Leaving the Codex...');

                        final settingsService = SettingsService();
                        final result = await settingsService.logout();

                        await Future.delayed(
                          const Duration(milliseconds: 1200),
                        );
                        EasyLoading.dismiss();

                        if (result.isSuccess) {
                          Get.offAllNamed(AppRoute.getLoginScreen());
                        }
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          gradient:
                              themeController.activeTheme.progressBarGradient,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: themeController.activeTheme.accentGoldColor
                                  .withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Logout',
                            style: getTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> skipUpcomingLog() async {
    EasyLoading.show(status: 'Skipping log...');

    await Future.delayed(const Duration(milliseconds: 800));

    EasyLoading.showSuccess('Log skipped successfully');
  }
}
