import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/widgets/custom_background2.dart';
import 'package:velvet_iron/core/common/widgets/custom_button.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/update_password/controller/update_password_controller.dart';
import 'package:velvet_iron/features/update_password/widgets/update_password_widget.dart';
import 'package:velvet_iron/features/update_password/widgets/update_password_form.dart';

class UpdatePasswordScreen extends StatelessWidget {
  const UpdatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UpdatePasswordController());

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
                        child: const UpdatePasswordAppBar(),
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
                              const UpdatePasswordAppBar(),
                              const SizedBox(height: 20),
                              const UpdatePasswordFormWidget(),
                              const SizedBox(height: 40),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: CustomButton(
                                  label: 'Update Password',
                                  onPressed: () => Get.back(),
                                ),
                              ),
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
