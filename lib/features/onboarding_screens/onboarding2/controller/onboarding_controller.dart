import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Onboarding2Controller extends GetxController {
  final selectedIndex = Rxn<int>();  
  final currentStep = 3.obs;
  final totalSteps = 11.obs;  
  final xpPoints = 10.obs; 
  final Rxn<File> profileImage = Rxn<File>();  
  final nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker(); 
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
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        backgroundColor: Colors.red.withValues(alpha: 0.7),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void onContinue() {
   
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter your name',
        backgroundColor: Colors.orange.withValues(alpha: 0.7),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    Get.snackbar(
      'Success',
      'Profile saved! +${xpPoints.value} XP',
      backgroundColor: Colors.green.withValues(alpha: 0.7),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
