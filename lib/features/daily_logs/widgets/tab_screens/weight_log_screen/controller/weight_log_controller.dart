import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/weight_log_screen/model/weight_log_model.dart';
import 'package:velvet_iron/features/daily_logs/widgets/tab_screens/weight_log_screen/service/weight_log_service.dart';

class WeightLogController extends GetxController {
  final currentWeight = "0".obs;
  final targetWeight = "0".obs;
  final weightIcon = "".obs;
  final totalChange = "0".obs;
  final entriesLogged = "0".obs;
  final historyList = <WeightLogModel>[].obs;

  late TextEditingController weightController;
  late TextEditingController noteController;
  final WeightLogService _service = WeightLogService();

  @override
  void onInit() {
    super.onInit();
    weightController = TextEditingController();
    noteController = TextEditingController();
    fetchWeightLogHistory();
  }

  @override
  void onClose() {
    weightController.dispose();
    noteController.dispose();
    super.onClose();
  }

  Future<String> _getAccessToken() async {
    return await SharedPreferencesHelper.getAccessToken() ?? '';
  }

  Future<String> _getRefreshToken() async {
    return await SharedPreferencesHelper.getRefreshToken() ?? '';
  }

  Future<void> fetchWeightLogHistory() async {
    try {
      EasyLoading.show(status: 'Loading...');

      final accessToken = await _getAccessToken();
      final refreshToken = await _getRefreshToken();

      debugPrint('║ accessToken  : $accessToken');
      debugPrint('║ refreshToken : $refreshToken');

      final result = await _service.getWeightLogHistory(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      debugPrint('║ currentWeight  : ${result.currentWeight}');
      debugPrint('║ totalChanges   : ${result.totalChanges}');
      debugPrint('║ totalLogsCount : ${result.totalLogsCount}');
      debugPrint('║ historyCount   : ${result.history.length}');
      for (int i = 0; i < result.history.length; i++) {
        final item = result.history[i];
        debugPrint(
          '║  [$i] id: ${item.id} | weight: ${item.weight} | change: ${item.weightChange} | loggedAt: ${item.loggedAt}',
        );
      }

      _applyHistoryData(result);
      EasyLoading.dismiss();
    } catch (e, stackTrace) {
      EasyLoading.showError('Failed to load data');
      debugPrint('║ [WeightLogController] fetchWeightLogHistory() → ERROR');
      debugPrint('║ Error      : $e');
      debugPrint('║ StackTrace : $stackTrace');
    }
  }

  void _applyHistoryData(WeightLogHistoryModel data) {
    currentWeight.value = data.currentWeight;
    totalChange.value = data.totalChanges;
    entriesLogged.value = data.totalLogsCount.toString();
    historyList.assignAll(data.history);
  }

  //  Submit New Weight Log
  Future<void> submitWeightLog() async {
    final weight = weightController.text.trim();
    final note = noteController.text.trim();

    if (weight.isEmpty) {
      EasyLoading.showError('Please enter your weight');
      debugPrint(
        '[WeightLogController] submitWeightLog() → Validation failed: weight is empty',
      );
      return;
    }

    try {
      EasyLoading.show(status: 'Saving...');
      debugPrint('║ weight : $weight');
      debugPrint('║ note   : $note');

      final accessToken = await _getAccessToken();
      final refreshToken = await _getRefreshToken();

      debugPrint('║ accessToken  : $accessToken');
      debugPrint('║ refreshToken : $refreshToken');

      final result = await _service.createWeightLog(
        weight: weight,
        note: note,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      debugPrint('║ id           : ${result.id}');
      debugPrint('║ userId       : ${result.userId}');
      debugPrint('║ weight       : ${result.weight}');
      debugPrint('║ note         : ${result.note}');
      debugPrint('║ weightChange : ${result.weightChange}');
      debugPrint('║ loggedAt     : ${result.loggedAt}');

      weightController.clear();
      noteController.clear();

      EasyLoading.showSuccess('Weight logged successfully!');

      // Refresh history
      await fetchWeightLogHistory();
    } catch (e, stackTrace) {
      EasyLoading.showError(e.toString().replaceFirst('Exception: ', ''));
      debugPrint('║ Error      : $e');
      debugPrint('║ StackTrace : $stackTrace');
    }
  }

  //  Legacy helpers kept for backward compatibility
  void updateWeightData(String weight, String target, String icon) {
    currentWeight.value = weight;
    targetWeight.value = target;
    weightIcon.value = icon;
  }

  void updateWeightLogSummary(String totalChangeVal, String entries) {
    totalChange.value = totalChangeVal;
    entriesLogged.value = entries;
  }
}
