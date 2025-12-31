import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/medication_logshot_controller.dart';

class LogDoseForm extends GetView<MedicationLogshotController> {
  const LogDoseForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff5B1616),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Dose Name'),
          _field(controller.selectedMedicine.value),
          const SizedBox(height: 12),
          _label('Medicine Type'),
          _field(controller.selectedType.value),
          const SizedBox(height: 12),
          _label('Dose (mg)'),
          _field('${controller.doseMg.value} mg'),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: controller.logDose,
            child: Container(
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xffE3B66A), Color(0xffB88A3E)],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'Log Dose (+10 XP)',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text, style: const TextStyle(color: Colors.white70)),
  );

  Widget _field(String text) => Container(
    height: 48,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    alignment: Alignment.centerLeft,
    decoration: BoxDecoration(
      color: const Color(0xff3A0D0D),
      borderRadius: BorderRadius.circular(24),
    ),
    child: Text(text, style: const TextStyle(color: Colors.white)),
  );
}
