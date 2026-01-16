import 'package:flutter/material.dart';

class FigmaBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;

  const FigmaBackButton({super.key, this.onPressed, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
              color: Colors.black.withValues(alpha: 0.35),
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
  }
}
