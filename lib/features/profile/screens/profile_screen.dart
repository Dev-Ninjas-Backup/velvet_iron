import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_background2.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/bottom_nav/screen/bottom_nav.dart';
import 'package:velvet_iron/features/profile/controller/profile_controller.dart';
import 'package:velvet_iron/features/profile/widgets/profile_widget.dart';
import 'package:velvet_iron/features/profile/widgets/update_Information_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize Profile Controller
    Get.put(ProfileController());

    return Scaffold(
      body: CustomBackground2(
        imageAsset: ImagePath.backgroundOne,
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: const ProfileAppBar(),
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
                          const ProfileWidget(),
                          const SizedBox(height: 20),
                          UpdateInformationWidget(),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: CustomButton(
                              label: 'Save Changes',
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: -20,
                child: const BottomNav(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
