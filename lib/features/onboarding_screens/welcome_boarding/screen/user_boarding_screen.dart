import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:velvet_iron/core/common/widgets/custom_background_withimage.dart';
import 'package:velvet_iron/core/common/widgets/custom_button_two.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/onboarding_screens/welcome_boarding/controller/user_boarding_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/welcome_boarding/widgets/user_boarding_widget.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(WelcomeController());

    return Scaffold(
      body: CustomBackgroundWithImage(
        imageAsset: ImagePath.magicImage,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 285),
                const WelcomeTitle(),
                const SizedBox(height: 24),
                const WelcomeDescription(),
                const SizedBox(height: 40),
                CustomButtonTwo(
                  label: "Continue Journey",
                  onPressed: () =>
                      Get.toNamed(AppRoute.getthemeOnboardingScreen()),
                ),

                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
