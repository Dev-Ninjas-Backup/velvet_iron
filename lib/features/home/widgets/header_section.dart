import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/app_theme/model/app_theme_model.dart';
import 'package:velvet_iron/features/home/controller/home_controller.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<AppThemeController>();
    final activeTheme =
        themeController.currentTheme.value ?? AppThemeModel.adventurerTheme;
    final controller = Get.find<HomeController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.user.value == null) {
        return const SizedBox.shrink();
      }
      return Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage(controller.user.value!.profileImage),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.user.value!.name,
                style: getTextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    IconPath.trophy,
                    width: 14,
                    height: 14,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "${controller.user.value!.title} | ${controller.user.value!.xp} xp",
                    style: getTextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: activeTheme.headerIconBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              "assets/icons/action1.png",
              width: 24,
              height: 24,
              color: activeTheme.id == 'mage' ? Colors.white : null,
              colorBlendMode:
                  activeTheme.id == 'mage' ? BlendMode.srcIn : null,
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoute.getsettingScreen()),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: activeTheme.headerIconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                "assets/icons/progress.png",
                width: 24,
                height: 24,
                color: activeTheme.id == 'mage' ? Colors.white : null,
                colorBlendMode:
                    activeTheme.id == 'mage' ? BlendMode.srcIn : null,
              ),
            ),
          ),
        ],
      );
    });
  }
}
