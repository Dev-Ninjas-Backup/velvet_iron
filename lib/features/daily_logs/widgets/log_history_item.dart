import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';

class LogHistoryItem extends StatelessWidget {
  final String title;
  final String xpText;
  final String iconPath;
  final String secondText;
  final String thirdText;

  final String dateTimeText;

  const LogHistoryItem({
    super.key,
    required this.title,
    required this.xpText,
    required this.iconPath,
    required this.secondText,
    this.thirdText = '',
    this.dateTimeText = '',
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: themeController.activeTheme.cardBackgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(iconPath, width: 25, height: 30),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(title, style: getTextStyle(fontSize: 14)),
                  ),
                  Row(
                    children: [
                      Text(
                        xpText,
                        style: getTextStyle(fontSize: 12, color: Colors.white),
                      ),
                      const SizedBox(width: 4),
                      Image.asset(IconPath.star, width: 12, height: 12),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Row(
                children: [
                  Text(
                    secondText,
                    style: getTextStyle(
                      fontSize: 12,
                      color: themeController.activeTheme.accentGoldColor,
                    ),
                  ),
                  if (dateTimeText.isNotEmpty) ...[
                    const Spacer(),
                    Text(dateTimeText, style: getTextStyle(fontSize: 12)),
                  ],
                ],
              ),

              if (thirdText.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  thirdText,
                  style: getTextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
