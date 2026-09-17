# Task: Restore Original Figma Welcome Card UI

## Context & Background
On the **Home Screen** (`lib/features/home/screen/home_screen.dart`), the **Welcome Card** widget (`lib/features/home/widgets/welcome_card.dart`) was previously modified in commit `ce4ddaf` ("four theme done") to display a full-width flat generated image of a 20-sided die on a map (`ImagePath.welcomeBackAdventurer`).

This deviated from the approved client Figma design:
1. **Removed Text & Typography:** The title (*"Welcome Back, Adventurer"*) and description subtitle (*"Your journey to wellness is a heroic quest. Track your daily progress."*) were removed.
2. **Visual Inconsistency:** The full-width image creates black borders/letterboxing and loses the `15px` rounded corner velvet card styling that matches the rest of the app's components.
3. **Broken Theme Flexibility:** The card should adapt cleanly across all 4 themes (Adventurer, Mage, Reader, Gamer) with their dedicated left emblems and right book artwork.

---

## Target File
* **File:** [`lib/features/home/widgets/welcome_card.dart`](file:///Users/saharaislam/Desktop/tahmid/velvet_iron/lib/features/home/widgets/welcome_card.dart)

---

## The Desired Solution (Original Figma UI)

Replace the entire contents of [`lib/features/home/widgets/welcome_card.dart`](file:///Users/saharaislam/Desktop/tahmid/velvet_iron/lib/features/home/widgets/welcome_card.dart) with the structured Flutter component below (retrieved from historical commit `58ad303`):

```dart
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activeTheme.id == 'mage'
                          ? "Welcome Back, Reader"
                          : activeTheme.id == 'reader'
                          ? "Welcome Back Gamer"
                          : activeTheme.id == 'gamer'
                          ? "Welcome Back Magician"
                          : "Welcome Back, Adventurer",
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
                          ? "The librarian closes the book and whispers: 'It's your turn now.'"
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
```

---

## Verification Steps
1. Run `flutter analyze` to ensure 0 errors and 0 warnings.
2. Launch the app on the emulator / test device:
   ```bash
   flutter run
   ```
3. Confirm the **Welcome Card** displays:
   * Curved corners (`borderRadius: 15`).
   * Golden tree emblem on the left.
   * Proper typography: **"Welcome Back, Adventurer"** + motivational subtitle.
   * Ornate 3D grimoire book on the right.
