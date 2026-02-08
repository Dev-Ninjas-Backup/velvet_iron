import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/common/widgets/custom_background2.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/profile/controller/profile_controller.dart';
import 'package:velvet_iron/features/themes_and_preference/widgets/select_companion.dart';
import 'package:velvet_iron/features/themes_and_preference/widgets/themes.dart';
import 'package:velvet_iron/features/themes_and_preference/widgets/themes_preference_widgets.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());

    return Scaffold(
      body: GetBuilder<AppThemeController>(
        builder: (themeController) {
          return CustomBackground2(
            imageAsset: themeController.activeTheme.backgroundImage,
            child: SafeArea(
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
                          Themes(
                            title: 'Adventurer',
                            badgeText: 'Active Now',
                            subtitle:
                                '"Discipline is the blade — sharpen it daily."',
                            gradientColors: _getThemeGradient('adventurer'),
                            icon: Image.asset(IconPath.goldencircle),
                          ),
                          const SizedBox(height: 12),
                          Themes(
                            title: 'Mage',
                            badgeText: 'Unlock 250 xp',
                            gradientColors: _getThemeGradient('mage'),
                            icon: Image.asset(IconPath.lock),
                          ),
                          const SizedBox(height: 12),
                          Themes(
                            title: 'Reader',
                            badgeText: 'Unlock 250 xp',
                            gradientColors: _getThemeGradient('reader'),
                            icon: Image.asset(IconPath.lock),
                          ),
                          const SizedBox(height: 12),
                          Themes(
                            title: 'Gamer',
                            badgeText: 'Unlock 250 xp',
                            gradientColors: _getThemeGradient('gamer'),
                            icon: Image.asset(IconPath.lock),
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
                          SelectCompanion(
                            leadingIcon: Image.asset(
                              IconPath.goldencircle,
                              fit: BoxFit.contain,
                            ),
                            avatar: Image.asset(
                              ImagePath.charecterOne,
                              fit: BoxFit.cover,
                            ),
                            name: 'Ser Kael Thornwatch',
                          ),
                          const SizedBox(height: 12),
                          SelectCompanion(
                            leadingIcon: Image.asset(
                              IconPath.lock,
                              fit: BoxFit.contain,
                            ),
                            avatar: Image.asset(
                              ImagePath.charecterThree,
                              fit: BoxFit.cover,
                            ),
                            name: 'Riven Ashcroft',
                            badgeText: 'Unlock 250 xp',
                          ),
                          const SizedBox(height: 12),
                          SelectCompanion(
                            leadingIcon: Image.asset(
                              IconPath.lock,
                              fit: BoxFit.contain,
                            ),
                            avatar: Image.asset(
                              ImagePath.charecterFour,
                              fit: BoxFit.cover,
                            ),
                            name: 'Pyraxis',
                            badgeText: 'Unlock 250 xp',
                          ),
                          const SizedBox(height: 12),
                          SelectCompanion(
                            leadingIcon: Image.asset(
                              IconPath.lock,
                              fit: BoxFit.contain,
                            ),
                            avatar: Image.asset(
                              ImagePath.charecterTwo,
                              fit: BoxFit.cover,
                            ),
                            name: 'Bram Ironledger',
                            badgeText: 'Unlock 250 xp',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
          Color(0xFF111C18),
          Color(0xFFE7C143),
        ];
      default:
        return const [
          Color(0xFF310101),
          Color(0xFF550606),
          Color(0xFF310101),
          Color(0xFF550606),
          Color(0xFF310101),
          Color(0xFF9E6D38),
          Color(0xFF683E23),
        ];
    }
  }
}
