import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';

class OnboardingController1 extends GetxController {
  final selectedIndex = Rxn<int>();
  final currentStep = 1.obs;
  final totalSteps = 9.obs;
  final xpPoints = 10.obs;

  double get progressValue => currentStep.value / totalSteps.value;

  final companions = <CompanionModel>[
    CompanionModel(
      id: 0,
      name: 'Ser Kael Thornwatch',
      title: 'The Unknown',
      description: 'Stand tall. We finish what we start — together.',
      theme: 'Active Theme & Companion',
      unlockXp: null,
      imagePath: ImagePath.serkael,
      bgImage: IconPath.serIcon,
      isActive: true,
      bgGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF310101),
          Color(0xFF550606),
          Color(0xFF550606),
          Color(0xFF310101),
          Color(0xFF550606),
          Color(0xFF310101),
        ],
      ),
    ),
    CompanionModel(
      id: 1,
      name: 'Riven Ashcroft',
      title: 'High Lord of the Fall',
      theme: '',
      description:
          '“Try not to disappoint me… I was just starting to enjoy your potential.”',
      unlockXp: 250,
      imagePath: ImagePath.riven,
      bgImage: IconPath.serIcon,
      isActive: false,
      bgGradient: const LinearGradient(
        colors: [
          Color(0xFF310101),
          Color(0xFF550606),
          Color(0xFF550606),
          Color(0xFF310101),
          Color(0xFF550606),
          Color(0xFF310101),
        ],
      ),
    ),
    CompanionModel(
      id: 2,
      name: 'Pyraxis',
      title: 'The Emberhound',
      description:
          '“Rise, little warrior. I don’t guard the weak — I forge the strong.”',
      theme: '',
      unlockXp: 250,
      imagePath: ImagePath.pyrax,
      bgImage: IconPath.serIcon,
      isActive: false,
      bgGradient: const LinearGradient(
        colors: [
          Color(0xFF310101),
          Color(0xFF550606),
          Color(0xFF550606),
          Color(0xFF310101),
          Color(0xFF550606),
          Color(0xFF310101),
        ],
      ),
    ),
    CompanionModel(
      id: 3,
      name: 'Bram Ironledger',
      title: 'Keeper of the Codex',
      theme: '',
      description:
          '“Every hero stumbles, child. What matters is that you rise wiser.”',
      unlockXp: 250,
      imagePath: ImagePath.bram,
      bgImage: IconPath.serIcon,
      isActive: false,
      bgGradient: const LinearGradient(
        colors: [
          Color(0xFF310101),
          Color(0xFF550606),
          Color(0xFF550606),
          Color(0xFF310101),
          Color(0xFF550606),
          Color(0xFF310101),
        ],
      ),
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();

    selectedIndex.value = 0;
  }

  void selectCompanion(int index) {
    if (isCompanionUnlocked(index)) {
      selectedIndex.value = index;
    } else {
      Get.snackbar(
        'Locked',
        'This companion requires ${companions[index].unlockXp} XP to unlock',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.7),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  bool isCompanionUnlocked(int index) {
    final companion = companions[index];
    if (companion.unlockXp == null) return true;
    return companion.isActive || xpPoints.value >= companion.unlockXp!;
  }

  void onContinue() {
    if (selectedIndex.value != null) {
      final selected = companions[selectedIndex.value!];

      Get.snackbar(
        'Companion Selected',
        'You have chosen ${selected.name}!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.7),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } else {
      Get.snackbar(
        'No Selection',
        'Please select a companion first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withValues(alpha: 0.7),
        colorText: Colors.white,
      );
    }
  }

  void unlockCompanion(int index) {
    final companion = companions[index];
    if (companion.unlockXp != null && xpPoints.value >= companion.unlockXp!) {
      xpPoints.value -= companion.unlockXp!;
      companion.isActive = true;
      companions.refresh();

      Get.snackbar(
        'Unlocked!',
        '${companion.name} is now unlocked',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.7),
        colorText: Colors.white,
      );
      selectCompanion(index);
    } else {
      Get.snackbar(
        'Insufficient XP',
        'You need ${companion.unlockXp} XP to unlock this companion',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.7),
        colorText: Colors.white,
      );
    }
  }

  // Go back
  void onBackPressed() {
    Get.back();
  }
}

// Companion Model
class CompanionModel {
  final int id;
  final String name;
  final String title;
  final String description;
  final String theme;
  final int? unlockXp;
  final String imagePath;
  final String bgImage;
  bool isActive;
  final LinearGradient bgGradient;

  CompanionModel({
    required this.id,
    required this.name,
    required this.title,
    this.description = '',
    required this.theme,
    this.unlockXp,
    required this.imagePath,
    required this.bgImage,
    required this.isActive,
    required this.bgGradient,
  });
}
