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
    // Load theme from API or local storage
    _loadActiveTheme();
  }

  /// Initialize and load the active theme
  /// Call this whenever auth state changes (login/logout/app start)
  Future<void> initializeTheme() async {
    await _loadActiveTheme();
  }

  /// Reload the active theme from API or local storage
  /// Use this when auth state changes or user returns to app
  Future<void> reloadTheme() async {
    // ignore: avoid_print
    print('Reloading theme...');
    await _loadActiveTheme();
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
          // Save both the UUID and theme name
          await SharedPreferencesHelper.saveActiveThemeId(
            activeThemeFromApi.id,
          );
          await SharedPreferencesHelper.saveActiveThemeName(
            activeThemeFromApi.name,
          );
          return;
        }
      }

      // Fallback: load from local storage by theme name
      final savedThemeName = await SharedPreferencesHelper.getActiveThemeName();
      if (savedThemeName != null && savedThemeName.isNotEmpty) {
        // Find the hardcoded theme by name
        final themeIndex = themes.indexWhere(
          (t) => t.name.toLowerCase() == savedThemeName.toLowerCase(),
        );
        if (themeIndex != -1) {
          selectTheme(themeIndex);
          return;
        }
      }

      // Default to first theme
      selectTheme(0);
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

  void selectThemeByName(String themeName) {
    final themeIndex = themes.indexWhere(
      (t) => t.name.toLowerCase() == themeName.toLowerCase(),
    );
    if (themeIndex != -1) {
      selectTheme(themeIndex);
    }
  }

  void selectThemeById(String themeId) {
    // This method now acts as an alias for backward compatibility
    // It treats the ID as a theme name (since hardcoded themes use short names as IDs)
    selectThemeByName(themeId);
  }

  AppThemeModel get activeTheme =>
      currentTheme.value ?? AppThemeModel.adventurerTheme;

  bool isThemeSelected(int index) => selectedThemeIndex.value == index;
}
