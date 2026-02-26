import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/daily_macro_goal/controller/daily_goal_controller.dart';
import 'package:velvet_iron/features/daily_macro_goal/widgets/daily_goal_widget.dart';
import 'package:velvet_iron/features/daily_macro_goal/widgets/daily_marco_goal.dart';

class DailyGoalScreen extends StatelessWidget {
  const DailyGoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DailyGoalController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GetBuilder<AppThemeController>(
        builder: (themeController) {
          return Stack(
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: CustomButton(
                                label: 'Save Changes',
                                onPressed: controller.saveGoals,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
