import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_background2.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/settings/controller/setting_controller.dart';
import 'package:velvet_iron/features/settings/widgets/setting_widget.dart';
import 'package:velvet_iron/features/settings/widgets/weekly_activity_widget.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SettingsController());

    return Scaffold(
      body: CustomBackground2(
        imageAsset: ImagePath.backgroundOne,
        child: SafeArea(
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
                      const WeeklyActivityProgress(title: 'Weekly Activity'),
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
      ),
    );
  }
}
