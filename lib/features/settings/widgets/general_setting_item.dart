import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/core/services/notification_service.dart';
import 'package:velvet_iron/core/services/revenuecat_service.dart';
import 'package:velvet_iron/core/services/end_points.dart';
import 'package:velvet_iron/core/common/widgets/subscription_legal_disclaimer.dart';
import 'package:velvet_iron/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

class GeneralSettingsWidget extends StatelessWidget {
  const GeneralSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeController) {
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
            _SettingsItem(
              themeController: themeController,
              iconPath: IconPath.myprofile,
              title: 'My Profile',
              onTap: () => Get.toNamed(AppRoute.getprofileScreen()),
            ),
            const SizedBox(height: 12),

            // Daily Macro Goal
            _SettingsItem(
              themeController: themeController,
              iconPath: IconPath.trophyAdventure,
              title: 'Daily Macro Goal',
              onTap: () => Get.toNamed(AppRoute.getdailyGoalScreen()),
            ),
            const SizedBox(height: 12),

            // Themes & Preference
            _SettingsItem(
              themeController: themeController,
              iconPath: IconPath.themes,
              title: 'Themes & Preference',
              onTap: () => Get.toNamed(AppRoute.getthemeScreen()),
            ),
            const SizedBox(height: 12),

            // Companion Reminders (Notification Toggle)
            _SettingsSwitchItem(
              themeController: themeController,
              title: 'Companion Reminders',
              subtitle: 'Daily check-in reminder at 8:00 PM',
            ),
            const SizedBox(height: 12),

            // My Subscriptions
            _SettingsItem(
              themeController: themeController,
              iconPath: ImagePath.diamondAdventurer,
              title: 'My Subscriptions',
              onTap: () => Get.toNamed(AppRoute.mySubscriptionScreen),
            ),
            const SizedBox(height: 12),

            // Guild Hall (Discord Community - Subscription Gated)
            _SettingsItem(
              themeController: themeController,
              iconPath: IconPath.discordwhite,
              title: 'Guild Hall (Discord Community)',
              onTap: () async {
                final isSubscribed = await RevenueCatService.isPremiumActive();
                if (!context.mounted) return;

                if (!isSubscribed) {
                  _showGuildHallPaywall(context, themeController);
                } else {
                  final url = Uri.parse('https://discord.gg/velvetiron');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    await launchUrl(url);
                  }
                }
              },
            ),
            const SizedBox(height: 12),

            // Feedback & Support
            _SettingsItem(
              themeController: themeController,
              iconPath: IconPath.feedback,
              title: 'Feedback & Support',
              onTap: () => Get.toNamed(AppRoute.getfeedbackScreen()),
            ),
            const SizedBox(height: 12),

            // About Training Codex
            _SettingsItem(
              themeController: themeController,
              iconPath: IconPath.taining,
              title: 'About Training Codex',
              onTap: () => Get.toNamed(AppRoute.getaboutTrainingScreen()),
            ),
            const SizedBox(height: 12),

            // Terms of Use (EULA)
            _SettingsItem(
              themeController: themeController,
              iconData: Icons.gavel_outlined,
              title: 'Terms of Use (EULA)',
              onTap: () => SubscriptionLegalDisclaimer.launchUrlSafe(Urls.appleEulaUrl),
            ),
            const SizedBox(height: 12),

            // Privacy Policy
            _SettingsItem(
              themeController: themeController,
              iconData: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () => SubscriptionLegalDisclaimer.launchUrlSafe(Urls.privacyPolicyUrl),
            ),
          ],
        );
      },
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final AppThemeController themeController;
  final String? iconPath;
  final IconData? iconData;
  final String title;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.themeController,
    this.iconPath,
    this.iconData,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeController.activeTheme.cardBackgroundColor.withValues(
            alpha: .5,
          ),
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
                  shaderCallback: (bounds) => themeController
                      .activeTheme
                      .progressBarGradient
                      .createShader(bounds),
                  child: iconData != null
                      ? Icon(iconData, color: Colors.white, size: 24)
                      : Image.asset(
                          iconPath ?? IconPath.todo,
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
            Icon(Icons.chevron_right, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }
}

class _SettingsSwitchItem extends StatefulWidget {
  final AppThemeController themeController;
  final String title;
  final String subtitle;

  const _SettingsSwitchItem({
    required this.themeController,
    required this.title,
    required this.subtitle,
  });

  @override
  State<_SettingsSwitchItem> createState() => _SettingsSwitchItemState();
}

class _SettingsSwitchItemState extends State<_SettingsSwitchItem> {
  bool _enabled = true;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final val = await NotificationService.isReminderEnabled();
    if (mounted) setState(() => _enabled = val);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: widget.themeController.activeTheme.cardBackgroundColor.withValues(
          alpha: .5,
        ),
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
                shaderCallback: (bounds) => widget.themeController
                    .activeTheme
                    .progressBarGradient
                    .createShader(bounds),
                child: const Icon(
                  Icons.notifications_active_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                Text(
                  widget.subtitle,
                  style: getTextStyle(
                    fontSize: 11,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _enabled,
            activeThumbColor: widget.themeController.activeTheme.accentGoldColor,
            onChanged: (val) async {
              setState(() => _enabled = val);
              await NotificationService.toggleReminder(val);
            },
          ),
        ],
      ),
    );
  }
}

void _showGuildHallPaywall(
  BuildContext context,
  AppThemeController themeController,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: themeController.activeTheme.dropdownBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
          color: themeController.activeTheme.borderColor.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: themeController.activeTheme.accentGoldColor.withValues(
                alpha: 0.15,
              ),
              shape: BoxShape.circle,
            ),
            child: Image.asset(IconPath.discordwhite, width: 32, height: 32),
          ),
          const SizedBox(height: 16),
          Text(
            'Guild Hall Access',
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'The Guild Hall Discord community is an exclusive sanctuary for active subscribers. Subscribe to participate in community challenges, events, and converse with fellow travelers.',
            textAlign: TextAlign.center,
            style: getTextStyle(
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Get.toNamed(AppRoute.mySubscriptionScreen);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeController.activeTheme.accentGoldColor,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'View Membership Plans',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Maybe Later',
              style: TextStyle(color: Colors.white60, fontSize: 13),
            ),
          ),
        ],
      ),
    ),
  );
}
