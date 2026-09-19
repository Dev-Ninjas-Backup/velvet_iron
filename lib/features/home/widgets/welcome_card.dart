import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
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

        // Path-specific decorative symbol, codex book, title, and subtitle
        String leftImage = ImagePath.emblemAdventurer;
        String rightImage = 'assets/images/book.png';
        String title = "Welcome Back, Adventurer";
        String subtitle =
            "Your journey to wellness is a heroic quest. Track your daily progress.";

        switch (activeTheme.id) {
          case 'mage': // Purple theme
            leftImage = ImagePath.emblemMage;
            rightImage = 'assets/images/book.png';
            title = "Welcome Back, Mage";
            subtitle = "Mastery grows quiet before it grows visible.";
            break;
          case 'reader': // Scribe (Blue) theme
            leftImage = ImagePath.emblemScribe;
            rightImage = ImagePath.blueBook;
            title = "Welcome Back, Scribe";
            subtitle =
                "The librarian closes the book and whispers: 'It's your turn now.'";
            break;
          case 'gamer': // Realmwalker (Green) theme
            leftImage = ImagePath.emblemRealmwalker;
            rightImage = ImagePath.greenBook;
            title = "Welcome Back, Realmwalker";
            subtitle = "Your stamina bar isn't going to refill itself.";
            break;
          default: // Adventurer (Red) theme
            leftImage = ImagePath.emblemAdventurer;
            rightImage = 'assets/images/book.png';
            title = "Welcome Back, Adventurer";
            subtitle =
                "Your journey to wellness is a heroic quest. Track your daily progress.";
        }

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: activeTheme.cardBackgroundColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Image.asset(
                leftImage,
                height: 92,
                width: 92,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: getTextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      textAlign: TextAlign.start,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: getTextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: 90,
                child: Image.asset(rightImage, height: 110, fit: BoxFit.contain),
              ),
            ],
          ),
        );
      },
    );
  }
}
