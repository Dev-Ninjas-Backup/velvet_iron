import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';

class MoodOptionWidget extends StatelessWidget {
  final String icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const MoodOptionWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 55.8,
        height: 80,
        padding: const EdgeInsets.fromLTRB(7, 7, 7, 11),
        decoration: BoxDecoration(
          color: const Color(0xFF3A0303),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isSelected ? const Color(0xFFDCAA64) : Colors.transparent,
            width: 0.6,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, width: 22, height: 24),
            const SizedBox(height: 6),
            Text(title, style: getTextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
