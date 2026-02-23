import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';

class WeightStatusCard extends StatelessWidget {
  final String iconPath;
  final String weightValue;
  final String label;

  const WeightStatusCard({
    super.key,
    required this.iconPath,
    required this.weightValue,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Container(
          // width: 109,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: themeController.activeTheme.cardBackgroundColor.withValues(
              alpha: 0.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                iconPath == 'steelyard'
                    ? (themeController.activeTheme.id == 'adventurer'
                          ? 'assets/icons/steelyard_adventure.png'
                          : themeController.activeTheme.id == 'mage'
                          ? 'assets/icons/steelyard_mage.png'
                          : themeController.activeTheme.id == 'gamer'
                          ? 'assets/icons/steelyard_gamer.png'
                          : 'assets/icons/steelyard_reader.png')
                    : iconPath == 'updown'
                    ? (themeController.activeTheme.id == 'adventurer'
                          ? 'assets/icons/updown_adventure.png'
                          : themeController.activeTheme.id == 'mage'
                          ? 'assets/icons/updown_mage.png'
                          : themeController.activeTheme.id == 'gamer'
                          ? 'assets/icons/updown_gamer.png'
                          : 'assets/icons/updown_reader.png')
                    : iconPath == 'clock'
                    ? (themeController.activeTheme.id == 'adventurer'
                          ? 'assets/icons/clock_adventure.png'
                          : themeController.activeTheme.id == 'mage'
                          ? 'assets/icons/clock_mage.png'
                          : themeController.activeTheme.id == 'gamer'
                          ? 'assets/icons/clock_gamer.png'
                          : 'assets/icons/clock_reader.png')
                    : iconPath,
                width: 32,
                height: 32,
              ),
              const SizedBox(height: 8),
              Text(
                weightValue,
                style: getTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: getTextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
