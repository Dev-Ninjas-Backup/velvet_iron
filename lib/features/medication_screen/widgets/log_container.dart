import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';

class CustomLogContainer extends StatelessWidget {
  final String iconPath;
  final String title;
  final String value;
  final String rewardAmount;
  final VoidCallback? onIconTap;

  const CustomLogContainer({
    super.key,
    required this.iconPath,
    required this.title,
    required this.value,
    required this.rewardAmount,
    this.onIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: themeController.activeTheme.cardBackgroundColor.withValues(
              alpha: 0.6,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Row
              Row(
                children: [
                  // Medication Icon
                  onIconTap != null
                      ? MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              debugPrint('[CustomLogContainer] Icon tapped!');
                              onIconTap!();
                            },
                            child: Opacity(
                              opacity: 0.8,
                              child: Image.asset(
                                iconPath,
                                width: 36,
                                height: 36,
                              ),
                            ),
                          ),
                        )
                      : Image.asset(iconPath, width: 36, height: 36),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: getTextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          value,
                          style: getTextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// Bottom Row
              Row(
                children: [
                  Text(
                    "Total Rewards:",
                    style: getTextStyle(
                      fontSize: 10,
                      color: themeController.activeTheme.textColor,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    "$rewardAmount XP",
                    style: getTextStyle(
                      color: themeController.activeTheme.textColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
