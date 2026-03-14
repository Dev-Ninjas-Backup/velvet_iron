import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';

class ExcersiseHistory extends StatelessWidget {
  final String title, sub, time;
  final String iconPath;
  final RxBool isSelected;

  const ExcersiseHistory({
    super.key,
    required this.title,
    required this.sub,
    required this.time,
    required this.iconPath,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Obx(
          () => Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: themeController.activeTheme.textfieldColor.withValues(
                alpha: isSelected.value ? 0.8 : 0.4,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Image.asset(
                  themeController.activeTheme.id == 'adventurer'
                      ? IconPath.doticonAdventure
                      : themeController.activeTheme.id == 'mage'
                      ? IconPath.doticonMage
                      : themeController.activeTheme.id == 'gamer'
                      ? IconPath.doticonGamer
                      : IconPath.doticonReader,
                  width: 22,
                  height: 22,
                ),

                const SizedBox(width: 8),

                Image.asset(
                  iconPath,
                  width: 24,
                  height: 24,
                  color: Colors.white,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.image_not_supported,
                    color: Colors.white,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: getTextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        sub,
                        style: getTextStyle(
                          color: themeController.activeTheme.textColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          themeController.activeTheme.id == 'adventurer'
                              ? IconPath.starAdventure
                              : themeController.activeTheme.id == 'mage'
                              ? IconPath.starMage
                              : themeController.activeTheme.id == 'gamer'
                              ? IconPath.starGamer
                              : IconPath.starReader,
                          width: 16,
                          height: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "+10 XP",
                          style: getTextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: getTextStyle(
                        color: themeController.activeTheme.textColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
