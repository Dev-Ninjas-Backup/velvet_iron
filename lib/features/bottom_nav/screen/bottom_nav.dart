import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/constants/colors.dart';
import 'package:velvet_iron/features/bottom_nav/controller/bottom_nav_controller.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BottomNavController>();

    return Container(
      height: 80,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF521212),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildNavItem(
              Icons.home,
              "Home",
              controller.tabIndex.value == 0,
              () => controller.changeTabIndex(0),
            ),
            _buildNavItem(
              Icons.list,
              "Daily Log",
              controller.tabIndex.value == 1,
              () => controller.changeTabIndex(1),
            ),
            _buildNavItem(
              Icons.medical_services,
              "Medication",
              controller.tabIndex.value == 2,
              () => controller.changeTabIndex(2),
            ),
            _buildNavItem(
              Icons.fitness_center,
              "Exercise",
              controller.tabIndex.value == 3,
              () => controller.changeTabIndex(3),
            ),
            _buildNavItem(
              Icons.explore,
              "Quests",
              controller.tabIndex.value == 4,
              () => controller.changeTabIndex(4),
            ),
            _buildNavItem(
              Icons.person,
              "Profile",
              controller.tabIndex.value == 5,
              () => controller.changeTabIndex(5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
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
          Icon(
            icon,
            size: 24,
            color: isSelected ? AppColors.gold : Colors.white54,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? AppColors.gold : Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}
