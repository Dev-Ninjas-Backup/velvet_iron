import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/app_theme/model/app_theme_model.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        final activeTheme =
            themeController.currentTheme.value ?? AppThemeModel.adventurerTheme;
        // Theme-specific welcome card image
        String welcomeCardImage = activeTheme.id == 'adventurer'
            ? ImagePath.welcomeBackAdventurer
            : activeTheme.id == 'mage'
            ? ImagePath.welcomeBackMage
            : activeTheme.id == 'gamer'
            ? ImagePath.welcomeBackGamer
            : ImagePath.welcomeBackReader;

        return LayoutBuilder(
          builder: (context, constraints) => Image.asset(
            welcomeCardImage,
            width: constraints.maxWidth,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
