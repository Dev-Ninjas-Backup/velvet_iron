import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class OnboardingController1 extends GetxController {
  final selectedIndex = Rxn<int>();
  final currentStep = 2.obs;
  final totalSteps = 11.obs;
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
      EasyLoading.showInfo('Requires ${companions[index].unlockXp} XP');
    }
  }

  bool isCompanionUnlocked(int index) {
    final companion = companions[index];
    if (companion.unlockXp == null) return true;
    return companion.isActive || xpPoints.value >= companion.unlockXp!;
  }

  Future<void> onContinue() async {
    if (selectedIndex.value != null) {
      final selected = companions[selectedIndex.value!];

      EasyLoading.show(status: 'Binding soul with ${selected.name}...');
      await Future.delayed(const Duration(milliseconds: 1000));

      EasyLoading.dismiss();

      Get.toNamed(AppRoute.getonboadingScreen2());
    } else {
      EasyLoading.showInfo('Please select a companion');
    }
  }

  void unlockCompanion(int index) {
    final companion = companions[index];
    if (companion.unlockXp != null && xpPoints.value >= companion.unlockXp!) {
      EasyLoading.show(status: 'Unlocking...');

      xpPoints.value -= companion.unlockXp!;
      companion.isActive = true;
      companions.refresh();
      EasyLoading.showSuccess('${companion.name} Unlocked!');
      selectCompanion(index);
    } else {
      EasyLoading.showError('Insufficient XP');
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
