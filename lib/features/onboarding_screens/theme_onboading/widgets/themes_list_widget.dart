import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/theme_onboading/controller/theme_onboarding_controller.dart';
import 'package:velvet_iron/features/themes_and_preference/widgets/themes.dart';

class ThemesListWidget extends StatelessWidget {
  const ThemesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<AppThemeController>();
    final onboardingController = Get.find<ThemeOnboardingController>();

    return Expanded(
      child: GetBuilder<AppThemeController>(
        builder: (_) => Obx(() {
          if (onboardingController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (onboardingController.themesList.isEmpty) {
            return const Center(child: Text('No themes available'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: themeController.themes.length,
            itemBuilder: (context, index) {
              final theme = themeController.themes[index];
              final isSelected = themeController.isThemeSelected(index);
              final isOnboardingSelected =
                  onboardingController.selectedThemeIndex.value == index;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Themes(
                  title: theme.name,
                  badgeText: isSelected ? 'Active Now' : '',
                  gradientColors: _getThemeGradient(theme.id),
                  icon: isOnboardingSelected
                      ? const Icon(
                          Icons.radio_button_checked,
                          color: Colors.white,
                          size: 20,
                        )
                      : const Icon(
                          Icons.radio_button_unchecked,
                          color: Colors.white,
                          size: 20,
                        ),
                  borderColor: isOnboardingSelected
                      ? Colors.white
                      : Colors.white.withValues(alpha: .3),
                  isSelected: isSelected,
                  onTap: () {
                    themeController.selectTheme(index);
                    onboardingController.selectTheme(index);
                  },
                ),
              );
            },
          );
        }),
      ),
    );
  }

  static List<Color> _getThemeGradient(String themeId) {
    switch (themeId) {
      case 'mage':
        return const [
          Color(0xFF1B0033),
          Color(0xFF35065E),
          Color(0xFF1B0033),
          Color(0xFF35065E),
          Color(0xFF1B0033),
          Color(0xFFBE32FF),
        ];
      case 'reader':
        return const [
          Color(0xFF00027B),
          Color(0xFF292CB7),
          Color(0xFF00027B),
          Color(0xFF00013F),
          Color(0xFF3385FF),
        ];
      case 'gamer':
        return const [
          Color(0xFF111C18),
          Color(0xFF1E332C),
          Color(0xFF111C18),
          Color(0xFF1E332C),
          Color(0xFF111C18),
          Color(0xFF008353),
        ];
      default:
        return const [
          Color(0xFF310101),
          Color(0xFF550606),
          Color(0xFF310101),
          Color(0xFF550606),
          Color(0xFF310101),
          Color(0xFF683E23),
          Color(0xFF9E6D38),
        ];
    }
  }
}
