import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';

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
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return GestureDetector(
          onTap: onPressed,
          child: AnimatedContainer(
            padding: const EdgeInsets.all(6),
            key: ValueKey(text),
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            // width: 85,
            // height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21),
              border: Border.all(
                color: isSelected ? Colors.transparent : Colors.grey.shade300,
                width: 1,
              ),
              gradient: isSelected
                  ? LinearGradient(
                      colors:
                          (themeController
                                  .activeTheme
                                  .selectedColors
                                  .isNotEmpty &&
                              themeController
                                      .activeTheme
                                      .selectedColors
                                      .length >
                                  1)
                          ? [
                              themeController.activeTheme.selectedColors[0],
                              themeController.activeTheme.selectedColors[1],
                            ]
                          : (themeController
                                .activeTheme
                                .selectedColors
                                .isNotEmpty)
                          ? [themeController.activeTheme.selectedColors[0]]
                          : [Colors.white],
                    )
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style: getTextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color:
                    (isSelected && themeController.activeTheme.id == 'reader')
                    ? const Color(0xFF141694)
                    : Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
