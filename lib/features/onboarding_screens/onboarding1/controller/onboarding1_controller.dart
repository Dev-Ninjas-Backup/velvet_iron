import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding1/model/companion_model.dart';
import 'package:velvet_iron/features/onboarding_screens/onboarding1/service/onboarding1_service.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class OnboardingController1 extends GetxController {
  final selectedIndex = Rxn<int>();
  final currentStep = 2.obs;
  final totalSteps = 11.obs;
  final isLoading = false.obs;

  final companions = <CompanionModel>[].obs;

  final _service = Onboarding1Service();

  double get progressValue => currentStep.value / totalSteps.value;

  @override
  void onInit() {
    super.onInit();
    fetchCompanions();
  }

  Future<void> fetchCompanions() async {
    try {
      isLoading.value = true;

      final data = await _service.fetchMyCompanions();

      if (data != null && data['companions'] != null) {
        final List list = data['companions'];

        companions.assignAll(
          list.map((json) {
            final name = json['name'] ?? '';
            return CompanionModel.fromJson(
              json,
              imagePath: CompanionModel.getImagePath(name),
              bgImage: IconPath.serIcon,
              bgGradient: CompanionModel.getGradient(name),
              theme: list.indexOf(json) == 0 ? 'Active Theme & Companion' : '',
            );
          }).toList(),
        );

        selectedIndex.value = -1;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load companions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectCompanion(int index) {
    selectedIndex.value = index;
    update();
  }

  Future<void> onContinue() async {
    if (selectedIndex.value == null) {
      EasyLoading.showInfo('Please select a companion');
      return;
    }

    final selected = companions[selectedIndex.value!];

    try {
      EasyLoading.show(status: 'Binding soul with ${selected.name}...');

      final success = await _service.unlockCompanion(selected.id);

      if (success) {
        Get.toNamed(AppRoute.getonboadingScreen2());
      } else {
        Get.snackbar('Error', 'Could not bind companion. Try again.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  void onBackPressed() {
    Get.back();
  }
}
