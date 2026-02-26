import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/profile/controller/profile_controller.dart';

class ProfileAppBar extends StatelessWidget {
  final double size;

  const ProfileAppBar({this.size = 40, super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          themeController.activeTheme.headerIconBackgroundColor,
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
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Profile',
                    style: getTextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 108,
                  height: 108,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: themeController.activeTheme.progressBarGradient,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: themeController.activeTheme.cardBackgroundColor,
                      ),
                      child: ClipOval(
                        child: Obx(() {
                          final localPath = controller.profileImage.value;
                          final remoteUrl = controller.remoteProfilePhoto.value;
                          final isLocalPicked =
                              localPath != ImagePath.profile &&
                              localPath.isNotEmpty;
                          if (isLocalPicked) {
                            return Image.file(
                              File(localPath),
                              width: 102,
                              height: 102,
                              fit: BoxFit.cover,
                            );
                          } else if (remoteUrl.isNotEmpty) {
                            return Image.network(
                              remoteUrl,
                              width: 102,
                              height: 102,
                              fit: BoxFit.cover,
                              loadingBuilder: (_, child, progress) {
                                if (progress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                );
                              },
                              errorBuilder: (_, __, ___) => Image.asset(
                                ImagePath.profile,
                                width: 102,
                                height: 102,
                                fit: BoxFit.cover,
                              ),
                            );
                          } else {
                            return Image.asset(
                              ImagePath.profile,
                              width: 102,
                              height: 102,
                              fit: BoxFit.cover,
                            );
                          }
                        }),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => controller.pickImage(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: themeController.activeTheme.accentGoldColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Obx(
              () => Text(
                controller.fullName.value,
                style: getTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),

            Obx(
              () => Text(
                controller.userName.value.isNotEmpty
                    ? '@${controller.userName.value}'
                    : '',
                style: getTextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),
            Container(
              height: 1,
              color: themeController.activeTheme.borderColor.withValues(
                alpha: 0.5,
              ),
            ),
          ],
        );
      },
    );
  }
}
