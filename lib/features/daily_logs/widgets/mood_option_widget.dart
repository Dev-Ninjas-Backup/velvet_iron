import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';

class MoodOptionWidget extends StatelessWidget {
  final String icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const MoodOptionWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            height: 80,
            padding: const EdgeInsets.fromLTRB(7, 7, 7, 11),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors:
                          (themeController
                                  .activeTheme
                                  .selectedColors
                                  .isNotEmpty &&
                              themeController
                                      .activeTheme
                                      .selectedColors
                                      .length >
                                  1)
                          ? [
                              themeController.activeTheme.selectedColors[0],
                              themeController.activeTheme.selectedColors[1],
                            ]
                          : (themeController
                                .activeTheme
                                .selectedColors
                                .isNotEmpty)
                          ? [themeController.activeTheme.selectedColors[0]]
                          : [Colors.white],
                    )
                  : null,
              color: isSelected
                  ? null
                  : themeController.activeTheme.dropdownBackgroundColor,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: isSelected
                    ? themeController.activeTheme.accentGoldColor
                    : Colors.transparent,
                width: 0.6,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(icon, width: 22, height: 24),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: getTextStyle(
                    fontSize: 11,
                    color:
                        (isSelected &&
                            themeController.activeTheme.id == 'reader')
                        ? const Color(0xFF141694)
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
