import 'package:get/get.dart';
import 'package:velvet_iron/features/daily_logs/models/log_option_model.dart';

class DailyLogController extends GetxController {
  final selectedMood = 0.obs;
  final selectedEnergy = 0.obs;
  final selectedHunger = 0.obs;
  final selectedTab = 0.obs;

  // Weight tracking variables
  final currentWeight = "0".obs;
  final targetWeight = "0".obs;
  final weightIcon = "".obs;

  final moods = <LogOptionModel>[
    LogOptionModel(title: "Tired", icon: "assets/icons/tiredEmoji.png"),
    LogOptionModel(title: "Good", icon: "assets/icons/goodEmoji.png"),
    LogOptionModel(title: "Pissed", icon: "assets/icons/pissedEmoji.png"),
    LogOptionModel(title: "Great", icon: "assets/icons/greatEmoji.png"),
    LogOptionModel(title: "Poor", icon: "assets/icons/poorEmoji.png"),
  ].obs;

  final energyLevels = ["Exhausted", "Low", "Moderate", "Energized", "High"];
  final hungerLevels = ["Not Hungry", "Hungry", "Very Hungry"];

  void selectMood(int index) => selectedMood.value = index;
  void selectEnergy(int index) => selectedEnergy.value = index;
  void selectHunger(int index) => selectedHunger.value = index;
  void setTab(int index) => selectedTab.value = index;

  void updateWeightData(String weight, String target, String icon) {
    currentWeight.value = weight;
    targetWeight.value = target;
    weightIcon.value = icon;
  }
}
