import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/app_theme/model/app_theme_model.dart';

class MoodSelector extends StatelessWidget {
  const MoodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        final activeTheme =
            themeController.currentTheme.value ?? AppThemeModel.adventurerTheme;

        // Select emoji icons based on active theme
        final moods = [
          {
            'label': 'Tired',
            'icon': activeTheme.id == 'gamer'
                ? IconPath.tiredEmojiGreen
                : activeTheme.id == 'mage'
                ? IconPath.tiredEmojiPurple
                : activeTheme.id == 'reader'
                ? IconPath.tiredEmojiWhite
                : IconPath.tiredEmoji,
          },
          {
            'label': 'Good',
            'icon': activeTheme.id == 'gamer'
                ? IconPath.goodEmojiGreen
                : activeTheme.id == 'mage'
                ? IconPath.goodEmojiPurple
                : activeTheme.id == 'reader'
                ? IconPath.goodEmojiWhite
                : IconPath.goodEmoji,
          },
          {
            'label': 'Pissed',
            'icon': activeTheme.id == 'gamer'
                ? IconPath.pissedEmojiGreen
                : activeTheme.id == 'mage'
                ? IconPath.pissedEmojiPurple
                : activeTheme.id == 'reader'
                ? IconPath.pissedEmojiWhite
                : IconPath.pissedEmoji,
          },
          {
            'label': 'Great',
            'icon': activeTheme.id == 'gamer'
                ? IconPath.greatEmojiGreen
                : activeTheme.id == 'mage'
                ? IconPath.greatEmojiPurple
                : activeTheme.id == 'reader'
                ? IconPath.greatEmojiWhite
                : IconPath.greatEmoji,
          },
          {
            'label': 'Poor',
            'icon': activeTheme.id == 'gamer'
                ? IconPath.poorEmojiGreen
                : activeTheme.id == 'mage'
                ? IconPath.poorEmojiPurple
                : activeTheme.id == 'reader'
                ? IconPath.poorEmojiWhite
                : IconPath.poorEmoji,
          },
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "How are you feeling?",
              style: getTextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...moods.map(
                  (m) => Container(
                    width: 55,
                    height: 80,
                    padding: const EdgeInsets.only(top: 0, bottom: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: activeTheme.moodBorderColor),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: Center(
                            child: Image.asset(
                              m['icon']!,
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                        Text(
                          m['label']!,
                          style: getTextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    height: 80,
                    width: 50,
                    decoration: BoxDecoration(
                      gradient: activeTheme.id == 'reader'
                          ? AppThemeModel.readerTheme.progressBarGradient
                          : activeTheme.id == 'gamer'
                          ? AppThemeModel.gamerTheme.progressBarGradient
                          : activeTheme.id == 'mage'
                          ? AppThemeModel.mageTheme.progressBarGradient
                          : AppThemeModel.adventurerTheme.progressBarGradient,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        "+\nAdd\n+05 xp",
                        textAlign: TextAlign.center,
                        style: getTextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
