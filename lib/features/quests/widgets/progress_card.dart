import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';

class ProgressCard extends StatelessWidget {
  final String iconPath;
  final String header;
  final String points;

  const ProgressCard({
    super.key,
    required this.iconPath,
    required this.header,
    required this.points,
  });

  TextStyle getTextStyle({
    double size = 14,
    FontWeight weight = FontWeight.normal,
  }) {
    return TextStyle(color: Colors.white, fontSize: size);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        // Theme-specific steelyard and trophy icons
        String steelyardIcon = themeController.activeTheme.id == 'adventurer'
            ? IconPath.steelyardAdenture
            : themeController.activeTheme.id == 'mage'
            ? IconPath.steelyardMage
            : themeController.activeTheme.id == 'gamer'
            ? IconPath.steelyardGamer
            : IconPath.steelyardReader;
        String trophyIcon = themeController.activeTheme.id == 'adventurer'
            ? IconPath.trophyAdventure
            : themeController.activeTheme.id == 'mage'
            ? IconPath.trophyMage
            : themeController.activeTheme.id == 'gamer'
            ? IconPath.trophyGamer
            : IconPath.trophyReader;

        return Container(
          constraints: const BoxConstraints(minHeight: 58),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: themeController.activeTheme.cardBackgroundColor.withValues(
              alpha: .4,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              iconPath == 'steelyard'
                  ? Image.asset(
                      steelyardIcon,
                      width: 36,
                      height: 36,
                      fit: BoxFit.contain,
                    )
                  : iconPath == 'trophy'
                  ? Image.asset(
                      trophyIcon,
                      width: 36,
                      height: 36,
                      fit: BoxFit.contain,
                    )
                  : Image.asset(
                      iconPath,
                      width: 36,
                      height: 36,
                      fit: BoxFit.contain,
                    ),
              const SizedBox(width: 8), 
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      header,
                      style: getTextStyle(size: 14, weight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      points,
                      style: getTextStyle(size: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
