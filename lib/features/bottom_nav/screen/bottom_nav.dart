import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/colors.dart';
import 'package:velvet_iron/features/bottom_nav/controller/bottom_nav_controller.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BottomNavController>();

    return Container(
      height: 75,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 71, 9, 9)),
        color: AppColors.textFieldFillColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _buildNavItem(
                "assets/icons/btmBar1.png",
                "Home",
                controller.tabIndex.value == 0,
                () => controller.changeTabIndex(0),
              ),
            ),
            Expanded(
              child: _buildNavItem(
                "assets/icons/btmBar2.png",
                "Daily Log",
                controller.tabIndex.value == 1,
                () => controller.changeTabIndex(1),
              ),
            ),
            Expanded(
              child: _buildNavItem(
                "assets/icons/btmBar3.png",
                "Medication",
                controller.tabIndex.value == 2,
                () => controller.changeTabIndex(2),
              ),
            ),
            Expanded(
              child: _buildNavItem(
                "assets/icons/btmBar4.png",
                "Exercise",
                controller.tabIndex.value == 3,
                () => controller.changeTabIndex(3),
              ),
            ),
            Expanded(
              child: _buildNavItem(
                "assets/icons/btmBar5.png",
                "Quests",
                controller.tabIndex.value == 4,
                () => controller.changeTabIndex(4),
              ),
            ),
            Expanded(
              child: _buildNavItem(
                "assets/icons/btmBar6.png",
                "Settings",
                controller.tabIndex.value == 5,
                () => controller.changeTabIndex(5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    String iconPath,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            width: 24,
            height: 24,
            color: isSelected ? AppColors.gold : Colors.white,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getTextStyle(
              fontSize: 12,
              color: isSelected ? AppColors.gold : Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}
