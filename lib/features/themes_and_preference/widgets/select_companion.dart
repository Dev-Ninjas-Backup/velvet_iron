import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';

class SelectCompanion extends StatelessWidget {
  const SelectCompanion({
    super.key,
    required this.leadingIcon,
    required this.avatar,
    required this.name,
    this.badgeText,
  });

  final Widget leadingIcon;
  final Widget avatar;
  final String name;
  final String? badgeText; // optional
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8, top: 16, bottom: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 18, height: 19, child: leadingIcon),
          const SizedBox(width: 12),
          SizedBox(width: 40, height: 40, child: avatar),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: getTextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const Spacer(),
          if (badgeText != null)
            GetBuilder<AppThemeController>(
              builder: (themeController) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 4,
                  ),
                  // height: 24,
                  // width: 98,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(width: 1, color: Colors.transparent),
                    gradient: themeController.activeTheme.progressBarGradient,
                  ),
                  child: Text(
                    badgeText!,
                    style: getTextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
