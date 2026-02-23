import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class GeneralSettingsWidget extends StatelessWidget {
  const GeneralSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'General Settings',
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // My Profile
            _SettingsItem(
              themeController: themeController,
              iconPath: IconPath.myprofile,
              title: 'My Profile',
              onTap: () => Get.toNamed(AppRoute.getprofileScreen()),
            ),
            const SizedBox(height: 12),

            // Daily Macro Goal
            _SettingsItem(
              themeController: themeController,
              iconPath: IconPath.trophyAdventure,
              title: 'Daily Macro Goal',
              onTap: () => Get.toNamed(AppRoute.getdailyGoalScreen()),
            ),
            const SizedBox(height: 12),

            // Themes & Preference
            _SettingsItem(
              themeController: themeController,
              iconPath: IconPath.themes,
              title: 'Themes & Preference',
              onTap: () => Get.toNamed(AppRoute.getthemeScreen()),
            ),
            const SizedBox(height: 12),

            // My Subscriptions
            _SettingsItem(
              themeController: themeController,
              iconPath: ImagePath.diamondAdventurer,
              title: 'My Subscriptions',
              onTap: () => Get.toNamed(AppRoute.mySubscriptionScreen),
            ),
            const SizedBox(height: 12),

            // Feedback & Support
            _SettingsItem(
              themeController: themeController,
              iconPath: IconPath.feedback,
              title: 'Feedback & Support',
              onTap: () => Get.toNamed(AppRoute.getfeedbackScreen()),
            ),
            const SizedBox(height: 12),

            // About Training Codex
            _SettingsItem(
              themeController: themeController,
              iconPath: IconPath.taining,
              title: 'About Training Codex',
              onTap: () => Get.toNamed(AppRoute.getaboutTrainingScreen()),
            ),
          ],
        );
      },
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final AppThemeController themeController;
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.themeController,
    required this.iconPath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeController.activeTheme.cardBackgroundColor.withValues(
            alpha: .5,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ShaderMask(
                  shaderCallback: (bounds) => themeController
                      .activeTheme
                      .progressBarGradient
                      .createShader(bounds),
                  child: Image.asset(
                    iconPath,
                    color: Colors.white,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }
}
