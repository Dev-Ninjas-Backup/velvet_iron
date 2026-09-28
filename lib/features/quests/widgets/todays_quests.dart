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
  final String questType;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TodaysQuestItem({
    super.key,
    required this.id,
    required this.header,
    required this.title,
    required this.xp,
    required this.isActive,
    this.questType = 'CODEX',
    this.onTap,
    this.onDelete,
  });

  static const Map<String, _TagData> _tagMap = {
    'track-your-shot': _TagData('Health', [Color(0xFFA60404), Color(0xFFF0AA48)]),
    'three-meals': _TagData('Nutrition', [Color(0xFF04A647), Color(0xFFF0AA48)]),
    'mood-check': _TagData('Mindfulness', [Color(0xFF7804A6), Color(0xFFF0AA48)]),
    'step-master': _TagData('Activity', [Color(0xFF0495A6), Color(0xFFF0AA48)]),
    'protein-power': _TagData('Nutrition', [Color(0xFF04A647), Color(0xFFF0AA48)]),
  };

  _TagData _resolveTag() {
    switch (questType) {
      case 'MEDICATION_SCHEDULE':
        return const _TagData('Medication', [Color(0xFF0072FF), Color(0xFF00C6FF)]);
      case 'WORKOUT_SCHEDULE':
        return const _TagData('Workout', [Color(0xFFFF512F), Color(0xFFF09819)]);
      case 'CUSTOM':
        return const _TagData('Custom', [Color(0xFFD4AF37), Color(0xFFF0AA48)]);
      default:
        return _tagMap[id] ??
            const _TagData('Codex', [Color(0xFF555555), Color(0xFF999999)]);
    }
  }

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

        final tag = _resolveTag();

        return GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            decoration: BoxDecoration(
              color: themeController.activeTheme.textfieldColor.withValues(
                alpha: 0.6,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isActive
                    ? themeController.activeTheme.accentGoldColor.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: .2),
              ),
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
                        style: getTextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ).copyWith(
                          decoration: isActive ? TextDecoration.lineThrough : null,
                          decorationColor: Colors.white54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: getTextStyle(
                          color: themeController.activeTheme.textColor,
                          fontSize: 11,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: tag.gradient),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            tag.label,
                            style: getTextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (questType == 'CUSTOM' && onDelete != null) ...[
                          const SizedBox(width: 4),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: onDelete,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              child: Icon(Icons.delete_outline, size: 20, color: Colors.white70),
                            ),
                          ),
                        ],
                      ],
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
              ],
            ),
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
