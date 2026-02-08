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
            'icon': activeTheme.id == 'mage'
                ? IconPath.tiredEmojiWhite
                : activeTheme.id == 'reader'
                ? IconPath.tiredEmojiGreen
                : activeTheme.id == 'gamer'
                ? IconPath.tiredEmojiPurple
                : IconPath.tiredEmoji,
          },
          {
            'label': 'Good',
            'icon': activeTheme.id == 'mage'
                ? IconPath.goodEmojiWhite
                : activeTheme.id == 'reader'
                ? IconPath.goodEmojiGreen
                : activeTheme.id == 'gamer'
                ? IconPath.goodEmojiPurple
                : IconPath.goodEmoji,
          },
          {
            'label': 'Pissed',
            'icon': activeTheme.id == 'mage'
                ? IconPath.pissedEmojiWhite
                : activeTheme.id == 'reader'
                ? IconPath.pissedEmojiGreen
                : activeTheme.id == 'gamer'
                ? IconPath.pissedEmojiPurple
                : IconPath.pissedEmoji,
          },
          {
            'label': 'Great',
            'icon': activeTheme.id == 'mage'
                ? IconPath.greatEmojiWhite
                : activeTheme.id == 'reader'
                ? IconPath.greatEmojiGreen
                : activeTheme.id == 'gamer'
                ? IconPath.greatEmojiPurple
                : IconPath.greatEmoji,
          },
          {
            'label': 'Poor',
            'icon': activeTheme.id == 'mage'
                ? IconPath.poorEmojiWhite
                : activeTheme.id == 'reader'
                ? IconPath.poorEmojiGreen
                : activeTheme.id == 'gamer'
                ? IconPath.poorEmojiPurple
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
                Container(
                  height: 80,
                  width: 50,
                  decoration: BoxDecoration(
                    gradient: activeTheme.id == 'mage'
                        ? const LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [Color(0xFFFFFFFF), Color(0x00FFF9F9)],
                          )
                        : activeTheme.id == 'reader'
                        ? const LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [Color(0xFF0E2D22), Color(0xFF105234)],
                          )
                        : activeTheme.id == 'gamer'
                        ? const LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [Color(0xFF1C0036), Color(0xFF360B5E)],
                          )
                        : const LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              Color(0xFFFDE7BB),
                              Color(0xFF9E6D38),
                              Color(0xFFE9B86E),
                              Color(0xFF9D6933),
                              Color(0xFFFEE9BF),
                              Color(0xFF683E23),
                            ],
                          ),
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
              ],
            ),
          ],
        );
      },
    );
  }
}
