import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';

// Theme gradient color sets
const List<Color> themeGradient1 = [
  Color(0xFF310101),
  Color(0xFF550606),
  Color(0xFF310101),
  Color(0xFF550606),
  Color(0xFF310101),
  Color(0xFF9E6D38),
  Color(0xFF683E23),
];

const List<Color> themeGradient2 = [
  Color(0xFF1B0033),
  Color(0xFF35065E),
  Color(0xFF1B0033),
  Color(0xFF35065E),
  Color(0xFF1B0033),
  Color(0xFFBE32FF),
];

const List<Color> themeGradient3 = [
  Color(0xFF00027B),
  Color(0xFF292CB7),
  Color(0xFF00027B),
  Color(0xFF00013F),
  Color(0xFF3385FF),
];

const List<Color> themeGradient4 = [
  Color(0xFF111C18),
  Color(0xFF1E332C),
  Color(0xFF111C18),
  Color(0xFF1E332C),
  Color(0xFF111C18),
  Color(0xFFE7C143),
];

class SelectTheme extends StatelessWidget {
  const SelectTheme({
    super.key,
    required this.title,
    required this.badgeText,
    required this.gradientColors,
    required this.icon,
    this.subtitle,
    this.borderColor,
    this.isSelected = false,
    this.selectedIcon,
    this.onTap,
  });

  final String title;
  final String badgeText;
  final String? subtitle; // optional
  final List<Color> gradientColors; // 4–6 colors
  final Widget icon;
  final Widget? selectedIcon;
  final Color? borderColor;
  final bool isSelected;
  final VoidCallback? onTap;

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
            color: borderColor ?? Colors.white.withValues(alpha: .3),
            width: 1,
          ),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: gradientColors, 
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // HUG CONTENT
          children: [
            // Top row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isSelected)
                  SizedBox(width: 18, height: 19, child: selectedIcon ?? icon),

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

                if (isSelected)
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
                      'Active theme',
                      style: getTextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
