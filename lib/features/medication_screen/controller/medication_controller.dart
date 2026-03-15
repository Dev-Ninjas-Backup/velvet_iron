import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/medication_screen/model/medication_model.dart';
import 'package:velvet_iron/features/medication_screen/service/medication_service.dart';

class MedicationController extends GetxController {
  @override
  void onClose() {
    selectedMedication.value = '';
    selectedDoseMg.value = 0.0;
    doseNameController.clear();
    doseMgController.clear();
    doseNameController.dispose();
    doseMgController.dispose();
    super.onClose();
  }

  var selectedMealTab = 0.obs;
  var medicationHistory = <Medication>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Form fields
  final Rx<String> selectedMedication = ''.obs;
  final Rx<String> selectedType = '--'.obs;
  final Rx<double> selectedDoseMg = 0.0.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;
  final doseNameController = TextEditingController();
  final doseMgController = TextEditingController();

  var availableMedications = <String>[].obs;
  var availableDoses = <double>[].obs;

  final isHistoryLoading = false.obs;
  final Rxn<MedicationHistoryResponse> historyData =
      Rxn<MedicationHistoryResponse>();

  final MedicationService _medicationService = MedicationService();

  @override
  void onInit() {
    super.onInit();
    fetchAvailableMedications();
    fetchMedicationHistory();
  }

  void setMealTab(int index) {
    selectedMealTab.value = index;
  }

  void updateTime(TimeOfDay time) {
    selectedTime.value = time;
  }

  //  build scheduleTime ISO string from selectedDate + selectedTime
  String _buildScheduleTime() {
    final date = selectedDate.value;
    final time = selectedTime.value;
    final combined = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    final utc = combined.toUtc();
    final iso = utc.toIso8601String();
    return '${iso.replaceFirst(RegExp(r'\.\d+Z$'), '')}Z';
  }

