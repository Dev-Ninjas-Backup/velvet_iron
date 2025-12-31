import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/medication_logshot_controller.dart';

class DoseCardSection extends GetView<MedicationLogshotController> {
  const DoseCardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _card(
          title: 'Dose Logged',
          value: controller.doseLogged.value.toString(),
          subtitle: 'Total Rewards: 150+ xp',
        ),
        const SizedBox(width: 12),
        _card(
          title: 'Next Dose',
          value: 'Ozempic (4mg)',
          subtitle: 'Rewards: 15+ xp',
        ),
      ],
    );
  }

  Widget _card({
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xff5B1616),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(subtitle, style: const TextStyle(color: Colors.amber)),
          ],
        ),
      ),
    );
  }
}
