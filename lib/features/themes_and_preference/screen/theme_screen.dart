// profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_background_withimage.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/bottom_nav/screen/bottom_nav.dart';
import 'package:velvet_iron/features/profile/controller/profile_controller.dart';
import 'package:velvet_iron/features/themes_and_preference/widgets/themes_preference_widgets.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize Profile Controller
    Get.put(ProfileController());

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
                    child: const ThemesPreferenceAppBar(),
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
                        ]
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
