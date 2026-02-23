import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';

class Themes extends StatelessWidget {
  const Themes({
    super.key,
    required this.title,
    required this.badgeText,
    required this.gradientColors,
    required this.icon,
    this.subtitle,
    this.borderColor,
    this.onTap,
    this.isSelected = false,
  });

  final String title;
  final String badgeText;
  final String? subtitle;
  final List<Color> gradientColors;
  final Widget icon;
  final Color? borderColor;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 78),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.white
                : (borderColor ?? Colors.white.withValues(alpha: .3)),
            width: isSelected ? 2 : 1,
          ),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: gradientColors,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 18, height: 19, child: icon),

                const SizedBox(width: 8),

                Text(
                  title,
                  style: getTextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                Container(
                  height: 33,
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(29),
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                  child: Text(
                    badgeText,
                    style: getTextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),

            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: getTextStyle(
                  color: Colors.white.withValues(alpha: .85),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
