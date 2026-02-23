import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/bottom_nav/controller/bottom_nav_controller.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BottomNavController>();

    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Obx(() {
          return Container(
            height: 75,
            padding: const EdgeInsets.all(12),
            // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              border: Border.all(
                color: themeController.activeTheme.borderColor,
              ),
              color: themeController.activeTheme.cardBackgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _buildNavItem(
                    IconPath.home,
                    "Home",
                    controller.tabIndex.value == 0,
                    () => controller.changeTabIndex(0),
                    themeController,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    "assets/icons/btmBar2.png",
                    "Daily Log",
                    controller.tabIndex.value == 1,
                    () => controller.changeTabIndex(1),
                    themeController,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    "assets/icons/btmBar3.png",
                    "Medication",
                    controller.tabIndex.value == 2,
                    () => controller.changeTabIndex(2),
                    themeController,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    "assets/icons/btmBar4.png",
                    "Exercise",
                    controller.tabIndex.value == 3,
                    () => controller.changeTabIndex(3),
                    themeController,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    "assets/icons/btmBar5.png",
                    "Quests",
                    controller.tabIndex.value == 4,
                    () => controller.changeTabIndex(4),
                    themeController,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    "assets/icons/btmBar6.png",
                    "Settings",
                    controller.tabIndex.value == 5,
                    () => controller.changeTabIndex(5),
                    themeController,
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildNavItem(
    String iconPath,
    String label,
    bool isSelected,
    VoidCallback onTap,
    AppThemeController themeController,
  ) {
    final Color iconColor = isSelected
        ? themeController.activeTheme.accentGoldColor
        : Colors.white;

    final Color textColor = isSelected
        ? themeController.activeTheme.accentGoldColor
        : Colors.white54;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconPath, width: 24, height: 24, color: iconColor),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getTextStyle(fontSize: 12, color: textColor),
          ),
        ],
      ),
    );
  }
}
