import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_small_button.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';

class QuestTips extends StatelessWidget {
  const QuestTips({super.key});

  TextStyle getTextStyle({
    double size = 14,
    FontWeight weight = FontWeight.normal,
    Color color = Colors.white,
  }) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: weight,
      fontFamily: 'Serif',
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: themeController.activeTheme.cardBackgroundColor.withValues(
              alpha: 0.8,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                IconPath
                    .moon, // This is your string variable containing the path
                width: 40,
                height: 41,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 18),
              SizedBox(
                child: Text(
                  "Quest Tips",
                  style: getTextStyle(size: 16, weight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              _buildTipRow(
                "Complete all daily quests to maintain your streak and earn bonus XP",
                themeController,
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  CustomSmallButton(
                    width: 108,
                    text: "Read Article",
                    onPressed: () {},
                    gradient: themeController.activeTheme.progressBarGradient,
                    fontColor: Colors.white,
                  ),
                  const Spacer(),
                  Text(
                    "Earn: +30 XP",
                    style: getTextStyle(size: 10, weight: FontWeight.bold),
                  ),
                  const SizedBox(width: 5),
                  Image.asset(
                    themeController.activeTheme.id == 'adventurer'
                        ? IconPath.starAdventure
                        : themeController.activeTheme.id == 'mage'
                        ? IconPath.starMage
                        : themeController.activeTheme.id == 'gamer'
                        ? IconPath.starGamer
                        : IconPath.starReader,
                    width: 14,
                    height: 14,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTipRow(String tip, AppThemeController themeController) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 7,
          height: 14,
          decoration: BoxDecoration(
            color: themeController.activeTheme.accentGoldColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(tip, style: getTextStyle(size: 14))),
      ],
    );
  }
}
