import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/settings/controller/setting_controller.dart';
import 'package:get/get.dart';

class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _ProfileAvatar(themeController: themeController),
              const SizedBox(width: 16),
              Expanded(
                child: _ProfileDetails(
                  themeController: themeController,
                  controller: controller,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final AppThemeController themeController;

  const _ProfileAvatar({required this.themeController});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: themeController.activeTheme.progressBarGradient.withOpacity(
          0.7,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF2A0F0F),
          ),
          child: ClipOval(
            child: Image.asset(
              IconPath.serkelProfile,
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileDetails extends StatelessWidget {
  final AppThemeController themeController;
  final SettingsController controller;

  const _ProfileDetails({
    required this.themeController,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ProfileHeader(
          themeController: themeController,
          controller: controller,
        ),
        const SizedBox(height: 9),
        _ProgressBar(themeController: themeController, controller: controller),
        const SizedBox(height: 8),
        _ProgressInfo(controller: controller),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final AppThemeController themeController;
  final SettingsController controller;

  const _ProfileHeader({
    required this.themeController,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(
          () => Text(
            controller.userName.value,
            style: getTextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        _LevelBadge(themeController: themeController, controller: controller),
      ],
    );
  }
}

class _LevelBadge extends StatelessWidget {
  final AppThemeController themeController;
  final SettingsController controller;

  const _LevelBadge({required this.themeController, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: themeController.activeTheme.cardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(IconPath.trophy, height: 14, width: 8),
          const SizedBox(width: 4),
          Obx(
            () => Text(
              'Level ${controller.userLevel.value}',
              style: getTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final AppThemeController themeController;
  final SettingsController controller;

  const _ProgressBar({required this.themeController, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: themeController.activeTheme.todoSubtitleColor.withValues(
                  alpha: 0.3,
                ),
              ),
            ),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: controller.progressPercentage,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  gradient: themeController.activeTheme.progressBarGradient,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressInfo extends StatelessWidget {
  final SettingsController controller;

  const _ProgressInfo({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () => Text(
              controller.progressText,
              style: getTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color(0xFFB8B8B8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Obx(
          () => Text(
            controller.xpText,
            style: getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
