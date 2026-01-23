// screens/about_training_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_background_withimage.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/about_training_codex/controller/about_training_controller.dart';
import 'package:velvet_iron/features/about_training_codex/widgets/about_training_widget.dart';
import 'package:velvet_iron/features/bottom_nav/screen/bottom_nav.dart';

class AboutTrainingScreen extends StatelessWidget {
  const AboutTrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AboutTrainingController());

    return Scaffold(
      body: CustomBackgroundWithImage(
        imageAsset: ImagePath.magicImage,
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: AboutTrainingAppBar(),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller.scrollController,
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        bottom: 120,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const IntroWidget(),
                          const SizedBox(height: 18),
                          const FounderInfoWidget(),
                          const SizedBox(height: 18),
                          Obx(
                            () => ExpandableSectionsContainer(
                              selectedSection: controller.selectedSection.value,
                              onSectionChanged: controller.selectSection,
                              features: controller.features,
                              partnerFeatures: controller.partnerFeatures,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const IntroSectionWidget(),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: BottomNav(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
