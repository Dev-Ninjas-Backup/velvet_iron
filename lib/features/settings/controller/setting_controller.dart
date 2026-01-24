import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
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
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(30, 0, 0, 1),
                Color.fromRGBO(104, 11, 11, 0.5),
                Color.fromRGBO(30, 0, 0, 1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Color(0xFFD4AF7A).withValues(alpha: 0.3),
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
                  colors: [
                    Color(0xFFFDE7BB),
                    Color(0xFF9E6D38),
                    Color(0xFFE9B86E),
                  ],
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
              SizedBox(height: 16),

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
              SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(53, 4, 4, 0.9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFFD4AF7A).withValues(alpha: 0.3),
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
                  SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        Get.toNamed(AppRoute.getLoginScreen());
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFFDE7BB),
                              Color(0xFF9E6D38),
                              Color(0xFFE9B86E),
                              Color(0xFFE5B46B),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFD4AF7A).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Logout',
                            style: getTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E0000),
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

  void skipUpcomingLog() {
    Get.snackbar('Skipped', 'Log skipped successfully');
  }
}
