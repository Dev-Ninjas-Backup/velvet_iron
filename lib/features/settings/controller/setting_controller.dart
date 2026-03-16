// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/settings/services/logout_service.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class SettingsController extends GetxController {
  final _profileService = UserProfileService();

  final userName = ''.obs;
  final nextLevel = 2.obs;
  final levelStatus = ''.obs;
  final xpRequired = 0.obs;
  final totalEarnXp = 0.obs;
  final currentXP = 0.obs;

  final upcomingLog = 'Breakfast'.obs;
  final upcomingLogXP = 10.obs;
  final upcomingLogTime = 'Wed - 8:30 AM'.obs;
  final upcomingLogDescription = ''.obs;
  final upcomingScheduleId = ''.obs;
  final appVersion = 'v1.0'.obs;
  final isLoadingProfile = false.obs;
  final isSkippingLog = false.obs;

  // Active companion image
  final activeCompanionImage = Rx<String?>(null);
  final activeCompanionName = Rx<String?>(null);

  // Progress bar uses totalEarnXp / xpRequired
  String get progressText => 'Progress to level ${nextLevel.value}';
  String get xpText => '${totalEarnXp.value}/${xpRequired.value} XP';
  double get progressPercentage =>
      xpRequired.value > 0 ? totalEarnXp.value / xpRequired.value : 0.0;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
    fetchActiveCompanion();
  }

  Future<void> fetchUserProfile() async {
    isLoadingProfile.value = true;
    final result = await _profileService.fetchProfile();
    isLoadingProfile.value = false;

    if (result.isSuccess && result.data != null) {
      final p = result.data!;
      userName.value = p.userName;
      nextLevel.value = p.nextLevel.level;
      levelStatus.value = p.levelStatus;
      xpRequired.value = p.nextLevel.xpRequired;
      totalEarnXp.value = p.totalEarnXp;
      currentXP.value = p.balanceXp;

      // Update upcoming log if available
      print('[SettingsController] upcoming object: ${p.upcoming}');
      print('[SettingsController] upcoming type: ${p.upcoming.runtimeType}');

      try {
        if (p.upcoming != null) {
          Map<String, dynamic>? upcomingData;

          // Handle different possible types
          if (p.upcoming is Map<String, dynamic>) {
            upcomingData = p.upcoming as Map<String, dynamic>;
          } else if (p.upcoming is Map) {
            upcomingData = Map<String, dynamic>.from(p.upcoming as Map);
          }

          if (upcomingData != null) {
            upcomingLog.value = upcomingData['title'] ?? 'Upcoming';
            upcomingLogXP.value = (upcomingData['earnedXp'] ?? 10) as int;
            upcomingLogDescription.value =
                (upcomingData['description'] ?? '') as String;
            final scheduledAt =
                (upcomingData['scheduledAt'] ?? 'N/A') as String;
            upcomingLogTime.value = _formatDateTime(scheduledAt);
            upcomingScheduleId.value = upcomingData['id'] ?? '';
            print('[SettingsController] ✅ Upcoming log loaded successfully');
            print('[SettingsController] Title: ${upcomingLog.value}');
            print(
              '[SettingsController] Description: ${upcomingLogDescription.value}',
            );
            print('[SettingsController] Time: ${upcomingLogTime.value}');
            print('[SettingsController] XP: ${upcomingLogXP.value}');
            print('[SettingsController] ID: ${upcomingScheduleId.value}');
          } else {
            print('[SettingsController] ⚠️ Could not convert upcoming to Map');
          }
        } else {
          print('[SettingsController] ⚠️ upcoming is null');
        }
      } catch (e) {
        print('[SettingsController] ❌ Error parsing upcoming: $e');
      }
    }
  }

  /// Fetch active companion from API
  Future<void> fetchActiveCompanion() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();

      if (token == null ||
          token.isEmpty ||
          refreshToken == null ||
          refreshToken.isEmpty) {
        print('ERROR: Token or Refresh Token is null or empty!');
        return;
      }

      final response = await http.get(
        Uri.parse(Urls.getCompanions),
        headers: {
          'Authorization': 'Bearer $token',
          'x-refresh-token': refreshToken,
          'Content-Type': 'application/json',
        },
      );

      print('COMPANIONS Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final List companions = data['companions'] ?? [];

        // Find the active companion
        for (var companion in companions) {
          if (companion['isAcitve'] == true) {
            final name = companion['name'] ?? '';
            final imagePath = _getCompanionImagePath(name);
            activeCompanionImage.value = imagePath;
            activeCompanionName.value = name;
            print('Active Companion: $name -> $imagePath');
            break;
          }
        }
      } else {
        print('ERROR: Failed to fetch companions. ${response.body}');
      }
    } catch (e) {
      print('EXCEPTION: $e');
    }
  }

  static String _formatDateTime(String isoString) {
    try {
      final dt = DateTime.parse(isoString);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      // Use UTC directly from the API, don't convert to local
      final day = days[dt.weekday - 1];
      final month = months[dt.month - 1];
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      return "${dt.day} $month, $day - $hour:$minute $period";
    } catch (e) {
      return isoString;
    }
  }

  /// Map companion name to image path
  static String _getCompanionImagePath(String name) {
    switch (name) {
      case 'Ser Kael Thornwatch':
        return ImagePath.serKael;
      case 'Riven Ashcroft':
        return ImagePath.rvenAshcroft;
      case 'Pyraxis':
        return ImagePath.pyraxis;
      case 'Bram Ironledger':
        return ImagePath.bramIronledger;
      default:
        return ImagePath.serKael;
    }
  }

  void navigateToProfile() => Get.toNamed('/profileScreen');
  void navigateToDailyMacroGoal() => Get.toNamed('/dailyMacroGoal');
  void navigateToThemes() => Get.toNamed('/themes');
  void navigateToFeedback() => Get.toNamed('/feedback');
  void navigateToAbout() => Get.toNamed('/about');

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
    if (upcomingScheduleId.value.isEmpty) {
      EasyLoading.showError('No upcoming schedule to skip');
      return;
    }

    try {
      isSkippingLog.value = true;
      EasyLoading.show(status: 'Skipping log...');

      final token = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();

      if (token == null || refreshToken == null) {
        EasyLoading.showError('Authentication tokens not found');
        isSkippingLog.value = false;
        return;
      }

      final response = await http.delete(
        Uri.parse(Urls.removeMealSchedule(upcomingScheduleId.value)),
        headers: {
          'Authorization': 'Bearer $token',
          'x-refresh-token': refreshToken,
          'Content-Type': 'application/json',
        },
      );

      print(
        '[SettingsController] Skip meal schedule status: ${response.statusCode}',
      );
      print('[SettingsController] Skip meal schedule body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        EasyLoading.dismiss();
        await Future.delayed(const Duration(milliseconds: 500));
        EasyLoading.showSuccess('Schedule skipped successfully');

        // Refresh profile data to get the next upcoming schedule
        await Future.delayed(const Duration(milliseconds: 800));
        await fetchUserProfile();
      } else {
        EasyLoading.showError(
          'Failed to skip schedule: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('[SettingsController] ❌ Error skipping log: $e');
      EasyLoading.showError('Error: ${e.toString()}');
    } finally {
      isSkippingLog.value = false;
    }
  }
}
