import 'package:get/get.dart';

class MedicationLogshotController extends GetxController {
  final doseLogged = 56.obs;
  final totalXp = 150.obs;

  final selectedMedicine = 'Ozempic'.obs;
  final selectedType = 'Injection'.obs;
  final doseMg = 4.obs;

  void logDose() {
    totalXp.value += 10;
  }
}
