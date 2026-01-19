import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/profile/controller/profile_controller.dart';

class ProfileAppBar extends StatelessWidget {
  final double size;

  const ProfileAppBar({this.size = 40, super.key});

  @override
  Widget build(BuildContext context) {
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
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF512212), Color(0xFF512212)],
                  ),
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
            // Title
            Expanded(
              child: Text(
                'Profile',
                style: getTextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// profile widget

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 108,
              height: 108,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFDE7BB),
                    Color(0xFF9E6D38),
                    Color(0xFFE9B86E),
                    Color(0xFFE5B46B),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF2A0F0F),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      ImagePath.profile,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
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
                    color: const Color(0xFFDCAA64),
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

        const SizedBox(height: 8),
        Obx(
          () => Text(
            '@${controller.email.value}',
            style: getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          height: 1,
          color: const Color(0xFF723737).withValues(alpha: 0.5),
        ),
      ],
    );
  }
}

// update information widget

class UpdateInformationWidget extends StatelessWidget {
  const UpdateInformationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Update Information:',
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 1,
            color: const Color(0xFF723737).withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),

          Text(
            'Full Name:',
            style: getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => _buildTextField(
              controller: controller.fullNameController,
              hintText: 'Enter full name',

              value: controller.fullName.value,
            ),
          ),
          const SizedBox(height: 20),

          // Username Field
          Text(
            'Username:',
            style: getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => _buildTextField(
              controller: controller.usernameController,
              hintText: 'Enter username/email',

              value: controller.username.value,
            ),
          ),

          const SizedBox(height: 20),

          // Username Field
          Text(
            'Email Address:',
            style: getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 8),
          Obx(
            () => _buildTextField(
              controller: controller.emailController,
              hintText: 'Enter email address',

              value: controller.email.value,
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Password:',
            style: getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => _buildTextField(
              controller: controller.passwordController,
              hintText: 'Enter password',

              isPassword: true,
              value: controller.password.value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,

    required String value,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3A0303).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF6B1717).withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: getTextStyle(fontSize: 14, color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: getTextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.5),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
