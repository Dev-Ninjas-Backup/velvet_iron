import 'package:get/get.dart';

class DailyGoalController extends GetxController {
  var carbs = 120.obs;
  var protein = 220.obs;
  var fats = 120.obs;

  // int get totalCalories =>
  //     (carbs.value * 4) + (protein.value * 4) + (fats.value * 9);

  void saveGoals() {
    Get.snackbar("Success", "Daily goals updated!");
  }
}
