import 'package:get/get.dart';
import 'package:velvet_iron/features/themes_and_preference/model/theme_model.dart';
import 'package:velvet_iron/features/themes_and_preference/model/companion_model.dart';

class ThemesController extends GetxController {
  // index of selected theme
  final RxInt selectedThemeIndex = 0.obs;
  final RxInt selectedCompanionIndex = 0.obs;

  // sample data - UI widgets can render from these models
  final RxList<ThemeModel> themes = <ThemeModel>[].obs;
  final RxList<CompanionModel> companions = <CompanionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadSampleData();
  }

  void _loadSampleData() {
    themes.assignAll([
      ThemeModel(
        id: 'adventurer',
        title: 'Adventurer',
        badgeText: 'Active Now',
        subtitle: '"Discipline is the blade — sharpen it daily."',
        gradientColors: [0xFF310101, 0xFF550606, 0xFF9E6D38],
        iconPath: 'assets/icons/goldencircle.png',
        locked: false,
      ),
      ThemeModel(
        id: 'mage',
        title: 'Mage',
        badgeText: 'Unlock 250 xp',
        subtitle: null,
        gradientColors: [0xFF1B0033, 0xFF35065E, 0xFFBE32FF],
        iconPath: 'assets/icons/lock.png',
        locked: true,
      ),
      ThemeModel(
        id: 'reader',
        title: 'Reader',
        badgeText: 'Unlock 250 xp',
        subtitle: null,
        gradientColors: [0xFF00027B, 0xFF292CB7, 0xFF3385FF],
        iconPath: 'assets/icons/lock.png',
        locked: true,
      ),
      ThemeModel(
        id: 'gamer',
        title: 'Gamer',
        badgeText: 'Unlock 250 xp',
        subtitle: null,
        gradientColors: [0xFF111C18, 0xFF1E332C, 0xFFE7C143],
        iconPath: 'assets/icons/lock.png',
        locked: true,
      ),
    ]);

    companions.assignAll([
      CompanionModel(
        id: 'serkael',
        name: 'Ser Kael Thornwatch',
        avatarPath: 'assets/images/character_two.png',
        leadingIconPath: 'assets/icons/goldencircle.png',
        locked: false,
      ),
    ]);
  }

  void selectTheme(int index) {
    if (index >= 0 && index < themes.length && !themes[index].locked) {
      selectedThemeIndex.value = index;
    }
  }

  void selectCompanion(int index) {
    if (index >= 0 && index < companions.length && !companions[index].locked) {
      selectedCompanionIndex.value = index;
    }
  }

  ThemeModel get selectedTheme => themes[selectedThemeIndex.value];
  CompanionModel get selectedCompanion =>
      companions[selectedCompanionIndex.value];
}
