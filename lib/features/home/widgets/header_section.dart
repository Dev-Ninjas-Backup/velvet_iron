import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/home/controller/home_controller.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        final activeTheme = themeController.activeTheme;
        return Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.userProfile.value == null) {
            return const SizedBox.shrink();
          }

          final profilePhoto = controller.userProfile.value?.profilePhoto;
          final imageProvider =
              (profilePhoto != null && profilePhoto.isNotEmpty)
              ? (profilePhoto.startsWith('http')
                    ? NetworkImage(profilePhoto) as ImageProvider
                    : AssetImage(profilePhoto))
              : null;

          return Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: imageProvider,
                backgroundColor: activeTheme.headerIconBackgroundColor,
                child: imageProvider == null
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.userProfile.value?.user.name ?? 'User',
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
                        IconPath.trophyAdventure,
                        width: 14,
                        height: 14,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "${controller.levelStatus} | ${controller.balanceXp} xp",
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
                  activeTheme.id == 'adventurer'
                      ? IconPath.quillpenAdenture
                      : activeTheme.id == 'mage'
                      ? IconPath.quillpenMage
                      : activeTheme.id == 'gamer'
                      ? IconPath.quillpenGamer
                      : activeTheme.id == 'reader'
                      ? IconPath.quillpenReader
                      : IconPath.quillpenAdenture,
                  width: 24,
                  height: 24,
                  color: Colors.white,
                  colorBlendMode: BlendMode.srcIn,
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
                    activeTheme.id == 'adventurer'
                        ? IconPath.settingsAdventure
                        : activeTheme.id == 'mage'
                        ? IconPath.settingsMage
                        : activeTheme.id == 'gamer'
                        ? IconPath.settingsGamer
                        : activeTheme.id == 'reader'
                        ? IconPath.settingsReader
                        : IconPath.settingsAdventure,
                    width: 24,
                    height: 24,
                    color: Colors.white,
                    colorBlendMode: BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          );
        });
      },
    );
  }
}
