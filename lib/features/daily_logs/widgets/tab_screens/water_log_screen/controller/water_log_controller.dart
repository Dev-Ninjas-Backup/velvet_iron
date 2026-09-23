import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/water_log_screen/models/water_log_model.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/water_log_screen/service/water_log_service.dart';
import 'package:velvet_iron/features/quests/controller/quest_controller.dart';

class WaterLogController extends GetxController {
  final WaterLogService _service = WaterLogService();

  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;

  final RxDouble currentIntake = 0.0.obs;
  final RxDouble goal = 64.0.obs;
  final RxString unit = 'OZ'.obs;
  final RxString display = '0 / 64 oz'.obs;
  final RxDouble fillPercentage = 0.0.obs;
  final RxDouble fillLevel = 0.0.obs;
  final RxBool isGoalReached = false.obs;
  final RxList<double> quickAdds = <double>[8.0, 16.0, 24.0, 32.0].obs;
  final RxList<WaterLogItem> todayLogs = <WaterLogItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTodayWater();
  }

  Future<void> fetchTodayWater({bool showLoading = true}) async {
    try {
      if (showLoading) isLoading.value = true;
      final res = await _service.getTodayWater();

      currentIntake.value = res.currentIntake;
      goal.value = res.goal;
      unit.value = res.unit;
      display.value = res.display;
      fillPercentage.value = res.fillPercentage;
      fillLevel.value = res.potionFlask.fillLevel;
      isGoalReached.value = res.isGoalReached;
      quickAdds.assignAll(res.quickAdds);
      todayLogs.assignAll(res.todayLogs);
    } catch (e) {
      debugPrint('[WaterLogController] Error fetching water: $e');
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  /// Optimistic quick add
  Future<void> quickAddWater(double amount) async {
    if (isSubmitting.value) return;

    // Snapshot for rollback
    final prevIntake = currentIntake.value;
    final prevFillLevel = fillLevel.value;
    final prevDisplay = display.value;
    final prevReached = isGoalReached.value;

    try {
      isSubmitting.value = true;

      // Optimistic update
      final newIntake = prevIntake + amount;
      currentIntake.value = newIntake;
      final newRatio = goal.value > 0 ? (newIntake / goal.value).clamp(0.0, 1.0) : 0.0;
      fillLevel.value = newRatio;
      isGoalReached.value = newIntake >= goal.value;
      final u = unit.value.toLowerCase();
      display.value = '${newIntake.toStringAsFixed(newIntake.truncateToDouble() == newIntake ? 0 : 1)} / ${goal.value.toStringAsFixed(goal.value.truncateToDouble() == goal.value ? 0 : 1)} $u';

      // Network call
      await _service.logWater(amount: amount, unit: unit.value);

      EasyLoading.showSuccess('+5 XP Mana Restored!');

      // Sync fresh data
      await fetchTodayWater(showLoading: false);

      // Refresh quests
      if (Get.isRegistered<QuestController>()) {
        Get.find<QuestController>().fetchQuests();
      }
    } catch (e) {
      // Rollback
      currentIntake.value = prevIntake;
      fillLevel.value = prevFillLevel;
      display.value = prevDisplay;
      isGoalReached.value = prevReached;
      EasyLoading.showError('Failed to log water: ${e.toString()}');
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Custom volume entry
  Future<void> logCustomWater(double amount, {String? customUnit}) async {
    try {
      EasyLoading.show(status: 'Brewing mana log...');
      await _service.logWater(amount: amount, unit: customUnit ?? unit.value);
      EasyLoading.showSuccess('+5 XP Mana Restored!');
      await fetchTodayWater(showLoading: false);

      if (Get.isRegistered<QuestController>()) {
        Get.find<QuestController>().fetchQuests();
      }
    } catch (e) {
      EasyLoading.showError('Failed to log water: ${e.toString()}');
    }
  }

  /// Update daily water goal & preferred unit
  Future<void> updateGoal({required double newGoal, required String newUnit}) async {
    try {
      EasyLoading.show(status: 'Updating goal...');
      await _service.updateWaterGoal(dailyWaterGoal: newGoal, waterUnit: newUnit);
      EasyLoading.showSuccess('Water goal updated!');
      await fetchTodayWater(showLoading: false);
    } catch (e) {
      EasyLoading.showError('Error: ${e.toString()}');
    }
  }

  /// Delete a log
  Future<void> deleteLog(String id) async {
    try {
      EasyLoading.show(status: 'Removing log...');
      await _service.deleteWaterLog(id);
      EasyLoading.showSuccess('Entry removed');
      await fetchTodayWater(showLoading: false);
    } catch (e) {
      EasyLoading.showError('Error: ${e.toString()}');
    }
  }
}
