import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/home/controller/theme_controller.dart';
import 'package:velvet_iron/features/home/models/home_theme_model.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        final activeTheme =
            themeController.currentTheme.value ??
            HomeThemeModel.adventurerTheme;

        // Get images based on theme
        String leftImage = ImagePath.tree;
        String rightImage = 'assets/images/book.png';

        switch (activeTheme.id) {
          case 'mage': // Blue theme
            leftImage = ImagePath.bottle;
            rightImage = ImagePath.blueBook;
            break;
          case 'reader': // Green theme
            leftImage = ImagePath.sword;
            rightImage = ImagePath.greenBook;
            break;
          case 'gamer': // Purple theme
            leftImage = ImagePath.chain;
            rightImage = ImagePath.threeCristal;
            break;
          default: // Adventurer (Red) theme
            leftImage = ImagePath.tree;
            rightImage = 'assets/images/book.png';
        }

        return Container(
          height: 150,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: activeTheme.id == 'mage'
                ? const Color(0xFFE0E0E0)
                : activeTheme.cardBackgroundColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: activeTheme.id == 'mage'
                ? [
                    BoxShadow(
                      color: const Color(0x1C000000),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Image.asset(leftImage, height: 144, width: 52),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      activeTheme.id == 'mage'
                          ? "Welcome Back, Reader"
                          : activeTheme.id == 'reader'
                          ? "Welcome Back Gamer"
                          : activeTheme.id == 'gamer'
                          ? "Welcome Back Magician"
                          : "Welcome Back Adventurer",
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: getTextStyle(
                        color: activeTheme.id == 'mage'
                            ? const Color(0xFF191970)
                            : Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      activeTheme.id == 'mage'
                          ? "The librarian closes the book and whispers: 'It's your turn now."
                          : activeTheme.id == 'reader'
                          ? "Your stamina bar isn't going to refill itself."
                          : activeTheme.id == 'gamer'
                          ? "Mastery grows quiet before it grows visible."
                          : "Your journey to wellness is a heroic quest. Track your daily progress.",
                      textAlign: TextAlign.start,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: getTextStyle(
                        color: activeTheme.id == 'mage'
                            ? const Color(0xFF191970)
                            : Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 100, child: Image.asset(rightImage, height: 120)),
            ],
          ),
        );
      },
    );
  }
}
