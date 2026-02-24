import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding2/model/profile_update_response_model.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding2/services/onboarding2_service.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class Onboarding2Controller extends GetxController {
  final selectedIndex = Rxn<int>();
  final currentStep = 3.obs;
  final totalSteps = 11.obs;
  final xpPoints = 10.obs;
  final Rxn<File> profileImage = Rxn<File>();
  final nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final Onboarding2Service _onboarding2Service = Onboarding2Service();
  double get progressValue => currentStep.value / totalSteps.value;

  void onBackPressed() {
    Get.back();
  }

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);

        EasyLoading.showSuccess('Image uploaded!');
      }
    } catch (e) {
      EasyLoading.showError('Failed to pick image');
    }
  }

  void onContinue() async {
    if (nameController.text.trim().isEmpty) {
      EasyLoading.showInfo('Please enter your name');
      return;
    }
    EasyLoading.show(status: 'Recording your legend...');

    final response = await _onboarding2Service.updateProfile(
      username: nameController.text.trim(),
      profilePhoto: profileImage.value,
    );

    if (response.isSuccess) {
      final profileResponse = ProfileUpdateResponseModel.fromJson(
        response.responseData,
      );
      EasyLoading.showSuccess(
        profileResponse.message.isNotEmpty
            ? profileResponse.message
            : 'Profile saved Successfully',
      );
      Get.toNamed(AppRoute.getonboardingScreen3());
    } else {
      EasyLoading.showError(response.errorMessage);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
