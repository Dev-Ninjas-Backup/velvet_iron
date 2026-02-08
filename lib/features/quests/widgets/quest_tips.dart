import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            color: themeController.activeTheme.cardBackgroundColor,
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
                width: 311,
                height: 16,
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
              // const SizedBox(height: 16),
              // _buildTipRow(
              //   "Quests reset daily at midnight, so check back tomorrow for new challenges",
              // ),
              // const SizedBox(height: 16),
              // _buildTipRow(
              //   "Building a streak helps establish healthy habits and keeps you motivated",
              // ),
              // const SizedBox(height: 16),
              // _buildTipRow(
              //   "Use the tracking features in other tabs to complete your quests",
              // ),
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
