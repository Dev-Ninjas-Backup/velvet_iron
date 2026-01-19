// profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_background_withimage.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/bottom_nav/screen/bottom_nav.dart';
import 'package:velvet_iron/features/daily_macro_goal/controller/daily_goal_controller.dart';
import 'package:velvet_iron/features/daily_macro_goal/widgets/daily_goal_widget.dart';

class DailyGoalScreen extends StatelessWidget {
  const DailyGoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DailyGoalController());

    return Scaffold(
      body: CustomBackgroundWithImage(
        imageAsset: ImagePath.magicImage,
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: const DailyGoalAppBar(),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 20,
                        bottom: 120,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          const DailyMacroGoalWidget(),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: CustomButton(
                              label: 'Save Changes',
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: const BottomNav(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
