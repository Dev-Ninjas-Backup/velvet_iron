import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/settings/controller/setting_controller.dart';

class SettingsAppBar extends StatelessWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final String? profileImageUrl;
  final double size;

  const SettingsAppBar({
    super.key,
    this.onNotificationTap,
    this.onProfileTap,
    this.profileImageUrl,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return SizedBox(
          height: 60,
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        themeController.activeTheme.headerIconBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: size * 0.4,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 6),

              Expanded(
                child: Text(
                  'Settings',
                  style: getTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              GestureDetector(
                onTap: onNotificationTap ?? () {},
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeController.activeTheme.cardBackgroundColor
                        .withValues(alpha: 0.5),
                  ),
                  child: Image.asset(
                    themeController.activeTheme.id == 'adventurer'
                        ? IconPath.quillpenAdenture
                        : themeController.activeTheme.id == 'mage'
                        ? IconPath.quillpenMage
                        : themeController.activeTheme.id == 'gamer'
                        ? IconPath.quillpenGamer
                        : IconPath.quillpenReader,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              GestureDetector(
                onTap: onProfileTap ?? () {},
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: themeController.activeTheme.accentGoldColor,
                      width: 2,
                    ),
                    image: DecorationImage(
                      image: profileImageUrl != null
                          ? NetworkImage(profileImageUrl!)
                          : Image.asset(ImagePath.profile).image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class LogoutWidget extends GetView<SettingsController> {
  const LogoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return InkWell(
          onTap: controller.logout,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: themeController.activeTheme.textfieldColor.withValues(
                alpha: 0.8,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 22,
                  height: 22,
                  child: ShaderMask(
                    shaderCallback: (bounds) => themeController
                        .activeTheme
                        .progressBarGradient
                        .createShader(bounds),
                    child: Image.asset(
                      IconPath.logoutIcon,
                      color: Colors.white,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Log Out',
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: themeController.activeTheme.textColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// app version widget

class AppVersionWidget extends GetView<SettingsController> {
  const AppVersionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Column(
          children: [
            Obx(
              () => Text(
                'App Version + ${controller.appVersion.value}',
                style: getTextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: themeController.activeTheme.textColor,
                ),
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'All Right Reserved by Velvet Tech Training Codex',
              style: getTextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: themeController.activeTheme.textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}
