import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';

class CustomBackgroundWithImage extends StatelessWidget {
  final Widget child;
  final String? imageAsset;

  const CustomBackgroundWithImage({
    super.key,
    required this.child,
    this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Container(
          decoration: BoxDecoration(
            gradient: themeController.activeTheme.backgroundGradient,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset(
                    themeController.activeTheme.backgroundImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              child,
            ],
          ),
        );
      },
    );
  }
}
