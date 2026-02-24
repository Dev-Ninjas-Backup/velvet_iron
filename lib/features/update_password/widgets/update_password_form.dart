import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/update_password/controller/update_password_controller.dart';

class UpdatePasswordFormWidget extends StatelessWidget {
  const UpdatePasswordFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdatePasswordController());
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.find<AppThemeController>().activeTheme.cardBackgroundColor
            .withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFDCAA64).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPasswordField(
            label: "Enter Old Password:",
            controller: controller.oldPasswordController,
            isVisible: controller.isOldPasswordVisible,
            onToggle: controller.toggleOldPassword,
          ),
          const SizedBox(height: 16),
          _buildPasswordField(
            label: "Enter New Password:",
            controller: controller.newPasswordController,
            isVisible: controller.isNewPasswordVisible,
            onToggle: controller.toggleNewPassword,
          ),
          const SizedBox(height: 16),
          _buildPasswordField(
            label: "Confirm New Password:",
            controller: controller.confirmPasswordController,
            isVisible: controller.isConfirmPasswordVisible,
            onToggle: controller.toggleConfirmPassword,
          ),
          const SizedBox(height: 12),
          Text(
            "* Password must be minimum 8 characters",
            style: getTextStyle(
              fontSize: 12,
              color: Get.find<AppThemeController>().activeTheme.accentGoldColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required RxBool isVisible,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: getTextStyle(fontSize: 14, color: Colors.white)),
        const SizedBox(height: 8),
        Obx(
          () => TextField(
            controller: controller,
            obscureText: !isVisible.value,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Get.find<AppThemeController>()
                  .activeTheme
                  .dropdownBackgroundColor
                  .withValues(alpha: 0.3),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: Image.asset(
                  Get.find<AppThemeController>().activeTheme.id == 'mage'
                      ? IconPath.eyeMage
                      : Get.find<AppThemeController>().activeTheme.id == 'gamer'
                      ? IconPath.eyeGamer
                      : Get.find<AppThemeController>().activeTheme.id ==
                            'reader'
                      ? IconPath.eyeReader
                      : IconPath.eyeAdventure,
                  height: 16,
                  width: 20,
                ),
                onPressed: onToggle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
