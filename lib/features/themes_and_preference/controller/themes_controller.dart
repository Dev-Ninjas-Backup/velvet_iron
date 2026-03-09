import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/themes_and_preference/model/theme_model.dart';
import 'package:velvet_iron/features/themes_and_preference/model/companion_model.dart';
import 'package:velvet_iron/features/themes_and_preference/service/themes_service.dart';
import 'package:velvet_iron/features/themes_and_preference/service/companions_service.dart';

class ThemesController extends GetxController {
  // index of selected theme
  final RxInt selectedThemeIndex = 0.obs;
  final RxInt selectedCompanionIndex = 0.obs;

  // sample data - UI widgets can render from these models
  final RxList<ThemeModel> themes = <ThemeModel>[].obs;
  final RxList<CompanionModel> companions = <CompanionModel>[].obs;

  final ThemesService _themesService = ThemesService();
  final CompanionsService _companionsService = CompanionsService();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemesFromApi();
    _loadCompanionsFromApi();
  }

  Future<void> _loadThemesFromApi() async {
    try {
      isLoading.value = true;
      final result = await _themesService.fetchThemes();

      if (result.isSuccess && result.data != null) {
        final apiThemes = result.data!.themes;

        ThemeData _findApi(String name) => apiThemes.firstWhere(
          (t) => t.name.toLowerCase() == name.toLowerCase(),
          orElse: () => ThemeData(
            id: '',
            name: name,
            isActive: false,
            isUnlocked: false,
            tagline: '',
            description: '',
            unlockXp: 250,
          ),
        );

        // Map API data to ThemeModel with unlock status
        final mappedThemes = [
          _buildThemeModel('adventurer', 'Adventurer', [
            0xFF310101,
            0xFF550606,
            0xFF9E6D38,
          ], _findApi('adventurer')),
          _buildThemeModel('mage', 'Mage', [
            0xFF1B0033,
            0xFF35065E,
            0xFFBE32FF,
          ], _findApi('mage')),
          _buildThemeModel('reader', 'Reader', [
            0xFF00027B,
            0xFF292CB7,
            0xFF3385FF,
          ], _findApi('reader')),
          _buildThemeModel('gamer', 'Gamer', [
            0xFF111C18,
            0xFF1E332C,
            0xFFE7C143,
          ], _findApi('gamer')),
        ];

        themes.assignAll(mappedThemes);

        // Find and select the active theme
        final activeThemeIndex = mappedThemes.indexWhere((t) {
          final apiTheme = apiThemes.firstWhere(
            (api) => api.name.toLowerCase() == t.title.toLowerCase(),
            orElse: () => ThemeData(
              id: '',
              name: '',
              isActive: false,
              isUnlocked: false,
              tagline: '',
              description: '',
              unlockXp: 0,
            ),
          );
          return apiTheme.isActive;
        });

        if (activeThemeIndex != -1) {
          selectedThemeIndex.value = activeThemeIndex;
        }
      } else {
        // Fallback to sample data on error
        _loadSampleData();
      }
    } catch (e) {
      print('Error loading themes: $e');
      _loadSampleData();
    } finally {
      isLoading.value = false;
    }
  }

  ThemeModel _buildThemeModel(
    String id,
    String title,
    List<int> gradientColors,
    ThemeData apiData,
  ) {
    return ThemeModel(
      id: id,
      apiId: apiData.id,
      title: title,
      badgeText: _getBadgeText(apiData),
      subtitle: _getSubtitle(apiData),
      gradientColors: gradientColors,
      iconPath: apiData.isActive
          ? 'assets/icons/goldencircle.png'
          : apiData.isUnlocked
          ? 'assets/icons/goldencircle.png'
          : 'assets/icons/lock.png',
      locked: !apiData.isUnlocked,
    );
  }

  String _getBadgeText(ThemeData themeData) {
    if (themeData.isActive) {
      return 'Active Now';
    }
    if (themeData.isUnlocked) {
      return 'Activate';
    }
    return 'Unlock ${themeData.unlockXp} xp';
  }

  String? _getSubtitle(ThemeData themeData) {
    if (themeData.isActive) {
      return '"Discipline is the blade — sharpen it daily."';
    }
    return null;
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
  }

  Future<void> _loadCompanionsFromApi() async {
    try {
      final result = await _companionsService.fetchCompanions();

      if (result.isSuccess && result.data != null) {
        final apiCompanions = result.data!.companions;

        // Map companion data based on unlock status
        final companionModels = _mapCompanionData(apiCompanions);
        companions.assignAll(companionModels);

        // Find and select the active companion
        final activeCompanionIndex = companionModels.indexWhere((c) {
          final apiCompanion = apiCompanions.firstWhere(
            (api) => api.name.toLowerCase() == c.name.toLowerCase(),
            orElse: () => CompanionData(
              id: '',
              name: '',
              title: '',
              quote: '',
              isActive: false,
              isUnlocked: false,
              unlockXp: 0,
            ),
          );
          return apiCompanion.isActive;
        });

        if (activeCompanionIndex != -1) {
          selectedCompanionIndex.value = activeCompanionIndex;
        }
      } else {
        _loadSampleCompanions();
      }
    } catch (e) {
      print('Error loading companions: $e');
      _loadSampleCompanions();
    }
  }

  List<CompanionModel> _mapCompanionData(List<CompanionData> apiCompanions) {
    final companionMap = {
      'Ser Kael Thornwatch': 'assets/images/charecter_one.png',
      'Riven Ashcroft': 'assets/images/charecter_two.png',
      'Pyraxis': 'assets/images/charecter_three.png',
      'Bram Ironledger': 'assets/images/charecter_four.png',
    };

    return apiCompanions.map((companion) {
      return CompanionModel(
        id: companion.id,
        apiId: companion.id,
        name: companion.name,
        avatarPath: companionMap[companion.name] ?? 'assets/images/serkael.png',
        leadingIconPath: companion.isActive
            ? 'assets/icons/goldencircle.png'
            : companion.isUnlocked
            ? 'assets/icons/goldencircle.png'
            : 'assets/icons/lock.png',
        locked: !companion.isUnlocked,
      );
    }).toList();
  }

  void _loadSampleCompanions() {
    companions.assignAll([
      CompanionModel(
        id: 'serkael',
        name: 'Ser Kael Thornwatch',
        avatarPath: 'assets/images/character_two.png',
        leadingIconPath: 'assets/icons/goldencircle.png',
        locked: false,
      ),
      CompanionModel(
        id: 'riven',
        name: 'Riven Ashcroft',
        avatarPath: 'assets/images/character_three.png',
        leadingIconPath: 'assets/icons/lock.png',
        locked: true,
      ),
      CompanionModel(
        id: 'pyraxis',
        name: 'Pyraxis',
        avatarPath: 'assets/images/character_four.png',
        leadingIconPath: 'assets/icons/lock.png',
        locked: true,
      ),
      CompanionModel(
        id: 'bram',
        name: 'Bram Ironledger',
        avatarPath: 'assets/images/character_two.png',
        leadingIconPath: 'assets/icons/lock.png',
        locked: true,
      ),
    ]);
  }

  Future<void> unlockThemeAtIndex(int index) async {
    if (index < 0 || index >= themes.length) return;
    final theme = themes[index];
    if (theme.apiId.isEmpty) {
      EasyLoading.showError('Theme ID not found');
      return;
    }

    try {
      EasyLoading.show(status: 'Unlocking...');
      final result = await _themesService.unlockTheme(theme.apiId);

      if (result['success'] == true) {
        EasyLoading.showSuccess(result['message'] ?? 'Theme unlocked!');
        // Refresh themes from API to get updated state
        await _loadThemesFromApi();
      } else {
        EasyLoading.showError(result['message'] ?? 'Failed to unlock theme');
      }
    } catch (e) {
      EasyLoading.showError('Failed to unlock theme');
    }
  }

  Future<void> activateThemeAtIndex(int index) async {
    if (index < 0 || index >= themes.length) return;
    final theme = themes[index];
    if (theme.locked || theme.apiId.isEmpty) return;

    try {
      EasyLoading.show(status: 'Activating...');
      final result = await _themesService.activateTheme(theme.apiId);

      if (result['success'] == true) {
        EasyLoading.showSuccess('Theme activated!');
        selectedThemeIndex.value = index;

        // Activate in the global AppThemeController
        final appThemeController = Get.find<AppThemeController>();
        final themeIndex = appThemeController.themes.indexWhere(
          (t) => t.name.toLowerCase() == theme.title.toLowerCase(),
        );
        if (themeIndex != -1) {
          appThemeController.selectTheme(themeIndex);
          await SharedPreferencesHelper.saveActiveThemeId(theme.apiId);
        }

        // Refresh themes to update badge states
        await _loadThemesFromApi();
      } else {
        EasyLoading.showError(result['message'] ?? 'Failed to activate theme');
      }
    } catch (e) {
      EasyLoading.showError('Failed to activate theme');
    }
  }

  void selectTheme(int index) {
    if (index >= 0 && index < themes.length && !themes[index].locked) {
      selectedThemeIndex.value = index;
    }
  }

  Future<void> unlockCompanionAtIndex(int index) async {
    if (index < 0 || index >= companions.length) return;
    final companion = companions[index];
    if (companion.apiId.isEmpty) {
      EasyLoading.showError('Companion ID not found');
      return;
    }

    try {
      EasyLoading.show(status: 'Unlocking...');
      final result = await _companionsService.unlockCompanion(companion.apiId);

      if (result['success'] == true) {
        EasyLoading.showSuccess(result['message'] ?? 'Companion unlocked!');
        await _loadCompanionsFromApi();
      } else {
        EasyLoading.showError(
          result['message'] ?? 'Failed to unlock companion',
        );
      }
    } catch (e) {
      EasyLoading.showError('Failed to unlock companion');
    }
  }

  Future<void> activateCompanionAtIndex(int index) async {
    if (index < 0 || index >= companions.length) return;
    final companion = companions[index];
    if (companion.locked || companion.apiId.isEmpty) return;

    try {
      EasyLoading.show(status: 'Activating...');
      final result = await _companionsService.activateCompanion(
        companion.apiId,
      );

      if (result['success'] == true) {
        EasyLoading.showSuccess('Companion activated!');
        selectedCompanionIndex.value = index;
        await _loadCompanionsFromApi();
      } else {
        EasyLoading.showError(
          result['message'] ?? 'Failed to activate companion',
        );
      }
    } catch (e) {
      EasyLoading.showError('Failed to activate companion');
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
