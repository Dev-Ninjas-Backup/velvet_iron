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
  final VoidCallback onSkipTap;

  const _UpcomingLogHeader({
    required this.themeController,
    required this.onSkipTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
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
            onTap: onSkipTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: themeController.activeTheme.textfieldColor.withValues(
                  alpha: 0.6,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: themeController.activeTheme.borderColor,
                  width: 1,
                ),
              ),
              child: Text(
                'skip',
                style: getTextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
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
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Center(child: Image.asset(IconPath.todo, height: 25, width: 25)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    controller.upcomingLog.value,
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '350 kCal',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: themeController.activeTheme.textColor,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Obx(
                    () => Text(
                      '+${controller.upcomingLogXP.value} XP',
                      style: getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Image.asset(
                    themeController.activeTheme.id == 'adventurer'
                        ? IconPath.starAdventure
                        : themeController.activeTheme.id == 'mage'
                        ? IconPath.starMage
                        : themeController.activeTheme.id == 'gamer'
                        ? IconPath.starGamer
                        : IconPath.starReader,
                    height: 12,
                    width: 12,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Obx(
                () => Text(
                  controller.upcomingLogTime.value,
                  style: getTextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: themeController.activeTheme.textColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
