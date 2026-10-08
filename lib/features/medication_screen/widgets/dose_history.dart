import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';

class DoseHistory extends StatelessWidget {
  final String title, sub, time;
  final String iconPath;
  final RxBool isSelected;
  final bool isTaken;
  final VoidCallback? onStatusIconTap;
  final VoidCallback? onEditTap;
  final VoidCallback? onDeleteTap;

  const DoseHistory({
    super.key,
    required this.title,
    required this.sub,
    required this.time,
    required this.iconPath,
    required this.isSelected,
    required this.isTaken,
    this.onStatusIconTap,
    this.onEditTap,
    this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Obx(
          () => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: themeController.activeTheme.textfieldColor.withValues(
                alpha: isSelected.value ? 0.8 : 0.4,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                // Status Icon - TAPPABLE
                onStatusIconTap != null && !isTaken
                    ? MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            debugPrint('[DoseHistory] 🖱️ Status icon tapped!');
                            onStatusIconTap!();
                          },
                          child: Image.asset(
                            isTaken
                                ? (themeController.activeTheme.id ==
                                          'adventurer'
                                      ? IconPath.doticonAdventure
                                      : themeController.activeTheme.id == 'mage'
                                      ? IconPath.doticonMage
                                      : themeController.activeTheme.id ==
                                            'gamer'
                                      ? IconPath.doticonGamer
                                      : IconPath.doticonReader)
                                : IconPath.whitecircle,
                            width: 22,
                            height: 22,
                          ),
                        ),
                      )
                    : Image.asset(
                        isTaken
                            ? (themeController.activeTheme.id == 'adventurer'
                                  ? IconPath.doticonAdventure
                                  : themeController.activeTheme.id == 'mage'
                                  ? IconPath.doticonMage
                                  : themeController.activeTheme.id == 'gamer'
                                  ? IconPath.doticonGamer
                                  : IconPath.doticonReader)
                            : IconPath.whitecircle,
                        width: 22,
                        height: 22,
                      ),
                const SizedBox(width: 8),
                Image.asset(
                  iconPath,
                  width: 24,
                  height: 24,
                  color: Colors.white,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.image_not_supported,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: getTextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        sub,
                        style: getTextStyle(
                          color: themeController.activeTheme.textColor,
                          fontSize: 11,
                        ),
                        maxLines: 1,
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
                        Image.asset(
                          themeController.activeTheme.id == 'adventurer'
                              ? IconPath.starAdventure
                              : themeController.activeTheme.id == 'mage'
                              ? IconPath.starMage
                              : themeController.activeTheme.id == 'gamer'
                              ? IconPath.starGamer
                              : IconPath.starReader,
                          width: 16,
                          height: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "+10 XP",
                          style: getTextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: getTextStyle(
                        color: themeController.activeTheme.textColor,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                if (onEditTap != null || onDeleteTap != null) ...[
                  const SizedBox(width: 8),
                  if (onEditTap != null)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onEditTap,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.edit_outlined,
                          size: 18,
                          color: themeController.activeTheme.textColor,
                        ),
                      ),
                    ),
                  if (onDeleteTap != null)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onDeleteTap,
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
