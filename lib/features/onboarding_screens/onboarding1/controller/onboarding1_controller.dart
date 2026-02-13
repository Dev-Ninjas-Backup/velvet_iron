import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/core/utils/constants/image_path.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding1/model/companion_model.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class OnboardingController1 extends GetxController {
  final selectedIndex = Rxn<int>();
  final currentStep = 2.obs;
  final totalSteps = 11.obs;

  double get progressValue => currentStep.value / totalSteps.value;

  final companions = <CompanionModel>[
    CompanionModel(
      id: 0,
      name: 'Ser Kael Thornwatch',
      title: 'The Unknown',
      description: 'Stand tall. We finish what we start — together.',
      theme: 'Active Theme & Companion',
      imagePath: ImagePath.serkael,
      bgImage: IconPath.serIcon,
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
          '"Try not to disappoint me… I was just starting to enjoy your potential."',
      imagePath: ImagePath.riven,
      bgImage: IconPath.serIcon,
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
          '"Rise, little warrior. I do not guard the weak — I forge the strong."',
      theme: '',
      imagePath: ImagePath.pyrax,
      bgImage: IconPath.serIcon,
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
          '"Every hero stumbles, child. What matters is that you rise wiser."',
      imagePath: ImagePath.bram,
      bgImage: IconPath.serIcon,
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
    selectedIndex.value = index;
    update();
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

  void onBackPressed() {
    Get.back();
  }
}
