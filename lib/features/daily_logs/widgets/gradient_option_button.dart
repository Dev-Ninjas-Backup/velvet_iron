import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';

class CustomGradientOptionButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const CustomGradientOptionButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        key: ValueKey(text),
        duration: const Duration(
          milliseconds: 150,
        ), 
        curve: Curves.easeInOut,
        width: 85,
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          border: Border.all(
            // Smoothly transition border color
            color: isSelected ? Colors.transparent : const Color(0xFF992929),
            width: 1,
          ),
          // We wrap the gradient in a way that doesn't "snap"
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFDE7BB),
                    Color(0xFF9E6D38),
                    Color(0xFFE9B86E),
                    Color(0xFF9D6933),
                    Color(0xFFFEE9BF),
                    Color(0xFF683E23),
                  ],
                  stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
                )
              : null,
          color: isSelected ? null : const Color(0xFF3A0303),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: getTextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? const Color(0xFF3A0303) : Colors.white,
          ),
        ),
      ),
    );
  }
}
