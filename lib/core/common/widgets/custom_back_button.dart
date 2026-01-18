import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';

class FigmaBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;
  final String? appBarTitle;

  const FigmaBackButton({
    super.key,
    this.onPressed,
    this.size = 40,
    this.appBarTitle,
  });

  @override
  Widget build(BuildContext context) {
    final backButton = GestureDetector(
      onTap: onPressed ?? () => Navigator.pop(context),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF512212), Color(0xFF512212)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .35),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: size * 0.4,
          ),
        ),
      ),
    );

    if (appBarTitle == null) {
      return backButton;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        backButton,
        const SizedBox(width: 12),
        Text(
          appBarTitle!,
          style: getTextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
