import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/settings/controller/setting_controller.dart';
import 'package:get/get.dart';

class UpcomingLogWidget extends StatelessWidget {
  const UpcomingLogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: themeController.activeTheme.textfieldColor.withValues(
              alpha: 0.6,
            ),
          ),
          child: Column(
            children: [
              _UpcomingLogHeader(
                themeController: themeController,
                controller: controller,
                onSkipTap: controller.skipUpcomingLog,
              ),
              _DividerLine(themeController: themeController),
              _UpcomingLogContent(
                themeController: themeController,
                controller: controller,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _UpcomingLogHeader extends StatelessWidget {
  final AppThemeController themeController;
  final SettingsController controller;
  final VoidCallback onSkipTap;

  const _UpcomingLogHeader({
    required this.themeController,
    required this.controller,
    required this.onSkipTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Up-coming Log:',
              style: getTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: controller.isSkippingLog.value ? null : onSkipTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: controller.isSkippingLog.value
                      ? themeController.activeTheme.textfieldColor.withValues(
                          alpha: 0.3,
                        )
                      : themeController.activeTheme.textfieldColor.withValues(
                          alpha: 0.6,
                        ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: themeController.activeTheme.borderColor,
                    width: 1,
                  ),
                ),
                child: Text(
                  controller.isSkippingLog.value ? 'Skipping...' : 'skip',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: controller.isSkippingLog.value
                        ? Colors.white54
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  final AppThemeController themeController;

  const _DividerLine({required this.themeController});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            themeController.activeTheme.todoSubtitleColor.withValues(
              alpha: 0.6,
            ),
            themeController.activeTheme.todoSubtitleColor.withValues(
              alpha: 0.6,
            ),
            themeController.activeTheme.todoSubtitleColor.withValues(
              alpha: 0.6,
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingLogContent extends StatelessWidget {
  final AppThemeController themeController;
  final SettingsController controller;

  const _UpcomingLogContent({
    required this.themeController,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Obx(
        () {
          final themeId = themeController.activeTheme.id;
          final starIcon = themeId == 'adventurer'
              ? IconPath.starAdventure
              : themeId == 'mage'
              ? IconPath.starMage
              : themeId == 'gamer'
              ? IconPath.starGamer
              : IconPath.starReader;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: Image.asset(IconPath.todo, height: 24, width: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.upcomingLog.value,
                      style: getTextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      controller.upcomingLogDescription.value.isNotEmpty
                          ? controller.upcomingLogDescription.value
                          : '350 kCal',
                      style: getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: themeController.activeTheme.textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '+${controller.upcomingLogXP.value} XP',
                        style: getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Image.asset(
                        starIcon,
                        height: 12,
                        width: 12,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    controller.upcomingLogTime.value,
                    style: getTextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: themeController.activeTheme.textColor,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
