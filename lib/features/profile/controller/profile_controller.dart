import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';

class ProfileController extends GetxController {
  final fullName = 'Jamie Friddle'.obs;
  final username = 'jamiefriddle123@gmail.com'.obs;
  final usernameHandle = 'jamiefriddle123'.obs;
  final profileImage = ImagePath.profile.obs;

  late TextEditingController fullNameController;
  late TextEditingController usernameController;

  final ImagePicker _picker = ImagePicker();

  // gender selection

  final selectedGender = RxnInt();

  final List<String> genders = ['Male', 'Female', 'Non-binary'];

  void selectGender(int index) {
    selectedGender.value = index;
  }

  // date of birth selection

  final selectedDay = '08'.obs;
  final selectedMonth = 'January'.obs;
  final selectedYear = '1999'.obs;

  final List<String> days = List.generate(
    31,
    (index) => (index + 1).toString().padLeft(2, '0'),
  );

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final List<String> years = List.generate(
    100,
    (index) => (DateTime.now().year - index).toString(),
  );

  @override
  void onInit() {
    super.onInit();

    fullNameController = TextEditingController(text: fullName.value);
    usernameController = TextEditingController(text: username.value);

    fullNameController.addListener(() {
      fullName.value = fullNameController.text;
    });
    usernameController.addListener(() {
      username.value = usernameController.text;
    });
  }

  @override
  void onClose() {
    fullNameController.dispose();
    usernameController.dispose();
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

    // Update observable values
    fullName.value = fullNameController.text;
    username.value = usernameController.text;

    Get.snackbar(
      'Success',
      'Profile updated successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withValues(alpha: 0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  // gender selection

  void onContinue() {
    if (selectedGender.value == null) {
      Get.snackbar(
        'Required',
        'Please select your gender',
        backgroundColor: Colors.orange.withValues(alpha: 0.7),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.snackbar(
      'Success',
      'Gender selected',
      backgroundColor: Colors.green.withValues(alpha: 0.7),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
