import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';

class ProfileController extends GetxController {
  final fullName = 'Jamie Friddle'.obs;
  final username = 'jamie'.obs;
  final email = 'jamiefriddle123@gmail.com'.obs;
  final password = '************'.obs;
  final profileImage = ImagePath.profile.obs;

  late TextEditingController fullNameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();

    fullNameController = TextEditingController(text: fullName.value);
    usernameController = TextEditingController(text: username.value);
    passwordController = TextEditingController(text: password.value);
    emailController = TextEditingController(text: email.value);

    fullNameController.addListener(() {
      fullName.value = fullNameController.text;
    });
    usernameController.addListener(() {
      username.value = usernameController.text;
    });
    passwordController.addListener(() {
      password.value = passwordController.text;
    });
    emailController.addListener(() {
      email.value = emailController.text;
    });
  }

  @override
  void onClose() {
    fullNameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        profileImage.value = image.path;
        Get.snackbar(
          'Success',
          'Profile image updated',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Save changes
  void saveChanges() {
    // Validate inputs
    if (fullNameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your full name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (usernameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your username',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (passwordController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Update observable values
    fullName.value = fullNameController.text;
    username.value = usernameController.text;
    password.value = passwordController.text;

    Get.snackbar(
      'Success',
      'Profile updated successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withValues(alpha: 0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}
