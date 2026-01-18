import 'package:get/get.dart';
import 'package:velvet_iron/features/daily_logs/models/log_option_model.dart';

class MoodLogController extends GetxController {
  final selectedMood = 0.obs;
  final selectedEnergy = 0.obs;
  final selectedHunger = 0.obs;
  final note = ''.obs;

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
  void setNote(String value) => note.value = value;
}
