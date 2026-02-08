import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';

class CustomSmallButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color fontColor;
  final double height;
  final double? width;
  final LinearGradient? gradient;

  const CustomSmallButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 30,
    required this.fontColor,
    this.width,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: height,
            width: width,
            decoration: BoxDecoration(
              gradient:
                  gradient ?? themeController.activeTheme.progressBarGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: fontColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        );
      },
    );
  }
}
