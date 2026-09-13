import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/app_theme/model/app_theme_model.dart';

class EmptyStateCard extends StatelessWidget {
  final IconData? icon;
  final String? iconPath;
  final String title;
  final String? subtitle;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const EmptyStateCard({
    super.key,
    this.icon,
    this.iconPath,
    required this.title,
    this.subtitle,
    this.height,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<AppThemeController>();

    return GetBuilder<AppThemeController>(
      builder: (_) {
        final activeTheme =
            themeController.currentTheme.value ?? AppThemeModel.adventurerTheme;

        final content = Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null || iconPath != null) ...[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: activeTheme.headerIconBackgroundColor.withValues(alpha: 0.7),
                  border: Border.all(
                    color: activeTheme.accentGoldColor.withValues(alpha: 0.4),
                    width: 1.2,
                  ),
                ),
                child: Center(
                  child: iconPath != null
                      ? Image.asset(
                          iconPath!,
                          width: 24,
                          height: 24,
                          color: activeTheme.accentGoldColor,
                          errorBuilder: (_, _, _) => Icon(
                            icon ?? Icons.inbox_outlined,
                            size: 22,
                            color: activeTheme.accentGoldColor,
                          ),
                        )
                      : Icon(
                          icon ?? Icons.inbox_outlined,
                          size: 24,
                          color: activeTheme.accentGoldColor,
                        ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: getTextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: getTextStyle(
                  color: activeTheme.textColor.withValues(alpha: 0.85),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ],
        );

        return Container(
          width: double.infinity,
          height: height,
          margin: margin,
          padding: padding ??
              const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          decoration: BoxDecoration(
            color: activeTheme.cardBackgroundColor.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: activeTheme.borderColor.withValues(alpha: 0.35),
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: content,
        );
      },
    );
  }
}
