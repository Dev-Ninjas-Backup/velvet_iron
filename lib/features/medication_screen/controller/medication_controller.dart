import 'package:get/get.dart';
import 'package:velvet_iron/features/medication_screen/model/medication_model.dart';

class MedicationController extends GetxController {
  var selectedMealTab = 0.obs;
  var medicationHistory = <Medication>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Form fields
  final Rx<String> selectedMedication = ''.obs;
  final Rx<double> selectedDose = 0.0.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  // For dropdowns or selection
  var availableMedications = <String>[].obs;
  var availableDoses = <double>[].obs;

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

      // Simulated API response
      await Future.delayed(const Duration(seconds: 1));
      medicationHistory.assignAll([
        Medication(
          id: '1',
          name: 'GLP-1',
          dose: 0.25,
          timestamp: DateTime.now().subtract(const Duration(days: 7)),
        ),
        Medication(
          id: '2',
          name: 'GLP-1',
          dose: 0.25,
          timestamp: DateTime.now().subtract(const Duration(days: 14)),
        ),
        Medication(
          id: '3',
          name: 'GLP-1',
          dose: 0.5,
          timestamp: DateTime.now().subtract(const Duration(days: 21)),
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
      availableDoses.assignAll([0.25, 0.5, 1.0]);
    } catch (e) {
      errorMessage('Failed to fetch available medications');
    }
  }

  // Log a new medication dose
  Future<void> logMedication() async {
    if (selectedMedication.value.isEmpty || selectedDose.value <= 0) {
      Get.snackbar('Error', 'Please select a medication and dose');
      return;
    }
    try {
      isLoading(true);
      errorMessage('');

      await Future.delayed(const Duration(seconds: 1));
      medicationHistory.insert(
        0,
        Medication(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: selectedMedication.value,
          dose: selectedDose.value,
          timestamp: selectedDate.value,
        ),
      );
      Get.snackbar('Success', 'Medication logged successfully');
    } catch (e) {
      errorMessage('Failed to log medication');
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading(false);
    }
  }

  // Example method to update dose
  void updateDose(double newDose) {
    selectedDose.value = newDose;
  }

  // Example method to update medication name
  void updateMedicationName(String newName) {
    selectedMedication.value = newName;
  }

  // Example method to update date
  void updateDate(DateTime newDate) {
    selectedDate.value = newDate;
  }
}
