import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';

class TodaysQuestItem extends StatefulWidget {
  final String header;
  final String title;
  final String tagText;
  final List<Color> tagGradient;
  final int xp;
  final bool isActive;

  const TodaysQuestItem({
    super.key,
    required this.header,
    required this.title,
    required this.tagText,
    required this.tagGradient,
    required this.xp,
    required this.isActive,
  });

  @override
  State<TodaysQuestItem> createState() => _TodaysQuestItemState();
}

class _TodaysQuestItemState extends State<TodaysQuestItem> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          decoration: BoxDecoration(
            color: themeController.activeTheme.cardBackgroundColor.withValues(
              alpha: .4,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: .2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                widget.isActive
                    ? (themeController.activeTheme.id == 'adventurer'
                          ? IconPath.doticonAdventure
                          : themeController.activeTheme.id == 'mage'
                          ? IconPath.doticonMage
                          : themeController.activeTheme.id == 'gamer'
                          ? IconPath.doticonGamer
                          : IconPath.doticonReader)
                    : IconPath.whitecircle,
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
                      widget.header,
                      style: getTextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.title,
                      style: getTextStyle(color: Colors.white, fontSize: 12),
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
                          gradient: LinearGradient(colors: widget.tagGradient),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.tagText,
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
                            '+${widget.xp}',
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
