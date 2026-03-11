// ignore_for_file: avoid_print

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/onboarding_screens/theme_onboading/model/theme_onboarding_model.dart';
import 'package:velvet_iron/features/onboarding_screens/theme_onboading/service/theme_onboarding_service.dart';
import 'package:velvet_iron/routes/app_routes.dart';

class ThemeOnboardingController extends GetxController {
  final currentStep = 1.obs;
  final totalSteps = 11.obs;
  final xpPoints = 10.obs;

  final selectedThemeIndex = (-1).obs;
  final selectedThemeId = ''.obs;

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
    if (index >= 0 && index < themesList.length) {
      selectedThemeId.value = themesList[index].id;
    }

    final globalTheme = Get.find<AppThemeController>();
    globalTheme.selectTheme(index);
  }

  void selectThemeById(String themeId) {
    selectedThemeId.value = themeId;
    // Find the corresponding theme by ID in API response
    final apiTheme = themesList.firstWhereOrNull((t) => t.id == themeId);

    if (apiTheme != null) {
      // Find the index in themesList
      final themeIndex = themesList.indexOf(apiTheme);
      if (themeIndex != -1) {
        selectedThemeIndex.value = themeIndex;
      }
      // Select in AppThemeController by theme name
      final globalTheme = Get.find<AppThemeController>();
      globalTheme.selectThemeByName(apiTheme.name);
    }
  }

  Future<void> onContinuePressed() async {
    try {
      EasyLoading.show(status: 'Saving Choice');

      final themeId = selectedThemeId.value;
      if (themeId.isEmpty) {
        EasyLoading.showError('Please select a theme');
        return;
      }
      final result = await _service.unlockTheme(themeId);

      if (result['success'] == true) {
        EasyLoading.showSuccess(
          result['message'] ?? 'Theme unlocked and activated!',
        );
        try {
          // Find theme name from API response
          final selectedTheme = themesList.firstWhere(
            (t) => t.id == themeId,
            orElse: () => themesList.first,
          );

          final appThemeController = Get.find<AppThemeController>();
          // Select by theme name
          appThemeController.selectThemeByName(selectedTheme.name);

          // Save both the UUID and the theme name for recovery
          await SharedPreferencesHelper.saveActiveThemeId(themeId);
          await SharedPreferencesHelper.saveActiveThemeName(selectedTheme.name);

          print('Theme activated: ${selectedTheme.name}');
        } catch (e) {
          print('Error activating theme: $e');
        }

        Get.toNamed(AppRoute.getonboadingScreen1());
      } else {
        EasyLoading.showError(result['message'] ?? 'Failed to unlock theme.');
      }
    } finally {
      EasyLoading.dismiss();
    }
  }
}
