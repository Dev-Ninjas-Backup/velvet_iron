import 'package:get/get.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/core/utils/app_theme/model/app_theme_model.dart';
import 'package:velvet_iron/features/onboarding_screens/theme_onboading/service/theme_onboarding_service.dart';

class AppThemeController extends GetxController {
  final Rx<AppThemeModel?> currentTheme = Rx<AppThemeModel?>(null);

  final RxInt selectedThemeIndex = (-1).obs;

  final List<AppThemeModel> themes = AppThemeModel.getAllThemes();
  final ThemeOnboardingService _themeService = ThemeOnboardingService();

  @override
  void onInit() {
    super.onInit();
    _loadActiveTheme();
  }

  /// Load the active theme from API or local storage
  Future<void> _loadActiveTheme() async {
    try {
      // Try to fetch themes from API to get the active one
      final response = await _themeService.fetchMyThemes();
      if (response != null && response.themes.isNotEmpty) {
        // Find the active theme from API response
        final activeThemeFromApi = response.themes.firstWhere(
          (theme) => theme.isActive,
          orElse: () => response.themes.first,
        );

        // Find matching theme by name and select it
        final themeIndex = themes.indexWhere(
          (t) => t.name.toLowerCase() == activeThemeFromApi.name.toLowerCase(),
        );

        if (themeIndex != -1) {
          selectTheme(themeIndex);
          // Save the active theme ID locally
          await SharedPreferencesHelper.saveActiveThemeId(
            activeThemeFromApi.id,
          );
          return;
        }
      }

      // Fallback: load from local storage
      final savedThemeId = await SharedPreferencesHelper.getActiveThemeId();
      if (savedThemeId != null && savedThemeId.isNotEmpty) {
        // Themes don't have IDs in AppThemeModel, so use index-based approach
        // Just select the first theme from saved context
        selectTheme(0);
      } else {
        // Default to first theme
        selectTheme(0);
      }
    } catch (e) {
      // Fallback to default theme on error
      selectTheme(0);
    }
  }

  void selectTheme(int index) {
    if (index >= 0 && index < themes.length) {
      selectedThemeIndex.value = index;
      currentTheme.value = themes[index];
      update();
    }
  }

  AppThemeModel get activeTheme =>
      currentTheme.value ?? AppThemeModel.adventurerTheme;

  bool isThemeSelected(int index) => selectedThemeIndex.value == index;
}
