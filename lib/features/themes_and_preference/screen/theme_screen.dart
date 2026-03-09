import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/profile/controller/profile_controller.dart';
import 'package:velvet_iron/features/themes_and_preference/controller/themes_controller.dart';
import 'package:velvet_iron/features/themes_and_preference/widgets/select_companion.dart';
import 'package:velvet_iron/features/themes_and_preference/widgets/themes.dart';
import 'package:velvet_iron/features/themes_and_preference/widgets/themes_preference_widgets.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themesController = Get.put(ThemesController());
    Get.put(ProfileController());

    return Scaffold(
      body: GetBuilder<AppThemeController>(
        builder: (themeController) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: themeController.activeTheme.backgroundGradient,
                ),
              ),
              Opacity(
                opacity: 0.2,
                child: Image.asset(
                  themeController.activeTheme.backgroundImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              SafeArea(
                child: Stack(
                  children: [
                    NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                            return <Widget>[
                              SliverAppBar(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                floating: true,
                                snap: true,
                                automaticallyImplyLeading: false,
                                titleSpacing: 16,
                                title: const ThemesPreferenceAppBar(),
                              ),
                            ];
                          },
                      body: SingleChildScrollView(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 20,
                          bottom: 120,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select Themes',
                              style: getTextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Your theme shapes the world around you, setting the mood and visual style of your journey.',
                              style: getTextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Obx(
                              () => Column(
                                children: List.generate(
                                  themesController.themes.length,
                                  (index) {
                                    final theme =
                                        themesController.themes[index];
                                    final isActive =
                                        themesController
                                            .selectedThemeIndex
                                            .value ==
                                        index;
                                    final isUnlocked = !theme.locked;

                                    return Column(
                                      children: [
                                        Themes(
                                          title: theme.title,
                                          badgeText: isActive
                                              ? 'Active Now'
                                              : theme.badgeText,
                                          subtitle: isActive
                                              ? '"Discipline is the blade — sharpen it daily."'
                                              : null,
                                          gradientColors: _getThemeGradient(
                                            theme.id,
                                          ),
                                          icon: isActive
                                              ? Image.asset(
                                                  IconPath.goldencircle,
                                                )
                                              : isUnlocked
                                              ? Image.asset(
                                                  IconPath.goldencircle,
                                                )
                                              : Image.asset(IconPath.lock),
                                          onTap: isActive
                                              ? null
                                              : isUnlocked
                                              ? () => themesController
                                                    .activateThemeAtIndex(index)
                                              : () => themesController
                                                    .unlockThemeAtIndex(index),
                                        ),
                                        if (index <
                                            themesController.themes.length - 1)
                                          const SizedBox(height: 12),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              'Select Companion',
                              style: getTextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Your companion is your chosen ally, guiding and encouraging you as you forge stronger habits.',
                              style: getTextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Obx(
                              () => Column(
                                children: List.generate(
                                  themesController.companions.length,
                                  (index) {
                                    final companion =
                                        themesController.companions[index];
                                    final isActive =
                                        themesController
                                            .selectedCompanionIndex
                                            .value ==
                                        index;
                                    final isUnlocked = !companion.locked;

                                    return Column(
                                      children: [
                                        SelectCompanion(
                                          leadingIcon: Image.asset(
                                            isActive || isUnlocked
                                                ? 'assets/icons/goldencircle.png'
                                                : 'assets/icons/lock.png',
                                            fit: BoxFit.contain,
                                          ),
                                          avatar: Image.asset(
                                            companion.avatarPath,
                                            fit: BoxFit.cover,
                                          ),
                                          name: companion.name,
                                          badgeText: isActive
                                              ? 'Active'
                                              : isUnlocked
                                              ? 'Activate'
                                              : 'Unlock 250 xp',
                                          onTap: isActive
                                              ? null
                                              : isUnlocked
                                              ? () => themesController
                                                    .activateCompanionAtIndex(
                                                      index,
                                                    )
                                              : () => themesController
                                                    .unlockCompanionAtIndex(
                                                      index,
                                                    ),
                                        ),
                                        if (index <
                                            themesController.companions.length -
                                                1)
                                          const SizedBox(height: 12),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
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
