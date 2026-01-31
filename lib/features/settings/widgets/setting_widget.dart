import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/settings/controller/setting_controller.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class SettingsAppBar extends StatelessWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final String? profileImageUrl;
  final double size;

  const SettingsAppBar({
    super.key,
    this.onNotificationTap,
    this.onProfileTap,
    this.profileImageUrl,
    this.size = 40,
  });

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

            Expanded(
              child: Text(
                'Settings',
                style: getTextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),

            GestureDetector(
              onTap: onNotificationTap ?? () {},
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF521212).withValues(alpha: 0.5),
                ),
                child: Image.asset(IconPath.quillpen),
              ),
            ),
            const SizedBox(width: 12),

            GestureDetector(
              onTap: onProfileTap ?? () {},
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                  image: DecorationImage(
                    image: profileImageUrl != null
                        ? NetworkImage(profileImageUrl!)
                        : Image.asset(ImagePath.profile).image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserProfileWidget extends GetView<SettingsController> {
  const UserProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
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
              padding: const EdgeInsets.all(2),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF2A0F0F),
                ),
                child: ClipOval(
                  child: Image.asset(
                    IconPath.serkelProfile,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Text(
                        controller.userName.value,
                        style: getTextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF521212),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Image.asset(IconPath.trophy, height: 14, width: 8),
                          const SizedBox(width: 4),
                          Obx(
                            () => Text(
                              'Level ${controller.userLevel.value}',
                              style: getTextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),

                Obx(
                  () => ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Stack(
                      children: [
                        Container(
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1A0808),
                          ),
                        ),

                        FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: controller.progressPercentage,
                          child: Container(
                            height: 8,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFFDE7BB),
                                  Color(0xFF9E6D38),
                                  Color(0xFFE9B86E),
                                  Color(0xFFE5B46B),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => Text(
                          controller.progressText,
                          style: getTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFB8B8B8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Obx(
                      () => Text(
                        controller.xpText,
                        style: getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// upcoming log widget

class UpcomingLogWidget extends GetView<SettingsController> {
  const UpcomingLogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xFF521212).withValues(alpha: .5),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Up-coming Log:',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: controller.skipUpcomingLog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF380404),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF6B1717),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'skip',
                      style: getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF914C4C),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 3,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF992929).withValues(alpha: 0.6),
                  const Color(0xFF992929).withValues(alpha: 0.6),
                  const Color(0xFF992929).withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Center(child: Image.asset(IconPath.todo)),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                          controller.upcomingLog.value,
                          style: getTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '350 kCal',
                        style: getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFB43737),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Obx(
                          () => Text(
                            '+${controller.upcomingLogXP.value} XP',
                            style: getTextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Image.asset(IconPath.star, height: 12, width: 12),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Obx(
                      () => Text(
                        controller.upcomingLogTime.value,
                        style: getTextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF914C4C),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// general settings widget
class GeneralSettingsWidget extends GetView<SettingsController> {
  const GeneralSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'General Settings',
          style: getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),

        // My Profile
        _buildSettingsItem(
          iconPath: IconPath.myprofile,
          title: 'My Profile',
          onTap: () => Get.toNamed(AppRoute.getprofileScreen()),
        ),
        const SizedBox(height: 12),

        // Daily Macro Goal
        _buildSettingsItem(
          iconPath: IconPath.trophy,
          title: 'Daily Macro Goal',
          onTap: () => Get.toNamed(AppRoute.getdailyGoalScreen()),
        ),
        const SizedBox(height: 12),

        // Themes & Preference
        _buildSettingsItem(
          iconPath: IconPath.themes,
          title: 'Themes & Preference',
          onTap: () => Get.toNamed(AppRoute.getthemeScreen()),
        ),
        const SizedBox(height: 12),

        // My Subscriptions
        _buildSettingsItem(
          iconPath: ImagePath.diamond,
          title: 'My Subscriptions',
          onTap: () => Get.toNamed(AppRoute.mySubscriptionScreen),
        ),
        const SizedBox(height: 12),

        // Feedback & Support
        _buildSettingsItem(
          iconPath: IconPath.feedback,
          title: 'Feedback & Support',
          onTap: () => Get.toNamed(AppRoute.getfeedbackScreen()),
        ),
        const SizedBox(height: 12),

        // About Training Codex
        _buildSettingsItem(
          iconPath: IconPath.taining,
          title: 'About Training Codex',
          onTap: () => Get.toNamed(AppRoute.getaboutTrainingScreen()),
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required String iconPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF521212).withValues(alpha: .5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFFFDE7BB),
                      Color(0xFF9E6D38),
                      Color(0xFFE9B86E),
                      Color(0xFFE5B46B),
                    ],
                  ).createShader(bounds),
                  child: Image.asset(
                    iconPath,
                    color: Colors.white,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFB43737), size: 24),
          ],
        ),
      ),
    );
  }
}

// logout widget

class LogoutWidget extends GetView<SettingsController> {
  const LogoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: controller.logout,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF4A1919).withValues(alpha: .5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Image.asset(IconPath.logoutIcon),
            ),
            const SizedBox(width: 16),
            Text(
              'Log Out',
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFFDCAA64),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// app version widget

class AppVersionWidget extends GetView<SettingsController> {
  const AppVersionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Text(
            'App Version - ${controller.appVersion.value}',
            style: getTextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Color(0xFF992929),
            ),
          ),
        ),
        const SizedBox(height: 7),
        Text(
          'All Right Reserved by Velvet Tech Training Codex',
          style: getTextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: Color(0xFF992929),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
