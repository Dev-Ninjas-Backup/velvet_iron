import 'package:get/get.dart';
import 'package:velvet_iron/features/home/models/home_theme_model.dart';

class ThemeController extends GetxController {
  final Rx<HomeThemeModel?> currentTheme = Rx<HomeThemeModel?>(null);

  final RxInt selectedThemeIndex = (-1).obs;

  final List<HomeThemeModel> themes = HomeThemeModel.getAllThemes();

  @override
  void onInit() {
    super.onInit();
    selectTheme(0);
  }

  void selectTheme(int index) {
    if (index >= 0 && index < themes.length) {
      selectedThemeIndex.value = index;
      currentTheme.value = themes[index];
      update(); 
    }
  }

  HomeThemeModel get activeTheme =>
      currentTheme.value ?? HomeThemeModel.adventurerTheme;

  bool isThemeSelected(int index) => selectedThemeIndex.value == index;
}
