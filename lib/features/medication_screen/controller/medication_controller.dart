import 'package:get/get.dart';
import 'package:velvet_iron/features/medication_screen/model/medication_model.dart';

class MedicationController extends GetxController {
  var selectedMealTab = 0.obs;

  void setMealTab(int index) {
    selectedMealTab.value = index;
  }
  // Observables for UI updates
  var medicationHistory = <Medication>[].obs;
  var isLoading = false.obs;

  // Form fields
  final Rx<String> selectedMedication = ''.obs;
  final Rx<double> selectedDose = 0.0.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    fetchMedicationHistory();
  }

  // Fetch medication history from an API
  Future<void> fetchMedicationHistory() async {
    try {
      isLoading(true);
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Dummy data - replace with actual API response
      medicationHistory.assignAll([
        Medication(name: 'GLP-1', dose: 0.25, timestamp: DateTime.now().subtract(const Duration(days: 7))),
        Medication(name: 'GLP-1', dose: 0.25, timestamp: DateTime.now().subtract(const Duration(days: 14))),
        Medication(name: 'GLP-1', dose: 0.5, timestamp: DateTime.now().subtract(const Duration(days: 21))),
      ]);

    } catch (e) {
      // Handle errors, e.g., show a snackbar
      Get.snackbar('Error', 'Failed to fetch medication history');
    } finally {
      isLoading(false);
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
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Add to local list (or refetch from API)
      medicationHistory.insert(0, Medication(
        name: selectedMedication.value,
        dose: selectedDose.value,
        timestamp: selectedDate.value,
      ));

      Get.snackbar('Success', 'Medication logged successfully');

    } catch (e) {
      Get.snackbar('Error', 'Failed to log medication');
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

  // You can add more methods here for other functionalities like
  // deleting a log, editing a log, etc.
}
