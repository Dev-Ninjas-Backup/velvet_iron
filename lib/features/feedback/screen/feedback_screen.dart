import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_background2.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/feedback/controller/feedback_controller.dart';
import 'package:velvet_iron/features/feedback/widgets/feedback_widgets.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FeedbackController());

    return Scaffold(
      body: GetBuilder<AppThemeController>(
        builder: (themeController) {
          return CustomBackground2(
            imageAsset: themeController.activeTheme.backgroundImage,
            child: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: const FeedbackAppBar(),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            bottom: 120,
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              const FeedbackWidget(),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: CustomButton(
                                  label: 'Send Feedback',
                                  onPressed: () {},
                                ),
                              ),
                              const SizedBox(height: 20),
                              const HelpAndSupportWidget(),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
