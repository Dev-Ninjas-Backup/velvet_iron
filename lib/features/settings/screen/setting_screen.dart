import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/settings/controller/setting_controller.dart';
import 'package:velvet_iron/features/settings/widgets/general_setting_item.dart';
import 'package:velvet_iron/features/settings/widgets/setting_widget.dart';
import 'package:velvet_iron/features/settings/widgets/upcoming_widgets.dart';
import 'package:velvet_iron/features/settings/widgets/user_profile.dart';
import 'package:velvet_iron/features/settings/widgets/weekly_activity_widget.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SettingsController());

    return GetBuilder<AppThemeController>(
      builder: (themeController) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: themeController.activeTheme.backgroundGradient,
                ),
              ),
              Opacity(
                opacity: 0.2,
                child: Image.asset(
                  themeController.activeTheme.backgroundImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SettingsAppBar(),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 20,
                          bottom: 90,
                        ),
                        child: Column(
                          children: [
                            const UserProfileWidget(),
                            const SizedBox(height: 20),
                            const UpcomingLogWidget(),
                            const SizedBox(height: 20),
                            const WeeklyActivityProgress(
                              title: 'Weekly Activity',
                            ),
                            const SizedBox(height: 20),
                            const GeneralSettingsWidget(),
                            const SizedBox(height: 22),
                            const LogoutWidget(),
                            const SizedBox(height: 20),
                            const AppVersionWidget(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
