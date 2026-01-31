import 'package:get/get.dart';

class DailyGoalController extends GetxController {
  var carbs = 120.obs;
  var protein = 220.obs;
  var fats = 120.obs;

  void saveGoals() {
    Get.snackbar("Success", "Daily goals updated!");
  }
}
