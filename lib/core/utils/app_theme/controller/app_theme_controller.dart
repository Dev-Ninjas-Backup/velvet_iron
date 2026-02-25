import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/app_theme/model/app_theme_model.dart';

class AppThemeController extends GetxController {
  final Rx<AppThemeModel?> currentTheme = Rx<AppThemeModel?>(null);

  final RxInt selectedThemeIndex = (-1).obs;

  final List<AppThemeModel> themes = AppThemeModel.getAllThemes();

  @override
  void onInit() {
    super.onInit();
    selectTheme(-1);
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
