import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/features/daily_logs/screen/daily_log_screen.dart';
import 'package:velvet_iron/features/exercise/screen/exercise_screen.dart';
import 'package:velvet_iron/features/medication_screen/screen/medication_screen.dart';
import 'package:velvet_iron/features/home/screen/home_screen.dart';
import 'package:velvet_iron/features/settings/screen/setting_screen.dart';
import 'package:velvet_iron/features/quests/screen/quests_screen.dart';

class BottomNavController extends GetxController {
  var tabIndex = 0.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  // Get the current screen based on tab index
  Widget getCurrentScreen() {
    switch (tabIndex.value) {
      case 0:
        return const HomeScreenContent();
      case 1:
        return const DailyLogScreen();
      case 2:
        return MedicationScreen();
      case 3:
        return const ExerciseScreen();
      case 4:
        return const QuestsScreen();
      case 5:
        return const SettingScreen();
      default:
        return const HomeScreenContent();
    }
  }
}
