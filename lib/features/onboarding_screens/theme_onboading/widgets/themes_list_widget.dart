import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/theme_onboading/widgets/select_theme.dart';

class ThemesListWidget extends StatelessWidget {
  const ThemesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<AppThemeController>();

    return Expanded(
      child: GetBuilder<AppThemeController>(
        builder: (_) => ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: themeController.themes.length,
          itemBuilder: (context, index) {
            final theme = themeController.themes[index];
            final isSelected = themeController.isThemeSelected(index);

            // Theme-specific subtitles/taglines
            String getThemeTagline(int index) {
              switch (index) {
                case 0:
                  return 'Discipline is the blade — sharpen it daily.';
                case 1:
                  return 'Knowledge is power.';
                case 2:
                  return 'Magic flows through your veins.';
                case 3:
                  return 'Level up and conquer.';
                default:
                  return theme.name;
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SelectTheme(
                title: theme.name,
                badgeText: 'Unlock',
                subtitle: getThemeTagline(index),
                gradientColors: theme.backgroundGradient.colors,
                icon: Image.asset(IconPath.goldencircle, width: 18, height: 18),
                isSelected: isSelected,
                borderColor: isSelected
                    ? theme.accentGoldColor
                    : Colors.white.withValues(alpha: .3),
                onTap: () {
                  themeController.selectTheme(index);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