  // fetchMedicationHistory now calls real GET - medication-history
  Future<void> fetchMedicationHistory() async {
    try {
      isHistoryLoading(true);
      errorMessage('');

      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();

      if (accessToken == null || refreshToken == null) {
        errorMessage('Session expired. Please log in again.');
        return;
      }

      final result = await _medicationService.getMedicationHistory(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      historyData.value = result;
      medicationHistory.assignAll(result.logs);

      debugPrint(
        '[MedicationController] History loaded. count=${result.logs.length}',
      );
      debugPrint(
        '[MedicationController] nextSchedule=${result.nextSchedule?.name}',
      );
      debugPrint(
        '[MedicationController] totalEarnedXp=${result.totalEarnedXp}',
      );
    } catch (e) {
      errorMessage('Failed to fetch medication history: $e');
      debugPrint('[MedicationController] fetchMedicationHistory error: $e');
    } finally {
      isHistoryLoading(false);
    }
  }

  Future<void> fetchAvailableMedications() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      availableMedications.assignAll(['GLP-1', 'Metformin']);
      availableDoses.assignAll([250, 500, 1000]);
    } catch (e) {
      errorMessage('Failed to fetch available medications');
    }
  }

  //  POST medication-log

  Future<void> logMedication() async {
    if (selectedMedication.value.isEmpty ||
        selectedDoseMg.value <= 0 ||
        selectedType.value == '--' ||
        selectedType.value.isEmpty) {
      EasyLoading.showInfo('Please fill all fields before logging medication.');
      return;
    }
    try {
      EasyLoading.show(status: 'Logging medication...');

      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();

      if (accessToken == null || refreshToken == null) {
        EasyLoading.showError('Session expired. Please log in again.');
        return;
      }

      final medication = await _medicationService.logMedication(
        name: selectedMedication.value,
        type: selectedType.value,
        doseMg: selectedDoseMg.value,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      medicationHistory.insert(0, medication);
      EasyLoading.showSuccess('Medication logged successfully');
      _clearFields();
      fetchMedicationHistory();
    } catch (e) {
      errorMessage.value = e.toString();
      EasyLoading.showError(e.toString());
    }
  }

  // POST medication-schedule

  Future<void> scheduleMedication() async {
    if (selectedMedication.value.isEmpty ||
        selectedDoseMg.value <= 0 ||
        selectedType.value == '--' ||
        selectedType.value.isEmpty) {
      EasyLoading.showInfo('Please fill all fields before scheduling.');
      return;
    }

    try {
      EasyLoading.show(status: 'Scheduling medication...');

      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();

      if (accessToken == null || refreshToken == null) {
        EasyLoading.showError('Session expired. Please log in again.');
        return;
      }

      final scheduleTime = _buildScheduleTime();

      debugPrint('[MedicationController] scheduleMedication...');
      debugPrint(
        '[MedicationController] name        : ${selectedMedication.value}',
      );
      debugPrint('[MedicationController] type        : ${selectedType.value}');
      debugPrint(
        '[MedicationController] doseMg      : ${selectedDoseMg.value}',
      );
      debugPrint('[MedicationController] scheduleTime: $scheduleTime');

      final medication = await _medicationService.scheduleMedication(
        name: selectedMedication.value,
        type: selectedType.value,
        doseMg: selectedDoseMg.value,
        scheduleTime: scheduleTime,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      EasyLoading.showSuccess(
        'Medication scheduled! +${medication.earnedXp} XP',
      );
      _clearFields();
      fetchMedicationHistory();
    } catch (e) {
      errorMessage.value = e.toString();
      EasyLoading.showError(e.toString());
    }
  }

  void _clearFields() {
    doseNameController.clear();
    doseMgController.clear();
    selectedType.value = '--';
    selectedMedication.value = '';
    selectedDoseMg.value = 0.0;
    selectedDate.value = DateTime.now();
    selectedTime.value = TimeOfDay.now();
  }

  void updateDoseMg(double newDose) {
    selectedDoseMg.value = newDose;
  }

  void updateMedicationName(String newName) {
    selectedMedication.value = newName;
  }

  void updateType(String newType) {
    selectedType.value = newType;
  }

  void updateDate(DateTime newDate) {
    selectedDate.value = newDate;
  }

  // PATCH: Mark medication as taken
  Future<void> markMedicationAsTaken(String medicationId) async {
    try {
      debugPrint(
        '[MedicationController] 🔄 Starting markMedicationAsTaken for ID: $medicationId',
      );

      EasyLoading.show(status: 'Marking as taken...');

      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();

      debugPrint(
        '[MedicationController] ✓ Token check - accessToken: ${accessToken?.isNotEmpty}, refreshToken: ${refreshToken?.isNotEmpty}',
      );

      if (accessToken == null || refreshToken == null) {
        debugPrint('[MedicationController] ❌ ERROR: Tokens are null!');
        EasyLoading.dismiss();
        EasyLoading.showError('Session expired. Please log in again.');
        return;
      }

      debugPrint(
        '[MedicationController] 📡 Calling API: /medication-schedule/$medicationId/taken?isTaken=true',
      );

      final medication = await _medicationService.markMedicationAsTaken(
        medicationId: medicationId,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      debugPrint('[MedicationController] ✅ API Success! Response received');
      debugPrint('[MedicationController]   - ID: ${medication.id}');
      debugPrint('[MedicationController]   - isTaken: ${medication.isTaken}');
      debugPrint(
        '[MedicationController]   - earnedXp: +${medication.earnedXp} XP',
      );

      EasyLoading.dismiss();
      EasyLoading.showSuccess(
        'Dose marked as taken! +${medication.earnedXp} XP',
      );

      // Refresh history to update UI with moved item
      debugPrint('[MedicationController] 🔄 Refreshing medication history...');
      await fetchMedicationHistory();
      debugPrint(
        '[MedicationController] ✅ History refreshed - UI should update',
      );
    } catch (e) {
      debugPrint('[MedicationController] ❌ ERROR: $e');
      debugPrint('[MedicationController] Error type: ${e.runtimeType}');
      EasyLoading.dismiss();
      EasyLoading.showError('Failed: $e');
      errorMessage.value = e.toString();
    }
  }
}
