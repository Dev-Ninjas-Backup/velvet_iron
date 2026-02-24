import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/theme_onboading/model/theme_onboarding_model.dart';
import 'package:velvet_iron/features/onboarding_screens/theme_onboading/service/theme_onboarding_service.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class ThemeOnboardingController extends GetxController {
  final currentStep = 1.obs;
  final totalSteps = 11.obs;
  final xpPoints = 10.obs;

  final selectedThemeIndex = 0.obs;

  var isLoading = true.obs;
  var themesList = <ThemeModel>[].obs;
  var userLevel = 1.obs;
  var unlockedThemesCount = 0.obs;

  double get progressValue => currentStep.value / totalSteps.value;
  final ThemeOnboardingService _service = ThemeOnboardingService();

  @override
  void onInit() {
    super.onInit();
    fetchThemesFromApi();
  }

  Future<void> fetchThemesFromApi() async {
    try {
      isLoading(true);
      var response = await _service.fetchMyThemes();
      if (response != null) {
        themesList.assignAll(response.themes);
      }
    } finally {
      isLoading(false);
    }
  }

  void selectTheme(int index) {
    selectedThemeIndex.value = index;

    final globalTheme = Get.find<AppThemeController>();

    globalTheme.selectTheme(index);
  }

  Future<void> onContinuePressed() async {
    try {
      EasyLoading.show(status: 'Saving Choice');

      final index = selectedThemeIndex.value;
      if (index < 0 || index >= themesList.length) {
        EasyLoading.showError('Please select a theme');
        return;
      }
      final themeId = themesList[index].id;
      final success = await _service.unlockTheme(themeId);

      if (success) {
        EasyLoading.showSuccess('Theme unlocked and activated!');
        Get.toNamed(AppRoute.getonboadingScreen1());
      } else {
        EasyLoading.showError('Failed to unlock theme.');
      }
    } finally {
      EasyLoading.dismiss();
    }
  }
}
