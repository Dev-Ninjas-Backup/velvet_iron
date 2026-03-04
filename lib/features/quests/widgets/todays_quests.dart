import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';

class TodaysQuestItem extends StatelessWidget {
  final String id;
  final String header;
  final String title;
  final int xp;
  final bool isActive;

  const TodaysQuestItem({
    super.key,
    required this.id,
    required this.header,
    required this.title,
    required this.xp,
    required this.isActive,
  });

  static const Map<String, _TagData> _tagMap = {
    'track-your-shot': _TagData('Health', [
      Color(0xFFA60404),
      Color(0xFFF0AA48),
    ]),
    'three-meals': _TagData('Nutrition', [
      Color(0xFF04A647),
      Color(0xFFF0AA48),
    ]),
    'mood-check': _TagData('Mindfulness', [
      Color(0xFF7804A6),
      Color(0xFFF0AA48),
    ]),
    'step-master': _TagData('Activity', [Color(0xFF0495A6), Color(0xFFF0AA48)]),
    'protein-power': _TagData('Nutrition', [
      Color(0xFF04A647),
      Color(0xFFF0AA48),
    ]),
  };

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        final themeId = themeController.activeTheme.id;

        final dotIcon = themeId == 'adventurer'
            ? IconPath.doticonAdventure
            : themeId == 'mage'
            ? IconPath.doticonMage
            : themeId == 'gamer'
            ? IconPath.doticonGamer
            : IconPath.doticonReader;

        final starIcon = themeId == 'adventurer'
            ? IconPath.starAdventure
            : themeId == 'mage'
            ? IconPath.starMage
            : themeId == 'gamer'
            ? IconPath.starGamer
            : IconPath.starReader;

        final tag =
            _tagMap[id] ??
            const _TagData('Quest', [Color(0xFF555555), Color(0xFF999999)]);

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          decoration: BoxDecoration(
            color: themeController.activeTheme.textfieldColor.withValues(
              alpha: 0.6,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: .2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                isActive ? dotIcon : IconPath.whitecircle,
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      header,
                      style: getTextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: getTextStyle(
                        color: themeController.activeTheme.todoSubtitleColor
                            .withValues(alpha: 1),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: tag.gradient),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tag.label,
                          style: getTextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '+$xp',
                            style: getTextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'XP',
                            style: getTextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Image.asset(starIcon, width: 12, height: 12),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TagData {
  final String label;
  final List<Color> gradient;
  const _TagData(this.label, this.gradient);
}
