import 'package:get/get.dart';
import 'package:velvet_iron/features/home/models/home_theme_model.dart';

class ThemeController extends GetxController {
  /// Current selected theme
  final Rx<HomeThemeModel?> currentTheme = Rx<HomeThemeModel?>(null);

  /// Currently selected theme index
  final RxInt selectedThemeIndex = (-1).obs;

  /// Get all available themes
  final List<HomeThemeModel> themes = HomeThemeModel.getAllThemes();

  @override
  void onInit() {
    super.onInit();
    // Load default theme if needed
    selectTheme(0);
  }

  /// Select theme by index
  void selectTheme(int index) {
    if (index >= 0 && index < themes.length) {
      selectedThemeIndex.value = index;
      currentTheme.value = themes[index];
      update(); // Notify GetBuilder listeners
    }
  }

  /// Get selected theme, return default if none selected
  HomeThemeModel get activeTheme =>
      currentTheme.value ?? HomeThemeModel.adventurerTheme;

  /// Check if a theme is currently selected
  bool isThemeSelected(int index) => selectedThemeIndex.value == index;
}
