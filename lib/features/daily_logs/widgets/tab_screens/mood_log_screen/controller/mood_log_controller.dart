import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/daily_logs/models/log_option_model.dart';

class MoodLogController extends GetxController {
  final selectedMood = 0.obs;
  final selectedEnergy = 0.obs;
  final selectedHunger = 0.obs;
  final note = ''.obs;
  final moods = <LogOptionModel>[].obs;

  final energyLevels = ["Exhausted", "Low", "Moderate", "Energized", "High"];
  final hungerLevels = ["Not Hungry", "Hungry", "Very Hungry"];

  late AppThemeController themeController;

  @override
  void onInit() {
    super.onInit();
    themeController = Get.find<AppThemeController>();
    _updateMoodsByTheme();
    // Listen to theme changes
    ever(themeController.currentTheme, (_) => _updateMoodsByTheme());
  }

  void _updateMoodsByTheme() {
    final activeTheme = themeController.currentTheme.value;
    final themeId = activeTheme?.id ?? 'adventurer';

    moods.value = [
      LogOptionModel(title: "Tired", icon: _getEmojiForTheme(themeId, 'tired')),
      LogOptionModel(title: "Good", icon: _getEmojiForTheme(themeId, 'good')),
      LogOptionModel(
        title: "Pissed",
        icon: _getEmojiForTheme(themeId, 'pissed'),
      ),
      LogOptionModel(title: "Great", icon: _getEmojiForTheme(themeId, 'great')),
      LogOptionModel(title: "Poor", icon: _getEmojiForTheme(themeId, 'poor')),
    ];
  }

  String _getEmojiForTheme(String themeId, String moodType) {
    switch (themeId) {
      case 'mage':
        return _getWhiteEmoji(moodType);
      case 'reader':
        return _getGreenEmoji(moodType);
      case 'gamer':
        return _getPurpleEmoji(moodType);
      default:
        return _getDefaultEmoji(moodType);
    }
  }

  String _getDefaultEmoji(String moodType) {
    switch (moodType) {
      case 'tired':
        return IconPath.tiredEmoji;
      case 'good':
        return IconPath.goodEmoji;
      case 'pissed':
        return IconPath.pissedEmoji;
      case 'great':
        return IconPath.greatEmoji;
      case 'poor':
        return IconPath.poorEmoji;
      default:
        return IconPath.tiredEmoji;
    }
  }

  String _getWhiteEmoji(String moodType) {
    switch (moodType) {
      case 'tired':
        return IconPath.tiredEmojiWhite;
      case 'good':
        return IconPath.goodEmojiWhite;
      case 'pissed':
        return IconPath.pissedEmojiWhite;
      case 'great':
        return IconPath.greatEmojiWhite;
      case 'poor':
        return IconPath.poorEmojiWhite;
      default:
        return IconPath.tiredEmojiWhite;
    }
  }

  String _getGreenEmoji(String moodType) {
    switch (moodType) {
      case 'tired':
        return IconPath.tiredEmojiGreen;
      case 'good':
        return IconPath.goodEmojiGreen;
      case 'pissed':
        return IconPath.pissedEmojiGreen;
      case 'great':
        return IconPath.greatEmojiGreen;
      case 'poor':
        return IconPath.poorEmojiGreen;
      default:
        return IconPath.tiredEmojiGreen;
    }
  }

  String _getPurpleEmoji(String moodType) {
    switch (moodType) {
      case 'tired':
        return IconPath.tiredEmojiPurple;
      case 'good':
        return IconPath.goodEmojiPurple;
      case 'pissed':
        return IconPath.pissedEmojiPurple;
      case 'great':
        return IconPath.greatEmojiPurple;
      case 'poor':
        return IconPath.poorEmojiPurple;
      default:
        return IconPath.tiredEmojiPurple;
    }
  }

  void selectMood(int index) => selectedMood.value = index;
  void selectEnergy(int index) => selectedEnergy.value = index;
  void selectHunger(int index) => selectedHunger.value = index;
  void setNote(String value) => note.value = value;
}
