import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/core/utils/app_theme/controller/app_theme_controller.dart';
import 'package:velvet_iron/features/daily_logs/models/log_option_model.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/mood_log_screen/model/mood_log_model.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/mood_log_screen/service/mood_log_service.dart';

class MoodLogController extends GetxController {
  final selectedMood = 0.obs;
  final selectedEnergy = 0.obs;
  final selectedHunger = 0.obs;
  final note = ''.obs;
  final moods = <LogOptionModel>[].obs;
  final isLoading = false.obs;
  final alreadyLoggedToday = false.obs;

  final energyLevels = ["Exhausted", "Low", "Moderate", "Energized", "High"];
  final hungerLevels = ["Not Hungry", "Hungry", "Very Hungry"];

  late AppThemeController themeController;
  final MoodLogService _service = MoodLogService();

  @override
  void onInit() {
    super.onInit();
    themeController = Get.find<AppThemeController>();
    _updateMoodsByTheme();
    ever(themeController.currentTheme, (_) => _updateMoodsByTheme());
    _fetchTodayLog();
  }

  // Fetch today's mood log

  Future<void> _fetchTodayLog() async {
    final accessToken = await SharedPreferencesHelper.getAccessToken();
    final refreshToken = await SharedPreferencesHelper.getRefreshToken();

    debugPrint('MoodLog accessToken : $accessToken');
    debugPrint('MoodLog refreshToken: $refreshToken');

    if (accessToken == null || refreshToken == null) {
      debugPrint('MoodLog Token missing — cannot fetch today log');
      return;
    }

    isLoading.value = true;

    try {
      final todayLog = await _service.getTodayMoodLog(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      if (todayLog != null) {
        selectedMood.value = MoodType.toIndex(todayLog.mood);
        selectedEnergy.value = EnergyLevel.toIndex(todayLog.energyLevel);
        selectedHunger.value = HungerLevel.toIndex(todayLog.hungerLevel);
        note.value = todayLog.note ?? '';
        alreadyLoggedToday.value = true;
      } else {
        alreadyLoggedToday.value = false;
        debugPrint('MoodLog No log for today — fresh state');
      }
    } on MoodLogException catch (e) {
      debugPrint('MoodLog Fetch MoodLogException: $e');
    } catch (e, stackTrace) {
      debugPrint('MoodLog Fetch unexpected error: $e');
      debugPrint('   StackTrace:\n$stackTrace');
    } finally {
      isLoading.value = false;
    }
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
      case 'gamer':
        return _getGreenEmoji(moodType);
      case 'mage':
        return _getPurpleEmoji(moodType);
      case 'reader':
        return _getWhiteEmoji(moodType);
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
        return IconPath.bluetired;
      case 'good':
        return IconPath.bluegood;
      case 'pissed':
        return IconPath.bluepissed;
      case 'great':
        return IconPath.bluegreat;
      case 'poor':
        return IconPath.bluepoor;
      default:
        return IconPath.bluetired;
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

  //  Log Entry
  Future<void> logEntry() async {
    final accessToken = await SharedPreferencesHelper.getAccessToken();
    final refreshToken = await SharedPreferencesHelper.getRefreshToken();

    debugPrint('MoodLog accessToken : $accessToken');
    debugPrint('MoodLog refreshToken: $refreshToken');

    if (accessToken == null || refreshToken == null) {
      debugPrint('MoodLog Token missing — aborting');
      EasyLoading.showError('Session expired. Please log in again.');
      return;
    }

    final mood = MoodType.fromIndex(selectedMood.value);
    final energy = EnergyLevel.fromIndex(selectedEnergy.value);
    final hunger = HungerLevel.fromIndex(selectedHunger.value);

    EasyLoading.show(status: 'Logging mood...');

    try {
      final result = await _service.logMood(
        mood: mood,
        energyLevel: energy,
        hungerLevel: hunger,
        note: note.value.isNotEmpty ? note.value : null,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      debugPrint('MoodLog Success →');
      debugPrint('id       : ${result.id}');
      debugPrint('earnedXp : +${result.earnedXp} XP');

      alreadyLoggedToday.value = true;
      EasyLoading.showSuccess('Mood logged! +${result.earnedXp} XP');
      Get.back();
    } on MoodLogException catch (e) {
      debugPrint('MoodLog MoodLogException: $e');
      EasyLoading.showError(e.message);
    } catch (e, stackTrace) {
      debugPrint('MoodLog Unexpected error: $e');
      debugPrint('StackTrace:\n$stackTrace');
      EasyLoading.showError('Failed to log mood. Please try again.');
    }
  }
}
