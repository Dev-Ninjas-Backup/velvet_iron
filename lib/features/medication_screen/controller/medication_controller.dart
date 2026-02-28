import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/services/shared_preferences_helper.dart';
import 'package:velvet_iron/features/medication_screen/model/medication_model.dart';
import 'package:velvet_iron/features/medication_screen/service/medication_service.dart';

class MedicationController extends GetxController {
  var selectedMealTab = 0.obs;
  var medicationHistory = <Medication>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Form fields
  final Rx<String> selectedMedication = ''.obs;
  final Rx<String> selectedType = 'CAPSULE'.obs;
  final Rx<double> selectedDoseMg = 0.0.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  // For dropdowns or selection
  var availableMedications = <String>[].obs;
  var availableDoses = <double>[].obs;

  // Service instance
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

  Future<void> fetchMedicationHistory() async {
    try {
      isLoading(true);
      errorMessage('');

      await Future.delayed(const Duration(seconds: 1));
      medicationHistory.assignAll([
        Medication(
          id: '1',
          userId: '',
          name: 'GLP-1',
          type: 'LIQUID',
          doseMg: 250,
          isTaken: true,
          earnedXp: 10,
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
        ),
        Medication(
          id: '2',
          userId: '',
          name: 'GLP-1',
          type: 'LIQUID',
          doseMg: 250,
          isTaken: true,
          earnedXp: 10,
          createdAt: DateTime.now().subtract(const Duration(days: 14)),
        ),
        Medication(
          id: '3',
          userId: '',
          name: 'GLP-1',
          type: 'LIQUID',
          doseMg: 500,
          isTaken: false,
          earnedXp: 0,
          createdAt: DateTime.now().subtract(const Duration(days: 21)),
        ),
      ]);
    } catch (e) {
      errorMessage('Failed to fetch medication history');
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading(false);
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

  Future<void> logMedication() async {
    if (selectedMedication.value.isEmpty || selectedDoseMg.value <= 0) {
      EasyLoading.showInfo('Please select a medication and dose');
      return;
    }
    try {
      EasyLoading.show(status: 'Logging medication...');

      // Get tokens from SharedPreferences
      final accessToken = await SharedPreferencesHelper.getAccessToken();
      final refreshToken = await SharedPreferencesHelper.getRefreshToken();

      if (accessToken == null || refreshToken == null) {
        EasyLoading.showError('Session expired. Please log in again.');
        return;
      }

      // Call API to log medication
      final medication = await _medicationService.logMedication(
        name: selectedMedication.value,
        type: selectedType.value,
        doseMg: selectedDoseMg.value,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      // Add to history
      medicationHistory.insert(0, medication);

      EasyLoading.showSuccess('Medication logged successfully');

      // Reset form
      selectedMedication.value = '';
      selectedDoseMg.value = 0.0;
      selectedType.value = 'CAPSULE';
    } catch (e) {
      errorMessage.value = e.toString();
      EasyLoading.showError(e.toString());
    }
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
}
