import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';

class LogHistoryItem extends StatelessWidget {
  final String title;
  final String xpText;
  final String iconPath;
  final String secondText;
  final String thirdText;
  final String dateTimeText;
  final String? moodType; // 'tired', 'good', 'pissed', 'great', 'poor'

  const LogHistoryItem({
    super.key,
    required this.title,
    required this.xpText,
    required this.iconPath,
    required this.secondText,
    this.thirdText = '',
    this.dateTimeText = '',
    this.moodType,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        // Get the emoji path based on theme if moodType is provided
        final displayIconPath = moodType != null
            ? _getEmojiForTheme(themeController.activeTheme.id, moodType!)
            : iconPath;

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: themeController.activeTheme.cardBackgroundColor.withValues(
              alpha: 0.4,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(displayIconPath, width: 25, height: 30),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Feeling $title',
                      style: getTextStyle(fontSize: 14),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        xpText,
                        style: getTextStyle(fontSize: 12, color: Colors.white),
                      ),
                      const SizedBox(width: 4),
                      Image.asset(
                        themeController.activeTheme.id == 'adventurer'
                            ? IconPath.starAdventure
                            : themeController.activeTheme.id == 'mage'
                            ? IconPath.starMage
                            : themeController.activeTheme.id == 'gamer'
                            ? IconPath.starGamer
                            : IconPath.starReader,
                        width: 12,
                        height: 12,
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Row(
                children: [
                  Text(
                    '$secondText & $title',
                    style: getTextStyle(
                      fontSize: 12,
                      color: themeController.activeTheme.todoTimeColor,
                    ),
                  ),
                  if (dateTimeText.isNotEmpty) ...[
                    const Spacer(),
                    Text(
                      dateTimeText,
                      style: getTextStyle(
                        fontSize: 12,
                        color: themeController.activeTheme.todoTimeColor,
                      ),
                    ),
                  ],
                ],
              ),

              // if (thirdText.isNotEmpty) ...[
              //   const SizedBox(height: 6),
              //   Text(
              //     // thirdText,
              //     style: getTextStyle(fontSize: 12, color: Colors.white),
              //   ),
              // ],
            ],
          ),
        );
      },
    );
  }

  String _getEmojiForTheme(String themeId, String moodType) {
    switch (themeId) {
      case 'gamer':
        return _getGreenEmoji(moodType);
      case 'mage':
        return _getPurpleEmoji(moodType);
      case 'reader':
        return _getWhiteEmoji(moodType);
      default:
        return _getDefaultEmoji(moodType);
    }
  }

  String _getDefaultEmoji(String moodType) {
    switch (moodType) {
      case 'tired':
        return IconPath.tiredEmoji;
      case 'good':
        return IconPath.goodEmoji;
      case 'pissed':
        return IconPath.pissedEmoji;
      case 'great':
        return IconPath.greatEmoji;
      case 'poor':
        return IconPath.poorEmoji;
      default:
        return IconPath.tiredEmoji;
    }
  }

  String _getWhiteEmoji(String moodType) {
    switch (moodType) {
      case 'tired':
        return IconPath.tiredEmojiWhite;
      case 'good':
        return IconPath.goodEmojiWhite;
      case 'pissed':
        return IconPath.pissedEmojiWhite;
      case 'great':
        return IconPath.greatEmojiWhite;
      case 'poor':
        return IconPath.poorEmojiWhite;
      default:
        return IconPath.tiredEmojiWhite;
    }
  }

  String _getGreenEmoji(String moodType) {
    switch (moodType) {
      case 'tired':
        return IconPath.tiredEmojiGreen;
      case 'good':
        return IconPath.goodEmojiGreen;
      case 'pissed':
        return IconPath.pissedEmojiGreen;
      case 'great':
        return IconPath.greatEmojiGreen;
      case 'poor':
        return IconPath.poorEmojiGreen;
      default:
        return IconPath.tiredEmojiGreen;
    }
  }

  String _getPurpleEmoji(String moodType) {
    switch (moodType) {
      case 'tired':
        return IconPath.tiredEmojiPurple;
      case 'good':
        return IconPath.goodEmojiPurple;
      case 'pissed':
        return IconPath.pissedEmojiPurple;
      case 'great':
        return IconPath.greatEmojiPurple;
      case 'poor':
        return IconPath.poorEmojiPurple;
      default:
        return IconPath.tiredEmojiPurple;
    }
  }
}
